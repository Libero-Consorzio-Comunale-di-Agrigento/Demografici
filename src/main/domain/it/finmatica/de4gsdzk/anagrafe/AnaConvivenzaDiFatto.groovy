package it.finmatica.de4gsdzk.anagrafe


import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.GsdBaseDomain
import jdk.nashorn.internal.ir.annotations.Immutable

import javax.persistence.*

@Entity
@Immutable
@Table(name = "ANACDF_V_ZK")
class AnaConvivenzaDiFatto  extends GsdBaseDomain{

    @Id
    @Column(name = "ID")
    Integer id

    @Column(name = "COD_CDF")
    Long codCdf

    @Column(name = "SEQUENZA")
    Integer sequenza

    @Column(name = "MATRICOLA")
    Integer matricola

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MATRICOLA_CV", nullable = true)
    AnaAnagrafe convivente

    @Column(name = "COGNOME_CV", nullable = true)
    String cognomeConvivente

    @Column(name = "NOME_CV", nullable = true)
    String nomeConvivente

    @Convert(converter= GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "SENZA_COGNOME_CV", nullable = true)
    Boolean senzaCognomeConvivente

    @Convert(converter= GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "SENZA_NOME_CV", nullable = true)
    Boolean senzaNomeConvivente

    @Column(name = "COGNOME_NOME_CV", nullable = true)
    private String cognomeNomeConvivente

    @Column(name = "NOTE", nullable = true)
    String note

    @Convert(converter = EStatoConvivenza.EnumStatoConvivenzaToStringConverter.class)
    @Column(name = "STATO_CDF", nullable = true)
    EStatoConvivenza statoConvivenza

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "convivenzaDiFatto")
    List<AnaAnagrafe> conviventi

    //////////////////////////
    //////// INIZIO
    //////////////////////////

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_INIZIO")
    Date dataInizio

    @Embedded
    @AttributeOverrides([@AttributeOverride(name = "codice", column = @Column(name = "COD_COM_INIZIO")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_INIZIO", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_INIZIO")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_INIZIO", updatable = false, insertable = false))])
    private Comune comuneInizio

    Comune getComuneInizio() {
        if (comuneInizio == null) {
            comuneInizio = new Comune()
        }
        return comuneInizio
    }

    void setComuneInizio(Comune c) {
        this.comuneInizio = c
    }

    @Column(name = "PRATICA_INIZIO")
    Long praticaInizio

    @Column(name = "ANNO_PRATICA_INIZIO")
    Integer annoPraticaInizio

    //////////////////////////
    //////// FINE
    //////////////////////////

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_FINE")
    Date dataFine

    @Embedded
    @AttributeOverrides([@AttributeOverride(name = "codice", column = @Column(name = "COD_COM_FINE")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_FINE", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_FINE")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_FINE", updatable = false, insertable = false))])
    private Comune comuneFine

    Comune getComuneFine() {
        if (comuneFine == null) {
            comuneFine = new Comune()
        }
        return comuneFine
    }

    void setComuneFine(Comune c) {
        this.comuneFine = c
    }

    @Column(name = "PRATICA_FINE")
    Long praticaFine

    @Column(name = "ANNO_PRATICA_FINE")
    Integer annoPraticaFine


    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Codice"), Etichette.getEtichetta("Conv"), Etichette.getEtichetta("Convivente"), Etichette.getEtichetta("Note"), Etichette.getEtichetta("Data_Registrazione"), Etichette.getEtichetta("Stato"),
                                              Etichette.getEtichetta("Inizio"), Etichette.getEtichetta("Fine"), Etichette.getEtichetta("Nome"), Etichette.getEtichetta("Cognome"), Etichette.getEtichetta("Convivenza_di_fatto"),
                                              Etichette.getEtichetta("Data"), Etichette.getEtichetta("Comune"), Etichette.getEtichetta("Pratica"), Etichette.getEtichetta("Anno")] as List<Map>


    @PrePersist
    void beforeInsert() {
        this.cognomeNomeConvivente = (cognomeConvivente?:"") + ((cognomeConvivente || nomeConvivente)?"/":"") + (nomeConvivente?:"")
    }

    @PreUpdate
    void beforeUpdate() {
        this.cognomeNomeConvivente = (cognomeConvivente?:"") + ((cognomeConvivente || nomeConvivente)?"/":"") + (nomeConvivente?:"")
    }
}
