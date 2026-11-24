package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.ILuogoEvento
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Table

@Entity
@Table(name = "CIVDG5")
class CivLuogoDecesso implements ILuogoEvento{

    @Id
    @Column(name = "COD_MOR")
    Integer id

    @Column(name = "NEL_MOR", nullable = true)
    String nel

    @Column(name = "LUOGO_MOR")
    String descrizione

    @Column(name = "RICEVUTO", nullable = true)
    String ricevuto

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map<String, String>> etichetteDomain = [Etichette.getEtichetta("Codice"), Etichette.getEtichetta("Nel"), Etichette.getEtichetta("Descrizione"), Etichette.getEtichetta("Ricevuto_da")]

}
