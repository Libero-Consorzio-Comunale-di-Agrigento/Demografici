package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.IComunicazione
import it.finmatica.de4gsdzk.utils.ETipoComunicazione
import it.finmatica.de4gsdzk.utils.ETipoSN
import it.finmatica.de4gsdzk.utils.Etichette
import org.hibernate.annotations.Formula
import org.hibernate.annotations.Type

import javax.persistence.*

@Entity
@Table(name = "CIVDCO")
class CivComunicazione extends GsdBaseDomain implements  IComunicazione {

    @Id
    @Column(name = "CODICE_CO")
    Integer id

    @Column(name = "DESCRIZIONE")
    String descrizione

    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_COMUNICAZIONE", nullable = false)
    ETipoComunicazione tipoComunicazione

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_ATTO_ALLEGATO", nullable = true)
    Boolean attoAllegato

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_PRIORITA", nullable = true)
    Boolean priorita

    @Formula("CONCAT(CODICE_CO, CONCAT(' - ', DESCRIZIONE))")
    String descrizioneEstesa

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Codice"), Etichette.getEtichetta("Descrizione"), Etichette.getEtichetta("Tipo_Comunicazione"), Etichette.getEtichetta("Adempimenti")]

}
