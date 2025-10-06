package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.utils.*

import javax.persistence.*

@Entity
@Table(name = "ANSCU2")
class AnscCasoUsoNascita extends AnscCasoUsoBaseDomain{

    @Column(name = "PARTE", nullable = false)
    Integer parte

    @Column(name = "SERIE", nullable = true)
    private String serie

    String getSerie() {
        return serie
    }

    void setSerie(String serie) {
        this.serie = serie?.toUpperCase()
    }

    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_FILIAZIONE")
    ETipoFiliazione tipoFiliazione

    @Enumerated(EnumType.STRING)
    @Column(name = "NATO_MORTO", nullable = true)
    ETipoSiNo natoMorto

    @Column(name = "TIPO_DICHIARANTE", nullable = true)
    String tipoDichiarante

    @Column(name = "TIPO_COMPARENTE", nullable = true)
    String tipoComparente

    @Column(name = "TIPO_COMPARENTE_ALTRO_SOGGETTO", nullable = true)
    String tipoComparenteAltroSoggetto

    @Enumerated(EnumType.STRING)
    @Column(name = "ATTO_NOTARILE", nullable = true)
    ETipoSiNo attoNotarile

    @Enumerated(EnumType.STRING)
    @Column(name = "DICHIARAZIONE_GIUDIZIALE", nullable = true)
    ETipoSiNo dichiarazioneGiudiziale

    @Enumerated(EnumType.STRING)
    @Column(name = "FASCIA_ETA_FIGLIO", nullable = true)
    ETipoFasciaEta fasciaEtaFiglio

    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_CONSENSO", nullable = true)
    ETipoConsenso tipoConsenso

    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_CONSENSO_2", nullable = true)
    ETipoConsenso tipoConsenso2

    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_RICONOSCIMENTO", nullable = true)
    ETipoRiconoscimentoPrenatale tipoRiconoscimento

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_EX_ART19", nullable = true)
    Boolean flagExArt19

    @Column(name = "MOTIVO_ADOZIONE", nullable = true)
    Long idMotivoAdozione

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_IN_VIAGGIO", nullable = true)
    Boolean flagInViaggio

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_FIGLIO_DI_IGNOTI", nullable = true)
    Boolean flagFiglioDiIgnoti

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = []

}
