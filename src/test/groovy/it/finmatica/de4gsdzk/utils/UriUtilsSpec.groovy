package it.finmatica.de4gsdzk.utils

import org.zkoss.zk.ui.Execution
import org.zkoss.zk.ui.Executions
import spock.lang.Specification

class UriUtilsSpec extends Specification {

    def 'test resolveUri with null URI'() {
        when:
        UriUtils.resolveUri(null)

        then:
        thrown(IllegalArgumentException)
    }

    def 'rest resolveUri with empty URI'() {
        given:
        URI uri = new URI("")

        and:
        def mockExecution = Mock(Execution)
        Executions.metaClass.static.getCurrent = { mockExecution }
        mockExecution.getScheme() >> "http"
        mockExecution.getServerName() >> "localhost"
        mockExecution.getServerPort() >> 8080
        mockExecution.getContextPath() >> "/context/path"

        when:
        URI result = UriUtils.resolveUri(uri)

        then:
        result == new URI("http://localhost:8080/context/path")
    }

    def 'test resolveUri with absolute URI'() {
        given:
        URI uri = new URI("https://example.com/somepath")

        when:
        URI result = UriUtils.resolveUri(uri)

        then:
        result == new URI("https://example.com/somepath")
    }

    def 'test resolveUri with relative URI'() {
        given:
        URI uri = new URI("/relative/path")

        and:
        def mockExecution = Mock(Execution)
        Executions.metaClass.static.getCurrent = { mockExecution }
        mockExecution.getScheme() >> "http"
        mockExecution.getServerName() >> "localhost"
        mockExecution.getServerPort() >> 8080

        when:
        URI result = UriUtils.resolveUri(uri)

        then:
        result == new URI("http://localhost:8080/relative/path")
    }

    def 'test resolveUri with missing leading slash on relative URI'() {
        given:
        URI uri = new URI("relative/path")

        and:
        def mockExecution = Mock(Execution)
        Executions.metaClass.static.getCurrent = { mockExecution }
        mockExecution.getScheme() >> "http"
        mockExecution.getServerName() >> "localhost"
        mockExecution.getServerPort() >> 8080

        when:
        URI result = UriUtils.resolveUri(uri)

        then:
        result == new URI("http://localhost:8080/relative/path")
    }
}
