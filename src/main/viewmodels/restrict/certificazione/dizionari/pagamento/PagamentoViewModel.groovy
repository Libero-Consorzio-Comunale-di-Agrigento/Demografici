package restrict.certificazione.dizionari.pagamento

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.certificazione.CertificazioneSezioneService
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.Sezione
import it.finmatica.de4gsdzk.utils.SezioneBusiness
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window
import restrict.AbstractTabNavigatorViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class PagamentoViewModel extends AbstractTabNavigatorViewModel {

    List<Sezione> sezioneList

    @WireVariable
    private CertificazioneSezioneService certificazioneSezioneService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        List<Map> eList = [Etichette.Parametri, Etichette.Voci_di_costo, Etichette.Servizi, Etichette.Documenti, Etichette.Utenti]

        doInit(w, eList)

        resize()

        List<SezioneBusiness> sezioneBusinessList = certificazioneSezioneService.listDizionarioPagamento()

        sezioneList = sezioneBusinessList.collect { SezioneBusiness it ->
            new Sezione(getEtichetta(it.etichetta), it.id, "", getUri(it), "")
        }
    }

    String getUri(SezioneBusiness sezione) {
        switch (sezione.id) {
            case Sezione.DIZIONARIO_PAGAMENTO_PARAMETRI:
                return "/restrict/certificazione/dizionari/pagamento/parametroLista.zul"
            case Sezione.DIZIONARIO_PAGAMENTO_VOCI_DI_COSTO:
                return "/restrict/certificazione/dizionari/pagamento/voceCostoLista.zul"
            case Sezione.DIZIONARIO_PAGAMENTO_SERVIZI:
                return "/restrict/certificazione/dizionari/pagamento/servizioLista.zul"
            case Sezione.DIZIONARIO_PAGAMENTO_DOCUMENTI:
                return "/restrict/certificazione/dizionari/pagamento/documentoLista.zul"
            case Sezione.DIZIONARIO_PAGAMENTO_UTENTI:
                return "/restrict/certificazione/dizionari/pagamento/utenteLista.zul"
        }

        return null
    }

}
