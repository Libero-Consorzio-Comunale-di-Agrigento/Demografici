package it.finmatica.de4gsdzk.utils

class ProspettoAtti {

    private String ANNO
    private String UFFICIO

    private String NAS1A
    private String NAS1B
    private String NAS2A
    private String NAS2B

    private String PUB1
    private String PUB2A
    private String PUB2B

    private String MAT1
    private String MAT2A
    private String MAT2B
    private String MAT2C

    private String MOR1
    private String MOR2A
    private String MOR2B
    private String MOR2C
    private String MOR2BB

    private String CIT

    private String UCI_V

    private String UCI_A

    ProspettoAtti(){}

    ProspettoAtti(Map<String, Object> m){
        for ( Map.Entry<String, Object> e : m ) {
            if (m[e.key] != null){
                this."$e.key" = String.valueOf(m[e.key].intValueExact())
            } else {
                this."$e.key" = ""
            }
        }
    }

    String getANNO() {
        return ANNO
    }

    String getUFFICIO() {
        return UFFICIO
    }

    String getNAS1A() {
        return NAS1A
    }

    String getNAS1B() {
        return NAS1B
    }

    String getNAS2A() {
        return NAS2A
    }

    String getNAS2B() {
        return NAS2B
    }

    String getPUB1() {
        return PUB1
    }

    String getPUB2A() {
        return PUB2A
    }

    String getPUB2B() {
        return PUB2B
    }

    String getMAT1() {
        return MAT1
    }

    String getMAT2A() {
        return MAT2A
    }

    String getMAT2B() {
        return MAT2B
    }

    String getMAT2C() {
        return MAT2C
    }

    String getMOR1() {
        return MOR1
    }

    String getMOR2A() {
        return MOR2A
    }

    String getMOR2B() {
        return MOR2B
    }

    String getMOR2C() {
        return MOR2C
    }

    String getMOR2BB() {
        return MOR2BB
    }

    String getCIT() {
        return CIT
    }

    String getUCI_V() {
        return UCI_V
    }

    String getUCI_A() {
        return UCI_A
    }
}

