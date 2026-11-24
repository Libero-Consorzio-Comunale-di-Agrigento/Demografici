package it.finmatica.de4gsdzk.elettorale

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.*

import javax.persistence.*

@Entity
@Table(name = "ELEDTL")
class EleTipoLista extends GsdBaseDomain {

    @Id
    @Column(name = "COD_TL")
    String id

    @Column(name = "DESCRIZIONE_BREVE", nullable = true)
    String descrizioneBreve

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Codice"), Etichette.getEtichetta("Descrizione")]

}

