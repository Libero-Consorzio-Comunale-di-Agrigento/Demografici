package it.finmatica.de4gsdzk

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Table


@Entity
@Table(name = "MENUDITTA_V")
class GsdMenuDitta {

    @Id
    @Column(name = "ID")
    String id

    @Column(name = "COM_CLIENTE", nullable = false)
    Integer comuneCliente

    @Column(name = "PRO_CLIENTE", nullable = false)
    Integer provinciaCliente

    @Column(name = "CLIENTE", nullable = true)
    String cliente

    @Column(name = "DITTA", nullable = true)
    String ditta

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////
}
