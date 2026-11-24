package it.finmatica.de4gsdzk.elettorale

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Table

@Entity
@Table(name = "ELECCE")
class EleComponenteCommissione extends GsdBaseDomain {

    @Id
    @Column(name = "COD_CO")
    String codice

    String getId() {
        return codice
    }

    @Column(name = "COGNOME_NOME", nullable = true, updatable = false, insertable = false)
    String cognomeNome

    @Column(name = "QUALIFICA", nullable = true, updatable = false, insertable = false)
    String qualifica

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Cognome_Nome"), Etichette.getEtichetta("Qualifica")]
}
