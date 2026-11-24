package it.finmatica.de4gsdzk.statocivile

import it.finmatica.ad4.autenticazione.Ad4Utente
import it.finmatica.ad4.hibernate.UtenteUpd
import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.statocivile.embed.Protocollo
import it.finmatica.de4gsdzk.statocivile.embed.SoggettoDAT
import it.finmatica.de4gsdzk.utils.ETipoSN
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "CIVDAT_V")
class CivDisposizioniAnticipateTrattamento  {

    @Id
    @Column(name = "ID")
    Integer id

    @Embedded
    @AttributeOverride(name = "anno", column = @Column(name="ANNO_PROTOCOLLO"))
    private Protocollo protocollo
    Protocollo getProtocollo() {
        if (protocollo == null){
            protocollo = new Protocollo()
        }
        return protocollo
    }
    void setProtocollo(Protocollo protocollo) {
        this.protocollo = protocollo
    }

    @ManyToOne(fetch=FetchType.EAGER)
    @JoinColumn(name="TIPO_ATTO", nullable = true)
    CivDisposizioniAnticipateTrattamentoTipoAtto tipoAttoDAT

    @Column(name = "NOTE_TIPO_ATTO", nullable = true)
    String noteTipoAtto

    @Enumerated(EnumType.STRING)
    @Column(name = "CONSENSO_INVIO_DAT", nullable = true)
    ETipoSN consensoInvioDAT

    @Column(name = "REPERIBILITA_DAT", nullable = true)
    String reperibilitaDAT

    @Enumerated(EnumType.STRING)
    @Column(name = "CONSENSO_RICEZIONE_MAIL", nullable = true)
    ETipoSN consensoNotificaMail

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_PRESENTAZIONE")
    Date dataPresentazione

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_MODIFICA", nullable = true)
    Date dataModifica

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_REVOCA", nullable = true)
    Date dataRevoca

    @Column(name = "NOTAIO", nullable = true)
    String notaio

