package it.finmatica.de4gsdzk.anagrafe.pratiche

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafe
import it.finmatica.de4gsdzk.anagrafe.AnaFamiglia
import it.finmatica.de4gsdzk.anagrafe.ETipoAnagrafe
import it.finmatica.de4gsdzk.anagrafe.ETipoFamiglia
import it.finmatica.de4gsdzk.archivi.ArcVia
import it.finmatica.de4gsdzk.statocivile.embed.indirizzo.IndirizzoCivico
import it.finmatica.de4gsdzk.utils.ETipoPratica
import it.finmatica.de4gsdzk.utils.ETipoRettifica
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "ANARET_V_ZK")
class AnaDichiarazioneRettifica extends GsdBaseDomain implements IDichiarazionePratica {

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

    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_RETTIFICA", nullable = false)
    ETipoRettifica tipoRettifica

    @Column(name = "COD_FAM", nullable = true)
    Long codFamiglia

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "COD_FAM_UNIQUE", nullable = true)
    AnaFamiglia famiglia

    @Transient
    ETipoFamiglia tipoFamiglia

    @Transient
    ETipoFamiglia tipoFamigliaOriginario

    @Embedded
    IndirizzoCivico indirizzo

    IndirizzoCivico getIndirizzo() {
        if (indirizzo == null) {
            indirizzo = new IndirizzoCivico()
        }
        return indirizzo
    }

    @Transient
    AnaTipoConvivenza tipoConvivenza

    @Transient
    String convivenza

    @Transient
    AnaAnagrafe intestatarioConvivenza

    @Transient
    Date dataIstituzioneConvivenza

    @Transient
    String cognomeIntestatarioConvivenza

    @Transient
    String nomeIntestatarioConvivenza

    @Transient
    Date dataIntestatarioConvivenza

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_ANNULLAMENTO", nullable = true)
    Boolean flagAnnullamento

    @Temporal(TemporalType.DATE)
    @Column(name= "D_DATA_DECORRENZA", nullable = true)
    Date dataDecorrenza

    @Convert(converter = ETipoAnagrafe.EnumTipoAnagrafeToStringConverter.class)
    @Column(name ="ANAGRAFE", updatable = false, insertable = false)
    ETipoAnagrafe archivioAnagrafe

    @Convert(converter = ETipoPratica.EnumTipoPraticaToStringConverter.class)
    @Column(name ="TIPO_EVENTO", updatable = false, insertable = false)
    ETipoPratica tipoPratica

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "dichiarazioneRettifica", cascade = CascadeType.ALL, orphanRemoval = true)
    List<AnaSoggettoRettifica> soggettiRettifica = new ArrayList<>()

    @Override
    List<ISoggettoPratica> getSoggetti() {
        return soggettiRettifica
    }

    @Override
    void setSoggetti(List<ISoggettoPratica> soggetti) {
        this.soggettiRettifica = soggetti as List<AnaSoggettoRettifica>
    }

    @Column(name ="SOTTOSCRITTO", nullable = true)
    Integer sottoscritto

    @Override
    Boolean getFlagAggregazione() {
        return true
    }

    @Override
    Long getCodFamigliaDest() {
        return codFamiglia
    }

    @Override
    Long getCodFamigliaProv() {
        return null
    }

    @Override
    void setCodFamigliaProv(Long codFamigliaProv) {

    }

    @Override
    AnaFamiglia getFamigliaDest() {
        return famiglia
    }

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Data_Decorrenza"), Etichette.getEtichetta("Indirizzo"), Etichette.getEtichetta("Civico"), Etichette.getEtichetta("Suffisso"),
                                              Etichette.getEtichetta("Interno"), Etichette.getEtichetta("Scala"), Etichette.getEtichetta("Piano"),
                                              Etichette.getEtichetta("Tipo"), Etichette.getEtichetta("Aggregazione"), Etichette.getEtichetta("Codice_Famiglia"),
                                              Etichette.getEtichetta("Data_Istituzione_Convivenza"), Etichette.getEtichetta("Matricola_Intestatario_Convivenza"), Etichette.getEtichetta("Cognome_Intestatario_Convivenza"),
                                              Etichette.getEtichetta("Nome_Intestatario_Convivenza"), Etichette.getEtichetta("Data_Decorrenza_Convivenza"), Etichette.getEtichetta("Denominazione"),
                                              Etichette.getEtichetta("Intestatario"), Etichette.getEtichetta("Tipo_Rettifica")] + AnaSoggettoRettifica.etichetteDomain
}
