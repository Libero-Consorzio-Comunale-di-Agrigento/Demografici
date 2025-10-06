package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.CivRegistroDocumentiBaseDomain
import it.finmatica.de4gsdzk.utils.ETipoArchivioDocumento
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "CIVRDE")
class CivRegistroDocumentiEntrata extends CivRegistroDocumentiBaseDomain{

    @Enumerated(EnumType.STRING)
    @Column(name = "ARCHIVIO_RIF", nullable = false)
    ETipoArchivioDocumento archivio

    ETipoArchivioDocumento getTipoRegistro() {
        return archivio
    }

    void setTipoRegistro(ETipoArchivioDocumento t) {
        this.archivio = t
    }

    /////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI /////////////////////////////
    /////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Archivio]

}
