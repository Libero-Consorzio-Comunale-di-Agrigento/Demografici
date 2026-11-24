package it.finmatica.de4gsdzk.statocivile


import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "CIVDCF", uniqueConstraints = @UniqueConstraint(columnNames=["FORMULA", "CODICE_CO"]))
class CivComunicazioneFormula extends CivComunicazioneRelazione2BaseDomain {

    @Id
    @Column(name = "ID")
    Long id

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "FORMULA", nullable = false)
    CivFormulaAnnotazione formula

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "CODICE_CO", nullable = false)
    CivComunicazione comunicazione

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="ID_CIVDDO_RIF", nullable = true)
    CivTipoDocumentoFascicolo tipoDocumentoFascicoloRif

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Formula")]

}
