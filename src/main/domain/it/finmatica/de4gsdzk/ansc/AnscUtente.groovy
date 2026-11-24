package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.ETipoSiNo
import it.finmatica.de4gsdzk.utils.Etichette

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

    @Column(name = "COGNOME", nullable = false)
    private String cognome

    String getCognome() {
        return cognome
    }

    void setCognome(String val) {
        this.cognome = (val?.toUpperCase())
    }

    @Column(name = "NOME", nullable = false)
    private String nome

    String getNome() {
        return nome
    }

    void setNome(String val) {
        this.nome = (val?.toUpperCase())
    }

    @Column(name = "COD_FISCALE", nullable = false)
    private String codiceFiscale

    String getCodiceFiscale() {
        return codiceFiscale
    }

    void setCodiceFiscale(String val) {
        this.codiceFiscale = (val?.toUpperCase())
    }

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_DEFAULT", nullable = true)
    Boolean flagDefault

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_NOTIFICHE", nullable = true)
    Boolean flagNotifiche

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

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Utenti_ANSC"),
                                              Etichette.getEtichetta("Codice_Utente"),
                                              Etichette.getEtichetta("Cognome"),
                                              Etichette.getEtichetta("Nome"),
                                              Etichette.getEtichetta("Codice_Fiscale"),
                                              Etichette.getEtichetta("Default"),
                                              Etichette.getEtichetta("Notifiche")]

}
