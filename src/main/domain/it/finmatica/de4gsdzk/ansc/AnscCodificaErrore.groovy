package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.GsdBaseDomain

import javax.persistence.*

@Entity
@Table(name = "ANSTCE")
class AnscCodificaErrore extends GsdBaseDomain{

    @Id
    @Column(name = "ERROR_CODE")
    String id

    @Column(name = "DESCRIZIONE")
    String descrizione

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_GESTITO", nullable = true)
    Boolean flagGestito

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_OTP_USER", nullable = true)
    Boolean flagOtpUser

}

