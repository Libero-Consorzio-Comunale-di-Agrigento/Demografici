package it.finmatica.de4gsdzk.utils

import groovy.util.logging.Slf4j

@Slf4j
class FunzioniPresentation<T extends Enum<T>> {
    private final Class<T> enumType
    private Funzioni<T> funzioni

    FunzioniPresentation(Class<T> enumType) {
        this.enumType = enumType
    }

    void setFunzioni(Funzioni<T> funzioni) {
        this.funzioni = funzioni
    }

    T getEnum(String name) {
        try {
            return Enum.valueOf(enumType, name)
        } catch (IllegalArgumentException e) {
            log.error(e.message, e)
            return null
        }
    }

    Boolean isVisible(String name) {
        T funzione = getEnum(name)
        if (funzione == null) {
            return Boolean.FALSE
        }
        if (funzioni == null) {
            return Boolean.FALSE
        }
        return funzioni.isVisible(funzione)
    }

    Boolean isDisabled(String name) {
        T funzione = getEnum(name)
        if (funzione == null) {
            return Boolean.FALSE
        }
        if (funzioni == null) {
            return Boolean.FALSE
        }
        return !funzioni.isEnabled(funzione)
    }
}
