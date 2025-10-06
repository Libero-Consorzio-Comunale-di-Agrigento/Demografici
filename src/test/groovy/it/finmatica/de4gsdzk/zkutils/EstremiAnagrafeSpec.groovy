package it.finmatica.de4gsdzk.zkutils

import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafe
import it.finmatica.de4gsdzk.config.Holders
import org.springframework.context.ApplicationContext
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.select.Selectors
import org.zkoss.zul.Label
import spock.lang.Specification
import spock.lang.Unroll

class EstremiAnagrafeSpec extends Specification {

    def setup() {
        // Use GroovyMock to stub out static methods so that ZK component loading doesn't occur
        GroovyMock(Executions, global: true)
        Executions.createComponents(_ as String, _ as Object, _) >> { String zul, def comp, def args ->
            if (comp instanceof CustomLabel) {
                comp.label = new Label()
            }
        }

        GroovyMock(Selectors, global: true)
        Selectors.wireVariables(_, _, _) >> null
        Selectors.wireComponents(_, _, _) >> null
        Selectors.wireEventListeners(_, _) >> null

        // Stub the Holders static call
        GroovySpy(Holders, global: true)
        ApplicationContext applicationContext = Mock(ApplicationContext)
        GsdEtichettaService etichettaService = Mock(GsdEtichettaService)
        Holders.getApplicationContext() >> applicationContext
        applicationContext.getBean(GsdEtichettaService) >> etichettaService
        etichettaService.listAndInsertWhereIdIn(_ as List) >> [
                'Matricola'         : 'Matricola',
                'Id_scheda_ANPR'    : 'Id Scheda ANPR',
                'Id_unico_nazionale': 'Id Unico Nazionale'
        ]
    }

    @Unroll
    def "Formattazione estremi anagrafe con matricola:#matricola, id scheda anpr:#idSoggettoAnpr, id unico nazionale:#idUnicoNazionale"() {
        given:
        AnaAnagrafe e = new AnaAnagrafe(id: matricola, idSoggettoAnpr: idSoggettoAnpr, idUnicoAnpr: idUnicoNazionale)
        EstremiAnagrafeLabel eal = new EstremiAnagrafeLabel()

        when:
        eal.setValue(e)

        then:
        eal.label.value == expected

        where:
        matricola | idSoggettoAnpr | idUnicoNazionale || expected
        100       | null           | null             || "Matricola 100"
        100       | 5              | null             || "Matricola 100 - Id Scheda ANPR 5"
        100       | null           | "A"              || "Matricola 100 - Id Unico Nazionale A"
        100       | 5              | "A"              || "Matricola 100 - Id Scheda ANPR 5 - Id Unico Nazionale A"
    }
}

