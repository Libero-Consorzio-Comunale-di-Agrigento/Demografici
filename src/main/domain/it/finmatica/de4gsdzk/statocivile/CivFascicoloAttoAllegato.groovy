package it.finmatica.de4gsdzk.statocivile

import it.finmatica.ad4.autenticazione.Ad4Utente
import it.finmatica.ad4.hibernate.UtenteIns
import it.finmatica.ad4.hibernate.UtenteUpd
import it.finmatica.de4gsdzk.GsdFileDocumentoEsternoBaseDomain
import it.finmatica.de4gsdzk.allegati.IAllegato
import it.finmatica.de4gsdzk.integrazioni.documentale.IDocumentoEsterno
import it.finmatica.de4gsdzk.utils.Etichette
import org.hibernate.annotations.CreationTimestamp
import org.hibernate.annotations.UpdateTimestamp

import javax.persistence.*

@Entity
@Table(name = "CIVFAS_ALLE_V")
class CivFascicoloAttoAllegato extends GsdFileDocumentoEsternoBaseDomain implements IAllegato{

    @GeneratedValue
    @Id
    @Column(name = "ID")
    Long id

    @Column(name = "NOME")
    String nome

    @Column(name = "NOTE")
    String note

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_CIVFAS", nullable = false)
    CivFascicoloAtto fascicoloAtto

    void setDocumento(IDocumentoEsterno de){
        fascicoloAtto = de
    }

    /*
    @Column(name = "NUMERO_COPIE", nullable = true)
    Integer numeroCopie
    */

    @Column(name = "HASH_ALLEGATO_ANSC", nullable = true)
    String hashAllegatoAnsc

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_CIVCOM_ALLE", nullable = false)
    CivComunicazioneAllegato allegatoComunicazione

    @CreationTimestamp
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "DATA_INS", nullable = false)
    Date dateCreated

    @UpdateTimestamp
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "DATA_UPD", nullable = false)
    Date lastUpdated

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "UTENTE_INS", nullable = false)
    @UtenteIns
    Ad4Utente utenteIns

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "UTENTE_UPD", nullable = false)
    @UtenteUpd
    Ad4Utente utenteUpd

    @Version
    @Column(nullable = false)
    Long version

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_DA_ATTESTARE_ANSC", nullable = true)
    Boolean flagDaAttestareAnsc

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_FIRMATO_ATT_ANSC", nullable = true, updatable = false, insertable = false)
    Boolean flagFirmatoAttestazioneAnsc

    /////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI /////////////////////////////
    /////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Data_Registrazione"), Etichette.getEtichetta("Data_Modifica"), Etichette.getEtichetta("Note"), Etichette.getEtichetta("Da_Attestare"), Etichette.getEtichetta("Terminalista")]

}
