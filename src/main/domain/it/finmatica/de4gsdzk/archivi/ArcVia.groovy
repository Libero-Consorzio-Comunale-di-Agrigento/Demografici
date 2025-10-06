package it.finmatica.de4gsdzk.archivi

import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Table

@Entity
@Table(name = "ARCVIE")
class ArcVia {
    @Id
    @Column(name = "COD_VIA", nullable = false)
    Long id

    @Column(name = "DENOM_UFF", nullable = false)
    String denominazione

    @Column(name = "DENOM_RIC", nullable = false)
    String denominazioneRicerca

    @Column(name = "DENOM_ORD", nullable = false)
    String denominazioneOrdinamento

    static final List<Map> etichetteDomain = [Etichette.Via]

}
