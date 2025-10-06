package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.GsdParametroBaseDomain
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "ANSINP")
class AnscParametro extends GsdParametroBaseDomain{

    static final String POSTAZIONE   = "POSTAZIONE"
    static final String SEDE         = "SEDE"
    static final String CERTIFICATO  = "CERTIFICATO"
    static final String PASSWORD     = "PASSWORD"
    static final String RESPONSE_XML = "RESP_XML"
    static final String URL_OTP      = "URL_OTP"

    static final String DURATA_OTP   = "DURATA_OTP"

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_BLOB", nullable = true)
    Boolean flagBlob

    @Version
    @Column(nullable = false)
    Long version

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Codice, Etichette.Descrizione, Etichette.Valore]
}
