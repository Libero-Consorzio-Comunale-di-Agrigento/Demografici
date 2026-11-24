package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.TipoAttoUtils
import org.hibernate.annotations.Formula

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Table

@Entity
@Table(name = "ANST03")
class AnscCasoUso extends  GsdBaseDomain {

    @Id
    @Column(name = "ID")
    Long id

    @Column(name = "DESCRIZIONE", nullable = false)
    String descrizione

    @Column(name = "TIPO_ATTO_ADS", nullable = false)
    Integer tipoAtto

    @Formula("CONCAT(ID, CONCAT(CASE WHEN ID IS NULL THEN '' ELSE ' - ' END, COALESCE(DESCRIZIONE, '')))")
    String descrizioneEstesa

//    ETipoAtto getTipoAttoEnum() { TipoAttoUtils.fromValoreDefault(tipoAtto) }
}
