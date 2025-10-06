package restrict.statocivile

import it.finmatica.de4gsdzk.statocivile.CivCategoriaTipoRichiesta

interface IRowMotivoRichiesta {

    // ------------------------------ TIPO RICHIESTA ------------------------------
    List<CivCategoriaTipoRichiesta> getListaTipoRichiesta()

    void caricaListaTipoRichiesta()

    void onSelectTipoRichiesta()

    // ------------------------------ MOTIVO RICHIESTA ------------------------------

    void onCaricaMotiviRichiesta()

    String getMotivoRichiestaField()
}