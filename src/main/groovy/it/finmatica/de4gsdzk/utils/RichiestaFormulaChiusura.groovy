package it.finmatica.de4gsdzk.utils

class RichiestaFormulaChiusura {

    private String autorita
    private String ordinanzaDel

    private Date dataOrdinanza
    private Date dataRestituzione
    private Date dataChiusura

    RichiestaFormulaChiusura() {
        super()
    }

    RichiestaFormulaChiusura(String autorita, String ordinanzaDel, Date dataOrdinanza, Date dataRestituzione, Date dataChiusura){
        this.autorita = autorita
        this.ordinanzaDel = ordinanzaDel
        this.dataOrdinanza = dataOrdinanza
        this.dataRestituzione = dataRestituzione
        this.dataChiusura = dataChiusura
    }

    String getAutorita() {
        return autorita
    }

    void setAutorita(String autorita) {
        this.autorita = autorita
    }

    String getOrdinanzaDel() {
        return ordinanzaDel
    }

    void setOrdinanzaDel(String ordinanzaDel) {
        this.ordinanzaDel = ordinanzaDel
    }

    Date getDataOrdinanza() {
        return dataOrdinanza
    }

    void setDataOrdinanza(Date dataOrdinanza) {
        this.dataOrdinanza = dataOrdinanza
    }

    Date getDataRestituzione() {
        return dataRestituzione
    }

    void setDataRestituzione(Date dataRestituzione) {
        this.dataRestituzione = dataRestituzione
    }

    Date getDataChiusura() {
        return dataChiusura
    }

    void setDataChiusura(Date dataChiusura) {
        this.dataChiusura = dataChiusura
    }
}