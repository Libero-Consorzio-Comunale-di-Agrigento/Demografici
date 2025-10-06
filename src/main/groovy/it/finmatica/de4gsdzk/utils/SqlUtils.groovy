package it.finmatica.de4gsdzk.utils

class SqlUtils {

    static String getFiltroLike(Object filtro) {
        filtro ? String.format("%%%s%%", filtro).toUpperCase() : null
    }

    static String beginsLike(String filtro) {
        if (filtro){
            return ("%" + filtro)
        }
        return ""
    }

    static String endsLike(String filtro) {
        if (filtro){
            return (filtro + "%")
        }
        return ""
    }

    static beginsAndEndsLike(String filtro){
        return (endsLike(beginsLike(filtro)))
    }

}
