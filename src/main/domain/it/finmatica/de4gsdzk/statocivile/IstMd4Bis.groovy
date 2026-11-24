package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.IstBaseDomain
import it.finmatica.de4gsdzk.anagrafe.AnaCittadinanza
import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.Etichette
import org.hibernate.annotations.Formula

import javax.persistence.*

@Entity
@Table(name = "ISTM4B_V")
class IstMd4Bis extends IstBaseDomain {

    @Column(name = "ID_ATTO", nullable = false)
    String idAtto

    @Column(name = "UFFICIO", nullable = true)
    Integer ufficio

    @Column(name = "ANNO", nullable = true)
    Integer anno

    @Column(name = "ATTO", nullable = false)
    Integer atto

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

    @Column(name = "INDICAZIONE_ETA", nullable = true)
    Integer indicazioneEtaDecesso

    @Column(name = "ETA_COMPIUTA", nullable = true)
    Integer etaDecesso

    @Formula("CASE WHEN INDICAZIONE_ETA = 1 THEN ETA_COMPIUTA ELSE NULL END")
    Integer etaDecessoOre

    @Formula("CASE WHEN INDICAZIONE_ETA = 2 THEN ETA_COMPIUTA ELSE NULL END")
    Integer etaDecessoGiorni

    @Formula("CASE WHEN INDICAZIONE_ETA = 3 THEN ETA_COMPIUTA ELSE NULL END")
    Integer etaDecessoMesi

    @Column(name = "GENERE_PARTO", nullable = true)
    Integer genereParto

    @Column(name = "TIPO_PARTO", nullable = true)
    Integer tipoParto

    @Column(name = "FILIAZIONE", nullable = true)
    Integer tipoFiliazione

    @Column(name = "LUOGO_PARTO", nullable = true)
    Integer luogoParto

    @Column(name = "PRESENTAZIONE", nullable = true)
    Integer presentazione

    @Column(name = "LUOGO_DECESSO", nullable = true)
    Integer luogoDecesso

    @Column(name = "NUMERO_SCHEDA", nullable = true)
    Integer numeroScheda

    @Column(name = "PESO_NEONATO", nullable = true)
    Integer pesoNascita

    @Column(name = "DURATA_GESTAZIONE", nullable = true)
    Integer durataGestazione

    @Column(name = "CONSANGUINEO", nullable = true)
    Integer consanguineo

    @Column(name = "ORDINE_NASCITA", nullable = true)
    Integer numeroParti

    @Column(name = "MORTALITA_PREC", nullable = true)
    Integer mortalitaInfantilePrecedente

    @Column(name = "NUMERO_MORTI_1ANNO", nullable = true)
    Integer mortiNelPrimoAnno

    @Column(name = "NUMERO_VIVI_PREC", nullable = true)
    Integer natiVivi

    @Column(name = "NUMERO_MORTI_PREC", nullable = true)
    Integer natiMorti

    @Column(name = "NUMERO_ABORTI_PREC", nullable = true)
    Integer aborti

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// PADRE ///////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Column(name = "COD_FISCALE_PAT", nullable = true)
    private String codiceFiscalePadre

    String getCodiceFiscalePadre() {
        return codiceFiscalePadre
    }

    void setCodiceFiscalePadre(String cf) {
        this.codiceFiscalePadre = cf?.toUpperCase()
    }

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="NAZIONALITA_PAT", nullable = true)
    AnaCittadinanza nazionalitaPadre

    @Column(name = "GRADO_ISTRUZIONE_PAT", nullable = true)
    Integer gradoIstruzionePadre

    @Column(name = "POSIZIONE_PROF_PAT", nullable = true)
    Integer posizioneProfessionalePadre

    @Column(name = "CONDIZIONE_PROF_PAT", nullable = true)
    Integer condizioneProfessionalePadre

    @Column(name = "ATTIVITA_PROF_PAT", nullable = true)
    Integer attivitaProfessionalePadre

    @Column(name = "NAZIONALITA_ITA_PAT", nullable = false)
    Integer nazionalitaItalianaPadre

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// MADRE ///////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAS_MAT", nullable = true)
    Date dataNascitaMadre

    @Column(name = "COD_FISCALE_MAT", nullable = true)
    private String codiceFiscaleMadre

    String getCodiceFiscaleMadre() {
        return codiceFiscaleMadre
    }

    void setCodiceFiscaleMadre(String cf) {
        this.codiceFiscaleMadre = cf?.toUpperCase()
    }

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="NAZIONALITA_MAT", nullable = true)
    AnaCittadinanza nazionalitaMadre

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "COD_COM_RES_MAT")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_RES_MAT", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "COD_PRO_RES_MAT")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_RES_MAT", updatable = false, insertable = false))
    ])
    private Comune comuneResidenzaMadre
    Comune getComuneResidenzaMadre() {
        if (comuneResidenzaMadre == null){
            comuneResidenzaMadre = new Comune()
        }
        return comuneResidenzaMadre
    }
    void setComuneResidenzaMadre(Comune comuneResidenzaMadre) {
        this.comuneResidenzaMadre = comuneResidenzaMadre
    }

    @Column(name = "GRADO_ISTRUZIONE_MAT", nullable = true)
    Integer gradoIstruzioneMadre

    @Column(name = "POSIZIONE_PROF_MAT", nullable = true)
    Integer posizioneProfessionaleMadre

    @Column(name = "CONDIZIONE_PROF_MAT", nullable = true)
    Integer condizioneProfessionaleMadre

    @Column(name = "ATTIVITA_PROF_MAT", nullable = true)
    Integer attivitaProfessionaleMadre

    @Column(name = "NAZIONALITA_ITA_MAT", nullable = false)
    Integer nazionalitaItalianaMadre

    ETipoAtto getTipoAttoEnum(){
        return ETipoAtto.MOR
    }

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Data_morte"), Etichette.getEtichetta("Filiazione"), Etichette.getEtichetta("Luogo_decesso"), Etichette.getEtichetta("Luogo_Parto"), Etichette.getEtichetta("Presentazione"),
                                              Etichette.getEtichetta("Numero_ordine_scheda"),
                                              Etichette.getEtichetta("Se_fino_ad_un_giorno"), Etichette.getEtichetta("Se_fino_ad_un_mese"), Etichette.getEtichetta("Se_fino_ad_un_anno"),
                                              Etichette.getEtichetta("Durata_gestazione"), Etichette.getEtichetta("Eta_compiuta"), Etichette.getEtichetta("Genere_parto"),
                                              Etichette.getEtichetta("Peso_nascita"), Etichette.getEtichetta("Tipo_parto"), Etichette.getEtichetta("Consanguineita_genitori"),
                                              Etichette.getEtichetta("Numero_nascite_precedenti"), Etichette.getEtichetta("Numero_nati_vivi_precedenti"),
                                              Etichette.getEtichetta("Numero_nati_morti_precedenti"), Etichette.getEtichetta("Numero_aborti_precedenti"),
                                              Etichette.getEtichetta("Mortalita_infantile"), Etichette.getEtichetta("Morti_nel_primo_anno") ]
}
