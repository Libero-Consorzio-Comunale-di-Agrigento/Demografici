package it.finmatica.de4gsdzk.utils

class DatiProvenienzaValidationCheck {

    private final ETipoAtto tipoAttoEnumSource
    private Boolean ufficialeAccordo = Boolean.FALSE
    private Boolean ufficialeAltro = Boolean.FALSE
    private Boolean riconciliazione = Boolean.FALSE

    private Boolean dichiaranteMandatory = Boolean.FALSE
    private Boolean richiedenteTeaMandatory = Boolean.FALSE
    private Boolean consolatoMandatory = Boolean.FALSE
    private Boolean richiedenteTepMandatory = Boolean.FALSE
    private Boolean firmatarioMandatory = Boolean.FALSE
    private Boolean attoDaTrascrivereMandatory = Boolean.FALSE
    private Boolean estremiAttoDaTrascrivereMandatory = Boolean.FALSE
    private Boolean attoNotarileMandatory = Boolean.FALSE
    private Boolean fuoriCasaComunaleMandatory = Boolean.FALSE
    private Boolean provenienzaCpdMandatory = Boolean.FALSE
    private Boolean luogoCelebrazioneMandatory = Boolean.FALSE
    private Boolean certificatoRichiestaUciMandatory = Boolean.FALSE
    private Boolean negozAssistitaMandatory = Boolean.FALSE
    private Boolean avvocatiMandatory = Boolean.FALSE
    private Boolean avvocato1Mandatory = Boolean.FALSE
    private Boolean avvocato2Mandatory = Boolean.FALSE
    private Boolean riconoscimento1Mandatory = Boolean.FALSE
    private Boolean riconoscimento2Mandatory = Boolean.FALSE
    private Boolean assensoMandatory = Boolean.FALSE
    private Boolean tipoDivorzioAltroMandatory = Boolean.FALSE
    private Boolean accordoMandatory = Boolean.FALSE
    private Boolean accertamentoMandatory = Boolean.FALSE
    private Boolean provvedimentoSeparazioneMandatory = Boolean.FALSE
    private Boolean confermaAccordoSeparazioneMandatory = Boolean.FALSE
    private Boolean tipoProvvedimentoSeparazioneMandatory = Boolean.FALSE
    private Boolean autoritaGiudizialeMandatory = Boolean.FALSE
    private Boolean tipoAccordoMandatory = Boolean.FALSE // div-scio
    private Boolean procuraMandatory = Boolean.FALSE
    private Boolean riassuntoMandatory = Boolean.FALSE
    private Boolean dataTrascrizioneMandatory = Boolean.FALSE
    private Boolean estremiTrascrizioneMandatory = Boolean.FALSE
    private Boolean dataPubblicazioneSentenzaMandatory = Boolean.FALSE
    private Boolean tipoLuogoNascitaMandatory = Boolean.FALSE

    DatiProvenienzaValidationCheck(ETipoAtto tipoAttoEnumSource){
        this.tipoAttoEnumSource = tipoAttoEnumSource
    }

    DatiProvenienzaValidationCheck(ETipoAtto tipoAttoEnumSource, Boolean ufficialeAccordo, Boolean ufficialeAltro, Boolean riconciliazione){
        this.tipoAttoEnumSource = tipoAttoEnumSource
        this.ufficialeAccordo = ufficialeAccordo
        this.ufficialeAltro = ufficialeAltro
        this.riconciliazione = riconciliazione
    }

    ETipoAtto getTipoAttoEnumSource() {
        return tipoAttoEnumSource
    }

    Boolean isUfficialeAccordo(){
        return ufficialeAccordo
    }

    Boolean isUfficialeAltro() {
        return ufficialeAltro
    }

    Boolean isRiconciliazione() {
        return riconciliazione
    }

    Boolean getDichiaranteMandatory() {
        return dichiaranteMandatory
    }

    void setDichiaranteMandatory(Boolean dichiaranteMandatory) {
        this.dichiaranteMandatory = dichiaranteMandatory
    }

    Boolean getRichiedenteTeaMandatory() {
        return richiedenteTeaMandatory
    }

