package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.IDaFascicolare
import it.finmatica.de4gsdzk.utils.ETipoIndividuiAtto
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@MappedSuperclass
class CivComunicazioneRelazione2BaseDomain extends CivComunicazioneRelazioneBaseDomain implements IDaFascicolare {

    @Column(name = "NUMERO_COPIE", nullable = true)
    Integer numeroCopie

    @Enumerated(EnumType.STRING)
    @Column(name = "INDIVIDUI_COINVOLTI", nullable = false)
    ETipoIndividuiAtto tipoIndividuiAtto

    @Column(name = "TYPE_WEGO", nullable = true)
    String tipo

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="ID_CIVDDO", nullable = true)
    CivTipoDocumentoFascicolo tipoDocumentoFascicolo

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Numero_copie"), Etichette.getEtichetta("Tipo_Individui"),
                                              Etichette.getEtichetta("Categoria"), Etichette.getEtichetta("Tipo_Documento_Fascicolo")]

}
