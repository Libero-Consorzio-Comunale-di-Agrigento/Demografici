package it.finmatica.de4gsdzk.utils

enum ETipoFormulaAnnotazioneDaAtto {

    NAS_1("NAS_1", 1),  // Su atto di nascita del primo soggetto
    NAS_2("NAS_2", 2),  // Su atto di nascita del secondo soggetto
    MAT("MAT", 3)       // Su atto di matrimonio o di unione civile

    final String id
    final int sequenza

    private ETipoFormulaAnnotazioneDaAtto(String id, int sequenza) {
        this.id = id
        this.sequenza = sequenza
    }

}