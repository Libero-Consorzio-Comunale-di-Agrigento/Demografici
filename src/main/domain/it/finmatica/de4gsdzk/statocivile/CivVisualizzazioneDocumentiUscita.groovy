package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.CivVisualizzazioneDocumentiBaseDomain
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "CIVVDU")
class CivVisualizzazioneDocumentiUscita extends CivVisualizzazioneDocumentiBaseDomain{

    @Id
    @Column(name = "ID")
    String id

    @Column(name = "ID_ATTO", nullable = false)
    String idAtto

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="COD_REGISTRO", nullable = true)
    CivRegistroDocumentiUscita registro

    @Column(name = "UFFICIO_MOR", nullable = false)
    Integer ufficio

    @Column(name = "ANNO_MOR", nullable = false)
    Integer anno

    @Column(name = "ATTO_MOR", nullable = false)
    Integer atto

    @Column(name = "PARTE_MOR", nullable = false)
    Integer parte

    @Column(name = "SERIE_MOR", nullable = true)
    String serie

    @Column(name = "ID_DTS", nullable = false)
    Integer idTrasportoESeppellimento

    /////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI /////////////////////////////
    /////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Ufficio"), Etichette.getEtichetta("Anno"), Etichette.getEtichetta("Numero_Atto"), Etichette.getEtichetta("Parte"), Etichette.getEtichetta("Serie"),
                                              Etichette.getEtichetta("Data"), Etichette.getEtichetta("Registro"), Etichette.getEtichetta("Protocollo"), Etichette.getEtichetta("Anno_Protocollo"), Etichette.getEtichetta("Cognome_Nome")]

}
