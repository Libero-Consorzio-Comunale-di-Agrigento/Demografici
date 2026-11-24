package it.finmatica.de4gsdzk.statocivile

import it.finmatica.ad4.autenticazione.Ad4Utente
import it.finmatica.ad4.hibernate.UtenteUpd
import it.finmatica.de4gsdzk.ISoggettoAtto1Base
import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.statocivile.embed.EstremiAtto
import it.finmatica.de4gsdzk.utils.ESesso
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "CIVRNA_V")
class CivRubricaNascite implements ISoggettoAtto1Base {

    @Id @Column Long id

    @Column(name = "ANNO", nullable = false) Integer annoRegistrazione

    @Column(nullable = false) String cognome

    @Column(nullable = false) String nome

    @Enumerated(EnumType.STRING)
    @Column ESesso sesso

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAS", nullable = false)
    Date dataNascita

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_REG", updatable = false, insertable = false)
    Date dataRegistrazione

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

    void setComuneNascita(Comune c) {
        this.comuneNascita = c
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "ufficio", column = @Column(name = "UFFICIO_NAS")),
            @AttributeOverride(name = "anno", column = @Column(name = "ANNO_ATTO_NAS")),
            @AttributeOverride(name = "atto", column = @Column(name = "ATTO_NAS")),
            @AttributeOverride(name = "parte", column = @Column(name = "PARTE_NAS")),
            @AttributeOverride(name = "serie", column = @Column(name = "SERIE_NAS")),
            @AttributeOverride(name = "idAttoAnsc", column = @Column(name = "ID_ATTO_ANSC_NAS")),
    ])
    EstremiAtto attoNascita

    @Column(name = "COD_COM_ATTO_NAS", nullable = false)
    Integer codiceComuneAttoNascita
    @Column(name = "DES_COM_ATTO_NAS", updatable = false, insertable = false)
    String descrizioneComuneAttoNascita
    @Column(name = "COD_PRO_ATTO_NAS", nullable = false)
    Integer codiceProvinciaAttoNascita
    @Column(name = "SIGLA_PRO_ATTO_NAS", updatable = false, insertable = false)
    String siglaProvinciaAttoNascita

    @Column(name = "COGNOME_PD") String cognomePadre
    @Column(name = "NOME_PD") String nomePadre
    @Column(name = "COGNOME_MD") String cognomeMadre
    @Column(name = "NOME_MD") String nomeMadre


    @Column(name = "COGNOME_NOME", nullable = true)
    private String cognomeNome

    @Column(name = "PATERNITA", nullable = true)
    private String cognomeNomePadre

    @Column(name = "MATERNITA", nullable = true)
    private String cognomeNomeMadre

    @PrePersist
    void beforeInsert() {
        this.cognomeNome = (cognome?:"") + ((cognome || nome)?"/":"") + (nome?:"")
        this.cognomeNomePadre = (cognomePadre?:"") + ((cognomePadre || nomePadre)?"/":"") + (nomePadre?:"")
        this.cognomeNomeMadre = (cognomeMadre?:"") + ((cognomeMadre || nomeMadre)?"/":"") + (nomeMadre?:"")
    }

    @PreUpdate
    void beforeUpdate() {
        this.cognomeNome = (cognome?:"") + ((cognome || nome)?"/":"") + (nome?:"")
        this.cognomeNomePadre = (cognomePadre?:"") + ((cognomePadre || nomePadre)?"/":"") + (nomePadre?:"")
        this.cognomeNomeMadre = (cognomeMadre?:"") + ((cognomeMadre || nomeMadre)?"/":"") + (nomeMadre?:"")
    }

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TERMINALISTA", nullable = false)
    @UtenteUpd
    Ad4Utente utenteUpd

    @Version
    @Column(nullable = false)
    Long version

    // Ai fini del report per la stampa
    String getCognome1Lista() {cognome}
    String getNome1Lista() {nome}
    String getCodiceSesso1Lista(){
        return (this.sesso?.name())
    }
    String getExtra1Lista(){
        return this.getMaternita()
    }
    Date getExtra2Lista(){
        return this.dataRegistrazione
    }
    String getExtra3Lista(){
        return (descrizioneComuneAttoNascita ? descrizioneComuneAttoNascita + (siglaProvinciaAttoNascita ? " (" + siglaProvinciaAttoNascita + ")" : "") : "")
    }
    String getComuneNascita1() {
        return (comuneNascita.descrizione ? comuneNascita.descrizione + (comuneNascita.siglaProvincia ? " (" + comuneNascita.siglaProvincia + ")" : "") : "")
    }
    Date getDataNascita1() {dataNascita}

    String getDescrizioneComuneNascita1() { comuneNascita.descrizione }

    String getSiglaProvinciaNascita1() { comuneNascita.siglaProvincia }
    String getPaternita() {cognomeNomePadre}
    String getMaternita() {cognomeNomeMadre}
    String getEstremiAttoListaPdf(){
        if (attoNascita.idAttoAnsc != null) {
            return attoNascita.idAttoAnsc
        }
        String parteSerie = attoNascita.parte ? "-" + String.valueOf(attoNascita.parte)+(attoNascita.serie?:"") : ""
        return (attoNascita.atto + parteSerie + (attoNascita.ufficio ? "-$attoNascita.ufficio" : "") + (attoNascita.anno?"/" + String.valueOf(attoNascita.anno):""))
    }

    ////////////////////////////////////////////////////////////////////////
    ///////////////////////////////// GENERALI /////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Anno_Registrazione"), Etichette.getEtichetta("Cognome"), Etichette.getEtichetta("Nome"),
                                              Etichette.getEtichetta("Sesso"), Etichette.getEtichetta("Data_Nascita"), Etichette.getEtichetta("Comune_Nascita"),
                                              Etichette.getEtichetta("Data_Registrazione"),
                                              Etichette.getEtichetta("Estremi_Atto_Nascita"),
                                              Etichette.getEtichetta("Comune_Atto_Nascita"),
                                              Etichette.getEtichetta("Comune_Atto"), Etichette.getEtichetta("Ufficio"), Etichette.getEtichetta("Anno"),
                                              Etichette.getEtichetta("Numero_Atto"), Etichette.getEtichetta("Atto"), Etichette.getEtichetta("Parte"), Etichette.getEtichetta("Serie"), Etichette.getEtichetta("Id_Atto_Ansc"),
                                              Etichette.getEtichetta("Cognome_Padre"), Etichette.getEtichetta("Nome_Padre"),
                                              Etichette.getEtichetta("Cognome_Madre"), Etichette.getEtichetta("Nome_Madre"),
                                              Etichette.getEtichetta("Paternita"), Etichette.getEtichetta("Maternita")]

}
