package it.finmatica.de4gsdzk.zkutils


import it.finmatica.de4gsdzk.config.Holders
import org.springframework.context.ApplicationContext
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.select.Selectors
import org.zkoss.zul.Label
import spock.lang.Specification
import spock.lang.Unroll

class DateLabelSpec extends Specification {

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

        GroovySpy(Holders, global: true)
        ApplicationContext applicationContext = Mock(ApplicationContext)
        Holders.getApplicationContext() >> applicationContext
    }

    @Unroll
    def "Formattazione data label con data:#date"() {
        given:
        DateLabel dl = new DateLabel()

        when:
        dl.setValue(date)

        then:
        dl.label.value == expected

        where:
        date                    | expected
        new Date(1735689600000) | "01/01/2025"
        null                    | ""
    }
}

