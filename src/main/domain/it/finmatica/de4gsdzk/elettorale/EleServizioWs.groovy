package it.finmatica.de4gsdzk.elettorale

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Table

@Entity
@Table(name = "WS_MININT_URL_V")
class EleServizioWs extends GsdBaseDomain {

    @Id
    @Column(name = "ID", updatable = false, insertable = false)
    Long id

    @Column(name = "SERVIZIO")
    String servizio

    @Column(name = "DESCRIZIONE")
    String descrizione

    @Column(name = "URL")
    String url

    @Column(name = "URL_BASE")
    String urlBase

    @Column(name = "URL_SEVIZIO")
    String urlServizio

    @Column(name = "RISPOSTA_SERVIZIO")
    String rispostaServizio

    @Column(name = "RISPOSTA_STR_1")
    String risposta1

    @Column(name = "RISPOSTA_STR_2")
    String risposta2

    @Column(name = "RISPOSTA_STR_3")
    String risposta3

    @Column(name = "RISPOSTA_STR_4")
    String risposta4

    @Column(name = "RISPOSTA_STR_5")
    String risposta5

    @Column(name = "RISPOSTA_STR_6")
    String risposta6

    @Column(name = "RISPOSTA_STR_7")
    String risposta7

    @Column(name = "RISPOSTA_STR_8")
    String risposta8

    @Column(name = "RISPOSTA_STR_9")
    String risposta9

    @Column(name = "RISPOSTA_STR_10")
    String risposta10

    @Column(name = "RISPOSTA_NS")
    String rispostaNs

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Servizi"), Etichette.getEtichetta("Id"), Etichette.getEtichetta("Servizio"),
                                              Etichette.getEtichetta("Url"), Etichette.getEtichetta("Url_Base"), Etichette.getEtichetta("Descrizione"),
                                              Etichette.getEtichetta("Url_Servizio"), Etichette.getEtichetta("Risposta_Servizio"),
                                              Etichette.getEtichetta("Risposta")]


}