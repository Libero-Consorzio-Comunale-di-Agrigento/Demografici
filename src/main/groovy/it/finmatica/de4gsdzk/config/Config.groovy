package it.finmatica.de4gsdzk.config

import com.jcabi.manifests.Manifests
import com.jcabi.manifests.ServletMfs
import it.finmatica.de4gsdzk.integrazioni.documentale.SpringSecurityAuthenticationProvider
import it.finmatica.de4gsdzk.integrazioni.documentale.StaticUserAuthenticationProvider
import it.finmatica.smartdoc.api.DocumentaleService
import it.finmatica.smartdoc.api.login.AuthenticationProvider
import it.finmatica.smartdoc.integrazioni.gdm.DocumentaleGdm
import it.finmatica.smartdoc.integrazioni.gdm.IntegrazioneGdmProperties
import it.finmatica.so4.login.So4SpringSecurityService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.thymeleaf.context.Context
import org.thymeleaf.spring4.templateresolver.SpringResourceTemplateResolver
import org.thymeleaf.templateresolver.ITemplateResolver

import javax.servlet.ServletContext
import javax.sql.DataSource

@Configuration
class Config {

    @Autowired ServletContext servletContext

    @Bean
    Holders de4gsdzkHolder() {
        return new Holders()
    }

    @Bean
    Manifests manifests() {
        Manifests manifests = new Manifests()
        manifests.append(new ServletMfs(servletContext))
        return manifests
    }

    @Bean
    ITemplateResolver xmlTemplateResolver() {
        SpringResourceTemplateResolver resolver = new SpringResourceTemplateResolver()
        resolver.setPrefix("classpath:/xml/")
        resolver.setSuffix(".xml")
        resolver.setCharacterEncoding("UTF-8")
        resolver.setTemplateMode("XML")
        return resolver
    }

    @Bean
    Context xmlContext() {
        return new Context()
    }

    @Bean
    DocumentaleService documentaleService(@Qualifier("dataSource_gdm") DataSource dataSource_gdm, So4SpringSecurityService springSecurityService) {
        AuthenticationProvider authenticationProvider = new SpringSecurityAuthenticationProvider(springSecurityService)
        return new DocumentaleGdm(dataSource_gdm, new IntegrazioneGdmProperties(), authenticationProvider)
    }

    @Bean
    DocumentaleService documentaleServiceStaticUser(@Qualifier("dataSource_gdm") DataSource dataSource_gdm) {
        AuthenticationProvider authenticationProvider = new StaticUserAuthenticationProvider()
        return new DocumentaleGdm(dataSource_gdm, new IntegrazioneGdmProperties(), authenticationProvider)
    }

}
