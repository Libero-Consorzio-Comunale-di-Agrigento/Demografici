package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.IntegrationSpec
import org.springframework.beans.factory.annotation.Autowired

class AnaCodiceEventoRepositorySpec extends IntegrationSpec {

    @Autowired
    AnaCodiceEventoRepository anaTipoEventoRepository

    void "Test che ci siano solo i tipi evento previsti con le descrizioni corrette"() {
        given: "Una lista di tipi evento da verificare"
        List<AnaCodiceEvento> tipiEvento = [
                new AnaCodiceEvento(id:1, descrizione: "NASCITA"),
                new AnaCodiceEvento(id:2, descrizione: "IMMIGRAZIONE"),
                new AnaCodiceEvento(id:3, descrizione: "REIMMIGRAZIONE"),
                new AnaCodiceEvento(id:4, descrizione: "REIMMIGRAZIONE DA AIRE"),
                new AnaCodiceEvento(id:5, descrizione: "ISCRIZIONE D'UFFICIO"),
                new AnaCodiceEvento(id:6, descrizione: "ISCRIZIONE D'UFFICIO AIRE"),
                new AnaCodiceEvento(id:7, descrizione: "TRASFERIMENTO AIRE DA ALTRO C."),
                new AnaCodiceEvento(id:8, descrizione: "ACQUISTO CITTADINANZA ITALIANA"),
                new AnaCodiceEvento(id:9, descrizione: "REISCRIZIONE DA IRREPERIB."),
                new AnaCodiceEvento(id:10, descrizione: "RESIDENZA ALL'ESTERO"),
                new AnaCodiceEvento(id:11, descrizione: "REISCR. DA MANCATO RINNOVO PS"),
                new AnaCodiceEvento(id:12, descrizione: "ISCR. DA ESTERO (ATTESA CITT.)"),
                new AnaCodiceEvento(id:13, descrizione: "MANCATA ISCR. IN ALCUN COMUNE"),
                new AnaCodiceEvento(id:14, descrizione: "ISCRIZIONE D.LGS. 30/2007"),
                new AnaCodiceEvento(id:15, descrizione: "ISCR. DIR.20/02/07 (ATTESA PS)"),
                new AnaCodiceEvento(id:16, descrizione: "ISCR. DIR.05/08/06 (PS SCAD.)"),
                new AnaCodiceEvento(id:17, descrizione: "ISCR. PRELIMINARE (DL 5/2012)"),
                new AnaCodiceEvento(id:18, descrizione: "RIPRISTINO RESIDENZA"),
                new AnaCodiceEvento(id:19, descrizione: "ISCR. DA ALTRO COMUNE ITALIANO"),
                new AnaCodiceEvento(id:20, descrizione: "ISCR. EX D.LGS. 142/2015"),
                new AnaCodiceEvento(id:50, descrizione: "MORTE"),
                new AnaCodiceEvento(id:51, descrizione: "EMIGRAZIONE"),
                new AnaCodiceEvento(id:52, descrizione: "EMIGRAZIONE A.I.R.E"),
                new AnaCodiceEvento(id:53, descrizione: "IRREPERIBILITA'"),
                new AnaCodiceEvento(id:54, descrizione: "IRREPERIBILITA' PRESUNTA"),
                new AnaCodiceEvento(id:55, descrizione: "IMMIGRAZIONE IN ALTRO COMUNE"),
                new AnaCodiceEvento(id:56, descrizione: "TRASFERIMENTO AIRE IN ALTRO C."),
                new AnaCodiceEvento(id:57, descrizione: "PERDITA CITTADINANZA ITALIANA"),
                new AnaCodiceEvento(id:58, descrizione: "DOPPIA ISCRIZIONE"),
                new AnaCodiceEvento(id:59, descrizione: "CANCELLAZIONE D'UFFICIO"),
                new AnaCodiceEvento(id:60, descrizione: "CANC. PER MANCATO RINNOVO PS"),
                new AnaCodiceEvento(id:61, descrizione: "TRASF. ALTRO COMUNE ITALIANO"),
                new AnaCodiceEvento(id:62, descrizione: "ACCERTAMENTI NEGATIVI"),
                new AnaCodiceEvento(id:63, descrizione: "REVOCA MIS. ACCOGLIENZA"),
                new AnaCodiceEvento(id:64, descrizione: "ALLONTANAMENTO INGIUSTIFICATO"),
                new AnaCodiceEvento(id:65, descrizione: "CANC. MANCATO RINNOVO DIMORA"),
                new AnaCodiceEvento(id:70, descrizione: "IN ATTESA DI ISCRIZIONE"),
                new AnaCodiceEvento(id:71, descrizione: "IMMIGRAZIONE ANNULLATA"),
                new AnaCodiceEvento(id:72, descrizione: "IN ATTESA DI ISCRIZIONE AIRE"),
                new AnaCodiceEvento(id:73, descrizione: "ISCRIZIONE AIRE ANNULLATA"),
                new AnaCodiceEvento(id:80, descrizione: "NON RESIDENTE"),
                new AnaCodiceEvento(id:81, descrizione: "NON RESIDENTE (ANPR)"),
                new AnaCodiceEvento(id:90, descrizione: "VARIAZIONE RAPPORTO PARENTELA"),
                new AnaCodiceEvento(id:91, descrizione: "TRASFERIMENTO RESIDENZA"),
                new AnaCodiceEvento(id:92, descrizione: "SCISSIONE"),
                new AnaCodiceEvento(id:93, descrizione: "MATRIMONIO"),
                new AnaCodiceEvento(id:94, descrizione: "VEDOVANZA"),
                new AnaCodiceEvento(id:97, descrizione: "RETTIFICA DATI MATRIMONIO"),
                new AnaCodiceEvento(id:98, descrizione: "RETTIFICA INDIRIZZO"),
                new AnaCodiceEvento(id:99, descrizione: "RETTIFICA")
        ]

        when: "Vengono recuperati tutti i tipi evento dal repository"
        List<AnaCodiceEvento> tipiEventoTrovati = anaTipoEventoRepository.findAll()

        then: "Il numero dei tipi evento nel database deve corrispondere esattamente al numero dei tipi evento previsti"
        tipiEventoTrovati.size() == tipiEvento.size()

        and: "Ogni tipo evento nel database deve avere l'id e la descrizione corretti"
        tipiEventoTrovati.each { tipoEventoTrovato ->
            AnaCodiceEvento tipoEventoAtteso = tipiEvento.find { it.id == tipoEventoTrovato.id }
            tipoEventoTrovato.descrizione == tipoEventoAtteso.descrizione
        }

        and: "Non devono esserci tipi evento non previsti"
        List<Integer> idsTrovati = tipiEventoTrovati.collect { it.id }
        List<Integer> idsPrevisti = tipiEvento.collect { it.id }
        idsTrovati.containsAll(idsPrevisti) && idsPrevisti.containsAll(idsTrovati)
    }

}