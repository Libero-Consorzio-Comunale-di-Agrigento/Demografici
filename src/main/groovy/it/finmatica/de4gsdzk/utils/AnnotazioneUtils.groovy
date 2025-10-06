package it.finmatica.de4gsdzk.utils

import groovy.util.logging.Slf4j

@Slf4j
class AnnotazioneUtils {

    static Integer fromStringToIntegerParte(String v){
        if ( (v?.trim()?:"") == ""){
            return null
        }
        if ( (v.trim().toUpperCase()) == "I"){
            return new Integer(1)
        }
        if ( (v.trim().toUpperCase()) == "II"){
            return new Integer(2)
        }
        return Integer.parseInt(v)
    }

    static Integer fromStringToIntegerUfficio(String v){
        return fromStringToInteger(v)
    }

    static Integer fromStringToIntegerAnno(String v){
        return fromStringToInteger(v)
    }

    static Integer fromStringToInteger(String v){
        if ( (v?.trim()?:"") == ""){
            return null
        }
        return Integer.parseInt(v)
    }
}
