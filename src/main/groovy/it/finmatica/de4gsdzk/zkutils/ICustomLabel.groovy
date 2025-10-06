package it.finmatica.de4gsdzk.zkutils

interface ICustomLabel {
    def getValue()
    void setValue(def value)
    void setMandatory(Boolean mandatory)
    void setBold(Boolean bold)
}