package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@MappedSuperclass
abstract class IstBaseDomain extends GsdBaseDomain {

    @Id
    @Column(name = "ID")
    Long id

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_COMPLETO", nullable = true)
    Boolean flagCompleto

    @Version
    @Column(nullable = false)
    Long version

    abstract Integer getUfficio()

    abstract Integer getAnno()

    abstract Integer getAtto()

    abstract Integer getParte()

    abstract ETipoAtto getTipoAttoEnum()

    Boolean hasParte(){
        return getTipoAttoEnum().hasParte()
    }

    Boolean hasSerie(){
        return getTipoAttoEnum().hasSerie()
    }

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Ufficio, Etichette.Anno, Etichette.Numero_Atto, Etichette.Parte, Etichette.Serie,
                                              Etichette.Cognome, Etichette.Nome, Etichette.Sesso, Etichette.Data_Nascita, Etichette.Anni, Etichette.Codice_Fiscale,
                                              Etichette.Luogo_Nascita, Etichette.Luogo_Residenza, Etichette.Cittadinanza, Etichette.Progressivo,
                                              Etichette.Stato_Civile, Etichette.Data_Matrimonio, Etichette.Data_Unione_Civile, Etichette.Rito,
                                              Etichette.Tipo_Accordo, Etichette.Comune_Matrimonio, Etichette.Comune_Unione_Civile, Etichette.Dal, Etichette.Nazionalita,
                                              Etichette.Regime_patrimoniale, Etichette.Regime_comunione, Etichette.Regime_separazione,
                                              Etichette.Completo, Etichette.Grado_Istruzione, Etichette.Titolo_Studio,
                                              Etichette.Posizione_professione, Etichette.Condizione_professionale,
                                              Etichette.Condizione_non_professionale, Etichette.Ramo_attivita_economica,
                                              Etichette.Stato_Civile_Pre_Unione, Etichette.Luogo_Residenza_Post_Matrimonio,
                                              Etichette.Stato_Civile_Pre_Matrimonio, Etichette.Data_cessazione_matrimonio_precedente]

}
