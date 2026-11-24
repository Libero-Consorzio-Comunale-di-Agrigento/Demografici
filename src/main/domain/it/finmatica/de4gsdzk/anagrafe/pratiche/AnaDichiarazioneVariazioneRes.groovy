package it.finmatica.de4gsdzk.anagrafe.pratiche

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafe
import it.finmatica.de4gsdzk.anagrafe.AnaFamiglia
import it.finmatica.de4gsdzk.anagrafe.ETipoFamiglia
import it.finmatica.de4gsdzk.statocivile.embed.indirizzo.IndirizzoCivico
import it.finmatica.de4gsdzk.utils.EConteggio
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "ANACRE_V_ZK")
class AnaDichiarazioneVariazioneRes extends GsdBaseDomain implements IDichiarazioneVariazione, IDichiarazioneRes {

    @Id
    @Column(name = "ID")
    Integer id

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
    @Column(name= "D_DATA_DECORRENZA", nullable = true)
    Date dataDecorrenza

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "dichiarazioneVariazioneRes", cascade = CascadeType.ALL, orphanRemoval = true)
    List<AnaSoggettoVariazioneRes> soggettiVariazioneRes = new ArrayList<>()

    @Override
    List<ISoggettoPratica> getSoggetti() {
        return soggettiVariazioneRes
    }

    @Override
    void setSoggetti(List<ISoggettoPratica> soggetti) {
        this.soggettiVariazioneRes = soggetti as List<AnaSoggettoVariazioneRes>
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

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_INTERO_NUCLEO", nullable = true)
    Boolean flagInteroNucleo

    @Column(name ="SOTTOSCRITTO", nullable = true)
    Integer sottoscritto

    //Utilizzate solo in iscrzione e cancellazione RES per modello APR4
    @Override
    EConteggio getConteggio() {
        return null
    }
    @Override
    Integer getNumero() {
        return null
    }
    @Override
    Integer getAnno() {
        return null
    }
    @Override
    String getIdDichiarazione() {
        return null
    }

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Data_Decorrenza"), Etichette.getEtichetta("Indirizzo"), Etichette.getEtichetta("Civico"), Etichette.getEtichetta("Suffisso"),
                                              Etichette.getEtichetta("Interno"), Etichette.getEtichetta("Scala"), Etichette.getEtichetta("Piano"),
                                              Etichette.getEtichetta("Tipo"), Etichette.getEtichetta("Aggregazione"), Etichette.getEtichetta("Codice_Famiglia"),
                                              Etichette.getEtichetta("Codice_Famiglia_Unique"), Etichette.getEtichetta("Presso"), Etichette.getEtichetta("Comune_Provenienza_Soggetto"),
                                              Etichette.getEtichetta("Comune_Iscrizione_Aire"), Etichette.getEtichetta("Convivenza"),
                                              Etichette.getEtichetta("Data_Istituzione_Convivenza"), Etichette.getEtichetta("Matricola_Intestatario_Convivenza"), Etichette.getEtichetta("Cognome_Intestatario_Convivenza"),
                                              Etichette.getEtichetta("Nome_Intestatario_Convivenza"), Etichette.getEtichetta("Data_Decorrenza_Convivenza"), Etichette.getEtichetta("Denominazione"),
                                              Etichette.getEtichetta("Richiedo_Comune"), Etichette.getEtichetta("Comunico"), Etichette.getEtichetta("Conteggio"), Etichette.getEtichetta("Comporta"), Etichette.getEtichetta("Non_Comporta")
    ] + AnaSoggettoVariazioneRes.etichetteDomain


    @PrePersist
    void beforeInsert() {
        this.presso = (cognomePresso?:"") + ((cognomePresso || nomePresso)?"/":"") + (nomePresso?:"")
    }

    @PreUpdate
    void beforeUpdate() {
        this.presso = (cognomePresso?:"") + ((cognomePresso || nomePresso)?"/":"") + (nomePresso?:"")
    }
}
