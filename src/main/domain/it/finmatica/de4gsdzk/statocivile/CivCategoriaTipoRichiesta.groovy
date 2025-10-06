package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.ETipoRichiesta
import it.finmatica.de4gsdzk.utils.TipoAttoUtils

import javax.persistence.*

@Entity
@Table(name = "CIVCTA_TIPI_RICHIESTA")
@IdClass(CivCategoriaTipoRichiestaCompositeId.class)
class CivCategoriaTipoRichiesta {

    @Id
    @Column(name = "TIPO_ATTO", nullable = false)
    Integer tipoAtto

    @Id
    @Column(name = "SIGLA_CATEGORIA", nullable = false)
    String siglaCategoria

    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_RICHIESTA", nullable = true)
    ETipoRichiesta tipoRichiesta

    @Column(name = "DESCRIZIONE", nullable = false)
    String descrizione

    ETipoAtto getTipoAttoEnum() { TipoAttoUtils.fromValoreDefault(tipoAtto) }
}

