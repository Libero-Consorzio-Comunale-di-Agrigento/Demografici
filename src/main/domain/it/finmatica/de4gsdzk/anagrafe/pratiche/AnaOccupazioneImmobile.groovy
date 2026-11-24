package it.finmatica.de4gsdzk.anagrafe.pratiche

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.anagrafe.ETipoAnagrafe
import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.utils.ETipoPratica
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "ANADOI_V_ZK")
class AnaOccupazioneImmobile extends GsdBaseDomain{

    @Id
    @Column(name = "ID")
    Long id

    @Convert(converter = ETipoAnagrafe.EnumTipoAnagrafeToStringConverter.class)
    @Column(name ="ANAGRAFE")
    ETipoAnagrafe archivioAnagrafe

    @Convert(converter = ETipoPratica.EnumTipoPraticaToStringConverter.class)
    @Column(name ="TIPO_EVENTO")
    ETipoPratica tipoPratica

    @Column(name ="ANNO_PRATICA", nullable = true)
    Integer annoPratica

    @OneToOne
    @JoinColumn(name = "ID_ANATPR")
    AnaPratica pratica

    @Column(name = "ID_PRATICA")
    String idPratica

    @Column(name ="PRATICA", nullable = true)
    Integer numeroPratica

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_LEGITTIMA", nullable = true)
    Boolean flagLegittima

    @Column(name ="SEZIONE_CATASTO_TPR", nullable = true)
    String sezioneCatastoTpr

    @Column(name ="FOGLIO_CATASTO_TPR", nullable = true)
    String foglioCatastoTpr

    @Column(name ="NUMERO_CATASTO_TPR", nullable = true)
    String numeroCatastoTpr

    @Column(name ="SUBALTERNO_CATASTO_TPR", nullable = true)
    String subalternoCatastoTpr

    //CHECK 1

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_PROPRIETARIO", nullable = true)
    Boolean flagProprietario

    @Column(name ="SEZIONE_CATASTO", nullable = true)
    String sezioneCatasto

    @Column(name ="FOGLIO_CATASTO", nullable = true)
    String foglioCatasto

    @Column(name ="NUMERO_CATASTO", nullable = true)
    String numeroCatasto

    @Column(name ="SUBALTERNO_CATASTO", nullable = true)
    String subalternoCatasto

    //CHECK 2

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_LOCAZIONE", nullable = true)
    Boolean flagLocazione

    @Column(name ="SEDE_CONTRATTO_LOCAZIONE", nullable = true)
    String sedeContrattoLocazione

    @Temporal(TemporalType.DATE)
    @Column(name= "D_DATA_CONTRATTO_LOCAZIONE", nullable = true)
    Date dataContrattoLocazione

    @Column(name ="NUM_CONTRATTO_LOCAZIONE", nullable = true)
    String numeroContrattoLocazione

    @Column(name ="NOME_PROPRIETA_LOCAZIONE", nullable = true)
    String nomeProprietaLocazione

    @Column(name ="CF_PROPRIETA_LOCAZIONE", nullable = true)
    String cfProprietaLocazione

    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "COD_COM_PROPRIETA_LOCAZIONE")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_PROPRIETA_LOCAZIONE", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "COD_PRO_PROPRIETA_LOCAZIONE")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_PROPRIETA_LOCAZIONE", updatable = false, insertable = false))
    ])
    private Comune comuneProprietaLocazione

    Comune getComuneProprietaLocazione() {
        if (comuneProprietaLocazione == null){
            comuneProprietaLocazione = new Comune()
        }
        return comuneProprietaLocazione
    }

    void setComuneProprietaLocazione(Comune c) {
        this.comuneProprietaLocazione = c
    }

    @Column(name ="COMUNE_PROPRIETA_LOCAZIONE", nullable = true)
    String comuneProprietaLocazioneString

    @Column(name ="VIA_PROPRIETA_LOCAZIONE", nullable = true)
    String viaProprietaLocazione


    //CHECK 3

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_LOCAZIONE_ERP", nullable = true)
    Boolean flagLocazioneErp

    @Column(name ="NOTE_LOCAZIONE_ERP", nullable = true)
    String noteLocazioneErp


    //CHECK 4

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_COMODATO", nullable = true)
    Boolean flagComodato

    @Column(name ="SEDE_CONTRATTO_COMODATO", nullable = true)
    String sedeContrattoComodato

    @Temporal(TemporalType.DATE)
    @Column(name= "D_DATA_CONTRATTO_COMODATO", nullable = true)
    Date dataContrattoComodato

    @Column(name ="NUM_CONTRATTO_COMODATO", nullable = true)
    String numeroContrattoComodato

    @Column(name ="NOME_PROPRIETA_COMODATO", nullable = true)
    String nomeProprietaComodato

    @Column(name ="CF_PROPRIETA_COMODATO", nullable = true)
    String cfProprietaComodato

    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "COD_COM_PROPRIETA_COMODATO")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_PROPRIETA_COMODATO", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "COD_PRO_PROPRIETA_COMODATO")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_PROPRIETA_COMODATO", updatable = false, insertable = false))
    ])
    private Comune comuneProprietaComodato

    Comune getComuneProprietaComodato() {
        if (comuneProprietaComodato == null){
            comuneProprietaComodato = new Comune()
        }
        return comuneProprietaComodato
    }

    void setComuneProprietaComodato(Comune c) {
        this.comuneProprietaComodato = c
    }

    @Column(name ="COMUNE_PROPRIETA_COMODATO", nullable = true)
    String comuneProprietaComodatoString

    @Column(name ="VIA_PROPRIETA_COMODATO", nullable = true)
    String viaProprietaComodato

    //CHECK 5

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_USUFRUTTO", nullable = true)
    Boolean flagUsufrutto

    @Column(name ="NOTE_USUFRUTTO", nullable = true)
    String noteUsufrutto

    //CHECK 6

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_TITOLO", nullable = true)
    Boolean flagTitolo

    @Column(name ="NOTE_TITOLO", nullable = true)
    String noteTitolo


    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Flag_Legittima"), Etichette.getEtichetta("Flag_Proprietario"), Etichette.getEtichetta("Sezione"),
                                              Etichette.getEtichetta("Foglio"), Etichette.getEtichetta("Particella"), Etichette.getEtichetta("Subalterno"),
                                              Etichette.getEtichetta("Flag_Locazione"), Etichette.getEtichetta("Registrato_in_Data"),
                                              Etichette.getEtichetta("Numero"), Etichette.getEtichetta("Presso_AE"), Etichette.getEtichetta("Proprietario"),
                                              Etichette.getEtichetta("Codice_Fiscale"), Etichette.getEtichetta("Residente"), Etichette.getEtichetta("In"),
                                              Etichette.getEtichetta("Flag_Locazione_Erp"), Etichette.getEtichetta("Flag_Comodato"), Etichette.getEtichetta("Flag_Usufrutto"),
                                              Etichette.getEtichetta("Flag_Titolo"), Etichette.getEtichetta("Titolo")
    ]


}
