package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.Etichette
import org.hibernate.annotations.Formula

import javax.persistence.*

@Entity
@Table(name = "ANADDO")
class AnaTipoDocumento extends GsdBaseDomain {

    @Id
    @Column(name = "COD_DO")
    String id

    @Column(name = "DESCRIZIONE")
    String descrizione

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_CDF", nullable = true)
    Boolean flagConvivenzaDiFatto

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_IDENTITA", nullable = true)
    Boolean flagIdentita

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_RICONOSCIMENTO", nullable = true)
    Boolean flagRiconoscimento

    @Formula("CONCAT(COD_DO, CONCAT(CASE WHEN DESCRIZIONE IS NULL THEN '' ELSE ' - ' END, COALESCE(DESCRIZIONE, '')))")
    String descrizioneEstesa

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Codice, Etichette.Descrizione]

    public static final String CE = "CE" // CARTA DI IDENTITA' ELETTRONICA
    public static final String CI = "CI" // CARTA DI IDENTITA'
    public static final String U1 = "U1" // SOGGIORNO UE - ART. 7/A
    public static final String U2 = "U2" // ATT.NE SOGGIORNO PERMANENTE UE
    public static final String PT = "PT" // PATENTE
    public static final String CC = "CC" // CARTA DI CIRCOLAZIONE
    public static final String LP = "LP" // LIBRETTO DI PENSIONE
    public static final String PE = "PE" // PERMESSO DI SOGGIORNO ELETTRONICO
    public static final String CA = "CA" //CARTA IDENTITA' DA CONSOLATO
    public static final String CS = "CS" //CARTA DI SOGGIORNO
    public static final String DC = "DC" //DOCUMENTO CONSOLARE
    public static final String DI = "DI" //DOCUMENTO DI IDENTITA'
    public static final String DV = "DV" //ATTO DIVORZIO STR
    public static final String MA = "MA" //ATTO MATRIMONIO STR
    public static final String MO = "MO" //ATTO MORTE STR
    public static final String NA = "NA" //ATTO NASCITA STR
    public static final String PP = "PP" //PASSAPORTO O CARTA ID STR
    public static final String PS = "PS" //PERMESSO DI SOGGIORNO
    public static final String RP = "RP" //PSO LUNGA DURATA
    public static final String SD = "SD" //STORICO DOCUMENTI
    public static final String XX = "XX" //CONVIVENZA FATTO ISTITUZIONE
    public static final String XR = "XR" //CONVIVENZA FATTO RISOLUZIONE
    public static final String ZI = "ZI" //CONTRATTO DI CONVIVENZA
    public static final String ZR = "ZR" //RISOLUZIONE CONTRATTO CONVIV

}
