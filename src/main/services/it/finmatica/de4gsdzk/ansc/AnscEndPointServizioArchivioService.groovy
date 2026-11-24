package it.finmatica.de4gsdzk.ansc

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.IAttoAnsc
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.statocivile.CivAttoService
import it.finmatica.de4gsdzk.statocivile.CivFirmatarioAtto
import it.finmatica.de4gsdzk.statocivile.CivFirmatarioAttoService
import it.finmatica.de4gsdzk.utils.ETipoArchivioAnsc
import it.finmatica.de4gsdzk.utils.ETipoFirmaAnsc
import it.finmatica.de4gsdzk.utils.SortUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.domain.Sort
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnscEndPointServizioArchivioService {

    private static final String CODICE_SERVIZIO_R001 = 'R001'
    private final GsdService gsdService

    private final CivAttoService civAttoService

    private final CivFirmatarioAttoService civFirmatarioAttoService

    private final AnscEndPointServizioArchivioRepository anscEndPointServizioArchivioRepository

    AnscEndPointServizioArchivioService(GsdService gsdService, CivAttoService civAttoService,
                                        AnscEndPointServizioArchivioRepository anscEndPointServizioArchivioRepository,
                                        CivFirmatarioAttoService civFirmatarioAttoService) {
        this.gsdService = gsdService
        this.civAttoService = civAttoService
        this.anscEndPointServizioArchivioRepository = anscEndPointServizioArchivioRepository
        this.civFirmatarioAttoService = civFirmatarioAttoService
    }

    AnscEndPointServizioArchivio get (Long id){
        return anscEndPointServizioArchivioRepository.findById(id)
    }

    AnscEndPointServizioArchivio getServizioArchivioNotifica(Boolean ricerca, Boolean conferma, Boolean rifiuto, Boolean consultazioneEvento, Boolean consultazioneSoggetto){
        List<AnscEndPointServizioArchivio> l = anscEndPointServizioArchivioRepository.findAllByArchivioAndFlagVisibileIsTrueOrderBySequenza(ETipoArchivioAnsc.NOT)
        List<AnscEndPointServizioArchivio> ls = []
        for (AnscEndPointServizioArchivio sa:l){
            if (ricerca && sa.servizio.flagNotificaRicerca){
                ls.add(sa)
            }
            if (conferma && sa.servizio.flagNotificaConferma){
                ls.add(sa)
            }
            if (rifiuto && sa.servizio.flagNotificaRifiuto){
                ls.add(sa)
            }
            if (consultazioneEvento && sa.servizio.flagConsultazioneEvento){
                ls.add(sa)
            }
            if (consultazioneSoggetto && sa.servizio.flagConsultazioneSoggetto){
                ls.add(sa)
            }
        }
        if ( (ls?.size()?:0) == 1){
            return ls.get(0)
        }
        return null
    }

    AnscEndPointServizioArchivio getServizioArchivioNotificaRicerca(){
        return getServizioArchivioNotifica(Boolean.TRUE, Boolean.FALSE, Boolean.FALSE, Boolean.FALSE, Boolean.FALSE)
    }

    AnscEndPointServizioArchivio getServizioArchivioNotificaConferma(){
        return getServizioArchivioNotifica(Boolean.FALSE, Boolean.TRUE, Boolean.FALSE, Boolean.FALSE, Boolean.FALSE)
    }

    AnscEndPointServizioArchivio getServizioArchivioNotificaRifiuto(){
        return getServizioArchivioNotifica(Boolean.FALSE, Boolean.FALSE, Boolean.TRUE, Boolean.FALSE, Boolean.FALSE)
    }

    AnscEndPointServizioArchivio getServizioArchivioNotificaConsultazioneEvento(){
        return getServizioArchivioNotifica(Boolean.FALSE, Boolean.FALSE, Boolean.FALSE, Boolean.TRUE, Boolean.FALSE)
    }

    AnscEndPointServizioArchivio getServizioArchivioNotificaConsultazioneSoggetto(){
        return getServizioArchivioNotifica(Boolean.FALSE, Boolean.FALSE, Boolean.FALSE, Boolean.FALSE, Boolean.TRUE)
    }

    AnscEndPointServizioArchivio getServizioConsultazioneEventoByArchivioAndCasoUsoNull(ETipoArchivioAnsc tipoArchivio) {
        List<AnscEndPointServizioArchivio> l = anscEndPointServizioArchivioRepository.findAllByArchivioAndServizioFlagConsultazioneEventoIsTrueAndIdCasoUsoIsNull(tipoArchivio)
        if ((l?.size() ?: 0) == 1) {
            return l.get(0)
        }
        return null
    }

    List<AnscEndPointServizioArchivio> listAllServiziAnnotazioneByArchivioAndCasoUsoAndFlagVisibileIsTrueOrderBySequenza(ETipoArchivioAnsc tipoArchivio, Long idCasoUso, String tipoEvento) {
        return anscEndPointServizioArchivioRepository.findAllByArchivioAndCasoUsoAndFlagVisibileIsTrueOrderBySequenza(tipoArchivio, idCasoUso, tipoEvento)
    }

    List<AnscEndPointServizioArchivio> listAllServiziAttoByArchivioAndCasoUsoAndFlagVisibileIsTrueOrderBySequenza(ETipoArchivioAnsc tipoArchivio, Long idCasoUso, String tipoEvento, CivAttoBaseDomain atto) {
        List<AnscEndPointServizioArchivio> serviziCdu = anscEndPointServizioArchivioRepository.findAllServiziAttoByArchivioAndCasoUsoAndFlagVisibileIsTrueOrderBySequenza(tipoArchivio, idCasoUso, tipoEvento, atto.id, atto.idAtto)
        AnscEndPointServizioArchivio servizioAtt = null
        AnscEndPointServizioArchivio servizioFirmaAtt = null
        for (AnscEndPointServizioArchivio sac : serviziCdu) {
            if (sac.servizio.flagAttestazione){
                if (sac.servizio.flagOtpFirma){
                    servizioFirmaAtt = sac
                } else {
                    servizioAtt = sac
                }
            }
        }
        if (servizioAtt != null) {
            // Per retrocompatibilità in quanto la gestione SOGEI dei cdu e di conseguenza la mia gestione dei filtri sono cambiate nel tempo
            Boolean daIncludere
            if (((IAttoAnsc) atto).getFlagFirmatoUscAnsc()) {
                daIncludere = civAttoService.isConformeAnsc(atto.getTipoAttoEnum(), atto.id)
            } else {
                if (tipoEvento?.contains(ETipoFirmaAnsc.CA.name())){
                    daIncludere = Boolean.TRUE
                } else {
                    daIncludere = civAttoService.hasAllegatiInviatiAnsc(atto.getTipoAttoEnum(), atto.id)
                }
            }
            if (!(daIncludere)) {
                if (servizioFirmaAtt) {
                    serviziCdu.remove(servizioFirmaAtt)
                }
                serviziCdu.remove(servizioAtt)
            }
        }
        return serviziCdu.sort{it.sequenza}
    }

    private Boolean isAnscEndPointServizioArchivioR001(AnscEndPointServizioArchivio it) {
        it.servizio.servizio == CODICE_SERVIZIO_R001
    }

    List<AnscEndPointServizioArchivio> listAllServiziAttoAllegatiByAndCasoUsoAndAtto(Long idCasoUso, CivAttoBaseDomain atto) {
        return listAllServiziAttoByAndCasoUsoAndAtto(idCasoUso, atto)
                .findAll {
                    isAnscEndPointServizioArchivioR001(it)
                }
    }

    List<AnscEndPointServizioArchivio> listAllServiziAttoNonAllegatiByAndCasoUsoAndAtto(Long idCasoUso, CivAttoBaseDomain atto) {
        return listAllServiziAttoByAndCasoUsoAndAtto(idCasoUso, atto)
                .findAll {
                    !isAnscEndPointServizioArchivioR001(it)
                }
    }

    List<AnscEndPointServizioArchivio> listAllServiziAttoByAndCasoUsoAndAtto(Long idCasoUso, CivAttoBaseDomain atto) {
        ETipoArchivioAnsc tipoArchivioComunicazioneAtto = ((IAttoAnsc) atto).getTipoArchivioAnsc()

        List<CivFirmatarioAtto> lFirmatari = civFirmatarioAttoService.listAllByIdAtto(atto.idAtto, new Sort(SortUtils.sequenzaAsc))
        Boolean b = isAttoDaAttestareAnsc(atto)
        String tipoEventoCdu = AnscUtils.getTipoEventoCdu(lFirmatari, b)

        return listAllServiziAttoByArchivioAndCasoUsoAndFlagVisibileIsTrueOrderBySequenza(tipoArchivioComunicazioneAtto, idCasoUso, tipoEventoCdu, atto)
    }

    Boolean isAttoDaAttestareAnsc(CivAttoBaseDomain atto) {
        Boolean b = civAttoService.hasAllegatiInviatiAnsc(atto.getTipoAttoEnum(), atto.id)
        return b
    }

    List<AnscEndPointServizioArchivio> listAllByArchivioAndCasoUsoAndFlagConsultazioneSoggettoIsTrueOrderBySequenza(ETipoArchivioAnsc tipoArchivio, Long idCasoUso){
        return anscEndPointServizioArchivioRepository.findAllByArchivioAndCasoUsoAndFlagConsultazioneSoggettoIsTrueOrderBySequenza(tipoArchivio, idCasoUso)
    }

    List<AnscEndPointServizioArchivio> listAllByArchivioAndCasoUsoAndFlagPoolingPresaVisioneIsTrue(ETipoArchivioAnsc tipoArchivio, Long idCasoUso){
        return anscEndPointServizioArchivioRepository.findAllByArchivioAndCasoUsoAndFlagPoolingPresaVisioneIsTrue(tipoArchivio, idCasoUso)
    }

    List<AnscEndPointServizioArchivio> listAllByArchivioAndCasoUsoAndFlagConsultazioneEventoIsTrueOrderBySequenza(ETipoArchivioAnsc tipoArchivio, Long idCasoUso){
        return anscEndPointServizioArchivioRepository.findAllByArchivioAndCasoUsoAndFlagConsultazioneEventoIsTrueOrderBySequenza(tipoArchivio, idCasoUso)
    }

    Page<AnscEndPointServizioArchivio> findAllByArchivioAndCasoUso(ETipoArchivioAnsc tipoArchivio, Long idCasoUso, Pageable pageable){
        return anscEndPointServizioArchivioRepository.findAllByArchivioAndCasoUso(tipoArchivio, idCasoUso, pageable)
    }

    private void validaDati(AnscEndPointServizioArchivio obj){
        if ( (obj.servizio == null) || (obj.archivio == null) || (obj.idCasoUso == null) ) {
            throw new CampoMandatoryRuntimeException()
        }
    }

    AnscEndPointServizioArchivio save (AnscEndPointServizioArchivio obj) {
        validaDati(obj)

        if (obj.id == null) {
            // solo in caso di inserimento
            obj.id = gsdService.getIdFromSequence(obj)
        }
        log.info("Lancio salvataggio su ANSTWS_ARC per id " + obj.id)
        return anscEndPointServizioArchivioRepository.save(obj)
    }

    void delete(AnscEndPointServizioArchivio obj){
        if (obj.id != null) {
            anscEndPointServizioArchivioRepository.delete(obj)
        }
    }

    AnscEndPointServizioArchivio getServizioArchivioSoggettiRicerca(){
        List<AnscEndPointServizioArchivio> l = anscEndPointServizioArchivioRepository.findByServizioFlagConsultazioneSoggParIsTrue()
        if ((l?.size() ?: 0) == 1) {
            return l.get(0)
        }
        return null
    }

}
