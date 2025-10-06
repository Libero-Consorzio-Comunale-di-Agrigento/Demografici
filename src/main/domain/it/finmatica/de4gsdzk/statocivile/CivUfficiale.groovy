package it.finmatica.de4gsdzk.statocivile


import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Table

@Entity
@Table(name = "CIVDUF")
class CivUfficiale {

    @Id
    @Column(name = "COD_UF")
    Integer id

    @Column(name = "COGNOME_NOME")
    String cognomeNome

    @Column(name = "QUALIFICA")
    String qualifica

    static final List<Map> etichetteDomain = [Etichette.Ufficiale, Etichette.Codice, Etichette.Cognome_Nome, Etichette.Qualifica]

}
