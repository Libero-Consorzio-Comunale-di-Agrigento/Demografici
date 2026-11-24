package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.ECanaleComunicazioneNotifica
import it.finmatica.de4gsdzk.utils.EGenereNotifica
import it.finmatica.de4gsdzk.utils.EStatoFlussoNotifica
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "ANSNOT_V")
class AnscNotifica extends GsdBaseDomain{

    @Id
    @Column(name = "ID")
    Long id

    @Column(name = "ID_SOGGETTO_ANSC", nullable = true)
    Long idSoggettoAnsc

    @Column(name = "ID_ANSC", nullable = true)
    String idAnsc

    @Convert(converter=EnumStatoToIntConverter.class)
    @Column(name = "STATO", nullable = true)
    EStatoFlussoNotifica stato

    @Convert(converter=EnumGenereToIntConverter.class)
    @Column(name = "GENERE", nullable = true)
    EGenereNotifica genere

    @Convert(converter=EnumCanaleComunicazioneNotifica.class)
    @Column(name = "CANALE_COMUNICAZIONE_ANSC", nullable = true)
    ECanaleComunicazioneNotifica canaleComunicazione

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "VALIDO_AL")
    Date validoAl

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "VALIDO_DAL", nullable = false)
    Date validoDal

    @Column(name = "DES_COMUNE_FORMAZIONE", nullable = true, updatable = false, insertable = false)
    String descrizioneComuneFormazione

    // Gestiamo cognome e nome come campi calcolati per esibirli anche prima della consultazione
    @Column(name = "COGNOME_SOGGETTO_ANSC", nullable = true, updatable = false, insertable = false)
    String cognomeSoggettoAnsc

    @Column(name = "NOME_SOGGETTO_ANSC", nullable = true, updatable = false, insertable = false)
    String nomeSoggettoAnsc

    @Column(name = "DESCRIZIONE", nullable = true)
    String descrizione

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Stato"), Etichette.getEtichetta("Genere"), Etichette.getEtichetta("Cognome_Nome"), Etichette.getEtichetta("Data"),
                                              Etichette.getEtichetta("Descrizione"), Etichette.getEtichetta("Comune_Formazione"), Etichette.getEtichetta("Dal"), Etichette.getEtichetta("Al"), Etichette.getEtichetta("Testo"),
                                              Etichette.getEtichetta("Evento_Primario"), Etichette.getEtichetta("Estremi_Atto"), Etichette.getEtichetta("Tipo_Atto"), Etichette.getEtichetta("Comune_Atto")]

    @Converter
    static class EnumStatoToIntConverter implements AttributeConverter<EStatoFlussoNotifica, Integer> {
        @Override Integer convertToDatabaseColumn(EStatoFlussoNotifica ee) {
            return (ee ? ee.valore : null)
        }
        @Override EStatoFlussoNotifica convertToEntityAttribute(Integer value) {
            EStatoFlussoNotifica ret = null
            for (EStatoFlussoNotifica ee : EStatoFlussoNotifica.values()) {
                if (ee.valore == value) {
                    ret = ee
                    break
                }
            }
            return ret
        }
    }

    @Converter
    static class EnumGenereToIntConverter implements AttributeConverter<EGenereNotifica, Integer> {
        @Override Integer convertToDatabaseColumn(EGenereNotifica ee) {
            return (ee ? ee.valore : null)
        }
        @Override EGenereNotifica convertToEntityAttribute(Integer value) {
            EGenereNotifica ret = null
            for (EGenereNotifica ee : EGenereNotifica.values()) {
                if (ee.valore == value) {
                    ret = ee
                    break
                }
            }
            return ret
        }
    }

    @Converter
    static class EnumCanaleComunicazioneNotifica implements AttributeConverter<ECanaleComunicazioneNotifica, Integer> {
        @Override Integer convertToDatabaseColumn(ECanaleComunicazioneNotifica ee) {
            return (ee ? ee.valore : null)
        }
        @Override ECanaleComunicazioneNotifica convertToEntityAttribute(Integer value) {
            ECanaleComunicazioneNotifica ret = null
            for (ECanaleComunicazioneNotifica ee : ECanaleComunicazioneNotifica.values()) {
                if (ee.valore == value) {
                    ret = ee
                    break
                }
            }
            return ret
        }
    }

}

