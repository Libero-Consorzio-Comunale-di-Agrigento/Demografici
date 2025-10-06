package it.finmatica.de4gsdzk.statocivile.embed

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Embeddable
class DocumentoSoggiorno {
    @Column(name = "NUMERO_DS", updatable = false, insertable = false)
    String numero

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_EMISSIONE_DS", updatable = false, insertable = false)
    Date dataEmissione

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_SCADENZA_DS", updatable = false, insertable = false)
    Date dataScadenza

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_SCADENZA_ILLIMITATA_DS", updatable = false, insertable = false)
    Boolean scadenzaIllimitata

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_ENTE_DS")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_ENTE_DS", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_ENTE_DS")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_ENTE_DS", updatable = false, insertable = false))
    ])
    private Comune comune

    Comune getComune() {
        if (comune == null) {
            comune = new Comune()
        }
        return comune
    }

    void setComune(Comune comune) {
        this.comune = comune
    }


    static final List<Map> etichetteDomain = [Etichette.Numero, Etichette.Data_emissione, Etichette.Scadenza_Illimitata,
                                              Etichette.Data_scadenza, Etichette.Comune]
}
