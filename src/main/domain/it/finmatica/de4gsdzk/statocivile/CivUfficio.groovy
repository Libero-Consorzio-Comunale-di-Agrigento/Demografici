package it.finmatica.de4gsdzk.statocivile


import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Table

@Entity
@Table(name = "CIVUSC")
class CivUfficio {

    @Id
    @Column(name = "UFFICIO")
    Integer id

    @Column(name = "SEDE")
    String sede

    static final List<Map> etichetteDomain = [Etichette.Ufficio, Etichette.Sede]

}
