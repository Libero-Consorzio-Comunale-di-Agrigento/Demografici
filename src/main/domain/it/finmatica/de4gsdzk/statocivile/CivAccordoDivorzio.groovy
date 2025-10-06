package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.CivAccordoBaseDomain

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Table

@Entity
@Table(name = "CIVMAT_V_UAC")
class CivAccordoDivorzio extends CivAccordoBaseDomain{

    @Column(name = "SERIE", nullable = true)
    String serie

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

}
