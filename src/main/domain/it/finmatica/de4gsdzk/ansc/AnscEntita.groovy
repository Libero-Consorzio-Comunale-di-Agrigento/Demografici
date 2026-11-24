package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.ETipoArchivioAnsc
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "ANSALL_V")
class AnscEntita extends GsdBaseDomain{

    @Id
    @Column(name = "ID")
    String id

    @Column(name = "ID_RIF")
    Long idRif

    @Enumerated(EnumType.STRING)
    @Column(name = "ARCHIVIO_RIF")
    ETipoArchivioAnsc archivioRif

    @Column(name = "ANNO", nullable = true)
    Integer anno

    @Column(name = "COGNOME_1", nullable = true)
    String cognome1

    @Column(name = "NOME_1", nullable = true)
    String nome1

    @Column(name = "COGNOME_2", nullable = true)
    String cognome2

    @Column(name = "NOME_2", nullable = true)
    String nome2

    @Column(name = "NUMERO_UNICO", nullable = true)
    Long numeroUnico

    @Column(name = "ID_ATTO_ANSC", nullable = true)
    String idAttoAnsc

    @Column(name = "TIPO_ATTO_ADS", nullable = false)
    Integer tipoAttoAds

    @Column(name = "COD_REC", nullable = false)
    Integer codiceRecord

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_DIVORZIO", nullable = true, updatable = false, insertable = false)
    Boolean flagDivorzio

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_PREN_PARTO_PLURIMO", nullable = true, updatable = false, insertable = false)
    Boolean flagPrenotazionePartoPlurimo

    Boolean isCodRec0(){
        return  ( (this.codiceRecord != null) && this.codiceRecord?.compareTo(new Integer(0)) == 0 )
    }

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Anno"), Etichette.getEtichetta("Cognome"), Etichette.getEtichetta("Nome"),
                                              Etichette.getEtichetta("Archivio"), Etichette.getEtichetta("Numero_comunale"),]

}
