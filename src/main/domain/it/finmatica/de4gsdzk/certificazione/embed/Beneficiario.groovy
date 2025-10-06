package it.finmatica.de4gsdzk.certificazione.embed

import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.utils.ESesso

import javax.persistence.*

@Embeddable
class Beneficiario {
    @Enumerated(EnumType.STRING)
    @Column(name = "SESSO_BENEFICIARIO", nullable = true)
    ESesso sesso

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAS_BENEFICIARIO", nullable = true)
    Date dataNascita

    @Column(name = "COD_FISCALE_BENEFICIARIO", nullable = true)
    private String codiceFiscale

    String getCodiceFiscale() {
        return codiceFiscale
    }

    void setCodiceFiscale(String val) {
        this.codiceFiscale = (val?.toUpperCase())
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_NAS_BENEFICIARIO")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_NAS_BENEFICIARIO", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_NAS_BENEFICIARIO")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_NAS_BENEFICIARIO", updatable = false, insertable = false))
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

    @Column(name = "COGNOME_BENEFICIARIO", nullable = true)
    String cognome

    @Column(name = "NOME_BENEFICIARIO", nullable = true)
    String nome

    @Column(name = "COGNOME_NOME", nullable = true)
    private String cognomeNome

    String getCognomeNome() {
        return cognomeNome
    }

    void beforeInsert() {
        this.cognomeNome = (cognome ?: "") + ((cognome || nome) ? "/" : "") + (nome ?: "")
    }

    void beforeUpdate() {
        this.cognomeNome = (cognome ?: "") + ((cognome || nome) ? "/" : "") + (nome ?: "")
    }
}
