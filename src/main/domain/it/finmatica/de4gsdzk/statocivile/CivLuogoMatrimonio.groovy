package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.ILuogoEvento
import it.finmatica.de4gsdzk.utils.Etichette
import org.hibernate.annotations.Formula

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Table

@Entity
@Table(name = "CIVDG4")
class CivLuogoMatrimonio implements ILuogoEvento{

    @Id
    @Column(name = "COD_MAT")
    Integer id

    @Column(name = "NEL_MAT", nullable = true)
    String nel

    @Column(name = "LUOGO_MAT")
    String descrizione

    @Column(name = "MINISTRO", nullable = true)
    String ministro

    @Column(name = "QUALITA", nullable = true)
    String qualita

    @Formula("CONCAT(COALESCE(NEL_MAT,''), CONCAT((CASE WHEN NEL_MAT IS NULL THEN '' ELSE ' ' END), COALESCE(LUOGO_MAT, '')))")
    String descrizioneEstesa

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map<String, String>> etichetteDomain = [Etichette.getEtichetta("Codice"), Etichette.getEtichetta("Nel"), Etichette.getEtichetta("Descrizione"),
                                                              Etichette.getEtichetta("Celebrante"), Etichette.getEtichetta("Qualifica"), Etichette.getEtichetta("Ministro")]

}
