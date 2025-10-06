package it.finmatica.de4gsdzk.utils

// TODO: generalizzare il Tab e il SelectedTab
class SelectedTabComunicazioneAnsc {
    ETabComunicazioniAnsc tab
    IPredicate<ETabComunicazioniAnsc> predicate

    SelectedTabComunicazioneAnsc(IPredicate predicate) {
        this.predicate = predicate
    }

    void initialize() {
        setIndex(0)
    }

    void setIndex(Integer index) {
        ETabComunicazioniAnsc tab = ETabComunicazioniAnsc.fromIndex(index)
        if (predicate.test(tab)) {
            this.tab = tab
        } else {
            setIndex(index + 1)
        }
    }

    Integer getIndex() {
        tab.index
    }
}
