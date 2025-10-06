package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.ad4.autenticazione.Ad4Utente
import it.finmatica.ad4.hibernate.UtenteUpd
import it.finmatica.de4gsdzk.GsdFileDocumentoEsternoBaseDomain
import it.finmatica.de4gsdzk.integrazioni.documentale.IDocumentoEsterno
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.IDownloadable

import javax.persistence.*

@Entity
@Table(name = "ANADOC_ALLE")
class AnaDocumentoAllegato extends GsdFileDocumentoEsternoBaseDomain implements IDownloadable {

    @Id
    @Column(name = "ID")
    Long id

    @Column(name = "NOME_ALLEGATO")
    String nome

    @Column(name = "ALLEGATO_BLOB", nullable = false)
    @Lob
    byte[] blobAllegato


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_ANADOC", nullable = false)
    AnaDocumento documento

    @Override
    void setDocumento(IDocumentoEsterno de) {
        documento = de as AnaDocumento
    }

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TERMINALISTA", nullable = false)
    @UtenteUpd
    Ad4Utente utenteUpd

    @Override
    boolean canDownload() {
        return idFileEsterno != null || blobAllegato != null
    }

    static final List<Map> etichetteDomain = [Etichette.Nome]

}
