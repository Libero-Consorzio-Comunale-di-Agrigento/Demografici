package it.finmatica.de4gsdzk

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.certificazione.CerStatoCivileFiltro
import it.finmatica.de4gsdzk.utils.ESesso
import it.finmatica.de4gsdzk.utils.ETipoSiNo

@CompileStatic
interface IAttoCertificabileService extends IAttoAnscService {

    ETipoSiNo getCertificabile(Long id)

    List<ICertificabile> listAllByStatoCivileFiltroList(List<CerStatoCivileFiltro> statoCivileFiltroList)

}
