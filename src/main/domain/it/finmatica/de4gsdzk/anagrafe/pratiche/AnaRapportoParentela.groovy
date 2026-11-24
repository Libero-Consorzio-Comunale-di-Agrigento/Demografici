package it.finmatica.de4gsdzk.anagrafe.pratiche

import it.finmatica.de4gsdzk.anagrafe.ETipoFamiglia
import it.finmatica.de4gsdzk.utils.ESesso

import javax.persistence.*

@Entity
@Table(name = "ANADRP_V")
class AnaRapportoParentela {

    @Id
    @Column(name = "ID", updatable = false, insertable = false)
    String id

    @Column(name ="COD_RP")
    String codiceRapportoParentela

    @Enumerated(EnumType.STRING)
    @Column(name = "SESSO")
    ESesso sesso

    @Column(name ="SEQUENZA")
    Integer sequenza

    @Column(name ="DESCRIZIONE")
    String descrizione

    @Convert(converter = ETipoFamiglia.EnumTipoFamigliaToStringConverter.class)
    @Column(name = "FAMIGLIA_CONVIVENZA", nullable = true)
    ETipoFamiglia tipoFamiglia

}
