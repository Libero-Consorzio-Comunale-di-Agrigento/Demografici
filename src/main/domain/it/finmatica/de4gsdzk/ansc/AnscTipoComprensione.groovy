package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.GsdBaseDomain

import javax.persistence.*

@Entity
@Table(name = "ANST32")
class AnscTipoComprensione extends GsdBaseDomain{

    @Id
    @Column(name = "ID")
    Integer id

    @Column(name = "DESCRIZIONE")
    String descrizione

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_MOTIVAZIONE", nullable = true)
    Boolean flagMotivazioneImpedimento

}