    void setRichiedenteTeaMandatory(Boolean richiedenteTeaMandatory) {
        this.richiedenteTeaMandatory = richiedenteTeaMandatory
    }

    Boolean getConsolatoMandatory() {
        return consolatoMandatory
    }

    void setConsolatoMandatory(Boolean consolatoMandatory) {
        this.consolatoMandatory = consolatoMandatory
    }

    Boolean getRichiedenteTepMandatory() {
        return richiedenteTepMandatory
    }

    void setRichiedenteTepMandatory(Boolean richiedenteTepMandatory) {
        this.richiedenteTepMandatory = richiedenteTepMandatory
    }

    Boolean getFirmatarioMandatory() {
        return firmatarioMandatory
    }

    void setFirmatarioMandatory(Boolean firmatarioMandatory) {
        this.firmatarioMandatory = firmatarioMandatory
    }

    Boolean getAttoDaTrascrivereMandatory() {
        return attoDaTrascrivereMandatory
    }

    void setAttoDaTrascrivereMandatory(Boolean attoDaTrascrivereMandatory) {
        this.attoDaTrascrivereMandatory = attoDaTrascrivereMandatory
    }

    Boolean getEstremiAttoDaTrascrivereMandatory() {
        return estremiAttoDaTrascrivereMandatory
    }

    void setEstremiAttoDaTrascrivereMandatory(Boolean estremiAttoDaTrascrivereMandatory) {
        this.estremiAttoDaTrascrivereMandatory = estremiAttoDaTrascrivereMandatory
    }

    Boolean getAttoNotarileMandatory() {
        return attoNotarileMandatory
    }

    void setAttoNotarileMandatory(Boolean attoNotarileMandatory) {
        this.attoNotarileMandatory = attoNotarileMandatory
    }

    Boolean getFuoriCasaComunaleMandatory() {
        return fuoriCasaComunaleMandatory
    }

    void setFuoriCasaComunaleMandatory(Boolean fuoriCasaComunaleMandatory) {
        this.fuoriCasaComunaleMandatory = fuoriCasaComunaleMandatory
    }

    Boolean getProvenienzaCpdMandatory() {
        return provenienzaCpdMandatory
    }

    void setProvenienzaCpdMandatory(Boolean provenienzaCpdMandatory) {
        this.provenienzaCpdMandatory = provenienzaCpdMandatory
    }

    Boolean getLuogoCelebrazioneMandatory() {
        return luogoCelebrazioneMandatory
    }

    void setLuogoCelebrazioneMandatory(Boolean luogoCelebrazioneMandatory) {
        this.luogoCelebrazioneMandatory = luogoCelebrazioneMandatory
    }

    Boolean getCertificatoRichiestaUciMandatory() {
        return certificatoRichiestaUciMandatory
    }

    void setCertificatoRichiestaUciMandatory(Boolean certificatoRichiestaUciMandatory) {
        this.certificatoRichiestaUciMandatory = certificatoRichiestaUciMandatory
    }

    Boolean getNegozAssistitaMandatory() {
        return negozAssistitaMandatory
    }

    void setNegozAssistitaMandatory(Boolean negozAssistitaMandatory) {
        this.negozAssistitaMandatory = negozAssistitaMandatory
    }

    Boolean getAvvocatiMandatory() {
        return avvocatiMandatory
    }

    void setAvvocatiMandatory(Boolean avvocatiMandatory) {
        this.avvocatiMandatory = avvocatiMandatory
    }

    Boolean getAvvocato1Mandatory() {
        return avvocato1Mandatory
    }

    void setAvvocato1Mandatory(Boolean avvocato1Mandatory) {
        this.avvocato1Mandatory = avvocato1Mandatory
    }

    Boolean getAvvocato2Mandatory() {
        return avvocato2Mandatory
    }

    void setAvvocato2Mandatory(Boolean avvocato2Mandatory) {
        this.avvocato2Mandatory = avvocato2Mandatory
    }

    Boolean getRiconoscimento1Mandatory() {
        return riconoscimento1Mandatory
    }

    void setRiconoscimento1Mandatory(Boolean riconoscimento1Mandatory) {
        this.riconoscimento1Mandatory = riconoscimento1Mandatory
    }

