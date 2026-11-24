package it.finmatica.de4gsdzk.utils

enum ETipoSalvataggioAnnotazioneComuneCliente {
    CREA_ATTO_E_SALVA_COMUNE_CLIENTE,
    NON_CREARE_ATTO_E_SALVA_ALTRO_COMUNE

    Map getEtichettaDesc() {
        switch (this) {
            case CREA_ATTO_E_SALVA_COMUNE_CLIENTE: return Etichette.getEtichetta("Crea_atto_pregresso_consolida")
            case NON_CREARE_ATTO_E_SALVA_ALTRO_COMUNE: return Etichette.getEtichetta("Consolida")
        }
        return null
    }
}