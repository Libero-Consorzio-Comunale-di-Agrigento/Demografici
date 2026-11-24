package it.finmatica.de4gsdzk.anagrafe.pratiche

import it.finmatica.ad4.autenticazione.Ad4Utente
import it.finmatica.ad4.hibernate.UtenteUpd
import it.finmatica.de4gsdzk.GsdFileDocumentoEsternoBaseDomain
import it.finmatica.de4gsdzk.allegati.IAllegato
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaComunicazioneAllegato
import it.finmatica.de4gsdzk.integrazioni.documentale.IDocumentoEsterno
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.IDownloadable

import javax.persistence.*

@Entity
@Table(name = "ANATPR_ALLE")
class AnaPraticaAllegato extends GsdFileDocumentoEsternoBaseDomain implements IDownloadable, IAllegato {

    @Id
    @Column(name = "ID")
    Long id

    @Column(name = "NOME_ALLEGATO")
    String nome

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_REG")
    Date dataRegistrazione

    @Column(name = "ALLEGATO_BLOB", nullable = false)
    @Lob
    byte[] blobAllegato

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_ANATPR", nullable = false)
    AnaPratica pratica

    void setDocumento(IDocumentoEsterno de) {
        pratica = de as AnaPratica
    }

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_ANACOM_ALLE", nullable = false)
    AnaComunicazioneAllegato allegatoComunicazione

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

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Nome"), Etichette.getEtichetta("Allegato"), Etichette.getEtichetta("Data_Registrazione"), Etichette.getEtichetta("Terminalista"), Etichette.getEtichetta("Note")]
}
