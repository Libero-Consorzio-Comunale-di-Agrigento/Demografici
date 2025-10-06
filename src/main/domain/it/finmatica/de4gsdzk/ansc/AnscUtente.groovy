package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.ETipoSiNo

import javax.persistence.*

@Entity
@Table(name = "ANSUTE")
class AnscUtente extends GsdBaseDomain{

    @Id
    @Column(name = "COD_UTENTE")
    private String id

    String getId() {
        return id
    }

    void setId(String val) {
        this.id = (val?.toUpperCase())
    }

    @Column(name = "COD_FISCALE", nullable = false)
    private String codiceFiscale

    String getCodiceFiscale() {
        return codiceFiscale
    }

    void setCodiceFiscale(String val) {
        this.codiceFiscale = (val?.toUpperCase())
    }

    @Column(name = "FIRMAREMOTA_USR", nullable = true)
    String utenteFirmaRemota

    @Column(name = "FIRMAREMOTA_PWD", nullable = true)
    String pwdFirmaRemota

    @Enumerated(EnumType.STRING)
    @Column(name = "ANSC_CONSENSO", nullable = true)
    ETipoSiNo anscConsensoMemo

    @Column(name = "ANSC_OTP", nullable = true)
    String anscOtp

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "D_DATA_ANSC_OTP", nullable = false)
    Date anscDataOtp

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = []

}
