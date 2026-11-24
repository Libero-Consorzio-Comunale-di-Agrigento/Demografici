package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Table

@Entity
@Table(name = "ANPT08")
class AnpCodiceTipoDocumento {

    @Id
    @Column(name = "CODICE")
    Integer codice

    @Column(name = "DESCRIZIONE")
    String descrizione

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Codice"), Etichette.getEtichetta("Descrizione")]
}