    Boolean getRiconoscimento2Mandatory() {
        return riconoscimento2Mandatory
    }

    void setRiconoscimento2Mandatory(Boolean riconoscimento2Mandatory) {
        this.riconoscimento2Mandatory = riconoscimento2Mandatory
    }

    Boolean getAssensoMandatory() {
        return assensoMandatory
    }

    void setAssensoMandatory(Boolean assensoMandatory) {
        this.assensoMandatory = assensoMandatory
    }

    Boolean getTipoDivorzioAltroMandatory() {
        return tipoDivorzioAltroMandatory
    }

    void setTipoDivorzioAltroMandatory(Boolean taa) {
        this.tipoDivorzioAltroMandatory = taa
    }

    Boolean getAccordoMandatory() {
        return accordoMandatory
    }

    void setAccordoMandatory(Boolean accordoMandatory) {
        this.accordoMandatory = accordoMandatory
    }

    Boolean getAccertamentoMandatory() {
        return accertamentoMandatory
    }

    void setAccertamentoMandatory(Boolean accertamentoMandatory) {
        this.accertamentoMandatory = accertamentoMandatory
    }

    Boolean getProvvedimentoSeparazioneMandatory() {
        return provvedimentoSeparazioneMandatory
    }

    void setProvvedimentoSeparazioneMandatory(Boolean provvedimentoSeparazioneMandatory) {
        this.provvedimentoSeparazioneMandatory = provvedimentoSeparazioneMandatory
    }

    Boolean getConfermaAccordoSeparazioneMandatory() {
        return confermaAccordoSeparazioneMandatory
    }

    void setConfermaAccordoSeparazioneMandatory(Boolean cse) {
        this.confermaAccordoSeparazioneMandatory = cse
    }

    Boolean getTipoProvvedimentoSeparazioneMandatory() {
        return tipoProvvedimentoSeparazioneMandatory
    }

    void setTipoProvvedimentoSeparazioneMandatory(Boolean tse) {
        this.tipoProvvedimentoSeparazioneMandatory = tse
    }

    Boolean getAutoritaGiudizialeMandatory() {
        return autoritaGiudizialeMandatory
    }

    void setAutoritaGiudizialeMandatory(Boolean ag) {
        this.autoritaGiudizialeMandatory = ag
    }

    Boolean getTipoAccordoMandatory() {
        return tipoAccordoMandatory
    }

    void setTipoAccordoMandatory(Boolean tac) {
        this.tipoAccordoMandatory = tac
    }

    Boolean getProcuraMandatory() {
        return procuraMandatory
    }

    void setProcuraMandatory(Boolean p) {
        this.procuraMandatory = p
    }

    Boolean getRiassuntoMandatory() {
        return riassuntoMandatory
    }

    void setRiassuntoMandatory(Boolean riassuntoMandatory) {
        this.riassuntoMandatory = riassuntoMandatory
    }

    Boolean getDataTrascrizioneMandatory() {
        return dataTrascrizioneMandatory
    }

    void setDataTrascrizioneMandatory(Boolean dataTrascrizioneMandatory) {
        this.dataTrascrizioneMandatory = dataTrascrizioneMandatory
    }

    Boolean getEstremiTrascrizioneMandatory() {
        return estremiTrascrizioneMandatory
    }

    void setEstremiTrascrizioneMandatory(Boolean estremiTrascrizioneMandatory) {
        this.estremiTrascrizioneMandatory = estremiTrascrizioneMandatory
    }

    Boolean getDataPubblicazioneSentenzaMandatory() {
        return dataPubblicazioneSentenzaMandatory
    }

    void setDataPubblicazioneSentenzaMandatory(Boolean dataPubblicazioneSentenzaMandatory) {
        this.dataPubblicazioneSentenzaMandatory = dataPubblicazioneSentenzaMandatory
    }

    Boolean getTipoLuogoNascitaMandatory() {
        return tipoLuogoNascitaMandatory
    }

    void setTipoLuogoNascitaMandatory(Boolean tipoLuogoNascitaMandatory) {
        this.tipoLuogoNascitaMandatory = tipoLuogoNascitaMandatory
    }
}
