package it.finmatica.de4gsdzk.anagrafe.pratiche

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafe
import it.finmatica.de4gsdzk.anagrafe.AnaFamiglia
import it.finmatica.de4gsdzk.anagrafe.ETipoFamiglia
import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.statocivile.embed.indirizzo.IndirizzoCivico
import it.finmatica.de4gsdzk.utils.EConteggio
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "ANAAP4_V_ZK")
class AnaDichiarazioneIscrizioneRes extends GsdBaseDomain implements IDichiarazioneIscrizione, IDichiarazioneRes {

    @Id
    @Column(name = "ID")
    Integer id

    @Column(name = "ID_DICHIARAZIONE")
    String idDichiarazione

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_ANATPR")
    AnaPratica pratica

    @Column(name = "ID_PRATICA")
    String idPratica

    @Column(name ="ANNO_PRATICA", nullable = true)
    Integer annoPratica

    @Column(name ="PRATICA", nullable = true)
    Integer numeroPratica

    @Temporal(TemporalType.DATE)
    @Column(name= "D_DATA_PRATICA", nullable = true)
    Date dataPratica

    @Column(name ="ANNO_DIC", nullable = true)
    Integer anno

    @Column(name ="NUMERO_DIC", nullable = true)
    Integer numero

    @Temporal(TemporalType.DATE)
    @Column(name= "D_DATA_DECORRENZA", nullable = true)
    Date dataDecorrenza

    @Temporal(TemporalType.DATE)
    @Column(name= "D_DATA_DEFINIZIONE", nullable = true)
    Date dataDefinizione

