package it.finmatica.de4gsdzk.anpr

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.ETabComunicazioniAnsc
import it.finmatica.de4gsdzk.utils.Etichette
import org.hibernate.annotations.Formula

import javax.persistence.*

@Entity
@Table(name = "ANPTWS_V_ZK")
class AnprEndPointServizio extends GsdBaseDomain {

    @Id
    @Column(name = "CODICE")
    String id

    @Column(name = "DESCRIZIONE")
    String descrizione

    @Column(name = "URL")
    String url

    @Column(name = "RISPOSTA_OK_STR_1")
    String rispostaOk1

    @Column(name = "RISPOSTA_OK_STR_2")
    String rispostaOk2

    @Column(name = "RISPOSTA_OK_STR_3")
    String rispostaOk3

    @Column(name = "RISPOSTA_OK_STR_4")
    String rispostaOk4

    @Column(name = "RISPOSTA_OK_STR_5")
    String rispostaOk5

    @Column(name = "RISPOSTA_KO_STR")
    String rispostaKo

    @Column(name = "RISPOSTA_KO_STR_1")
    String rispostaKo1

    @Column(name = "RISPOSTA_KO_STR_2")
    String rispostaKo2

    @Column(name = "RISPOSTA_KO_STR_3")
    String rispostaKo3

    @Column(name = "RISPOSTA_KO_STR_4")
    String rispostaKo4

    @Column(name = "RISPOSTA_KO_STR_5")
    String rispostaKo5

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_MODIFICA_PRE", updatable = false, insertable = false)
    Boolean flagModificaPre


    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Id"),
                                              Etichette.getEtichetta("Url"), Etichette.getEtichetta("Descrizione"),
                                              Etichette.getEtichetta("Risposta")]
}
