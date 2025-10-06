package it.finmatica.de4gsdzk.anagrafe

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.IntegrationSpec
import it.finmatica.de4gsdzk.utils.SortUtils
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.data.domain.Sort
import spock.lang.Unroll

@Slf4j
class AnaAnagrafeRepositorySpec extends IntegrationSpec {

    public static final String RES2027269 = "RES2027269"
    public static final String RES0001063 = "RES0001063"
    public static final String AIR0000124 = "AIR0000124"

    @Autowired
    AnaAnagrafeRepository anaAnagrafeRepository

    @Unroll
    void "Ottenimento dei membri della famiglia #idFamiglia - showCancellati=#showCancellati"() {
        given:
        AnaFamiglia famiglia = new AnaFamiglia(id: idFamiglia)

        when:
        Sort sort = new Sort(SortUtils.anagrafeSoggettoFamiliareAsc)
        List<AnaAnagrafe> list = anaAnagrafeRepository.findAllByFamiglia(famiglia, showCancellati, sort)

        then:
        list.every {
            it.famiglia.id == idFamiglia
        }
        list.size() == countMembri

        where:
        idFamiglia | showCancellati | countMembri
        RES2027269 | true           | 3
        RES2027269 | false          | 3
        RES0001063 | true           | 4
        RES0001063 | false          | 1
        AIR0000124 | true           | 4
        AIR0000124 | false          | 0

    }

}
