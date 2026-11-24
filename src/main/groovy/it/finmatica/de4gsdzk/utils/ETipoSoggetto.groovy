package it.finmatica.de4gsdzk.utils

enum ETipoSoggetto {

    PADRE, MADRE, ALTRO, //nelle nascite
    NATO_A, // in CIVRNA e nelle nascite (CGE)
    TESTIMONE_1, TESTIMONE_2, TESTIMONE_3, TESTIMONE_4,//, ALTRO
    SOGGETTO, CONIUGE, RICHIEDENTE, INCARICATO, //PADRE, MADRE, ALTRO // in CIVDTS
    DISPONENTE, FIDUCIARIO_1, FIDUCIARIO_2, // in CIVDAT
    INTERPRETE, ASCENDENTE, CAMBIO_GENERALITA, SANITARIO, // CIVSOG
    RICONOSCIMENTO_PADRE, RICONOSCIMENTO_MADRE,
    PROCURATORE_PADRE, PROCURATORE_MADRE, // CIVSOG
    SOGGETTO_1, SOGGETTO_2, // in ISTAT, mat-div-pub-pvu-uci-scio

    RICHIEDENTE_CERTIFICATO, BENEFICIARIO_CERTIFICATO // in CERCEM

    Map getEtichettaDesc() {
        switch (this) {
            case RICHIEDENTE_CERTIFICATO: return Etichette.getEtichetta("Richiedente")
            case BENEFICIARIO_CERTIFICATO: return Etichette.getEtichetta("Beneficiario")
        }
        return null
    }
}