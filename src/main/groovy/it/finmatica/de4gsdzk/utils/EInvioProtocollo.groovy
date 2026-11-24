package it.finmatica.de4gsdzk.utils

enum EInvioProtocollo {
    R, S, N
    Map getEtichettaDesc() {
        switch(this) {
            case R: return Etichette.getEtichetta("A_Richiesta")
            case S: return Etichette.getEtichetta("SI")
            case N: return Etichette.getEtichetta("NO")
        }
    }
}