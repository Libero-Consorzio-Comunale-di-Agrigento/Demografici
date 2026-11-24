package it.finmatica.de4gsdzk.certificazione.generazione.ansc

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.IAttoAnsc
import it.finmatica.de4gsdzk.ansc.*
import it.finmatica.de4gsdzk.certificazione.CerCertificatoEmesso
import it.finmatica.de4gsdzk.certificazione.generazione.CertificatoGenerato
import it.finmatica.de4gsdzk.certificazione.generazione.ETipoGenerazioneCertificato
import it.finmatica.de4gsdzk.certificazione.generazione.IGenerazioneCertificatoParams
import it.finmatica.de4gsdzk.certificazione.generazione.IGenerazioneCertificatoService
import it.finmatica.de4gsdzk.errors.AnscRuntimeException
import it.finmatica.de4gsdzk.statocivile.CivDatiProvenienzaAtto
import it.finmatica.de4gsdzk.statocivile.CivDatiProvenienzaAttoService
import it.finmatica.de4gsdzk.utils.*
import org.springframework.stereotype.Service
import org.zkoss.zk.ui.Executions
import org.zkoss.zul.Window

@Slf4j
@Service
class AnscGenerazioneCertificatoService implements IGenerazioneCertificatoService {

    private AnscEndPointServizioService anscEndPointServizioService
    private AnscUtenteService anscUtenteService
    private AnscAllegatoService anscAllegatoService
    private AnscComunicazioneService anscComunicazioneService
    private CivDatiProvenienzaAttoService civDatiProvenienzaAttoService

    AnscGenerazioneCertificatoService(AnscEndPointServizioService anscEndPointServizioService,
                                      AnscUtenteService anscUtenteService,
                                      AnscAllegatoService anscAllegatoService,
                                      AnscComunicazioneService anscComunicazioneService,
                                      CivDatiProvenienzaAttoService civDatiProvenienzaAttoService) {
        this.anscEndPointServizioService = anscEndPointServizioService
        this.anscUtenteService = anscUtenteService
        this.anscAllegatoService = anscAllegatoService
        this.anscComunicazioneService = anscComunicazioneService
        this.civDatiProvenienzaAttoService = civDatiProvenienzaAttoService
    }

    AnscEndPointServizio getServizio(CerCertificatoEmesso certificato) {
        Integer idTipoCertificato = certificato?.tipoCertificato?.tipoCertificatoAnsc
        String flagEnte = (certificato?.tipoRichiedente?.isAttivaSezioneEnte()) ? 'S' : 'N'
        AnscEndPointServizio servizio = anscEndPointServizioService.getServizioCertificazione(idTipoCertificato, flagEnte)
        if (!servizio) {
            throw new AnscRuntimeException(Etichette.getEtichetta("Compilare_servizio_ANSC"))
        }
        return servizio
    }

    @Override
    void validateGenerazioneCertificato(CerCertificatoEmesso certificato) {
        // Sempre valido
    }

    @Override
    void generateCertificato(IGenerazioneCertificatoParams p) {
        try {
            AnscGenerazioneCertificatoParams paramsAnsc = (AnscGenerazioneCertificatoParams) p
            AnscEndPointServizio servizio = getServizio(paramsAnsc.certificato)

            AnscUtente ansUte = anscUtenteService.get(paramsAnsc.certificato.terminalista.id)
            if (!ansUte) {
                throw new AnscRuntimeException(Etichette.getEtichetta("Errore_ANSC_abilitazione_utente"))
            }

            Boolean otpValido = Boolean.FALSE
            if (ansUte.anscDataOtp != null) {
                Date dateLimit = DataUtils.addMinutes(ansUte.anscDataOtp, AnscUtils.OTP_DURATION)
                otpValido = (dateLimit?.compareTo(new Date()) > 0)
            }

            if (ansUte.anscOtp && otpValido && (!(servizio.flagOtpFirma))) {
                AnscCredenziali cre = new AnscCredenziali(ansUte, ansUte.anscOtp)
                sendAndOpenOtpWhenError(paramsAnsc.certificato, cre, paramsAnsc)
                return
            }

            openOtp(paramsAnsc)
        } catch (Exception ex) {
            p.onFailure.call(new AnscGenerazioneCertificatoRuntimeException((ex.message ?:
                                                                             ex?.cause?.class?.name) ?:
                                                                             ""))
        }
    }

