package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.statocivile.embed.AnaConiuge
import it.finmatica.de4gsdzk.statocivile.embed.EstremiAtto
import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.utils.EStatoCivile
import it.finmatica.de4gsdzk.utils.Etichette
import jdk.nashorn.internal.ir.annotations.Immutable

import javax.persistence.*

@Entity
@Immutable
@Table(name = "ANAESC_VANA")
class AnaEventoStatoCivile {

    @Id
    @Column(name = "ID")
    String id

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MATRICOLA", nullable = true)
    AnaAnagrafe anagrafe

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_EVE")
    Date dataEvento

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_EVE")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_EVE", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_EVE")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_EVE", updatable = false, insertable = false))
    ])
    private Comune comuneEvento

    Comune getComuneEvento() {
        if (comuneEvento == null) {
            comuneEvento = new Comune()
        }
        return comuneEvento
    }

    void setComuneEvento(Comune comuneAtto) {
        this.comuneEvento = comuneAtto
    }

    @Column(name = "DES_COD_EVE")
    String descrizione

    @Convert(converter = EStatoCivile.EnumStatoCivileToStringConverter.class)
    @Column(name = "STATO_CIVILE", nullable = true)
    EStatoCivile statoCivile

    @Embedded
    AnaConiuge coniuge

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "ufficio", column = @Column(name = "UFFICIO")),
            @AttributeOverride(name = "anno", column = @Column(name = "ANNO_ATTO")),
            @AttributeOverride(name = "atto", column = @Column(name = "ATTO")),
            @AttributeOverride(name = "parte", column = @Column(name = "PARTE")),
            @AttributeOverride(name = "serie", column = @Column(name = "SERIE")),
            @AttributeOverride(name = "idAttoAnsc", column = @Column(name = "ATTO_DIGITALE"))
    ])
    EstremiAtto atto

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_ATTO")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_ATTO", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_ATTO")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_ATTO", updatable = false, insertable = false))
    ])
    private Comune comuneAtto

    Comune getComuneAtto() {
        if (comuneAtto == null) {
            comuneAtto = new Comune()
        }
        return comuneAtto
    }

    void setComuneAtto(Comune comuneAtto) {
        this.comuneAtto = comuneAtto
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "ufficio", column = @Column(name = "UFFICIO_TR")),
            @AttributeOverride(name = "anno", column = @Column(name = "ANNO_ATTO_TR")),
            @AttributeOverride(name = "atto", column = @Column(name = "ATTO_TR")),
            @AttributeOverride(name = "parte", column = @Column(name = "PARTE_TR")),
            @AttributeOverride(name = "serie", column = @Column(name = "SERIE_TR")),
            @AttributeOverride(name = "idAttoAnsc", column = @Column(name = "ATTO_TR_DIGITALE"))
    ])
    EstremiAtto attoTrascritto

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Data_Evento"), Etichette.getEtichetta("Comune"), Etichette.getEtichetta("Descrizione"),
                                              Etichette.getEtichetta("Stato_Civile"),
                                              Etichette.getEtichetta("Cognome"), Etichette.getEtichetta("Nome"),
                                              Etichette.getEtichetta("Coniuge"), Etichette.getEtichetta("Contraente"),
                                              Etichette.getEtichetta("Atto"), Etichette.getEtichetta("Comune_Atto"), Etichette.getEtichetta("Trascrizione")]
}
