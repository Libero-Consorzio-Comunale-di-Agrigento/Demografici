package it.finmatica.de4gsdzk.certificazione.emissione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.ICertificabile
import it.finmatica.de4gsdzk.certificazione.*
import it.finmatica.de4gsdzk.certificazione.generazione.ETipoGenerazioneCertificato
import it.finmatica.de4gsdzk.certificazione.generazione.TipoGenerazioneCertificatoService
import it.finmatica.de4gsdzk.statocivile.CivAnnotazioneAttoService
import it.finmatica.de4gsdzk.statocivile.CivAttoService
import it.finmatica.de4gsdzk.statocivile.CivMessaggio
import it.finmatica.de4gsdzk.statocivile.CivMessaggioService
import it.finmatica.de4gsdzk.utils.ETipoAnnotazione
import it.finmatica.de4gsdzk.utils.ETipoAtto
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class EmissioneCertificatoStatoCivileService {

    private final CerStatoCivileFiltroService cerStatoCivileFiltroService
    private final CerTerminalistaService cerTerminalistaService
    private final CivAttoService civAttoService
    private final CivAnnotazioneAttoService civAnnotazioneAttoService
    private final CivMessaggioService civMessaggioService
    private final TipoGenerazioneCertificatoService tipoGenerazioneCertificatoService

    EmissioneCertificatoStatoCivileService(CerStatoCivileFiltroService cerStatoCivileFiltroService,
                                           CerTerminalistaService cerTerminalistaService,
                                           CivAttoService civAttoService,
                                           CivAnnotazioneAttoService civAnnotazioneAttoService,
                                           CivMessaggioService civMessaggioService,
                                           TipoGenerazioneCertificatoService tipoGenerazioneCertificatoService) {
        this.cerStatoCivileFiltroService = cerStatoCivileFiltroService
        this.cerTerminalistaService = cerTerminalistaService
        this.civAttoService = civAttoService
        this.civMessaggioService = civMessaggioService
        this.civAnnotazioneAttoService = civAnnotazioneAttoService
        this.tipoGenerazioneCertificatoService = tipoGenerazioneCertificatoService
    }

    List<ICertificabile> listAttiByTipoCertificatoAndBeneficiario(CerTipoCertificato tipoCertificato, BeneficiarioViewState beneficiarioState) {
        List<CerStatoCivileFiltro> statoCivileFiltroList = cerStatoCivileFiltroService.listAllByTipoAttoAndFiltroAndAnagrafe(tipoCertificato.tipoAttoEnum, tipoCertificato.filtro, beneficiarioState.anagrafe)
        return civAttoService.listAllByStatoCivileFiltroList(statoCivileFiltroList)
    }

    CivAttoBaseDomain getAtto(ETipoAtto tipoAttoEnum, Long pkAtto) {
        civAttoService.getAttoCertificazione(tipoAttoEnum, pkAtto)
    }

    List<CivMessaggio> listMessaggiStatoCivileByAtto(CivAttoBaseDomain atto) {
        civMessaggioService.listAllForCertificazioneByAtto(atto)
    }

    Boolean isEmissioneCertificatoBloccatoDaMessaggiStatoCivileBloccanti(CerModalitaRilascio modalitaRilascio, List<CivMessaggio> messaggiStatoCivile) {
        if (modalitaRilascio.flagUsoInterno) {
            return Boolean.FALSE
        }
        Boolean existBloccante = messaggiStatoCivile.any { it.bloccante }
        return existBloccante
    }

    Boolean shouldShowAnscRichiedenteWarning(CerTipoRichiedente tipoRichiedente, Boolean forceGenerazioneGte, CerTipoCertificato tipoCertificato) {
        if (tipoRichiedente.id in [CerTipoRichiedente.ISTANZA_DI_PARTE, CerTipoRichiedente.ISTANZA_DI_UFFICIO]) {
            return tipoGenerazioneCertificatoService.get(forceGenerazioneGte, tipoCertificato) == ETipoGenerazioneCertificato.ANSC
        }

        return false
    }

    Boolean shouldShowAnscMorteRichiedenteWarning(CerTipoRichiedente tipoRichiedente, Boolean forceGenerazioneGte, CerTipoCertificato tipoCertificato) {
        if (tipoCertificato.tipoAttoEnum == ETipoAtto.MOR) {
            return shouldShowAnscRichiedenteWarning(tipoRichiedente, forceGenerazioneGte, tipoCertificato)
        }

        return false
    }

    Boolean shouldEnableEmissioneCertificatoSuAtto(ETipoAtto tipoAtto, CerTipoRichiedente tipoRichiedente, Boolean forceGenerazioneGte, CerTipoCertificato tipoCertificato, CivAttoBaseDomain atto) {
        if (tipoAtto != ETipoAtto.MOR) {
            return true
        }

        if (!(tipoRichiedente.id in [CerTipoRichiedente.ISTANZA_DI_PARTE, CerTipoRichiedente.ISTANZA_DI_UFFICIO])) {
            return true
        }

        ETipoGenerazioneCertificato tipoGenerazioneCertificato = tipoGenerazioneCertificatoService.get(forceGenerazioneGte, tipoCertificato, atto)
        return tipoGenerazioneCertificato == ETipoGenerazioneCertificato.GTE
    }

    Boolean shouldOpenAnnotazioni(ETipoGenerazioneCertificato tipoGenerazioneCertificato, CerTipoCertificato tipoCertificato, CivAttoBaseDomain atto) {
        CerTerminalista terminalista = cerTerminalistaService.getTerminalistaUtente()
        Boolean existsAnnotazioni = civAnnotazioneAttoService.existsByUkAttoAndTipoAttoAndTipoIn(atto.idAtto, atto.tipoAtto, [ETipoAnnotazione.M, ETipoAnnotazione.C])
        if (terminalista.flagUfficialeStatoCivile &&
                tipoGenerazioneCertificato == ETipoGenerazioneCertificato.GTE &&
                tipoCertificato.flagAnnotazioni == Boolean.TRUE &&
                existsAnnotazioni) {
            return true
        }
        return false
    }
}