    private void openOtp(AnscGenerazioneCertificatoParams paramsAnsc) {
        AnscEndPointServizio servizio = getServizio(paramsAnsc.certificato)
        Window w = (Window) Executions.createComponents("/restrict/afc/anscOtp.zul", paramsAnsc.window, [servizio: servizio])
        w.addEventListener(CustomEvents.ON_SEND_ANSC_SERVICE, { event ->
            if (event.data.credenziali instanceof AnscCredenziali) {
                AnscCredenziali cre = (AnscCredenziali) event.data.credenziali
                try {
                    CertificatoGenerato certificatoGenerato = send(paramsAnsc.certificato, paramsAnsc.atto, cre)
                    paramsAnsc.onSuccess.call(certificatoGenerato)
                } catch (Exception ex) {
                    paramsAnsc.onFailure.call(new AnscGenerazioneCertificatoRuntimeException((ex.message ?:
                                                                                              ex?.cause?.class?.name) ?:
                                                                                              ""))
                }
            }
        })
        w.addEventListener(CustomEvents.ON_CLOSE_RELOAD, { event ->
            paramsAnsc.onFailure.call(new AnscGenerazioneCertificatoRuntimeException('Operazione annullata dall\'utente.'))
        })
        w.doModal()
    }

    private CertificatoGenerato send(CerCertificatoEmesso certificatoEmesso, CivAttoBaseDomain atto, AnscCredenziali cre) {
        AnscEndPointServizio servizio = getServizio(certificatoEmesso)
        AnscEndPointServizio servizioPrec = null
        ETipoArchivioAnsc taRif = ETipoArchivioAnsc.CER
        ETipoArchivioAnsc taRifComPrec = null
        List<Long> idRifPrecs = null
        Long idCasoUso = (atto as IAttoAnsc).idAnscUseCase
        Long idRif = certificatoEmesso.idEmissione as Long
        Long idComunicazione = null
        if (taRif && servizio && idRif && cre) {
            CivDatiProvenienzaAtto datiProvenienza = civDatiProvenienzaAttoService.getByUkAtto(atto.idAtto)
            String tipoDocumentoCdu = AnscUtils.getTipoDocumentoCdu(atto, datiProvenienza)
            AnscInfoComunicazioneServizio com = anscComunicazioneService.inviaComunicazioneAtto(taRifComPrec, servizioPrec, idRifPrecs, taRif, servizio, idRif, idCasoUso, tipoDocumentoCdu, atto, idComunicazione, cre)
            if ((com.getRetVal() ?: "") != "") {
                throw new AnscRuntimeException(com.getRetVal())
            }

            if (servizio.flagDownloadAllegato) {
                AnscAllegato anscAllegato = anscAllegatoService.get(com.getIdComunicazione())
                if (!anscAllegato) {
                    throw new AnscRuntimeException("Errore in recupero file allegato")
                }

                return new CertificatoGenerato(
                        ETipoGenerazioneCertificato.ANSC,
                        anscAllegato.blobAllegato,
                        ETipoFile.PDF.estensione)
            }
        }
        throw new AnscRuntimeException("Errore in invio comunicazione atto ANSC")
    }

    private void sendAndOpenOtpWhenError(CerCertificatoEmesso certificatoEmesso, AnscCredenziali cre, AnscGenerazioneCertificatoParams paramsAnsc) {
        try {
            CertificatoGenerato certificatoGenerato = send(certificatoEmesso, paramsAnsc.atto, cre)

            paramsAnsc.onSuccess.call(certificatoGenerato)
        } catch (AnscRuntimeException arex) {
            if (arex.codificaErrore?.flagOtpUser && (!(arex.codificaErrore?.flagGestito))) {
                openOtp(paramsAnsc)
            } else {
                throw arex
            }
        }
    }
}
