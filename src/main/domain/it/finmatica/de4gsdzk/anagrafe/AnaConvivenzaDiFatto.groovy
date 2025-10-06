package it.finmatica.de4gsdzk.anagrafe


import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.utils.Etichette
import jdk.nashorn.internal.ir.annotations.Immutable

import javax.persistence.*

@Entity
@Immutable
@Table(name = "ANACDF_V_ZK")
class AnaConvivenzaDiFatto {

    @Id
    @Column(name = "COD_CDF")
    Long id

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MATRICOLA_CV", nullable = true)
    AnaAnagrafe convivente

    @Column(name = "COGNOME_CV", nullable = true)
    String cognomeConvivente

    @Column(name = "NOME_CV", nullable = true)
    String nomeConvivente

    @Column(name = "NOTE", nullable = false)
    String note

    @Column(name = "D_DATA_REG", nullable = true)
    Date dataRegistrazione

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


    static final List<Map> etichetteDomain = [Etichette.Codice, Etichette.Convivente, Etichette.Note, Etichette.Data_Registrazione, Etichette.Stato,
                                              Etichette.Inizio, Etichette.Fine, Etichette.Nome, Etichette.Cognome,
                                              Etichette.Data, Etichette.Comune, Etichette.Pratica, Etichette.Anno] as List<Map>

}
