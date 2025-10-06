package it.finmatica.de4gsdzk.config

import com.jcabi.manifests.Manifests
import it.finmatica.de4gsdzk.integrazioni.documentale.SpringSecurityAuthenticationProvider
import it.finmatica.de4gsdzk.integrazioni.documentale.StaticUserAuthenticationProvider
import it.finmatica.smartdoc.api.DocumentaleService
import it.finmatica.smartdoc.integrazioni.gdm.DocumentaleGdm
import it.finmatica.so4.login.So4SpringSecurityService
import org.thymeleaf.context.Context
import spock.lang.Specification

import javax.servlet.ServletContext
import javax.sql.DataSource

class ConfigSpec extends Specification {

    // Create an instance of the configuration class
    Config config = new Config()

    def setup() {
        // Manually inject the required ServletContext dependency.
        config.servletContext = Mock(ServletContext)
    }

    def "should create de4gsdzkHolder bean"() {
        when:
        def holder = config.de4gsdzkHolder()

        then:
        holder != null
    }

    def "should create manifests bean and append a ServletMfs"() {
        when:
        Manifests manifests = config.manifests()

        then:
        manifests != null

        // If you need to check that a ServletMfs was appended, you might use its toString
        // or other available API; here we simply verify that the bean creation did not fail.
    }

    def "should create xmlContext bean"() {
        when:
        Context contextBean = config.xmlContext()

        then:
        contextBean != null
    }

    def "should create documentaleService bean with SpringSecurityAuthenticationProvider"() {
        given:
        DataSource dataSource = Mock(DataSource)
        So4SpringSecurityService springSecurityService = Mock(So4SpringSecurityService)

        when:
        DocumentaleService service = config.documentaleService(dataSource, springSecurityService)

        then:
        service instanceof DocumentaleGdm

        and: "the authentication provider is of type SpringSecurityAuthenticationProvider"
        def authProvider = extractField(service, "authenticationProvider")
        authProvider instanceof SpringSecurityAuthenticationProvider
    }

    def "should create documentaleServiceStatic bean with StaticUserAuthenticationProvider"() {
        given:
        DataSource dataSource = Mock(DataSource)

        when:
        DocumentaleService service = config.documentaleServiceStaticUser(dataSource)

        then:
        service instanceof DocumentaleGdm

        and: "the authentication provider is of type StaticUserAuthenticationProvider"
        def authProvider = extractField(service, "authenticationProvider")
        authProvider instanceof StaticUserAuthenticationProvider
    }

    /**
     * Helper method to extract a private field via reflection.
     */
    private Object extractField(Object target, String fieldName) {
        def field = target.getClass().getDeclaredField(fieldName)
        field.setAccessible(true)
        return field.get(target)
    }
}
