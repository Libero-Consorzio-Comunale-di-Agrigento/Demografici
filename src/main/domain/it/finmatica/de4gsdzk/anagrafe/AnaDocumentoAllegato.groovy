package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.ad4.autenticazione.Ad4Utente
import it.finmatica.ad4.hibernate.UtenteUpd
import it.finmatica.de4gsdzk.GsdFileDocumentoEsternoBaseDomain
import it.finmatica.de4gsdzk.allegati.IAllegato
import it.finmatica.de4gsdzk.integrazioni.documentale.IDocumentoEsterno
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.IDownloadable

import javax.persistence.*

@Entity
@Table(name = "ANADOC_ALLE")
class AnaDocumentoAllegato extends GsdFileDocumentoEsternoBaseDomain implements IDownloadable, IAllegato {

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

    @Override
    boolean canDownload() {
        return idFileEsterno != null || blobAllegato != null
    }

    @Column(name = "NOTE")
    String note

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TERMINALISTA", nullable = false)
    @UtenteUpd
    Ad4Utente terminalista

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_REG")
    Date dataRegistrazione

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Nome"), Etichette.getEtichetta("Allegato"), Etichette.getEtichetta("Data_Registrazione"), Etichette.getEtichetta("Terminalista"), Etichette.getEtichetta("Note")]

}
