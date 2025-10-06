package it.finmatica.de4gsdzk.anagrafe

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.IntegrationSpec
import org.hibernate.Hibernate
import org.springframework.beans.factory.annotation.Autowired

@Slf4j
class AnaDocumentoRepositorySpec extends IntegrationSpec {

    @Autowired
    AnaDocumentoRepository anaDocumentoRepository

    void "Ottenimento dei documenti CE di Brico/Luca hanno il fetch"() {
        given:
        AnaAnagrafe anagrafe = new AnaAnagrafe(id: 114395)
        AnaTipoDocumento tipoDocumento = new AnaTipoDocumento(id: AnaTipoDocumento.CE)

        when:
        List<AnaDocumento> list = anaDocumentoRepository.findAllByAnagrafeAndTipoDocumentoOrderByProgressivoDesc(anagrafe, tipoDocumento)

        then:
        !list.empty
        list.every {
            Hibernate.isInitialized(it.anagrafe)
            Hibernate.isInitialized(it.tipoDocumento)
            Hibernate.isInitialized(it.allegati)
        }

    }

}
