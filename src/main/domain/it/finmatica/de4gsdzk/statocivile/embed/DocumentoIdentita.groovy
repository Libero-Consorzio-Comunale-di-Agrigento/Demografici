package it.finmatica.de4gsdzk.statocivile.embed

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Embeddable
class DocumentoIdentita {
    @Column(name = "NUMERO_DI", updatable = false, insertable = false)
    String numero

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_EMISSIONE_DI", updatable = false, insertable = false)
    Date dataEmissione

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_SCADENZA_DI", updatable = false, insertable = false)
    Date dataScadenza

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_ENTE_DI", updatable = false, insertable = false)),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_ENTE_DI", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_ENTE_DI", updatable = false, insertable = false)),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_ENTE_DI", updatable = false, insertable = false))
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

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_VAL_ESPATRIO_DI", updatable = false, insertable = false)
    Boolean validitaPerEspatrio

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Numero"), Etichette.getEtichetta("Data_emissione"),
                                              Etichette.getEtichetta("Data_scadenza"), Etichette.getEtichetta("Comune"),
                                              Etichette.getEtichetta("Espatrio")]
}
