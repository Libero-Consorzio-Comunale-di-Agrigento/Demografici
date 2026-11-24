package it.finmatica.de4gsdzk.anagrafe.pratiche

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.ETipoPratica
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "WEB_VTPR_V_ZK")
class AnaEsitoAccertamento extends GsdBaseDomain {

    @Id
    @Column(name = "ID")
    Long id

    @Convert(converter = ETipoPratica.EnumTipoPraticaToStringConverter.class)
    @Column(name ="TIPO_EVENTO")
    ETipoPratica tipoPratica

    @Column(name ="PRATICA", nullable = true, updatable = false, insertable = false)
    Integer pratica

    @Column(name ="ANNO_PRATICA", nullable = true, updatable = false, insertable = false)
    Integer annoPratica

    @Enumerated(EnumType.STRING)
    @Column(name = "ESITO", nullable = true, updatable = false, insertable = false)
    EEsito esito

    @Column(name ="NOTE", nullable = true, updatable = false, insertable = false)
    String note

    @Temporal(TemporalType.DATE)
    @Column(name= "D_DATA_ESITO", nullable = true, updatable = false, insertable = false)
    Date dataEsito

    @Column(name ="SEQUENZA", nullable = true, updatable = false, insertable = false)
    Integer sequenza

    @Column(name ="UTENTE", nullable = true, updatable = false, insertable = false)
    String utente

    @Column(name = "ALLEGATO_BLOB", nullable = false, updatable = false, insertable = false)
    @Lob
    byte[] blobAllegato

    @Column(name = "ALLEGATO_NOME", nullable = true, updatable = false, insertable = false)
    String nomeAllegato

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_ANASAP")
    AnaAvanzamentoPratica avanzamento

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Archivio_Anagrafe"), Etichette.getEtichetta("Tipo_Pratica"), Etichette.getEtichetta("Numero_Pratica"), Etichette.getEtichetta("Anno_Pratica"),
                                              Etichette.getEtichetta("Esito"), Etichette.getEtichetta("Data_Esito"),
                                              Etichette.getEtichetta("Utente"), Etichette.getEtichetta("Sequenza"), Etichette.getEtichetta("Note")]



}
