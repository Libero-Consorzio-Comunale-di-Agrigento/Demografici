package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.ad4.autenticazione.Ad4Utente
import it.finmatica.ad4.hibernate.UtenteUpd
import it.finmatica.de4gsdzk.GsdFileDocumentoEsternoBaseDomain
import it.finmatica.de4gsdzk.integrazioni.documentale.IDocumentoEsterno
import it.finmatica.de4gsdzk.utils.ETipoSN
import it.finmatica.de4gsdzk.utils.Etichette
import org.hibernate.annotations.Formula
import org.hibernate.annotations.Type

import javax.persistence.*

@Slf4j
@Entity
@Table(name = "CIVCOM_ALLE")
class CivComunicazioneAllegato extends GsdFileDocumentoEsternoBaseDomain{

    @Id
    @Column(name = "ID")
    Long id

    // Nel versione fors11 la fk era verso CIVCOM_PROT, ma poiché la PK di CIVCOM e quella di CIVCOM_PROT
    // COINCIDONO (e sono alimentate dalla stessa SEQUENCE), alla luce della nuova modalità di gestione
    // delle comunicazioni introdotta dall'analisi per la versione zk software, abbiamo convenuto di girare la
    // FK verso CIVCOM e parcheggiare in questa tabella i testi di tutte le comunicazioni (sia quelle
    // protocollare che quelle non inviate al protocollo)
    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="ID_COM", nullable = false)
    CivArchivioComunicazione archivioComunicazione

    void setDocumento(IDocumentoEsterno de){
        archivioComunicazione = de
    }

    @Column(name = "NOME_ALLEGATO")
    String nomeAllegato

    @Column(name = "ALLEGATO_BLOB", nullable = false)
    @Lob
    byte[] blobAllegato

    @Column(name = "NOTE_WS_FIRMA")
    String noteWSFirma

    @Enumerated(EnumType.STRING)
    @Column(name = "FLAG_DA_FIRMARE", nullable = false, length = 1)
    ETipoSN daFirmareDb

    void setDaFirmare(Boolean val) {
        this.daFirmareDb = (val? ETipoSN.S: null)
    }

    Boolean getDaFirmare() {
        return (daFirmareDb == ETipoSN.S)
    }

    @Enumerated(EnumType.STRING)
    @Column(name = "FLAG_WS_FIRMA", nullable = false, length = 1)
    ETipoSN firmatoDb

    void setFirmato(Boolean val) {
        this.firmatoDb = (val? ETipoSN.S: null)
    }

    Boolean getFirmato() {
        return (firmatoDb == ETipoSN.S)
    }

    @Enumerated(EnumType.STRING)
    @Column(name = "FLAG_PRINCIPALE", nullable = false, length = 1)
    ETipoSN principaleDb

    @Formula("CASE WHEN COALESCE(FLAG_PRINCIPALE, 'N') = 'N' THEN 0 ELSE 1 END")
    @Type(type="numeric_boolean")
    private Boolean principale

    Boolean getPrincipale() {
        return this.principale
    }

    void setPrincipale(Boolean val) {
        this.principale = val
        this.principaleDb = (val? ETipoSN.S: null)
    }

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TERMINALISTA", nullable = false)
    @UtenteUpd
    Ad4Utente utenteUpd

    String getNome(){
        return nomeAllegato
    }

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Allegato, Etichette.Principale, Etichette.Da_Firmare, Etichette.Firmato]

}
