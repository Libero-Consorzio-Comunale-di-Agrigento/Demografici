package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.CivVisualizzazioneDocumentiBaseDomain
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "CIVVDE")
class CivVisualizzazioneDocumentiEntrata extends CivVisualizzazioneDocumentiBaseDomain{

    @Id
    @Column(name = "ID")
    Integer id

    @ManyToOne(fetch= FetchType.LAZY)
    @JoinColumn(name="COD_REGISTRO", nullable = true)
    CivRegistroDocumentiEntrata registro

    @Column(name = "ID_DAT")
    Integer idDisposizioniTrattamento

    /////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI /////////////////////////////
    /////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Data_Protocollo, Etichette.Registro, Etichette.Protocollo, Etichette.Anno_Protocollo, Etichette.Cognome_Nome]

}
