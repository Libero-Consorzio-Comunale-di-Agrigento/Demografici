package it.finmatica.de4gsdzk


import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.test.context.ActiveProfiles
import org.springframework.test.context.TestPropertySource
import org.springframework.test.context.web.WebAppConfiguration
import org.springframework.transaction.annotation.Transactional
import spock.lang.Specification

import javax.sql.DataSource

@WebAppConfiguration("web-app")
@SpringBootTest
@Transactional
@ActiveProfiles("test")
@TestPropertySource(properties = ["hibernate.integration.envers.enabled=false",
        "spring.jpa.properties.org.hibernate.integration.envers.enabled=false",
        "spring.jpa.properties.hibernate.integration.envers.enabled=false"])
class IntegrationSpec extends Specification {
    @Autowired
    DataSource dataSource
}
