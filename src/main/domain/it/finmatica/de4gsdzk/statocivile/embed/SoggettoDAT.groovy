package it.finmatica.de4gsdzk.statocivile.embed

import it.finmatica.de4gsdzk.ISoggettoCollegato
import it.finmatica.de4gsdzk.anagrafe.AnaEnte
import it.finmatica.de4gsdzk.anagrafe.AnaTipoDocumento
import it.finmatica.de4gsdzk.utils.ESesso
import it.finmatica.de4gsdzk.utils.ETipoSN
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

/**
 * Gestisce i campi dei soggetti DISPONENTE, FIDUCIARIO_1 e FIDUCIARIO_2 in DAT
 *
 * @see it.finmatica.de4gsdzk.statocivile.CivDisposizioniAnticipateTrattamento
 */
@Embeddable
class SoggettoDAT implements ISoggettoCollegato{

    @Column(name = "COGNOME", nullable = true)
    String cognome

    @Column(name = "NOME", nullable = true)
    String nome

    @Column(name = "COGNOME_NOME", nullable = true)
    private String cognomeNome

    @Enumerated(EnumType.STRING)
    @Column(name = "SESSO")
    ESesso sesso

    @Column Integer matricola

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAS")
    Date dataNascita

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "COD_COM_NAS")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_NAS", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "COD_PRO_NAS")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_NAS", updatable = false, insertable = false))
    ])
    private Comune comuneNascita

    Comune getComuneNascita() {
        if (comuneNascita == null){
            comuneNascita = new Comune()
        }
        return comuneNascita
    }

    void setComuneNascita(Comune comuneNascita) {
        this.comuneNascita = comuneNascita
    }

    @Column(name = "COD_FISCALE", nullable = true)
    private String codiceFiscale

    String getCodiceFiscale() {
        return codiceFiscale
    }

    void setCodiceFiscale(String val) {
        this.codiceFiscale = (val?.toUpperCase())
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "COD_COM_RES")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_RES", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "COD_PRO_RES")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_RES", updatable = false, insertable = false))
    ])
    private Comune comuneResidenza

    Comune getComuneResidenza() {
        if (comuneResidenza == null){
            comuneResidenza = new Comune()
        }
        return comuneResidenza
    }

    void setComuneResidenza(Comune comuneResidenza) {
        this.comuneResidenza = comuneResidenza
    }

    @Column(name = "INDIRIZZO_RES")
    String indirizzo

    @Column(name = "CAP_RES")
    String cap

    @Column(name = "NUMERO_TEL")
    String telefono

    @Column(name = "INDIRIZZO_MAIL")
    String indirizzoMail

    @Column(name = "NUMERO_DOC")
    private String numeroDocumento

    String getNumeroDocumento() {
        return numeroDocumento
    }

    void setNumeroDocumento(String val) {
        this.numeroDocumento = (val?.toUpperCase())
    }

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_RILASCIO_DOC")
    Date dataRilascioDocumento

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_SCADENZA_DOC")
    Date dataScadenzaDocumento

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "COD_COM_DOC")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_DOC", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "COD_PRO_DOC")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_DOC", updatable = false, insertable = false))
    ])
    private Comune comuneDocumento

    Comune getComuneDocumento() {
        if (comuneDocumento == null){
            comuneDocumento = new Comune()
        }
        return comuneDocumento
    }

    void setComuneDocumento(Comune comuneDocumento) {
        this.comuneDocumento = comuneDocumento
    }

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="TIPO_DOC", nullable = true)
    private AnaTipoDocumento tipoDocumento

    AnaTipoDocumento getTipoDocumento() {
        return tipoDocumento
    }

    void setTipoDocumento(AnaTipoDocumento tipoDocumento) {
        this.tipoDocumento = tipoDocumento
    }

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="ENTE_DOC", nullable = true)
    private AnaEnte ente

    AnaEnte getEnte() {
        return ente
    }

    void setEnte(AnaEnte ente) {
        this.ente = ente
    }

    @Enumerated(EnumType.STRING)
    @Column(name = "CONSENSO_TRATTAMENTO", nullable = true)
    ETipoSN consensoTrattamento

    @Enumerated(EnumType.STRING)
    @Column(name = "SOTTOSCRITTO", nullable = true, updatable = false, insertable = false)
    ETipoSN sottoscrittoDAT

    void prePersist() {
        this.cognomeNome = (cognome?:"") + ((cognome || nome)?"/":"") + (nome?:"")
    }

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Cognome, Etichette.Nome, Etichette.Matricola, Etichette.Sottoscrizione_DAT,
                                              Etichette.Sesso, Etichette.Data_Nascita, Etichette.Comune_Nascita, Etichette.Codice_Fiscale,
                                              Etichette.Indirizzo, Etichette.Comune_Residenza, Etichette.CAP, Etichette.Numero_telefono,
                                              Etichette.Email, Etichette.Numero, Etichette.Data_Scadenza, Etichette.Data_Rilascio, Etichette.Comune,
                                              Etichette.Documento_identita, Etichette.Ente_Rilascio, Etichette.Consenso_Trattamento_Dati]

}
