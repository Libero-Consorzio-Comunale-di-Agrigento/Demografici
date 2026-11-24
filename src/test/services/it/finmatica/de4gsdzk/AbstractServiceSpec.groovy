package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.statocivile.CivRichiamoFormula
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.jdbc.core.JdbcTemplate
import spock.lang.Specification

class AbstractServiceSpec<E> extends Specification {

    GsdService gsdService

    GsdEtichettaService gsdEtichettaService

    ArcParametroService arcParametroService

    @Autowired
    private JdbcTemplate jdbcTemplate

    void setup() {
        gsdService = Mock(GsdService)
        gsdService.getIdFromSequence(_) >> { (Long) (Math.random() * 10000) }
        gsdService.getIdFromSequence(_,_) >> { (Long) (Math.random() * 10000) }
        arcParametroService = Mock(ArcParametroService)
        gsdEtichettaService = new GsdEtichettaService(null, null, arcParametroService)
    }

    protected E duplica(E doc) {
        Map props = doc.getProperties()
        props.remove('class')
        props.remove('metaClass')
        props.remove( 'etichetteDomain')
        E ret = doc.getClass().newInstance()
        if (ret instanceof CivRichiamoFormula){
            props = ["id": doc["id"], "formula": doc["formula"], "tipoAtto": doc["tipoAtto"], "richiamo": doc["richiamo"], "progressivo": doc["progressivo"]]
        }
        props.keySet().each { ret[it] = doc[it] }
        return ret
    }

    Boolean gestioneVariabiliOld(String formula){
        String sql = "SELECT * FROM CIVNFA WHERE FORMULA LIKE '" + formula + "'"
        List<Map<String, Object>> nfaList = jdbcTemplate.queryForList(sql)

        for (int j = 0; j < nfaList.size(); j++){
            if (nfaList[j]["TESTO_VAR_AUTO"] != null){
                return false
            }
        }
        return true
    }

}
