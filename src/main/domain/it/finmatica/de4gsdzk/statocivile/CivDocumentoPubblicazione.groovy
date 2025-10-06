package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.utils.ETipoSiNo
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "CIVPDO_V")
class CivDocumentoPubblicazione extends GsdBaseDomain{

    @Id
    @Column(name = "ID")
    Long id

    @Column(name = "ID_ATTO", nullable = false)
    String idAtto

    @Column(name = "TIPO_ATTO", nullable = false)
    Integer tipoAtto

    @Column(name = "UFFICIO", nullable = false)
    Integer ufficio

    @Column(name = "ANNO", nullable = false)
    Integer anno

    @Column(name = "ATTO", nullable = false)
    Integer atto

    @Column(name = "PARTE", nullable = false)
    Integer parte

    @Column(name = "SERIE", nullable = true)
    String serie

    @Enumerated(EnumType.STRING)
    @Column(name = "DOCUMENTI_PRESENTATI", nullable = false)
    ETipoSiNo documentoPresentatoPubblicazione

    @Column(name = "CHIESA_RICHIESTA", nullable = true)
    String chiesaRichiesta

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_RICHIESTA", nullable = true)
    Date dataChiesaRichiesta

    @Column(name = "AUTORITA_NULLA_OSTA", nullable = true)
    String autoritaNullaOsta

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NULLA_OSTA", nullable = true)
    Date dataNullaOsta

    ///////////////////////////////// SPOSO ///////////////////////////////

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_ESTRATTO_M", nullable = true)
    Date dataEstratto1

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "COD_COM_ESTRATTO_M")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_ESTRATTO_M", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "COD_PRO_ESTRATTO_M")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_ESTRATTO_M", updatable = false, insertable = false))
    ])
    private Comune comuneEstratto1

    Comune getComuneEstratto1() {
        if (comuneEstratto1 == null){
            comuneEstratto1 = new Comune()
        }
        return comuneEstratto1
    }

    void setComuneEstratto1(Comune c) {
        this.comuneEstratto1 = c
    }

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_CUMULATIVO_M", nullable = true)
    Date dataCumulativo1

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "COD_COM_CUMULATIVO_M")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_CUMULATIVO_M", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "COD_PRO_CUMULATIVO_M")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_CUMULATIVO_M", updatable = false, insertable = false))
    ])
    private Comune comuneCumulativo1

    Comune getComuneCumulativo1() {
        if (comuneCumulativo1 == null){
            comuneCumulativo1 = new Comune()
        }
        return comuneCumulativo1
    }

    void setComuneCumulativo1(Comune c) {
        this.comuneCumulativo1 = c
    }

    ///////////////////////////////// SPOSA ///////////////////////////////

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_ESTRATTO_F", nullable = true)
    Date dataEstratto2

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "COD_COM_ESTRATTO_F")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_ESTRATTO_F", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "COD_PRO_ESTRATTO_F")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_ESTRATTO_F", updatable = false, insertable = false))
    ])
    private Comune comuneEstratto2

    Comune getComuneEstratto2() {
        if (comuneEstratto2 == null){
            comuneEstratto2 = new Comune()
        }
        return comuneEstratto2
    }

    void setComuneEstratto2(Comune c) {
        this.comuneEstratto2 = c
    }

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_CUMULATIVO_F", nullable = true)
    Date dataCumulativo2

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "COD_COM_CUMULATIVO_F")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_CUMULATIVO_F", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "COD_PRO_CUMULATIVO_F")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_CUMULATIVO_F", updatable = false, insertable = false))
    ])
    private Comune comuneCumulativo2

    Comune getComuneCumulativo2() {
        if (comuneCumulativo2 == null){
            comuneCumulativo2 = new Comune()
        }
        return comuneCumulativo2
    }

    void setComuneCumulativo2(Comune c) {
        this.comuneCumulativo2 = c
    }

    ///////////////////////////////// DOCUMENTI ///////////////////////////////

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_DOCUMENTI_PRODOTTI", nullable = true)
    Boolean documentiProdotti

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_DOCUMENTI_ACQUISITI", nullable = true)
    Boolean documentiAcquisiti

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_DOCUMENTI_PRESA_VISIONE", nullable = true)
    Boolean documentiPresaVisione

    ////////////////////////////////////////////////////////////////////////
    /////////////////////////////// GENERALI ///////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static List<Map> etichetteDomain = [Etichette.Prodotti, Etichette.Acquisiti, Etichette.Visionati, Etichette.Il,
                                        Etichette.Copia_integrale_atto_nascita,
                                        Etichette.Certificato_contestuale_residenza_cittadinanza_stato_libero]

}