    @Column(name="TIPO_RICHIESTA", nullable = false)
    String iniziativa

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "dichiarazioneIscrizioneRes", cascade = CascadeType.ALL, orphanRemoval = true)
    List<AnaSoggettoIscrizioneRes> soggettiIscrizioneRes = new ArrayList<>()

    @Override
    List<ISoggettoPratica> getSoggetti() {
        return soggettiIscrizioneRes
    }

    @Override
    void setSoggetti(List<ISoggettoPratica> soggetti) {
        this.soggettiIscrizioneRes = soggetti as List<AnaSoggettoIscrizioneRes>
    }

    @Convert(converter = ETipoFamiglia.EnumTipoFamigliaToStringConverter.class)
    @Column(name = "FAMIGLIA_CONVIVENZA", nullable = true)
    ETipoFamiglia tipoFamiglia

    @Embedded
    IndirizzoCivico indirizzo

    IndirizzoCivico getIndirizzo() {
        if (indirizzo == null) {
            indirizzo = new IndirizzoCivico()
        }
        return indirizzo
    }

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_AGGREGAZIONE", nullable = true)
    Boolean flagAggregazione

    @Column(name = "COD_FAM_DEST", nullable = true)
    Long codFamigliaDest

    @Column(name = "COD_FAM_PROV", nullable = true)
    Long codFamigliaProv

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "COD_FAM_UNIQUE_DEST", nullable = true)
    AnaFamiglia famigliaDest

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "COD_FAM_UNIQUE_PROV", nullable = true)
    AnaFamiglia famigliaProv

    ETipoFamiglia getTipoFamigliaOriginario() {
        return famigliaProv?.convivenza ? ETipoFamiglia.CONVIVENZA : ETipoFamiglia.FAMIGLIA
    }

    @Column(name = "PRESSO", nullable = true)
    String presso

    @Column(name = "COGNOME_PRESSO", nullable = true)
    String cognomePresso

    @Column(name = "NOME_PRESSO", nullable = true)
    String nomePresso

    @Column(name = "STATO_PRATICA", nullable = true)
    String statoPratica

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_EVE")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_EVE", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_EVE")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_EVE", updatable = false, insertable = false))
    ])
    Comune comuneProvenienza

    Comune getComuneProvenienza() {
        if (comuneProvenienza == null){
            comuneProvenienza = new Comune()
        }
        return comuneProvenienza
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_ISCR_AIRE")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_ISCR_AIRE", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_ISCR_AIRE")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_ISCR_AIRE", updatable = false, insertable = false))
    ])
    Comune comuneIscrizioneAire

    Comune getComuneIscrizioneAire() {
        if (comuneIscrizioneAire == null){
            comuneIscrizioneAire = new Comune()
        }
        return comuneIscrizioneAire
    }

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TIPO_CONVIVENZA", nullable = true)
    AnaTipoConvivenza tipoConvivenza

    @Column(name = "CONVIVENZA", nullable = true)
    String convivenza

    @Temporal(TemporalType.DATE)
    @Column(name= "D_DATA_ISTITUZIONE_CONV", nullable = true)
    Date dataIstituzioneConvivenza

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MATRICOLA_INTESTATARIO_CONV", nullable = true)
    AnaAnagrafe intestatarioConvivenza

    @Column(name = "COGNOME_INTESTATARIO_CONV", nullable = true)
    String cognomeIntestatarioConvivenza

    @Column(name = "NOME_INTESTATARIO_CONV", nullable = true)
    String nomeIntestatarioConvivenza

    @Temporal(TemporalType.DATE)
    @Column(name= "D_DATA_INTESTATARIO_CONV", nullable = true)
    Date dataIntestatarioConvivenza

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_RICHIESTA", nullable = true, updatable = false, insertable = false)
    AnaDizionarioPratiche richiesta

    @Column(name="RICHIESTA", nullable = false)
    String codiceRichiesta

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_PROVVEDIMENTO", nullable = true, updatable = false, insertable = false)
    AnaDizionarioPratiche provvedimento

    @Column(name="PROVVEDIMENTO", nullable = false)
    String codiceProvvedimento

    @Temporal(TemporalType.DATE)
    @Column(name= "D_DATA_IRREPERIBILITA ", nullable = true)
    Date dataIrreperibilita

    @Column(name="MOTIVO", nullable = false)
    String motivo

    @Column(name="COD_STATO", nullable = false)
    Integer codiceStato

    @Column(name ="SOTTOSCRITTO", nullable = true)
    Integer sottoscritto

    @Convert(converter = EConteggio.EnumConteggioToIntegerConverter.class)
    @Column(name ="CONTEGGIO", nullable = true)
    EConteggio conteggio

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_INTERO_NUCLEO", nullable = true)
    Boolean flagInteroNucleo


    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Data_Decorrenza"), Etichette.getEtichetta("Indirizzo"),
                                              Etichette.getEtichetta("Tipo"), Etichette.getEtichetta("Aggregazione"), Etichette.getEtichetta("Codice_Famiglia"),
                                              Etichette.getEtichetta("Codice_Famiglia_Unique"), Etichette.getEtichetta("Presso"), Etichette.getEtichetta("Comune_Provenienza_Soggetto"),
                                              Etichette.getEtichetta("Comune_Iscrizione_Aire"), Etichette.getEtichetta("Convivenza"), Etichette.getEtichetta("Intestatario"),
                                              Etichette.getEtichetta("Data_Istituzione_Convivenza"), Etichette.getEtichetta("Matricola_Intestatario_Convivenza"), Etichette.getEtichetta("Cognome_Intestatario_Convivenza"),
                                              Etichette.getEtichetta("Nome_Intestatario_Convivenza"), Etichette.getEtichetta("Data_Decorrenza_Convivenza"), Etichette.getEtichetta("Denominazione"),
                                              Etichette.getEtichetta("Richiedo_Comune"), Etichette.getEtichetta("Comunico"), Etichette.getEtichetta("Conteggio"), Etichette.getEtichetta("Comporta"), Etichette.getEtichetta("Non_Comporta")
    ] + AnaSoggettoIscrizioneRes.etichetteDomain


    @PrePersist
    void beforeInsert() {
        this.presso = (cognomePresso?:"") + ((cognomePresso || nomePresso)?"/":"") + (nomePresso?:"")
    }

    @PreUpdate
    void beforeUpdate() {
        this.presso = (cognomePresso?:"") + ((cognomePresso || nomePresso)?"/":"") + (nomePresso?:"")
    }
}
