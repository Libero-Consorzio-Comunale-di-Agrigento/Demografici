package it.finmatica.de4gsdzk.anagrafe


import it.finmatica.de4gsdzk.GsdFileDocumentoEsternoBaseDomain
import it.finmatica.de4gsdzk.integrazioni.documentale.IDocumentoEsterno
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.IDownloadable

import javax.persistence.*

@Entity
@Table(name = "ANAFAM_ALLE")
class AnaFamigliaAllegato extends GsdFileDocumentoEsternoBaseDomain implements IDownloadable {

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
    @JoinColumn(name = "COD_FAM_UNIQUE", nullable = false)
    AnaFamiglia famiglia

    void setDocumento(IDocumentoEsterno de) {
        famiglia = de as AnaFamiglia
    }

    @Override
    boolean canDownload() {
        return idFileEsterno != null || blobAllegato != null
    }

    static final List<Map> etichetteDomain = [Etichette.Nome, Etichette.Allegato, Etichette.Data_Registrazione]
}
