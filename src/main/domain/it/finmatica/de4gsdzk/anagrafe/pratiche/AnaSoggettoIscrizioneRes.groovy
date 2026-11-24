package it.finmatica.de4gsdzk.anagrafe.pratiche

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafe
import it.finmatica.de4gsdzk.anagrafe.AnaStato
import it.finmatica.de4gsdzk.anagrafe.EFascia
import it.finmatica.de4gsdzk.anagrafe.ETipoAnagrafe
import it.finmatica.de4gsdzk.istat.IstatDizionarioDettagliSoggetto
import it.finmatica.de4gsdzk.utils.ESesso
import it.finmatica.de4gsdzk.utils.ETipoPratica
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "ANAAPM_V_ZK")
class AnaSoggettoIscrizioneRes extends GsdBaseDomain implements ISoggettoPratica, ISoggettoPraticaIscrizione {

    @Id
    @Column(name = "ID")
    Integer id

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MATRICOLA", nullable = true)
    AnaAnagrafe anagrafe

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_ANAAP4", nullable = true)
    AnaDichiarazioneIscrizioneRes dichiarazioneIscrizioneRes

    @Override
    IDichiarazionePratica getDichiarazione() {
        return dichiarazioneIscrizioneRes
    }

    @Override
    void setDichiarazione(IDichiarazionePratica dichiarazione) {
        this.dichiarazioneIscrizioneRes = dichiarazione as AnaDichiarazioneIscrizioneRes
    }

    @Column(name = "ID_DICHIARAZIONE", nullable = true)
    String idDichiarazione

    @Enumerated(EnumType.STRING)
    @Column(name = "SESSO", nullable = false)
    ESesso sesso

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_SOGGETTO", nullable = true)
    Boolean flagSoggetto

    @Column(name = "NUMERO_ORDINE", nullable = true)
    Integer numeroOrdine

    @Column(name = "ANNO_DIC", nullable = true)
    Integer annoDichiarazione

    @Column(name = "NUMERO_DIC", nullable = true)
    Integer numeroDichiarazione

    @Convert(converter = ETipoAnagrafe.EnumTipoAnagrafeToStringConverter.class)
    @Column(name ="ANAGRAFE", updatable = false, insertable = false)
    ETipoAnagrafe archivioAnagrafe

    @Convert(converter = ETipoPratica.EnumTipoPraticaToStringConverter.class)
    @Column(name ="TIPO_EVENTO", updatable = false, insertable = false)
    ETipoPratica tipoPratica

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_ANATPR")
    AnaPratica pratica

    @Column(name = "ID_PRATICA", updatable = false, insertable = false)
    String idPratica

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_ANADPI", nullable = true, updatable = false, insertable = false)
    AnaRapportoParentelaIstat rapportoParentela

    @Column(name = "IST_RP", nullable = true)
    String istRp

    @Transient
    IstatDizionarioDettagliSoggetto titoloStudioIstat

    @Transient
    IstatDizionarioDettagliSoggetto professioneIstat

    @Column(name = "IST_TS", nullable = true)
    Integer codiceTitoloStudioIstat

    @Column(name = "IST_NP", nullable = true)
    Integer codiceProfessioneIstat

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "ANNULLAMENTO", nullable = true)
    Boolean flagAnnullamento

    @Transient
    AnaRapportoParentela rapportoParentelaNuovo

    @Column(name = "NUOVO_RAPPORTO_PAR", nullable = true)
    String nuovoCodRp

    @Column(name = "NUOVA_SEQUENZA_PAR", nullable = true)
    Integer nuovaSequenzaRp

    @Transient
    AnaRapportoParentela rapportoParentelaPrecedente

    @Column(name = "RAPPORTO_PAR_PREC", nullable = true)
    String codRpPrecedente

    @Column(name = "SEQUENZA_PAR_PREC", nullable = true)
    Integer sequenzaRpPrecedente

    @Convert(converter = EFascia.EnumFasciaToIntConverter.class)
    @Column(name = "FASCIA_RIPRISTINO", nullable = false)
    EFascia fasciaRipristino

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "STATO_RIPRISTINO")
    AnaStato statoRipristino

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "D_DATA_INIZIO_FAM_RIPRISTINO", nullable = true)
    Date dataInizioFamigliaRipristino

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "D_DATA_INIZIO_RES_RIPRISTINO", nullable = true)
    Date dataInizioResidenzaRipristino

    @Column(name = "RAPPORTO_PAR_RIPRISTINO", nullable = true)
    String codRpRipristino

    @Column(name = "SEQUENZA_PAR_RIPRISTINO", nullable = true)
    Integer sequenzaRpRipristino

    @Column(name = "COD_FAM_RIPRISTINO", nullable = true)
    Long codFamigliaRipristino



    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Cognome"), Etichette.getEtichetta("Nome"), Etichette.getEtichetta("Data_Nascita"), Etichette.getEtichetta("Sesso"), Etichette.getEtichetta("Soggetto"),
                                              Etichette.getEtichetta("Rapporto_Parentela"), Etichette.getEtichetta("Rapporto_Parentela_Provenienza"), Etichette.getEtichetta("Rapporto_Parentela_Destinazione"),
                                              Etichette.getEtichetta("Numero_Ordine"), Etichette.getEtichetta("Matricola"), Etichette.getEtichetta("Stato_Anagrafico")]

}
