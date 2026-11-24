package it.finmatica.de4gsdzk.anagrafe.pratiche

import it.finmatica.de4gsdzk.GsdBaseDomain

import javax.persistence.Column
import javax.persistence.Convert
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Table

@Entity
@Table(name = "ANADTR")
class AnaTipoRecapito {

    @Id
    @Column(name = "COD_TR")
    Integer codTr

    @Column(name = "DESCRIZIONE")
    String descrizione

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_NUMERO_TELEFONICO", nullable = true)
    Boolean flagNumeroTelefonico

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_INDIRIZZO", nullable = true)
    Boolean flagIndirizzo

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_COMUNE", nullable = true)
    Boolean flagComune


}
