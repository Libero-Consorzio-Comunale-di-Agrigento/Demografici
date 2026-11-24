package it.finmatica.de4gsdzk.integrazioni.documentale

enum EModelloGdm {
    FascicoliStatoCivile("FASCICOLI_CIV"),
    CertificatiEmessi("CERTIFICATI_EMESSI"),
    CarteIdentitaElettronica("CE"),
    CarteIdentita("CI"),
    CarteIdentitaDaConsolato("CA"),
    SoggiornoUe("U1"),
    SoggiornoPermanenteUe("U2"),
    Individuo("AP5_Individui"),
    Famiglia("AP6_Famiglie"),
    CartaSoggiorno("CS"),
    DocumentoConsolare("DC"),
    DocumentoIdentita("DI"),
    AttoDivorzio("DV"),
    AttoMatrimonio("MA"),
    AttoMorte("MO"),
    AttoNascita("NA"),
    Passaporto("PP"),
    PermessoSoggiorno("PS"),
    Pso("RP"),
    StoricoDocumenti("SD"),
    CdFIstituzionale("XX"),
    CdFRisoluzione("XR"),
    ContrattoConvivenza("ZI"),
    RisoluzioneContrattoConvivenza("ZR"),
    Pratica("Pratica")

    final String id

    EModelloGdm(String id) {
        this.id = id
    }

    @Override
    String toString() {
        return id
    }
}

