package it.finmatica.de4gsdzk.statocivile.embed.indirizzo

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.archivi.ArcVia

import javax.persistence.*

@Embeddable
class IndirizzoCivico {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "COD_VIA", nullable = true)
    ArcVia via

    @Column(name = "NUM_CIV", nullable = true, length = 6)
    Long numeroCivico

    @Column(name = "SUFFISSO", nullable = true, length = 10)
    String suffisso

    @Column(name = "INTERNO", nullable = true, length = 4)
    Long interno

    @Column(name = "SUB_INTERNO", nullable = true, length = 3)
    String subInterno

    @Column(name = "SCALA", nullable = true, length = 3)
    String scala

    @Column(name = "SCALA_ESTERNA", nullable = true, length = 10)
    String scalaEsterna

    @Column(name = "PIANO", nullable = true, length = 3)
    String piano

    // Dettagli civico esterno (ANPR)
    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_METRICO", nullable = true)
    Boolean flagMetrico

    @Column(name = "PROGR_SNC", nullable = true, length = 10)
    String progrSnc

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_LETTERA", nullable = true)
    Boolean flagLettera

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_ESPONENTE", nullable = true)
    Boolean flagEsponente

    @Column(name = "COLORE", nullable = true, length = 10)
    String colore

    // Dettagli civico interno (ANPR)
    @Column(name = "CORTE", nullable = true, length = 10)
    String corte

    @Column(name = "INTERNO2", nullable = true, length = 4)
    Long interno2

    @Column(name = "SUB_INTERNO2", nullable = true, length = 3)
    String subInterno2

    @Column(name = "SECONDARIO", nullable = true, length = 10)
    String secondario

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_NUI", nullable = true)
    Boolean flagNui

    @Column(name = "NUI", nullable = true, length = 10)
    String nui
}