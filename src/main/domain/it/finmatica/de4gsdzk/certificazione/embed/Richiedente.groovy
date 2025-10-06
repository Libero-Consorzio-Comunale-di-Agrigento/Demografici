package it.finmatica.de4gsdzk.certificazione.embed


import it.finmatica.de4gsdzk.anagrafe.AnaNazionalita
import it.finmatica.de4gsdzk.anagrafe.AnaTipoDocumento
import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.utils.ESesso

import javax.persistence.*

@Embeddable
class Richiedente {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TIPO_DOC_RICHIEDENTE", nullable = true)
    AnaTipoDocumento tipoDocumento

    @Column(name = "NUMERO_DOC_RICHIEDENTE")
    private String numeroDocumento

    String getNumeroDocumento() {
        return numeroDocumento
    }

    void setNumeroDocumento(String val) {
        this.numeroDocumento = (val?.toUpperCase())
    }

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_RIL_DOC_RICHIEDENTE")
    Date dataRilascioDocumento

    @Enumerated(EnumType.STRING)
    @Column(name = "SESSO_RICHIEDENTE", nullable = true)
    ESesso sesso

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAS_RICHIEDENTE", nullable = true)
    Date dataNascita

    @Column(name = "COD_FISCALE_RICHIEDENTE", nullable = true)
    private String codiceFiscale

    String getCodiceFiscale() {
        return codiceFiscale
    }

    void setCodiceFiscale(String val) {
        this.codiceFiscale = (val?.toUpperCase())
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_NAS_RICHIEDENTE")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_NAS_RICHIEDENTE", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_NAS_RICHIEDENTE")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_NAS_RICHIEDENTE", updatable = false, insertable = false))
    ])
    private Comune comuneNascita

    Comune getComuneNascita() {
        if (comuneNascita == null) {
            comuneNascita = new Comune()
        }
        return comuneNascita
    }

    void setComuneNascita(Comune c) {
        this.comuneNascita = c
    }

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "NAZIONALITA_RICHIEDENTE", nullable = true)
    AnaNazionalita nazionalita

    @Column(name = "COGNOME_RICHIEDENTE", nullable = true)
    String cognome

    @Column(name = "NOME_RICHIEDENTE", nullable = true)
    String nome

    @Column(name = "RICHIEDENTE", nullable = true)
    private String cognomeNome

    String getCognomeNome() {
        return cognomeNome
    }

    @Column(name = "NOTE_RICHIEDENTE", nullable = true)
    String note

    void beforeInsert() {
        this.cognomeNome = (cognome ?: "") + ((cognome || nome) ? "/" : "") + (nome ?: "")
    }

    void beforeUpdate() {
        this.cognomeNome = (cognome ?: "") + ((cognome || nome) ? "/" : "") + (nome ?: "")
    }
}
