package it.finmatica.de4gsdzk.utils

class FormulaChiusuraAtti {

    private long totAtti

    private Integer attoMinAtto
    private Date attoMinData

    private Integer attoMaxAtto
    private Date attoMaxData

    FormulaChiusuraAtti(){
        super()
    }

    FormulaChiusuraAtti(long totAtti, Integer attoMinAtto, Date attoMinData, Integer attoMaxAtto, Date attoMaxData) {
        super()
        this.totAtti = totAtti
        this.attoMinAtto = attoMinAtto
        this.attoMinData = attoMinData
        this.attoMaxAtto = attoMaxAtto
        this.attoMaxData = attoMaxData
    }

    long getTotAtti() {
        return totAtti
    }

    void setTotAtti(long totAtti) {
        this.totAtti = totAtti
    }

    Integer getAttoMinAtto() {
        return attoMinAtto
    }

    void setAttoMinAtto(Integer attoMinAtto) {
        this.attoMinAtto = attoMinAtto
    }

    Date getAttoMinData() {
        return attoMinData
    }

    void setAttoMinData(Date attoMinData) {
        this.attoMinData = attoMinData
    }

    Integer getAttoMaxAtto() {
        return attoMaxAtto
    }

    void setAttoMaxAtto(Integer attoMaxAtto) {
        this.attoMaxAtto = attoMaxAtto
    }

    Date getAttoMaxData() {
        return attoMaxData
    }

    void setAttoMaxData(Date attoMaxData) {
        this.attoMaxData = attoMaxData
    }
}
