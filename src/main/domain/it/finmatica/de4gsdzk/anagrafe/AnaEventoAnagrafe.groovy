package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.utils.Etichette
import jdk.nashorn.internal.ir.annotations.Immutable

import javax.persistence.*

@Entity
@Immutable
@Table(name = "ANAEVE_VANA")
class AnaEventoAnagrafe extends GsdBaseDomain{

    @Id
    @Column(name = "ID")
    String id

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MATRICOLA")
    AnaAnagrafe anagrafe

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "COD_FAM_UNIQUE_STORICO", nullable = true)
    AnaFamiglia famiglia

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_INIZIO")
    Date dataInizio

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_EVE_STORICO")
    Date dataEvento

    @Column(name = "DES_EVENTO")
    String descrizione

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_DATA_CONVENZIONALE", nullable = true, updatable = false, insertable = false)
    Boolean flagDataConvenzionale

    @Column(name = "ANNO_PRATICA")
    Integer annoPratica

    @Column(name = "PRATICA")
    Integer pratica

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_ISCR_AIRE")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_ISCR_AIRE", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_ISCR_AIRE")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_ISCR_AIRE", updatable = false, insertable = false))
    ])
    private Comune comuneIscrizioneAire

    Comune getComuneIscrizioneAire() {
        if (comuneIscrizioneAire == null) {
            comuneIscrizioneAire = new Comune()
        }
        return comuneIscrizioneAire
    }

    void setComuneIscrizioneAire(Comune comuneIscrizioneAire) {
        this.comuneIscrizioneAire = comuneIscrizioneAire
    }

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "D_DATA_REG", nullable = true)
    Date dataRegistrazione

    @Column(name = "PROVINCIA_CONTEA")
    String provinciaContea

    @Column(name = "PRESSO")
    String presso

    @Column(name = "CODICE_CONSOLATO", updatable = false, insertable = false)
    String codiceConsolato

    @Column(name = "DES_TIPO_CONSOLATO", updatable = false, insertable = false)
    String tipoConsolato

    @Column(name = "INDIRIZZO_CONSOLATO", updatable = false, insertable = false)
    String indirizzoConsolato

    @Column(name = "SEDE_CONSOLATO", updatable = false, insertable = false)
    String sedeConsolato

    @Column(name = "COD_TERRITORIO", updatable = false, insertable = false)
    Long codiceTerritorio

    @Column(name = "DES_TERRITORIO", updatable = false, insertable = false)
    String territorio

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Famiglia"), Etichette.getEtichetta("Data_Inizio"), Etichette.getEtichetta("Data_Evento"), Etichette.getEtichetta("Descrizione"),
                                              Etichette.getEtichetta("Dal"), Etichette.getEtichetta("Al"), Etichette.getEtichetta("Data_Convenzionale_tooltip"),
                                              Etichette.getEtichetta("Dettaglio_Evento"), Etichette.getEtichetta("Dettaglio_Pratica"), Etichette.getEtichetta("Numero"),
                                              Etichette.getEtichetta("Anno"), Etichette.getEtichetta("Data_Registrazione"), Etichette.getEtichetta("Comune_Iscrizione_Aire"),
                                              Etichette.getEtichetta("Dati_AIRE"), Etichette.getEtichetta("Provincia_Contea"), Etichette.getEtichetta("Presso"),
                                              Etichette.getEtichetta("Ufficio_Consolare"), Etichette.getEtichetta("Indirizzo"),
                                              Etichette.getEtichetta("Sede"), Etichette.getEtichetta("Territorio")]
}
