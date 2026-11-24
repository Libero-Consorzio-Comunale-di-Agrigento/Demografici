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

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Ufficio"), Etichette.getEtichetta("Anno"), Etichette.getEtichetta("Numero_Atto"), Etichette.getEtichetta("Parte"), Etichette.getEtichetta("Serie"),
                                              Etichette.getEtichetta("Cognome"), Etichette.getEtichetta("Nome"), Etichette.getEtichetta("Sesso"), Etichette.getEtichetta("Data_Nascita"), Etichette.getEtichetta("Anni"),Etichette.getEtichetta("Codice_Fiscale"),
                                               Etichette.getEtichetta("Luogo_Nascita"),  Etichette.getEtichetta("Luogo_Residenza"),  Etichette.getEtichetta("Cittadinanza"), Etichette.getEtichetta("Progressivo"),
                                              Etichette.getEtichetta("Stato_Civile"), Etichette.getEtichetta("Data_Matrimonio"), Etichette.getEtichetta("Data_Unione_Civile"),  Etichette.getEtichetta("Rito"),
                                               Etichette.getEtichetta("Tipo_Accordo"), Etichette.getEtichetta("Comune_Matrimonio"), Etichette.getEtichetta("Comune_Unione_Civile"), Etichette.getEtichetta("Dal"), Etichette.getEtichetta("Nazionalita"),
                                               Etichette.getEtichetta("Regime_patrimoniale"),  Etichette.getEtichetta("Regime_comunione"),  Etichette.getEtichetta("Regime_separazione"),
                                               Etichette.getEtichetta("Completo"),  Etichette.getEtichetta("Grado_Istruzione"),  Etichette.getEtichetta("Titolo_Studio"),
                                               Etichette.getEtichetta("Posizione_professione"),  Etichette.getEtichetta("Condizione_professionale"),
                                               Etichette.getEtichetta("Condizione_non_professionale"),  Etichette.getEtichetta("Ramo_attivita_economica"),
                                               Etichette.getEtichetta("Stato_Civile_Pre_Unione"),  Etichette.getEtichetta("Luogo_Residenza_Post_Matrimonio"),
                                               Etichette.getEtichetta("Stato_Civile_Pre_Matrimonio"),  Etichette.getEtichetta("Data_cessazione_matrimonio_precedente")]

}