    @Column(name = "INDIRIZZO_NOTAIO", nullable = true)
    String indirizzoNotaio

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "COD_COM_NOTAIO")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_NOTAIO", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "COD_PRO_NOTAIO")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_NOTAIO", updatable = false, insertable = false))
    ])
    private Comune comuneNotaio

    Comune getComuneNotaio() {
        if (comuneNotaio == null){
            comuneNotaio = new Comune()
        }
        return comuneNotaio
    }

    void setComuneNotaio(Comune comuneNotaio) {
        this.comuneNotaio = comuneNotaio
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "COD_COM_COLLEGIO")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_COLLEGIO", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "COD_PRO_COLLEGIO")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_COLLEGIO", updatable = false, insertable = false))
    ])
    private Comune comuneCollegioNotarile

    Comune getComuneCollegioNotarile() {
        if (comuneCollegioNotarile == null){
            comuneCollegioNotarile = new Comune()
        }
        return comuneCollegioNotarile
    }

    void setComuneCollegioNotarile(Comune comuneCollegioNotarile) {
        this.comuneCollegioNotarile = comuneCollegioNotarile
    }

    @Column(name = "NOTE", nullable = true)
    String note

    @Embedded
    private SoggettoDAT disponente
    SoggettoDAT getDisponente() {
        if (disponente == null){
            disponente = new SoggettoDAT()
        }
        return disponente
    }
    void setDisponente(SoggettoDAT disponente) {
        this.disponente = disponente
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "nome", column = @Column(name="NOME_FID_1")),
            @AttributeOverride(name = "cognome", column = @Column(name="COGNOME_FID_1")),
            @AttributeOverride(name = "cognomeNome", column = @Column(name="COGNOME_NOME_FID_1")),
            @AttributeOverride(name = "sesso", column = @Column(name="SESSO_FID_1")),
            @AttributeOverride(name = "matricola", column = @Column(name="MATRICOLA_FID_1")),
            @AttributeOverride(name = "dataNascita", column = @Column(name="D_DATA_NAS_FID_1")),
            @AttributeOverride(name = "comuneNascita.codice", column = @Column(name="COD_COM_NAS_FID_1")),
            @AttributeOverride(name = "comuneNascita.descrizione", column = @Column(name="DES_COM_NAS_FID_1", updatable = false, insertable = false)),
            @AttributeOverride(name = "comuneNascita.codiceProvincia", column = @Column(name="COD_PRO_NAS_FID_1")),
            @AttributeOverride(name = "comuneNascita.siglaProvincia", column = @Column(name="SIGLA_PRO_NAS_FID_1", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceFiscale", column = @Column(name="COD_FISCALE_FID_1")),
            @AttributeOverride(name = "indirizzo", column = @Column(name="INDIRIZZO_RES_FID_1")),
            @AttributeOverride(name = "comuneResidenza.codice", column = @Column(name="COD_COM_RES_FID_1")),
            @AttributeOverride(name = "comuneResidenza.descrizione", column = @Column(name="DES_COM_RES_FID_1", updatable = false, insertable = false)),
            @AttributeOverride(name = "comuneResidenza.codiceProvincia", column = @Column(name="COD_PRO_RES_FID_1")),
            @AttributeOverride(name = "comuneResidenza.siglaProvincia", column = @Column(name="SIGLA_PRO_RES_FID_1", updatable = false, insertable = false)),
            @AttributeOverride(name = "cap", column = @Column(name="CAP_RES_FID_1")),
            @AttributeOverride(name = "telefono", column = @Column(name="NUMERO_TEL_FID_1")),
            @AttributeOverride(name = "indirizzoMail", column = @Column(name="INDIRIZZO_MAIL_FID_1")),
            @AttributeOverride(name = "numeroDocumento", column = @Column(name="NUMERO_DOC_FID_1")),
            @AttributeOverride(name = "dataRilascioDocumento", column = @Column(name="D_DATA_RILASCIO_DOC_FID_1")),
            @AttributeOverride(name = "dataScadenzaDocumento", column = @Column(name="D_DATA_SCADENZA_DOC_FID_1")),
            @AttributeOverride(name = "comuneDocumento.codice", column = @Column(name="COD_COM_DOC_FID_1")),
            @AttributeOverride(name = "comuneDocumento.descrizione", column = @Column(name="DES_COM_DOC_FID_1", updatable = false, insertable = false)),
            @AttributeOverride(name = "comuneDocumento.codiceProvincia", column = @Column(name="COD_PRO_DOC_FID_1")),
            @AttributeOverride(name = "comuneDocumento.siglaProvincia", column = @Column(name="SIGLA_PRO_DOC_FID_1", updatable = false, insertable = false)),
            @AttributeOverride(name = "consensoTrattamento", column = @Column(name="CONSENSO_TRATTAMENTO_FID_1")),
            @AttributeOverride(name = "sottoscrittoDAT", column = @Column(name="SOTTOSCRITTO_FID_1")),
    ])
    @AssociationOverrides([
            @AssociationOverride(name = "tipoDocumento", joinColumns = @JoinColumn(name = "TIPO_DOC_FID_1")),
            @AssociationOverride(name = "ente", joinColumns = @JoinColumn(name = "ENTE_DOC_FID_1"))
    ])
    private SoggettoDAT fiduciario1

    SoggettoDAT getFiduciario1() {
        if (fiduciario1 == null){
            fiduciario1 = new SoggettoDAT()
        }
        return fiduciario1
    }

    void setFiduciario1(SoggettoDAT fiduciario1) {
        this.fiduciario1 = fiduciario1
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "nome", column = @Column(name="NOME_FID_2")),
            @AttributeOverride(name = "cognome", column = @Column(name="COGNOME_FID_2")),
            @AttributeOverride(name = "cognomeNome", column = @Column(name="COGNOME_NOME_FID_2")),
            @AttributeOverride(name = "sesso", column = @Column(name="SESSO_FID_2")),
            @AttributeOverride(name = "matricola", column = @Column(name="MATRICOLA_FID_2")),
            @AttributeOverride(name = "dataNascita", column = @Column(name="D_DATA_NAS_FID_2")),
            @AttributeOverride(name = "comuneNascita.codice", column = @Column(name="COD_COM_NAS_FID_2")),
            @AttributeOverride(name = "comuneNascita.descrizione", column = @Column(name="DES_COM_NAS_FID_2", updatable = false, insertable = false)),
            @AttributeOverride(name = "comuneNascita.codiceProvincia", column = @Column(name="COD_PRO_NAS_FID_2")),
            @AttributeOverride(name = "comuneNascita.siglaProvincia", column = @Column(name="SIGLA_PRO_NAS_FID_2", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceFiscale", column = @Column(name="COD_FISCALE_FID_2")),
            @AttributeOverride(name = "indirizzo", column = @Column(name="INDIRIZZO_RES_FID_2")),
            @AttributeOverride(name = "comuneResidenza.codice", column = @Column(name="COD_COM_RES_FID_2")),
            @AttributeOverride(name = "comuneResidenza.descrizione", column = @Column(name="DES_COM_RES_FID_2", updatable = false, insertable = false)),
            @AttributeOverride(name = "comuneResidenza.codiceProvincia", column = @Column(name="COD_PRO_RES_FID_2")),
            @AttributeOverride(name = "comuneResidenza.siglaProvincia", column = @Column(name="SIGLA_PRO_RES_FID_2", updatable = false, insertable = false)),
            @AttributeOverride(name = "cap", column = @Column(name="CAP_RES_FID_2")),
            @AttributeOverride(name = "telefono", column = @Column(name="NUMERO_TEL_FID_2")),
            @AttributeOverride(name = "indirizzoMail", column = @Column(name="INDIRIZZO_MAIL_FID_2")),
            @AttributeOverride(name = "numeroDocumento", column = @Column(name="NUMERO_DOC_FID_2")),
            @AttributeOverride(name = "dataRilascioDocumento", column = @Column(name="D_DATA_RILASCIO_DOC_FID_2")),
            @AttributeOverride(name = "dataScadenzaDocumento", column = @Column(name="D_DATA_SCADENZA_DOC_FID_2")),
            @AttributeOverride(name = "comuneDocumento.codice", column = @Column(name="COD_COM_DOC_FID_2")),
            @AttributeOverride(name = "comuneDocumento.descrizione", column = @Column(name="DES_COM_DOC_FID_2", updatable = false, insertable = false)),
            @AttributeOverride(name = "comuneDocumento.codiceProvincia", column = @Column(name="COD_PRO_DOC_FID_2")),
            @AttributeOverride(name = "comuneDocumento.siglaProvincia", column = @Column(name="SIGLA_PRO_DOC_FID_2", updatable = false, insertable = false)),
            @AttributeOverride(name = "consensoTrattamento", column = @Column(name="CONSENSO_TRATTAMENTO_FID_2")),
            @AttributeOverride(name = "sottoscrittoDAT", column = @Column(name="SOTTOSCRITTO_FID_2")),
    ])
    @AssociationOverrides([
            @AssociationOverride(name = "tipoDocumento", joinColumns = @JoinColumn(name = "TIPO_DOC_FID_2")),
            @AssociationOverride(name = "ente", joinColumns = @JoinColumn(name = "ENTE_DOC_FID_2"))
    ])
    private SoggettoDAT fiduciario2

    SoggettoDAT getFiduciario2() {
        if (fiduciario2 == null){
            fiduciario2 = new SoggettoDAT()
        }
        return fiduciario2
    }

    void setFiduciario2(SoggettoDAT fiduciario2) {
        this.fiduciario2 = fiduciario2
    }

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TERMINALISTA", nullable = false)
    @UtenteUpd
    Ad4Utente utenteUpd

    @Version
    @Column(nullable = false)
    Long version

    @PrePersist @PreUpdate
    void prePersist() {
        disponente.prePersist()
        fiduciario1.prePersist()
        fiduciario2.prePersist()
    }

    /////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI /////////////////////////////
    /////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Tipo_Atto"), Etichette.getEtichetta("Data_Consegna"), Etichette.getEtichetta("Data_Modifica"), Etichette.getEtichetta("Data_Revoca"), Etichette.getEtichetta("Notaio"),
                                              Etichette.getEtichetta("Indirizzo"), Etichette.getEtichetta("Consenso_Invio_DAT"), Etichette.getEtichetta("Comune"), Etichette.getEtichetta("Collegio_Notarile"), Etichette.getEtichetta("Reperibilta_DAT"),
                                              Etichette.getEtichetta("Consenso_Notifica_Mail"), Etichette.getEtichetta("Reperibilita_DAT"), Etichette.getEtichetta("Note"), Etichette.getEtichetta("Numero_Protocollo_Anno"), Etichette.getEtichetta("Data")]
}

