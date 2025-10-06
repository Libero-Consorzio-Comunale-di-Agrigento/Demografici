package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.CivRegistroDocumentiBaseDomain

import javax.persistence.*

@Entity
@Table(name = "CIVRDU")
class CivRegistroDocumentiUscita extends CivRegistroDocumentiBaseDomain{

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="TIPO_REGISTRO", nullable = false)
    CivTipoRegistro tipoRegistro

    /////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI /////////////////////////////
    /////////////////////////////////////////////////////////////////////////

}
