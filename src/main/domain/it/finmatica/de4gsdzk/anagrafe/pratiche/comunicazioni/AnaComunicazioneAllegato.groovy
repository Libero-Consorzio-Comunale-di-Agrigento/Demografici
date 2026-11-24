package it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni

import groovy.util.logging.Slf4j
import it.finmatica.ad4.autenticazione.Ad4Utente
import it.finmatica.ad4.hibernate.UtenteUpd
import it.finmatica.de4gsdzk.GsdFileDocumentoEsternoBaseDomain
import it.finmatica.de4gsdzk.IComunicazioneAllegato
import it.finmatica.de4gsdzk.integrazioni.documentale.IDocumentoEsterno
import it.finmatica.de4gsdzk.utils.ETipoSN
import it.finmatica.de4gsdzk.utils.Etichette
import org.hibernate.annotations.Formula
import org.hibernate.annotations.Type

import javax.persistence.*

@Slf4j
@Entity
@Table(name = "ANACOM_ALLE")
class AnaComunicazioneAllegato extends GsdFileDocumentoEsternoBaseDomain implements  IComunicazioneAllegato {

    @Id
    @Column(name = "ID")
    Long id

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="ID_COM", nullable = false)
    AnaArchivioComunicazione archivioComunicazione

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

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_DA_FIRMARE", nullable = true)
    Boolean daFirmare

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_WS_FIRMA", nullable = true)
    Boolean firmato

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_PRINCIPALE", nullable = true)
    Boolean principale

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

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Allegati"), Etichette.getEtichetta("Allegato"), Etichette.getEtichetta("Principale"), Etichette.getEtichetta("Da_Firmare"), Etichette.getEtichetta("Firmato")]

}
