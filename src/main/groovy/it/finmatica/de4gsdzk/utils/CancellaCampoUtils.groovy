package it.finmatica.de4gsdzk.utils

class CancellaCampoUtils {

    static cancellaCampo(Object entita, String campo) {
        if (campo.indexOf(",") >= 0) {
            String[] sa = campo.split(",")
            for (String s : sa) {
                cancellaCampo(entita, s.trim())
            }
        } else {
            if (campo.indexOf(".") >= 0) {
                List<String> sa = campo.tokenize(".")
                String sa0 = sa[0]
                String sa1 = sa[1]
                entita."$sa0"?."$sa1" = null
            } else {
                entita."$campo" = null
            }
        }
    }
}
