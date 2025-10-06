package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.ETipoAttoAnsc
import it.finmatica.de4gsdzk.utils.Etichette
import org.hibernate.annotations.Formula

import javax.persistence.*

@MappedSuperclass
abstract class AnscCasoUsoBaseDomain extends GsdBaseDomain{

    @Id
    @Column(name = "ID")
    Long id

    @Column(name = "DESCRIZIONE", nullable = false)
    String descrizione

    @Formula("CONCAT(ID, CONCAT(CASE WHEN ID IS NULL THEN '' ELSE ' - ' END, COALESCE(DESCRIZIONE, '')))")
    String descrizioneEstesa

    @Column(name = "SIGLA_CATEGORIA", nullable = false)
    String codiceCategoria

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_SERVIZIO", nullable = true)
    Boolean flagServizio

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_VISIBILE", nullable = true)
    Boolean flagVisibile

    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_ATTO_ANSC", nullable = true)
    ETipoAttoAnsc tipoAttoAnsc

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Descrizione]
}
