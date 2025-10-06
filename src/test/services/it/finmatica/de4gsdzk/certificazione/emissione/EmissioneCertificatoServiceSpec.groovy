package it.finmatica.de4gsdzk.certificazione.emissione

import it.finmatica.de4gsdzk.GsdMenuDittaService
import it.finmatica.de4gsdzk.anagrafe.*
import it.finmatica.de4gsdzk.anpr.AnpAnagrafe
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.certificazione.*
import it.finmatica.de4gsdzk.certificazione.generazione.ETipoGenerazioneCertificato
import it.finmatica.de4gsdzk.certificazione.generazione.GenerazioneCertificatoParamsFactory
import it.finmatica.de4gsdzk.certificazione.generazione.GenerazioneCertificatoServiceFactory
import it.finmatica.de4gsdzk.integrazioni.ad4.UtenteCustomService
import it.finmatica.de4gsdzk.statocivile.CivAnnotazioneAttoService
import it.finmatica.de4gsdzk.statocivile.CivAttoService
import it.finmatica.de4gsdzk.statocivile.StatoCivileService
import spock.lang.Specification
import spock.lang.Subject
import spock.lang.Unroll

class EmissioneCertificatoServiceSpec extends Specification {
    @Subject
    EmissioneCertificatoService emissioneCertificatoService

    void setup() {
        GenerazioneCertificatoServiceFactory generazioneCertificatoServiceFactory = Mock(GenerazioneCertificatoServiceFactory)
        GenerazioneCertificatoParamsFactory generazioneCertificatoParamsFactory = Mock(GenerazioneCertificatoParamsFactory)
        CerCertificatoEmessoService cerCertificatoEmessoService = Mock(CerCertificatoEmessoService)
        CerTipoCertificatoService cerTipoCertificatoService = Mock(CerTipoCertificatoService)
        CerStatoCivileFiltroService cerStatoCivileFiltroService = Mock(CerStatoCivileFiltroService)
        CerIndividuoCertificatoService cerIndividuoCertificatoService = Mock(CerIndividuoCertificatoService)
        CerTerminalistaService cerTerminalistaService = Mock(CerTerminalistaService)
        CerTipoRichiedenteService cerTipoRichiedenteService = Mock(CerTipoRichiedenteService)
        CivAttoService civAttoService = Mock(CivAttoService)
        CivAnnotazioneAttoService civAnnotazioneAttoService = Mock(CivAnnotazioneAttoService)
        AnaAnagrafeService anaAnagrafeService = Mock(AnaAnagrafeService)
        AnaTipoDocumentoService anaTipoDocumentoService = Mock(AnaTipoDocumentoService)
        AnaDocumentoService anaDocumentoService = Mock(AnaDocumentoService)
        AnaDocumentoAllegatoService anaDocumentoAllegatoService = Mock(AnaDocumentoAllegatoService)
        ArcParametroService arcParametroService = Mock(ArcParametroService)
        GsdMenuDittaService gsdMenuDittaService = Mock(GsdMenuDittaService)
        StatoCivileService statoCivileService = Mock(StatoCivileService)
        UtenteCustomService utenteCustomService = Mock(UtenteCustomService)

        emissioneCertificatoService = new EmissioneCertificatoService(
                generazioneCertificatoServiceFactory,
                generazioneCertificatoParamsFactory,
                cerCertificatoEmessoService,
                cerTipoCertificatoService,
                cerStatoCivileFiltroService,
                cerIndividuoCertificatoService,
                cerTerminalistaService,
                cerTipoRichiedenteService,
                civAttoService,
                civAnnotazioneAttoService,
                anaAnagrafeService,
                anaTipoDocumentoService,
                anaDocumentoService,
                anaDocumentoAllegatoService,
                arcParametroService,
                gsdMenuDittaService,
                statoCivileService,
                utenteCustomService)
    }

    @Unroll
    void "Ritorna l'obbligatorietà del documento del richiedente"() {
        when:
        boolean mandatory = emissioneCertificatoService.isDocumentoRichiedenteMandatory(tipoGenerazioneCertificato, anagrafe)

        then:
        mandatory == expected

        where:
        tipoGenerazioneCertificato       | anagrafe          | expected
        ETipoGenerazioneCertificato.ANPR | new AnpAnagrafe() | false
        ETipoGenerazioneCertificato.ANPR | new AnaAnagrafe() | true
        ETipoGenerazioneCertificato.ANPR | null              | true
        ETipoGenerazioneCertificato.ANSC | new AnpAnagrafe() | false
        ETipoGenerazioneCertificato.ANSC | new AnaAnagrafe() | false
        ETipoGenerazioneCertificato.ANSC | null              | false
        ETipoGenerazioneCertificato.GTE  | new AnpAnagrafe() | false
        ETipoGenerazioneCertificato.GTE  | new AnaAnagrafe() | false
        ETipoGenerazioneCertificato.GTE  | null              | false
        null                             | new AnpAnagrafe() | false
        null                             | new AnaAnagrafe() | false
        null                             | null              | false
    }

    @Unroll
    void "Ritorna l'obbligatorietà di dati anagrafici aggiuntivi del richiedente"() {
        when:
        boolean mandatory = emissioneCertificatoService.isDatiAnagraficiAggiuntiviRichiedenteMandatory(tipoGenerazioneCertificato)

        then:
        mandatory == expected

        where:
        tipoGenerazioneCertificato       | expected
        ETipoGenerazioneCertificato.ANPR | false
        ETipoGenerazioneCertificato.ANSC | true
        ETipoGenerazioneCertificato.GTE  | false
        null                             | false
    }
}
