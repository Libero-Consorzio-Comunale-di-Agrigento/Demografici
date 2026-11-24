package it.finmatica.de4gsdzk.anagrafe.pratiche

import it.finmatica.de4gsdzk.anagrafe.ETipoAnagrafe
import it.finmatica.de4gsdzk.utils.ETipoPratica

import javax.persistence.*

@Entity
@Table(name = "ANADET_V_ZK")
class AnaDizionarioEventoPratica {

    @Id
    @Column(name = "ID")
    Integer id

    @Convert(converter = ETipoAnagrafe.EnumTipoAnagrafeToStringConverter.class)
    @Column(name ="ANAGRAFE")
    ETipoAnagrafe archivioAnagrafe

    @Convert(converter = ETipoPratica.EnumTipoPraticaToStringConverter.class)
    @Column(name ="TIPO_EVENTO")
    ETipoPratica tipoPratica

    @Column(name ="SEQUENZA", nullable = true)
    Integer sequenza

    @Column(name ="EVENTO_PRATICA", nullable = true)
    Integer codEp

    @Column(name ="NEXT_EVENTO_PRATICA_P", nullable = true)
    Integer codEpNextP

    @Column(name ="NEXT_EVENTO_PRATICA_N", nullable = true)
    Integer codEpNextN

}
