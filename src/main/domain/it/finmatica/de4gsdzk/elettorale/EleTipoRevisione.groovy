package it.finmatica.de4gsdzk.elettorale

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Table

@Entity
@Table(name = "ELEDRE")
class EleTipoRevisione {

    @Id
    @Column(name = "COD_RE")
    String codice

    @Column(name = "DESCRIZIONE", nullable = true, updatable = false, insertable = false)
    String descrizione

}
