package it.finmatica.de4gsdzk

import groovy.transform.CompileStatic

@CompileStatic
interface IAttoService {

    Integer getCodiceRecord(Long id)

    Boolean getBloccato(Long id)

    CivAttoBaseDomain get (Long id, Map params)

    CivAttoBaseDomain getByUkAtto(Integer ufficio, Integer anno, Integer atto, Integer parte, String serie)

    Boolean existsByUkAtto(Integer ufficio, Integer anno, Integer atto, Integer parte, String serie)

}
