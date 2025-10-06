package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.ILuogoEvento
import it.finmatica.de4gsdzk.utils.Etichette
import org.hibernate.annotations.Formula

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Table

@Entity
@Table(name = "CIVDG2")
class CivLuogoNascita implements ILuogoEvento{

    @Id
    @Column(name = "COD_NAS")
    Integer id

    @Column(name = "NEL_NAS", nullable = true)
    String nel

    @Column(name = "LUOGO_NAS")
    String descrizione

    @Formula("CONCAT(COALESCE(NEL_NAS,''), CONCAT((CASE WHEN NEL_NAS IS NULL THEN '' ELSE ' ' END), COALESCE(LUOGO_NAS, '')))")
    String descrizioneEstesa

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map<String, String>> etichetteDomain = [Etichette.Codice, Etichette.Nel, Etichette.Descrizione]

}
