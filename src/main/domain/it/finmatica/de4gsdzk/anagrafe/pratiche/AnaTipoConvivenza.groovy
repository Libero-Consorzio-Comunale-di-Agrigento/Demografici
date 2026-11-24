package it.finmatica.de4gsdzk.anagrafe.pratiche

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Table


@Entity
@Table(name = "ANATCV")
class AnaTipoConvivenza {

    @Id
    @Column(name = "COD_TC")
    Integer id

    @Column(name = "DESCRIZIONE")
    String descrizione

    @Column(name = "CODICE_ANPR")
    Integer idAnpr

}
