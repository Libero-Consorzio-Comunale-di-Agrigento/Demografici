package it.finmatica.de4gsdzk.pagamento.depag

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "WS_PAGAMENTI_SER")
class DepagServizio extends GsdBaseDomain {

    @Id
    @Column(name = "COD_SERVIZIO")
    String id

    @Column(name = "DESCRIZIONE", nullable = false)
    String descrizione

    @Column(name = "COD_DEPAG", nullable = true)
    String codiceDepag

    @Column(name = "COD_TASSONOMIA", nullable = false)
    String codiceTassonomia

    @Column(name = "DES_TASSONOMIA", nullable = false)
    String descrizioneTassonomia

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_DEFAULT", nullable = true)
    Boolean flagDefault

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Codice, Etichette.Descrizione, Etichette.Servizio_Depag, Etichette.Tassonomia]
}
