package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.utils.ValidationUtils

/**
 * Classe base per un Service legato a una entity DB
 *
 * - NON usata ancora!
 * - TODO: controllare che non spacchi la transazionalità (non dovrebbe)
 *
 * @param <T> il tipo della entity
 */
abstract class BaseService<T> {

    /**
     * @see ValidationUtils#validaDatiObbligatori(java.lang.Object, java.util.Map)
     */
    void validaDati(T entity, Map condition = [:]) {
        ValidationUtils.validaDatiObbligatori(entity, condition)
    }

}