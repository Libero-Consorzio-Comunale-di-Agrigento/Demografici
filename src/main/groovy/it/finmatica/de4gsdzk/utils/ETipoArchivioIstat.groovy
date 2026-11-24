package it.finmatica.de4gsdzk.utils

enum ETipoArchivioIstat {

    GDI("GDI"), // 'GDI', 'Grado di istruzione'
    PNP("PNP"), // 'PNP', 'Posizione nella professione'
    RDA("RDA"), // 'RDA', 'Ramo di attivita'
    CNP("CNP"), // 'CNP', 'Condizione non professionale'
    RDM("RDM"), // 'RDM', 'Rito del matrimonio'
    RPA("RPA"), // 'RPA', 'Regime Patrimoniale'
    TCI("TCI"), // 'TCI', 'Tipo Cittadinanza'
    LDE("LDE"), // 'LDE', 'Luogo decesso'
    LPA("LPA"), // 'LPA', 'Luogo del parto'
    TPA("TPA"), // 'TPA', 'Tipo di parto'
    TFI("TFI"), // 'TFI', 'Tipo di filiazione'
    PRE("PRE"), // 'PRE', 'Presentazione'
    GPA("GPA"), // 'GPA', 'Genere del parto'
    CON("CON"), // 'CON', 'Consanguineita'''
    SCM("SCM"), // 'SCM', 'Stato civile M'
    SCF("SCF"), // 'SCF', 'Stato civile F'
    TAC("TAC"), // 'TAC', 'Tipo di accordo extragiudiziale - divorzio/separazione'
    TAS("TAS"), // 'TAS', 'Tipo di accordo extragiudiziale - scioglimento UCI'
    SCN("SCN"), // 'SCN', 'Sostentamente Coniuge'
    CCN("CCN"), // 'CCN', 'Sostentamente Coniuge (Chi)'
    ABI("ABI"), // 'ABI', 'Assegnamento Abitazione'
    PFG("PFG"), // 'PFG', 'Figli'
    CDI("CDI"), // 'CDI', 'Causa divorzio'
    TST("TST"), // 'TST', 'Titolo di studio'
    PSC("PSC"), // 'PSC', 'Posizione nella professione per modello SC'
    CSC("CSC"), // 'CSC', 'Condizione professionale per modello SC'
    TAF("TAF"), // 'TAF', 'Tipo affidamento'
    MFG("MFG"), // 'MFG', 'Mantenimento Figli'
    CFG("CFG"), // 'CFG', 'Sostentamente Figli (Chi)'
    MFM("MFM"), // 'MFM', 'Mantenimento Figli Maggiorenni'
    SEX("SEX"), // 'SEX', 'Sesso'
    PRO("PRO"), // 'PRO', 'Tipo di provvedimento emesso dal Tribunale o Corte d’Appello - divorzio'
    PRS("PRS"), // 'PRS', 'Tipo di provvedimento emesso dal Tribunale o Corte d’Appello - scioglimento UCI'
    TPR("TPR")  // 'TPR', 'Tipo procedura'

    final String id

    private ETipoArchivioIstat(String id) {
        this.id = id
    }

}
