package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.ENaturaAtto
import it.finmatica.de4gsdzk.utils.ETipoDivorzio
import it.finmatica.de4gsdzk.utils.ETipoDivorzioAltro
import it.finmatica.de4gsdzk.utils.Etichette
import org.hibernate.annotations.Formula

import javax.persistence.*

@Entity
@Table(name = "CIVDTA_V", uniqueConstraints = @UniqueConstraint(columnNames=["TIPO_ATTO", "SEQUENZA"]))
class CivTipoAtto extends GsdBaseDomain{

    public static final String SERIE_A = "A"
    public static final String SERIE_B = "B"
    public static final String SERIE_BIS = "BIS"
    public static final String SERIE_C = "C"

    public static final String TIPO_BASE = "T"
    public static final String TIPO_CATEGORIA = "C"
    public static final String TIPO_PREGRESSO = "P"

    @Id
    @Column(name = "ID")
    Long id

    @Column(name = "TIPO_ATTO", nullable = false)
    Integer tipoAtto

    @Column(name = "PARTE", nullable = true)
    Integer parte

    @Column(name = "SERIE", nullable = true)
    private String serie

    String getSerie() {
        return serie
    }

    void setSerie(String serie) {
        this.serie = serie?.toUpperCase()
    }

    @Column(name = "DESCRIZIONE")
    String descrizione

    @Enumerated(EnumType.STRING)
    @Column(name = "NATURA_DECODE", nullable = false, updatable = false, insertable = false)
    private ENaturaAtto natura

    ENaturaAtto getNatura(){
        return natura
    }

    void setNatura(ENaturaAtto n){
        natura = n
        naturaOriginale = n?.name()
    }

    @Column(name = "NATURA", nullable = false)
    String naturaOriginale

    @Column(name = "SEQUENZA")
    Integer sequenza

    @Column(name = "COD_MI")
    Integer codiceMinuta

    @Column(name = "NOTE")
    String note

    @Column(name = "NUM_RIGHE", nullable = true)
    Integer numeroRighe

    @Column(name = "NUM_COLONNE", nullable = true)
    Integer numeroColonne

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_DIMENSIONI_FISSE", nullable = true)
    Boolean dimensioniFisse

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_DIVORZIO", nullable = true)
    Boolean divorzio

    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_DIVORZIO", nullable = true)
    ETipoDivorzio tipoDivorzio

    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_DIVORZIO_ALTRO", nullable = true)
    ETipoDivorzioAltro tipoDivorzioAltro

    // introdotta nella nuova versione del prodotto
    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="ID_CIVCTA", nullable = false)
    CivCategoriaTipoAtto categoriaDomain

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="ID_CIVDDO_CIA", nullable = true)
    CivTipoDocumentoFascicolo tipoDocumentoFascicoloCia

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_PREGRESSO", nullable = true)
    Boolean flagPregresso

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_DISMESSO", nullable = true)
    Boolean flagDismesso

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_ANSC", nullable = true)
    Boolean flagAnsc

    @Formula("CONCAT(COALESCE(PARTE, NULL), CONCAT((CASE WHEN PARTE IS NULL THEN '' ELSE ' - ' END), CONCAT((CASE WHEN SERIE IS NULL THEN '' ELSE UPPER(SERIE) END), CONCAT((CASE WHEN SERIE IS NULL THEN '' ELSE ' - ' END), COALESCE(DESCRIZIONE, '') ) ) ) )")
    String descrizioneEstesa

    Boolean isParteSeconda(){
        Boolean val = ( (this.parte?.intValue()?:1) == 2 )
        return val
    }

    Boolean isSecondaB(){
        Boolean val = ( isParteSeconda() && ((this.serie?:"") == SERIE_B) )
        return val
    }

    Boolean isSecondaC(){
        Boolean val = ( isParteSeconda() && ((this.serie?:"") == SERIE_C) )
        return val
    }

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Parte"), Etichette.getEtichetta("Serie"), Etichette.getEtichetta("Descrizione"), Etichette.getEtichetta("Natura_Atto"),
                                              Etichette.getEtichetta("Categoria"), Etichette.getEtichetta("Sequenza"), Etichette.getEtichetta("Note"), Etichette.getEtichetta("Minuta"), Etichette.getEtichetta("Caso_specifico"),
                                              Etichette.getEtichetta("Tipo_Atto"), Etichette.getEtichetta("Tipo_Documento_CIA_Fascicolo"), Etichette.getEtichetta("Dismesso")]

}
