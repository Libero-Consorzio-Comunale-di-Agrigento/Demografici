package it.finmatica.de4gsdzk.anagrafe.pratiche

import it.finmatica.ad4.autenticazione.Ad4Utente
import it.finmatica.ad4.hibernate.UtenteUpd
import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafe
import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.statocivile.embed.EstremiAtto
import it.finmatica.de4gsdzk.utils.ESesso
import it.finmatica.de4gsdzk.utils.Etichette
import org.hibernate.annotations.NotFound
import org.hibernate.annotations.NotFoundAction

import javax.persistence.*

@Entity
@Table(name = "ANAAUC_V")
class AnaUrnaCineraria extends GsdBaseDomain{

    @Id
    @Column(name = "ID")
    Long id

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MATRICOLA", nullable = true)
    AnaAnagrafe anagrafe

    @Enumerated(EnumType.STRING)
    @Column(name = "SESSO_MOR", nullable = true)
    ESesso sessoMorto

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "ufficio", column = @Column(name = "UFFICIO_MOR")),
            @AttributeOverride(name = "anno", column = @Column(name = "ANNO_ATTO_MOR")),
            @AttributeOverride(name = "atto", column = @Column(name = "ATTO_MOR")),
            @AttributeOverride(name = "parte", column = @Column(name = "PARTE_MOR")),
            @AttributeOverride(name = "serie", column = @Column(name = "SERIE_MOR")),
            @AttributeOverride(name = "idAttoAnsc", column = @Column(name = "ATTO_MOR_DIGITALE"))
    ])
    private EstremiAtto estremiAttoMorte

    EstremiAtto getEstremiAttoMorte() {
        if (estremiAttoMorte == null) {
            estremiAttoMorte = new EstremiAtto()
        }
        return estremiAttoMorte
    }

    void setEstremiAttoMorte(EstremiAtto estremiAttoMorte) {
        this.estremiAttoMorte = estremiAttoMorte
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_NAS_MOR")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_NAS_MOR", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_NAS_MOR")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_NAS_MOR", updatable = false, insertable = false))
    ])
    private Comune comuneNascitaMorto

    Comune getComuneNascitaMorto() {
        if (comuneNascitaMorto == null) {
            comuneNascitaMorto = new Comune()
        }
        return comuneNascitaMorto
    }

    void setComuneNascitaMorto(Comune comuneNascitaMorto) {
        this.comuneNascitaMorto = comuneNascitaMorto
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_MOR")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_MOR", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_MOR")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_MOR", updatable = false, insertable = false))
    ])
    private Comune comuneMorte

    Comune getComuneMorte() {
        if (comuneMorte == null) {
            comuneMorte = new Comune()
        }
        return comuneMorte
    }

    void setComuneMorte(Comune comuneMorte) {
        this.comuneMorte = comuneMorte
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_ATTO_MOR")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_ATTO_MOR", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_ATTO_MOR")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_ATTO_MOR", updatable = false, insertable = false))
    ])
    private Comune comuneAttoMorte

    Comune getComuneAttoMorte() {
        if (comuneAttoMorte == null) {
            comuneAttoMorte = new Comune()
        }
        return comuneAttoMorte
    }

    void setComuneAttoMorte(Comune comuneAttoMorte) {
        this.comuneAttoMorte = comuneAttoMorte
    }

    @Column(name = "NOTE", nullable = true)
    String note

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TERMINALISTA", nullable = true)
    @UtenteUpd
    @NotFound(action = NotFoundAction.IGNORE)
    Ad4Utente terminalista

    @Column(name = "ANNO_REG", nullable = true)
    Integer annoRegistro

    @Column(name = "NUMERO_REG", nullable = true)
    Long numeroRegistro

    @Column(name = "VERBALE_AFFIDAMENTO", nullable = true)
    String verbaleAffidamento

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_ANADRP", nullable = true, updatable = false, insertable = false)
    AnaRapportoParentela rapportoParentela

    @Column(name = "RAPPORTO_PAR", nullable = true)
    String codRp

    @Column(name = "COGNOME_MOR", nullable = true)
    String cognomeMorto

    @Column(name = "NOME_MOR", nullable = true)
    String nomeMorto

    @Column(name = "COGNOME_NOME_MOR", nullable = true)
    String cognomeNomeMorto

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAS_MOR", nullable = true)
    Date dataNascitaMorto

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_MOR", nullable = true)
    Date dataMorte

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_CREMAZIONE", nullable = true)
    Date dataCremazione

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_AFFIDAMENTO", nullable = true)
    Date dataAffidamento

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_REG", nullable = true)
    Date dataRegistrazione

    static final List<Map> etichetteDomain = [
            Etichette.getEtichetta("Sesso_Defunto"),
            Etichette.getEtichetta("Estremi_Atto_Morte"),
            Etichette.getEtichetta("Comune_Nascita_Defunto"),
            Etichette.getEtichetta("Note"),
            Etichette.getEtichetta("Terminalista"),
            Etichette.getEtichetta("Numero_Registro"),
            Etichette.getEtichetta("Verbale_Affidamento"),
            Etichette.getEtichetta("Rapporto_Parentela_Affidatario"),
            Etichette.getEtichetta("Numero_Atto"),
            Etichette.getEtichetta("Parte"),
            Etichette.getEtichetta("Serie"),
            Etichette.getEtichetta("Ufficio"),
            Etichette.getEtichetta("Anno"),
            Etichette.getEtichetta("Id_Atto_Ansc"),
            Etichette.getEtichetta("Comune_Atto"),
            Etichette.getEtichetta("Comune_Morte"),
            Etichette.getEtichetta("Cognome_Defunto"),
            Etichette.getEtichetta("Nome_Defunto"),
            Etichette.getEtichetta("Data_Nascita_Defunto"),
            Etichette.getEtichetta("Data_Morte"),
            Etichette.getEtichetta("Data_Cremazione"),
            Etichette.getEtichetta("Data_Affidamento"),
            Etichette.getEtichetta("Data_Registrazione")
    ]

    @Override
    boolean equals(Object obj) {
        if (this.is(obj)) return true
        if (obj == null || getClass() != obj.getClass()) return false
        AnaUrnaCineraria that = (AnaUrnaCineraria) obj
        return Objects.equals(id, that.id)
    }

    @Override
    int hashCode() {
        return Objects.hash(id)
    }

    @Override
    String toString() {
        return "AnaUrnaCineraria{" +
                "id=" + id +
                ", cognomeMorto='" + cognomeMorto + '\'' +
                ", nomeMorto='" + nomeMorto + '\'' +
                ", dataMorte=" + dataMorte +
                '}'
    }

    @PrePersist
    void beforeInsert() {
        this.cognomeNomeMorto = (cognomeMorto ?: "") + ((cognomeMorto || nomeMorto) ? "/" : "") + (nomeMorto ?: "")
    }

    @PreUpdate
    void beforeUpdate() {
        this.cognomeNomeMorto = (cognomeMorto ?: "") + ((cognomeMorto || nomeMorto) ? "/" : "") + (nomeMorto ?: "")
    }
}
