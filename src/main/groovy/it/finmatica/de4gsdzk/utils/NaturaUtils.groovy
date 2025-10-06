package it.finmatica.de4gsdzk.utils

class NaturaUtils {

    static List<ENaturaAtto> getValoriCittadinanza(){
        return [ENaturaAtto.A, ENaturaAtto.P, ENaturaAtto.D, ENaturaAtto.N]
    }

    static List<ENaturaAtto> getValoriNascita(){
        return [ENaturaAtto.O, ENaturaAtto.T, ENaturaAtto.D, ENaturaAtto.N]
    }

    static List<ENaturaAtto> getValoriMatrimonio(){
        return [ENaturaAtto.O, ENaturaAtto.T, ENaturaAtto.D, ENaturaAtto.N]
    }

    static List<ENaturaAtto> getValoriDivorzio(){
        return [ENaturaAtto.D, ENaturaAtto.N]
    }

    static List<ENaturaAtto> getValoriVerbalePubblicazione(){
        return [ENaturaAtto.O, ENaturaAtto.T, ENaturaAtto.N]
    }

    static List<ENaturaAtto> getValoriDecesso(){
        return [ENaturaAtto.O, ENaturaAtto.T, ENaturaAtto.D, ENaturaAtto.N]
    }

    static List<ENaturaAtto> getValoriUnioneCivile(){
        return [ENaturaAtto.O, ENaturaAtto.T, ENaturaAtto.D, ENaturaAtto.N]
    }

    static List<ENaturaAtto> getValoriProcessoVerbale(){
        return [ENaturaAtto.V, ENaturaAtto.N]
    }

    static List<ENaturaAtto> getValoriScioglimento(){
        return [ENaturaAtto.D, ENaturaAtto.N]
    }

    static List<ENaturaAtto> getValoriByTipoAtto(ETipoAtto tipoAtto) {
        switch (tipoAtto) {
            case ETipoAtto.CIT: return getValoriCittadinanza()
            case ETipoAtto.NAS: return getValoriNascita()
            case ETipoAtto.MAT: return getValoriMatrimonio()
            case ETipoAtto.UCI: return getValoriUnioneCivile()
            case ETipoAtto.MOR: return getValoriDecesso()
            case ETipoAtto.PUB: return getValoriVerbalePubblicazione()
            case ETipoAtto.PVU: return getValoriProcessoVerbale()
            default: return []
        }
    }

}
