package it.finmatica.de4gsdzk.utils

enum EInvioProtocollo {
    R, S, N
    Map getEtichettaDesc() {
        switch(this) {
            case R: return Etichette.A_Richiesta
            case S: return Etichette.SI
            case N: return Etichette.NO
        }
    }
}