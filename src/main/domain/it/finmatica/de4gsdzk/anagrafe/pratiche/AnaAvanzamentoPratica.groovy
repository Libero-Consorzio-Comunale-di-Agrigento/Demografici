package it.finmatica.de4gsdzk.anagrafe.pratiche

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.anagrafe.ETipoAnagrafe
import it.finmatica.de4gsdzk.certificazione.CerTerminalista
import it.finmatica.de4gsdzk.utils.ETipoPratica
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "ANASAP_V_ZK")
class AnaAvanzamentoPratica extends GsdBaseDomain{

    @Id
    @Column(name = "ID")
    Integer id

    @Convert(converter = ETipoAnagrafe.EnumTipoAnagrafeToStringConverter.class)
    @Column(name ="ANAGRAFE")
    ETipoAnagrafe archivioAnagrafe

    @Convert(converter = ETipoPratica.EnumTipoPraticaToStringConverter.class)
    @Column(name ="TIPO_EVENTO")
    ETipoPratica tipoPratica

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_ANATPR")
    AnaPratica pratica

    @Column(name = "ID_PRATICA")
    String idPratica

    @Column(name ="ANNO_PRATICA", nullable = true)
    Integer annoPratica

    @Column(name ="PRATICA", nullable = true)
    Integer numeroPratica

    @Column(name ="SEQUENZA", nullable = true)
    Integer sequenza

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "EVENTO_PRATICA")
    AnaEventoPratica eventoPratica

    @Temporal(TemporalType.DATE)
    @Column(name= "D_DATA_EVENTO", nullable = true)
    Date dataEvento

    @Temporal(TemporalType.DATE)
    @Column(name= "D_DATA_RESTITUZIONE", nullable = true)
    Date dataRestituzione

    @Enumerated(EnumType.STRING)
    @Column(name = "ESITO", nullable = false)
    EEsito esito

    @Column(name ="NOTE", nullable = true)
    String note

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TERMINALISTA", nullable = true)
    CerTerminalista terminalista

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_ON_LINE", nullable = true)
    Boolean flagOnline

    @Transient
    Boolean inserito

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Avanzamento_Pratica"), Etichette.getEtichetta("Sequenza"), Etichette.getEtichetta("Evento_Pratica"),
                                              Etichette.getEtichetta("Web"), Etichette.getEtichetta("Data_Evento"), Etichette.getEtichetta("Data_Restituzione"),
                                              Etichette.getEtichetta("Esito"), Etichette.getEtichetta("Note")]
}
