package it.finmatica.de4gsdzk.archivi

import it.finmatica.de4gsdzk.GsdParametroBaseDomain
import it.finmatica.de4gsdzk.utils.EGruppo
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "ARCINP")
class ArcParametro extends GsdParametroBaseDomain{

    public static final String MULTILANG        = "MULTILANG"
    public static final String ATTI_ALERT       = "ATTI_ALERT"
    public static final String ATTI_MINUS       = "ATTI_MINUS"
    public static final String ATTI_ODT         = "ATTI_ODT"
    public static final String ATTI_A3          = "ATTI_A3"
    public static final String ATTI_MAR         = "ATTI_MAR"
    public static final String ATTI_A4_FR       = "ATTI_A4_FR"
    public static final String ANAS_COM         = "ANAS_COM"
    public static final String ANAS_COGN        = "ANAS_COGN"
    public static final String FIRMA_AUTO       = "FIRMA_AUTO"
    public static final String FIRMA_OTP        = "FIRMA_OTP"
    public static final String CIV_COM_PR       = "CIV_COM_PR"
    public static final String ISTATEL          = "ISTATEL"
    public static final String SEAW_DATA        = "SEAW_DATA"
    public static final String CSV_CHRSET       = "CSV_CHRSET"
    public static final String LOGO_CIV         = "LOGO_CIV"
    public static final String LOGO_SCIA        = "SCIA_LOGO"
    public static final String LOGO_CER         = "LOGO_CER"
    public static final String CIV_ANPR         = "CIV_ANPR"
    public static final String ATTI_LI          = "ATTI_LI"
    public static final String RANN_ATTO        = "RANN_ATTO"
    public static final String RANN_ESTR        = "RANN_ESTR"
    public static final String TANN_BLOC        = "TANN_BLOC"
    public static final String TANN_AUTO        = "TANN_AUTO"
    public static final String ANSC             = "ANSC"
    public static final String ANSC_INT         = "ANSC_INT"
    public static final String MODULO_CER       = "MODULO_CER"
    public static final String WSPA = "WSPA"
    public static final String DEPAG_URL        = "DEPAG_URL"
    public static final String NEXT_URL         = "NEXT_URL"
    @Deprecated
    public static final String CERT_SANN        = "CERT_SANN"
    public static final String XPMO_PARAM       = "XPMO"
    public static final String FIRMA_LIST       = 'FIRMA_LIST'
    public static final String STATS_URL        = 'STATS_URL'
    public static final String ATTI_ANN_N       = 'ATTI_ANN_N'
    public static final String VANA_2FAM        = 'VANA_2FAM'

    @Column(name = "NOTE")
    String note

    @Enumerated(EnumType.STRING)
    @Column(name = "GRUPPO")
    EGruppo gruppo

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Codice, Etichette.Descrizione, Etichette.Note, Etichette.Valore]
}
