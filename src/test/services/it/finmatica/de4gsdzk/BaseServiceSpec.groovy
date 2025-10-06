package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.statocivile.CivParametroProtocollo

class BaseServiceSpec<E> extends AbstractServiceSpec<E> {

    void "Controlla i campi obbligatori dell'entity"() {

        given:
        BaseService<CivParametroProtocollo> service = new BaseService<CivParametroProtocollo>() {}
        CivParametroProtocollo p = new CivParametroProtocollo()

        when:
        service.validaDati(p)

        then:
        String msg = thrown(CampoMandatoryRuntimeException)
        System.out.println("ERR: " + msg)
    }

}
