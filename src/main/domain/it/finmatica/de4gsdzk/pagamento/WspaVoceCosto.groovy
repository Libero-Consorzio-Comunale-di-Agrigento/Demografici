package it.finmatica.de4gsdzk.pagamento

import it.finmatica.de4gsdzk.certificazione.CerTariffaDiritto
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "WS_PAGAMENTI_VDC_V")
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(discriminatorType = DiscriminatorType.STRING,
        name = "PROVIDER")
abstract class WspaVoceCosto {

    @Id
    @Column(name = "ID")
    Long id

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "ID_CERDTD_RIF", nullable = false, updatable = false, insertable = false)
    CerTariffaDiritto tariffaDiritto

    @Column(name = "CODICE_VDC_1", nullable = true)
    String voceCosto1

    @Column(name = "DESCRIZIONE_VDC_1", nullable = true)
    String descrizioneVoceCosto1

    @Column(name = "CODICE_VDC_2", nullable = true)
    String voceCosto2

    @Column(name = "DESCRIZIONE_VDC_2", nullable = true)
    String descrizioneVoceCosto2


    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Tariffa_Diritto"),
                                              Etichette.getEtichetta("Voce_costo_1_codice"), Etichette.getEtichetta("Voce_costo_1_descrizione"),
                                              Etichette.getEtichetta("Voce_costo_2_codice"), Etichette.getEtichetta("Voce_costo_2_descrizione")]


}
