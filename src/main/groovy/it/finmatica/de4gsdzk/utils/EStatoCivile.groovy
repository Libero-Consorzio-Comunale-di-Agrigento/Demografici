package it.finmatica.de4gsdzk.utils

import javax.persistence.AttributeConverter
import javax.persistence.Converter

enum EStatoCivile {

    UC("UC"), // Unito civilmente
    VU("VU"), // Vedovo da unione civile
    GU("GU"), // Già unito civilmente
    CN("CN"), // Coniugato
    VE("VE"), // Vedovo
    CE("CE"), // Celibe
    NU("NU"), // Nubile
    GC("GC"), // Già coniugato
    DV("DV"), // Divorziato
    NC("NC")  // Non conosciuto

    String id

    EStatoCivile(String id) {
        this.id = id
    }

    boolean isUnioneCivile() {
        return this in [UC, VU, GU]
    }

    boolean isMatrimonio() {
        return this in [CN, VE, GC, DV]
    }

    boolean hasConiugeContraente() {
        return this in [CN, UC, VE, VU, DV, GC, GU]
    }

    boolean isVedovo(){
        return this in [VE,VU]
    }

    boolean isDivorzioScioglimento(){
        return this in [DV, GC, GU]
    }

    @Converter
    static class EnumStatoCivileToStringConverter implements AttributeConverter<EStatoCivile, String> {
        @Override
        String convertToDatabaseColumn(EStatoCivile ee) {
            return (ee ? ee.id : null)
        }

        @Override
        EStatoCivile convertToEntityAttribute(String value) {
            EStatoCivile ret = null
            for (EStatoCivile ee : values()) {
                if (ee.id == value) {
                    ret = ee
                    break
                }
            }
            return ret
        }
    }

}