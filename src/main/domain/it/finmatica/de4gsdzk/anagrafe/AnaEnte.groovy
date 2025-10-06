package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.utils.Etichette
import org.hibernate.annotations.Formula

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Table

@Entity
@Table(name = "ANADEN")
class AnaEnte {

    @Id
    @Column(name = "COD_EN", nullable = false)
    Integer id

    @Column(name = "DESCRIZIONE", nullable = false)
    String descrizione

    @Formula("CONCAT(COD_EN, CONCAT(CASE WHEN DESCRIZIONE IS NULL THEN '' ELSE ' - ' END, COALESCE(DESCRIZIONE, '')))")
    String descrizioneEstesa

    /////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI /////////////////////////////
    /////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Codice, Etichette.Descrizione]

    static final Integer COMUNE = 1
}
