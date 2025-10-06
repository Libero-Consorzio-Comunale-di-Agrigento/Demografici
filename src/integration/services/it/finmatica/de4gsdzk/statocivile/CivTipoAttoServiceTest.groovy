package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.IntegrationSpec
import it.finmatica.de4gsdzk.utils.ETipoAtto
import org.springframework.beans.factory.annotation.Autowired

class CivTipoAttoServiceTest extends IntegrationSpec {
    @Autowired
    CivTipoAttoService civTipoAttoService

    def "Recupero CivTipoAtto per atto di nascita, parte 1, senza serie"() {
        given: "Tipo atto di nascita, parte e serie"
        Integer tipoAtto = ETipoAtto.NAS.valore
        Integer parte = 1
        String serie = null

        when: "Viene recuperato il CivTipoAtto"
        CivTipoAtto civTipoAtto = civTipoAttoService.getPregressoOriginaleByTipoAttoAndParteAndSerie(tipoAtto, parte, null)

        then: "Il CivTipoAtto esiste"
        civTipoAtto != null
    }

    def "Recupero CivTipoAtto per atto di nascita, parte 1 , serie A"() {
        given: "Tipo atto di nascita, parte e serie"
        Integer tipoAtto = ETipoAtto.NAS.valore
        Integer parte = 1
        String serie = "A"

        when: "Viene recuperato il CivTipoAtto"
        CivTipoAtto civTipoAtto = civTipoAttoService.getPregressoOriginaleByTipoAttoAndParteAndSerie(tipoAtto, parte, serie)

        then: "Il CivTipoAtto esiste"
        civTipoAtto != null
    }
}
