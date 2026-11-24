package it.finmatica.de4gsdzk.statocivile


import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Table

@Entity
@Table(name = "CIVDTR")
class CivTipoRegistro {

    public static final String ID_TRASPORTO = "T"
    public static final String ID_SEPPELLIMENTO = "S"
    public static final String ID_CREMAZIONE = "C"

    @Id
    @Column(name = "TIPO_REGISTRO", nullable = false)
    String id

    @Column(name = "DESCRIZIONE")
    String descrizione

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Codice"), Etichette.getEtichetta("Descrizione")]

}
