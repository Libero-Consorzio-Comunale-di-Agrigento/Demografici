package it.finmatica.de4gsdzk.anagrafe.pratiche

import it.finmatica.de4gsdzk.anagrafe.ETipoFamiglia
import it.finmatica.de4gsdzk.utils.ESesso

import javax.persistence.Column
import javax.persistence.Convert
import javax.persistence.Entity
import javax.persistence.EnumType
import javax.persistence.Enumerated
import javax.persistence.Id
import javax.persistence.Table

@Entity
@Table(name = "ANADPI_V")
class AnaRapportoParentelaIstat {

    @Id
    @Column(name = "ID", updatable = false, insertable = false)
    String id

    @Column(name ="IST_RP")
    String istRp

    @Enumerated(EnumType.STRING)
    @Column(name = "SESSO")
    ESesso sesso

    @Column(name ="DESCRIZIONE")
    String descrizione

    @Convert(converter = ETipoFamiglia.EnumTipoFamigliaToStringConverter.class)
    @Column(name = "FAMIGLIA_CONVIVENZA", nullable = true)
    ETipoFamiglia tipoFamiglia

    @Column(name ="COD_RP")
    String codiceRapportoParentela

}
