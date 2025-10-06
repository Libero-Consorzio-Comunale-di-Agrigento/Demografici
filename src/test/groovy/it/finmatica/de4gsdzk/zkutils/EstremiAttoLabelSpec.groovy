package it.finmatica.de4gsdzk.zkutils

import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.statocivile.embed.EstremiAtto
import it.finmatica.de4gsdzk.config.Holders
import org.springframework.context.ApplicationContext
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.select.Selectors
import org.zkoss.zul.Label
import spock.lang.Specification
import spock.lang.Unroll

class EstremiAttoLabelSpec extends Specification {

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
                'Provvisorio': 'Provvisorio',
                'Parte'      : 'Parte',
                'Serie'      : 'Serie',
                'Anno'       : 'Anno',
                'Ufficio'    : 'Ufficio'
        ]
    }

    @Unroll
    def "Formattazione estremi atto con atto:#atto, parte:#parte, serie:#serie, anno:#anno, ufficio:#ufficio"() {
        given:
        EstremiAttoLabel eal = new EstremiAttoLabel()
        EstremiAtto e = new EstremiAtto(atto: atto, parte: parte, serie: serie, anno: anno, ufficio: ufficio)

        when:
        eal.setValue(e)

        then:
        eal.label.value == expected

        where:
        atto | parte | serie | anno | ufficio || expected
        100  | null  | null  | null | null    || "100"
        0    | null  | null  | null | null    || "Provvisorio"
        100  | 5     | null  | null | null    || "100 - Parte 5"
        100  | null  | "A"   | null | null    || "100 - Serie A"
        100  | null  | null  | 2021 | null    || "100 - Anno 2021"
        100  | null  | null  | null | 3       || "100 - Ufficio 3"
        100  | 5     | "A"   | 2021 | 3       || "100 - Parte 5 - Serie A - Anno 2021 - Ufficio 3"
    }

    @Unroll
    def "Formattazione estremi atto con atto:#atto, parte:#parte, serie:#serie, anno:#anno, ufficio:#ufficio"() {
        given:
        EstremiAttoLabel eal = new EstremiAttoLabel()

        when:
        eal.setAtto(atto)
        eal.setParte(parte)
        eal.setSerie(serie)
        eal.setAnno(anno)
        eal.setUfficio(ufficio)

        then:
        eal.label.value == expected

        where:
        atto | parte | serie | anno | ufficio || expected
        100  | null  | null  | null | null    || "100"
        0    | null  | null  | null | null    || "Provvisorio"
        100  | 5     | null  | null | null    || "100 - Parte 5"
        100  | null  | "A"   | null | null    || "100 - Serie A"
        100  | null  | null  | 2021 | null    || "100 - Anno 2021"
        100  | null  | null  | null | 3       || "100 - Ufficio 3"
        100  | 5     | "A"   | 2021 | 3       || "100 - Parte 5 - Serie A - Anno 2021 - Ufficio 3"
    }
}

