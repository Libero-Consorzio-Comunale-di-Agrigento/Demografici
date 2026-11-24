package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.GsdFirmaService
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaEnteService
import it.finmatica.de4gsdzk.archivi.ArcComuneBaseService
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.utils.Funzioni
import spock.lang.Specification
import spock.lang.Unroll

class AnaDocumentoServiceSpec extends Specification {

    AnaDocumentoService anaDocumentoService

    void setup() {
        AnaDocumentoRepository anaDocumentoRepository = Mock(AnaDocumentoRepository)
        AnaDocumentoAllegatoService anaDocumentoAllegatoService = Mock(AnaDocumentoAllegatoService)
        AnaEnteService anaEnteService = Mock(AnaEnteService)
        ArcComuneBaseService arcComuneBaseService = Mock(ArcComuneBaseService)
        GsdFirmaService gsdFirmaService = Mock(GsdFirmaService)
        GsdService gsdService = Mock(GsdService)
        anaDocumentoService = new AnaDocumentoService(anaDocumentoRepository, anaDocumentoAllegatoService, anaEnteService, arcComuneBaseService, gsdFirmaService, gsdService)
    }

    @Unroll
    void "Visibilità di #funzioneDocumento è #expectedVisibility"() {
        given:
        AnaDocumento documento = Mock(AnaDocumento)
        documento.canDownload() >> downloadAllegatoEnable

        when:
        Funzioni funzioniDocumento = anaDocumentoService.getFunzioniDocumento(documento)

        then:
        funzioniDocumento.isVisible(funzioneDocumento) == expectedVisibility

        where:
        funzioneDocumento               | downloadAllegatoEnable | expectedVisibility
        EFunzioneDocumento.DOWNLOAD     | true                   | true
        EFunzioneDocumento.DOWNLOAD     | false                  | false
        EFunzioneDocumento.ADD_ALLEGATO | true                   | true
        EFunzioneDocumento.ADD_ALLEGATO | false                  | true
    }
}