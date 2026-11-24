package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.ETipoFormulaAggiuntiva
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.TipoAttoUtils

import javax.persistence.*

@Entity
@Table(name = "CIVFAA")
class CivFormulaAggiuntiva extends GsdBaseDomain{

    @Id
    @Column(name = "ID")
    Long id

    @Column(name = "TIPO_ATTO", nullable = false)
    Integer tipoAtto

    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_FORMULA", nullable = false)
    ETipoFormulaAggiuntiva tipoFormula

    @Column(name = "TESTO", nullable = true)
    String testo

    @Column(name = "SEQUENZA", nullable = true)
    Integer sequenza

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_CIA", nullable = true)
    Boolean flagCiaVisibile

    ETipoAtto getTipoAttoEnum(){
        return TipoAttoUtils.fromValoreDefault(this.tipoAtto.intValue())
    }

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Tipo_Atto"), Etichette.getEtichetta("Testo"), Etichette.getEtichetta("Sequenza"),
                                              Etichette.getEtichetta("Formula_CIA"), Etichette.getEtichetta("Visibile_in_CIA")]

}
