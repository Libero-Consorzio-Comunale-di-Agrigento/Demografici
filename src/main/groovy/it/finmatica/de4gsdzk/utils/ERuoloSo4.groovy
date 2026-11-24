package it.finmatica.de4gsdzk.utils

enum ERuoloSo4 {
    CIV_SUPERUSER("GSDCIVSU"),          // - Super User (su Stato Civile)
    CIV_VISUALIZZATORE("GSDCIVVI"),     // - Visualizzatore  (su Stato Civile)

    CER_SUPERUSER("GSDCERSU"),          // - Super User (su Certificazione)
    CER_ANAGRAFE("GSDCERAN"),           // - Modifica Anagrafe (su Certificazione)
    CER_STATO_CIVILE("GSDCERSC"),       // - Modifica Stato Civile (su Certificazione)
    CER_ELETTORALE("GSDCEREL"),         // - Modifica Elettorale (su Certificazione)
    CER_LEVA_MILITARE("GSDCERLM"),      // - Modifica Leva Militare (su Certificazione)

    ANA_SUPERUSER("GSDANASU"),           // - Super User (su Anagrafe)
    ANA_VISUALIZZATORE("GSDANAVI"),     // - Visualizzatore  (su Anagrafe)

    ELE_SUPERUSER("GSDELESU"),          // - Super User (su Elettorale)

    LEV_SUPERUSER("GSDLEVSU"),          // - Super User (su Leva Militare)

    TOP_SUPERUSER("GSDTOPSU")           // - Super User (su Toponomastica)

    ERuoloSo4(String id) {
        this.id = id
    }

    String id

    static List<ERuoloSo4> statoCivile = [CIV_SUPERUSER]

    static List<ERuoloSo4> certificazione = [CER_ANAGRAFE, CER_ELETTORALE, CER_LEVA_MILITARE, CER_STATO_CIVILE, CER_SUPERUSER]

    static List<ERuoloSo4> anagrafe = [ANA_SUPERUSER, ANA_VISUALIZZATORE]

    static List<ERuoloSo4> elettorale = [ANA_SUPERUSER, ELE_SUPERUSER]

    static List<ERuoloSo4> levaMilitare = [ANA_SUPERUSER, LEV_SUPERUSER]

    static List<ERuoloSo4> toponomastica = [ANA_SUPERUSER, TOP_SUPERUSER]
}
