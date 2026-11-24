package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.GsdDocumentoEsternoBaseDomain
import it.finmatica.de4gsdzk.IArchivioComunicazione
import it.finmatica.de4gsdzk.IRiferimentoAttoDomain
import it.finmatica.de4gsdzk.utils.*
import org.hibernate.annotations.Formula
import org.hibernate.annotations.Type

import javax.persistence.*

@Entity
@Table(name = "CIVCOM_V")
class CivArchivioComunicazione extends GsdDocumentoEsternoBaseDomain implements IRiferimentoAttoDomain, IArchivioComunicazione {

    @Id
    @Column(name = "ID")
    Long id

    @Column(name = "TIPO_ATTO", nullable = false)
    Integer tipoAtto

    @Column(name = "UFFICIO", nullable = false)
    Integer ufficio

    @Column(name = "ANNO", nullable = false)
    Integer anno

    @Column(name = "ATTO", nullable = false)
    Integer atto

    @Column(name = "PARTE", nullable = true)
    Integer parte

    @Column(name = "SERIE", nullable = true)
    String serie

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="CODICE_CO", nullable = false)
    CivComunicazione comunicazione

    @Column(name = "DES_COMUNICAZIONE", updatable = false, insertable = false)
    String descrizione

    @Column(name = "DES_NOME_FILE_COMUNICAZIONE", updatable = false, insertable = false)
    String nomeFileComunicazione

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_REG", nullable = false)
    Date dataRegistrazione

    @Column(name = "SEQUENZA")
    Integer sequenza

    @Column(name = "NUMERO_COPIE", nullable = true)
    Integer numeroCopie

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="FORMULA_DFA", updatable = false, insertable = false)
    CivFormulaAnnotazione formulaDfa

    @Column(name = "FORMULA", nullable = true)
    String formula

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="ID_CIVANN", nullable = true)
    CivAnnotazioneAtto annotazioneAtto

    @Enumerated(EnumType.STRING)
    @Column(name = "STAMPA_ESEGUITA", nullable = false)
    private ETipoSiNo stampaEseguitaDb

    @Formula("CASE WHEN COALESCE(STAMPA_ESEGUITA, 'NO') = 'NO' THEN 0 ELSE 1 END")
    @Type(type="numeric_boolean")
    private Boolean stampaEseguita

    Boolean getStampaEseguita() {
        return this.stampaEseguita
    }

    void setStampaEseguita(Boolean val) {
        this.stampaEseguita = val
        this.stampaEseguitaDb = (val? ETipoSiNo.SI: ETipoSiNo.NO)
    }

    @Column(name = "VERSIONE", nullable = true)
    Integer versione

    @Enumerated(EnumType.STRING)
    @Column(name = "FLAG_PROTOCOLLO", nullable = false, updatable = false, insertable = false)
    EStatoProtocollazione statoProtocollazione

    Boolean isDaProtocollare(){
        return ((statoProtocollazione != null) && (statoProtocollazione == EStatoProtocollazione.D))
    }

    Boolean isProtocollato(){
        return ((statoProtocollazione != null) && (statoProtocollazione == EStatoProtocollazione.P))
    }

    @Enumerated(EnumType.STRING)
    @Column(name = "FLAG_ALBO_PRETORIO", nullable = false, updatable = false, insertable = false)
    EStatoInvioAlbo statoInvioAlbo

    Boolean isDaInviareAlbo(){
        return ((statoInvioAlbo != null) && (statoInvioAlbo == EStatoInvioAlbo.D))
    }

    @Override
    Integer getNumero() {
        return atto
    }

    Boolean isInviatoAlbo(){
        return ((statoInvioAlbo != null) && (statoInvioAlbo == EStatoInvioAlbo.I))
    }

    @Column(columnDefinition = "char", name = "TIPO_FORMULA", nullable = false, updatable = false, insertable = false)
    String tipoFormula

    @Column(name = "ID_ATTO", nullable = false)
    String idAtto

    @Column(name = "ID_ATTO_RIF", nullable = true)
    String idAttoRif

    @Column(name = "TIPO_ATTO_RIF", nullable = false, updatable = false, insertable = false)
    Integer tipoAttoRif

    @Column(name = "TIPO_ATTO_COM", nullable = false, updatable = false, insertable = false)
    Integer tipoAttoComunicazione

    ETipoAtto getTipoAttoRifEnum(){
        return TipoAttoUtils.fromValoreDefault(this.tipoAttoRif.intValue())
    }

    Boolean isAttoDiAltroComune(){
        return TipoAttoUtils.isAttoDiAltroComune(tipoAtto)
    }

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Ufficio"), Etichette.getEtichetta("Anno"), Etichette.getEtichetta("Tipo_Atto"), Etichette.getEtichetta("Numero_Atto"), Etichette.getEtichetta("Parte"), Etichette.getEtichetta("Serie"),
                                              Etichette.getEtichetta("Codice"), Etichette.getEtichetta("Descrizione"), Etichette.getEtichetta("Stampa_Eseguita"), Etichette.getEtichetta("Numero_copie"), Etichette.getEtichetta("Data_Registrazione")]

}
