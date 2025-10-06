package it.finmatica.de4gsdzk.certificazione

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Table

@Entity
@Table(name = "CERDNS_V")
class CerSindaco extends GsdBaseDomain {

    @Id
    @Column(name = "COD_DNS", nullable=false)
    private String id
    String getId() { id }
    void setId(String id) { this.id = id }

    @Column(name = "COGNOME_NOME", nullable = false)
    String cognomeNome

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Cognome_Nome]
}
