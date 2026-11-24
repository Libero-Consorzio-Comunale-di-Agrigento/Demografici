package it.finmatica.de4gsdzk.ansc

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.utils.ETipoFile
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Slf4j
@Entity
@Table(name = "ANSC_ALLEGATI")
class AnscAllegato {

    @Id
    @Column(name = "ID_OPERAZIONE")
    Long id

    @Column(name = "ALLEGATO_BLOB", nullable = false)
    @Lob
    byte[] blobAllegato

    /*
    potrebbero gestire anche file tif
    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_FILE", nullable = false)
    ETipoFile tipoFile
    */

    @Column(name = "NOME_FILE", nullable = false)
    String nomeFile

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Allegato")]

}
