package it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni

import it.finmatica.de4gsdzk.GsdDocumentoEsternoBaseDomain
import it.finmatica.de4gsdzk.IArchivioComunicazione
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafe
import it.finmatica.de4gsdzk.anagrafe.ETipoAnagrafe
import it.finmatica.de4gsdzk.anagrafe.pratiche.AnaEventoPratica
import it.finmatica.de4gsdzk.statocivile.CivAnnotazioneAtto
import it.finmatica.de4gsdzk.statocivile.CivFormulaAnnotazione
import it.finmatica.de4gsdzk.utils.*
import org.hibernate.annotations.Formula
import org.hibernate.annotations.Type

import javax.persistence.*

@Entity
@Table(name = "ANACOM_V")
class AnaArchivioComunicazione  extends GsdDocumentoEsternoBaseDomain implements IArchivioComunicazione {

    @Id
    @Column(name = "ID")
    Long id

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MATRICOLA", nullable = true)
    AnaAnagrafe anagrafe

    @Convert(converter = ETipoAnagrafe.EnumTipoAnagrafeToStringConverter.class)
    @Column(name ="ANAGRAFE")
    ETipoAnagrafe archivioAnagrafe

    @Convert(converter = ETipoPratica.EnumTipoPraticaToStringConverter.class)
    @Column(name ="TIPO_EVENTO")
    ETipoPratica tipoPratica

    @Column(name ="ANNO_PRATICA", nullable = true)
    Integer annoPratica

    @Column(name ="PRATICA", nullable = true)
    Integer numeroPratica

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="CODICE_CO", nullable = false)
    AnaComunicazione comunicazione

    @Column(name = "DES_COMUNICAZIONE", updatable = false, insertable = false)
    String descrizione

    @Column(name = "DES_NOME_FILE_COMUNICAZIONE", updatable = false, insertable = false)
    String nomeFileComunicazione

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_REG", nullable = false)
    Date dataRegistrazione

    @Column(name = "NUMERO_COPIE", nullable = true)
    Integer numeroCopie

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

    @ManyToOne(fetch= FetchType.LAZY)
    @JoinColumn(name="ID_ANADEP", updatable = false, insertable = false)
    AnaEventoPratica eventoPratica

    Boolean isDaInviareAlbo(){
        return ((statoInvioAlbo != null) && (statoInvioAlbo == EStatoInvioAlbo.D))
    }

    @Override
    Integer getNumero() {
        return numeroPratica
    }

    Boolean isInviatoAlbo(){
        return ((statoInvioAlbo != null) && (statoInvioAlbo == EStatoInvioAlbo.I))
    }

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Comunicazione"), Etichette.getEtichetta("Ufficio"), Etichette.getEtichetta("Anno"), Etichette.getEtichetta("Tipo_Atto"), Etichette.getEtichetta("Numero_Atto"), Etichette.getEtichetta("Parte"), Etichette.getEtichetta("Serie"),
                                              Etichette.getEtichetta("Codice"), Etichette.getEtichetta("Descrizione"), Etichette.getEtichetta("Stampa_Eseguita"), Etichette.getEtichetta("Numero_copie"), Etichette.getEtichetta("Data_Registrazione")]

}
