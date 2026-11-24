package it.finmatica.de4gsdzk.anagrafe.pratiche

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafe
import it.finmatica.de4gsdzk.anagrafe.ETipoAnagrafe
import it.finmatica.de4gsdzk.utils.ETipoPratica
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "ANAREM_V_ZK")
class AnaSoggettoRettifica extends GsdBaseDomain implements ISoggettoPratica {

    @Id
    @Column(name = "ID")
    Integer id

    @Column(name = "ANNO_PRATICA", nullable = true)
    Integer annoPratica

    @Column(name ="PRATICA", nullable = true)
    Integer numeroPratica

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MATRICOLA", nullable = true)
    AnaAnagrafe anagrafe

    @Transient
    AnaRapportoParentela rapportoParentelaPrecedente

    @Column(name = "RAPPORTO_PAR_PREC", nullable = true)
    String codRpPrecedente

    @Column(name = "SEQUENZA_PAR_PREC", nullable = true)
    Integer sequenzaRpPrecedente

    @Transient
    AnaRapportoParentela rapportoParentelaNuovo

    @Column(name = "NUOVO_RAPPORTO_PAR", nullable = true)
    String nuovoCodRp

    @Column(name = "NUOVA_SEQUENZA_PAR", nullable = true)
    Integer nuovaSequenzaRp

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_SOGGETTO", nullable = true)
    Boolean flagSoggetto

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_ANNULLAMENTO", nullable = true)
    Boolean flagAnnullamento

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_ANATPR")
    AnaPratica pratica

    @Column(name = "ID_PRATICA", updatable = false, insertable = false)
    String idPratica

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_ANARET", nullable = true)
    AnaDichiarazioneRettifica dichiarazioneRettifica

    @Override
    IDichiarazionePratica getDichiarazione() {
        return dichiarazioneRettifica
    }

    @Override
    void setDichiarazione(IDichiarazionePratica dichiarazione) {
        this.dichiarazioneRettifica = dichiarazione as AnaDichiarazioneRettifica
    }

    @Column(name = "NUMERO_ORDINE", nullable = true)
    Integer numeroOrdine

    @Convert(converter = ETipoAnagrafe.EnumTipoAnagrafeToStringConverter.class)
    @Column(name ="ANAGRAFE", updatable = false, insertable = false)
    ETipoAnagrafe archivioAnagrafe

    @Convert(converter = ETipoPratica.EnumTipoPraticaToStringConverter.class)
    @Column(name ="TIPO_EVENTO", updatable = false, insertable = false)
    ETipoPratica tipoPratica


    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Cognome"), Etichette.getEtichetta("Nome"), Etichette.getEtichetta("Data_Nascita"), Etichette.getEtichetta("Sesso"), Etichette.getEtichetta("Soggetto"),
                                              Etichette.getEtichetta("Rapporto_Parentela_Precedente"), Etichette.getEtichetta("Rapporto_Parentela_Nuovo"), Etichette.getEtichetta("Rapporto_Parentela"),
                                              Etichette.getEtichetta("Numero_Ordine"), Etichette.getEtichetta("Matricola"), Etichette.getEtichetta("Stato_Anagrafico")]

}
