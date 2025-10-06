package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.ENaturaAtto

import javax.persistence.*

@Entity
@Table(name = "CIVCTA_V")
class CivCategoriaTipoAtto extends GsdBaseDomain{

    @Id
    @Column(name = "ID")
    Integer id

    @Column(name = "TIPO_ATTO", nullable = false)
    Integer tipoAtto

    @Enumerated(EnumType.STRING)
    @Column(name = "NATURA")
    ENaturaAtto natura

    @Column(name = "PARTE", nullable = true)
    Integer parte

    @Column(name = "SERIE", nullable = true)
    private String serie

    String getSerie() {
        return serie
    }

    void setSerie(String serie) {
        this.serie = serie?.toUpperCase()
    }

    @Column(name = "SIGLA", nullable = false)
    String codice

    @Column(name = "DESCRIZIONE", nullable = false)
    String descrizione

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_FORMULE", nullable = true)
    Boolean flagFormule

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_PREGRESSO", nullable = true)
    Boolean flagPregresso

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_DIVORZIO", nullable = true)
    Boolean divorzio

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_ANAGRAFE", nullable = true)
    Boolean flagAnagrafe

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_ISTAT", nullable = true)
    Boolean flagIstat

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_ANSC", nullable = true)
    Boolean flagAnsc

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI ////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final String CNA = "CNA" //CENTRO NASCITA
    static final String TEP = "TEP" //TRASCRIZIONE ESTERO (PRIVATO)
    static final String TEA = "TEA" //TRASCRIZIONE ESTERO (AUTORITA')
    static final String RPN = "RPN" //RICONOSCIMENTO (PRE-NATALE)
    static final String RIC = "RIC" //RICONOSCIMENTO (POST-NASCITA)
    static final String CGE = "CGE" //CAMBIO GENERALITA’

    static final String ODN = "ODN" //TRASCRIZIONE DECRETO TRIBUNALE OMESSA DIC. DI NASCITA
    static final String ADO = "ADO" //ADOZIONE NAZIONALE / INTERNAZIONALE

    static final String ATL = "ATL" //ATTO A TESTO LIBERO

    static final String CPD = "CPD" //CIVILE PER DELEGA
    static final String TMC = "TMC" //TRASCRIZIONE MATRIMONIO CIVILE
    static final String TMD = "TMD" //TRASCRIZIONE MATRIMONIO CIVILE SU DELEGA

    static final String UAC = "UAC" //UFFICIALE DI STATO CIVILE - ACCORDO (CESSAZIONE / SCIOGLIMENTO / SEPARAZIONE)
    static final String UCO = "UCO" //UFFICIALE DI STATO CIVILE - CONFERMA (CESSAZIONE / SCIOGLIMENTO / SEPARAZIONE)
    static final String UAL = "UAL" //UFFICIALE DI STATO CIVILE - ALTRO (MANCATA CONFERMA ACCORDO / MODIFICA CONDIZIONI / RICONCILIAZIONE)
    static final String AVV = "AVV" //AVVOCATI (CESSAZIONE / SCIOGLIMENTO / SEPARAZIONE)
    static final String AAL = "AAL" //AVVOCATI - ALTRO
    static final String TRI = "TRI" //TRIBUNALE (CESSAZIONE / SCIOGLIMENTO)
    static final String EST = "EST" //DIVORZIO ESTERO
    static final String RCN = "RCN" //RICONCILIAZIONE
  //static final String FCC = "FCC" //MATRIMONIO - FUORI DALLA CASA COMUNALE
  //static final String PDV = "PDV" //MATRIMONIO - PERICOLO DI VITA

    static final String MPR = "MPR" //MORTE PRESUNTA
    static final String CIG = "CIG" //CADUTO IN GUERRA
    static final String BIS = "BIS" //DECEDUTO IN OSPEDALE DI ALTRO COMUNE

    static final String PV1 = "PV1" //UFFICIALE DI STATO CIVILE
    static final String PV2 = "PV2" //AUTORITA' GIUDIZIARIA
    static final String PV3 = "PV3" //FUORI DALLA CASA COMUNALE

    static final String O1  = "O1"  //UNIONE CIVILE
    static final String UCN = "UCN" //UNIONE CIVILE - CONIUGI
    static final String FCC = "FCC" //UNIONE CIVILE - FUORI DALLA CASA COMUNALE
    static final String PDV = "PDV" //UNIONE CIVILE PERICOLO DI VITA
    static final String UPD = "UPD" //UNIONE CIVILE PER DELEGA
    static final String T2  = "T2"  //TRASCRIZIONE DA ALTRO COMUNE

    static final String DVS = "DVS" //DICHIARAZIONE VOLONTA’ SCIOGLIMENTO UNIONE

    static final String GIU = "GIU" //GIURAMENTO
    static final String DAQ = "DAQ" //DECRETO ACQUISTO
    static final String R18 = "R18" //RICHIESTA 18ENNE
    static final String AS1 = "AS1" //ATTESTAZIONE SINDACO 18ENNE
    static final String ASM = "ASM" //ATTESTAZIONE SINDACO MINORE
    static final String DPE = "DPE" //DECRETO PERDITA

}
