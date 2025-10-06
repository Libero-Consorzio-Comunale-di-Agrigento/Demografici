package it.finmatica.de4gsdzk

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.archivi.ArcParametro
import it.finmatica.de4gsdzk.certificazione.CerTipoCertificato
import it.finmatica.de4gsdzk.GestioneTestiGsdModelloRepository
import it.finmatica.de4gsdzk.GestioneTestiGsdTipoModelloRepository
import it.finmatica.de4gsdzk.archivi.ArcParametroRepository
import it.finmatica.de4gsdzk.certificazione.CerTipoCertificatoRepository
import it.finmatica.de4gsdzk.statocivile.CivComunicazioneAttoRepository
import it.finmatica.de4gsdzk.statocivile.CivComunicazioneRepository
import it.finmatica.de4gsdzk.statocivile.GestioneTestiModelloRelazioneRepository
import it.finmatica.de4gsdzk.statocivile.CivComunicazione
import it.finmatica.de4gsdzk.statocivile.CivComunicazioneAtto
import it.finmatica.de4gsdzk.statocivile.GestioneTestiModelloRelazione
import it.finmatica.de4gsdzk.utils.*
import org.apache.commons.io.FilenameUtils
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service

import static org.apache.commons.io.FileUtils.readFileToByteArray

@Slf4j
@Service
class CaricaModelliService {

    @Autowired
    GestioneTestiGsdModelloRepository gestioneTestiGsdModelloRepository

    @Autowired
    GestioneTestiGsdTipoModelloRepository gestioneTestiGsdTipoModelloRepository

    @Autowired
    CivComunicazioneRepository civComunicazioneRepository

    @Autowired
    CivComunicazioneAttoRepository civComunicazioneAttoRepository

    @Autowired
    GestioneTestiModelloRelazioneRepository gestioneTestiModelloRelazioneRepository

    @Autowired
    ArcParametroRepository arcParametroRepository

    @Autowired
    CerTipoCertificatoRepository cerTipoCertificatoRepository

    boolean modelliComunicazioniLoaded(){
        if (gestioneTestiGsdModelloRepository.countByGruppoAndAmbito(EGruppo.CIV, EAmbito.CO) > 0) {
            log.info ("La tabella contiene già dei modelli CO, aggiornamento non consentito")
            return true
        }
        return false
    }

    /**
     * Carica i modelli ODT nel DB
     *
     * @param files i modelli ODT da caricare
     * @return il numero di modelli caricati con successo
     */
    int caricaModelliComunicazioni(File[] files) {

        int count = 0

        if (modelliComunicazioniLoaded()) {
            return 0
        }

        for (File f : files) {

            log.info(" - " + f.getName() + "...")

            String estensione = FilenameUtils.getExtension(f.getName())
            if (estensione.equalsIgnoreCase(ETipoFile.TXT.estensione)){
                continue
            }

            String codice = FilenameUtils.removeExtension(f.getName())
            if (codice.startsWith(GestioneTestiGsdModello.PREFISSO_MODELLI_STANDARD) && (codice.length() == 7) ){
                codice = codice.substring(4)

                try {
                    String codiceTipoAtto = codice.substring(0, 1)
                    int tipoAtto
                    if (codiceTipoAtto == ParametroProtocolloDiz.CODICE_TIPO_ATTO_UCI){
                        tipoAtto = -4
                    } else {
                        tipoAtto = Integer.parseInt(codiceTipoAtto)
                    }
                    int codiceComunicazione = Integer.parseInt(codice.substring(1))

                    GestioneTestiGsdModello modello = new GestioneTestiGsdModello(
                            utenteIns: ConfigurazioneUtils.CODICE_UTENZA_TECNICA,
                            utenteUpd: ConfigurazioneUtils.CODICE_UTENZA_TECNICA,
                            codice: codice,
                            nome: f.getName(),
                            tipo: FilenameUtils.getExtension(f.getName()),
                            ambito: EAmbito.CO,
                            gruppo: EGruppo.CIV,
                            valido: true,
                            fileTemplate: readFileToByteArray(f)
                    )

                    GestioneTestiModelloRelazione mr
                    if (tipoAtto == 0){ // E' una comunicazione formula
                        CivComunicazione co = civComunicazioneRepository.findById(new Integer(codiceComunicazione))
                        if (co){
                            mr = new GestioneTestiModelloRelazione(comunicazione: co, modello: modello)
                            log.info("Tento registrazione testo della comunicazione ${co.id}...")
                        }
                    } else { // E' una comunicazione atto
                        CivComunicazioneAtto ca = civComunicazioneAttoRepository.findById(codice)
                        if (ca){
                            mr = new GestioneTestiModelloRelazione(comunicazioneAtto: ca, modello: modello)
                            log.info("Tento registrazione testo della comunicazione atto ${codice}...")
                        }
                    }

                    if (mr) {
                        count++
                        gestioneTestiGsdModelloRepository.save(modello)
                        gestioneTestiModelloRelazioneRepository.save(mr)
                    }

                } catch (NumberFormatException ex){
                    log.error(ex.getMessage())
                }
            }

        }

        return count
    }

    boolean modelliDATLoaded(){
        if (gestioneTestiGsdModelloRepository.countByGruppoAndAmbito(EGruppo.CIV, EAmbito.TB) > 0) {
            log.info ("La tabella contiene già dei modelli TB, aggiornamento non consentito")
            return true
        }
        return false
    }

    int caricaModelliDAT(File[] files) {

        int count = 0

        if (modelliDATLoaded()) {
            return 0
        }

        List<File> xmlFiles = []
        List<File> modelliFiles = []
        for (File f : files) {
            if (FilenameUtils.getExtension(f.getName()).equalsIgnoreCase(ETipoFile.XML.estensione)){
                xmlFiles.add(f)
            } else {
                modelliFiles.add(f)
            }
        }

        GestioneTestiGsdTipoModello tm = null
        if (xmlFiles.size() == 1){
            File f = xmlFiles[0]
            tm = gestioneTestiGsdTipoModelloRepository.save( new GestioneTestiGsdTipoModello(
                    utenteIns: ConfigurazioneUtils.CODICE_UTENZA_TECNICA,
                    utenteUpd: ConfigurazioneUtils.CODICE_UTENZA_TECNICA,
                    codice: FilenameUtils.removeExtension(f.getName()),
                    descrizione: "Sorgente Dati DAT",
                    valido: true,
                    query: readFileToByteArray(f))
            )
            count++
        }

        for (File f : modelliFiles) {

            log.info(" - " + f.getName() + "...")

            try {
                GestioneTestiGsdModello m = new GestioneTestiGsdModello(
                        utenteIns: ConfigurazioneUtils.CODICE_UTENZA_TECNICA,
                        utenteUpd: ConfigurazioneUtils.CODICE_UTENZA_TECNICA,
                        codice: f.getName().substring(0, 7),
                        nome: f.getName(),
                        tipo: FilenameUtils.getExtension(f.getName()),
                        ambito: EAmbito.TB,
                        gruppo: EGruppo.CIV,
                        fileTemplate: readFileToByteArray(f),
                        tipoModello: tm,
                        valido: true
                )
                if (m.codice.endsWith("1")) {
                    m.descrizione = "Dichiarazione Disponente"
                }
                if (m.codice.endsWith("2")) {
                    m.descrizione = "Dichiarazione Fiduciario 1"
                }
                if (m.codice.endsWith("3")) {
                    m.descrizione = "Dichiarazione Fiduciario 2"
                }
                if (m.codice.endsWith("4")) {
                    m.descrizione = "Ricevuta Disponente"
                }
                if (m.codice.endsWith("5")) {
                    m.descrizione = "Ricevuta Fiduciario 1"
                }
                if (m.codice.endsWith("6")) {
                    m.descrizione = "Ricevuta Fiduciario 2"
                }

                if (m) {
                    gestioneTestiGsdModelloRepository.save(m)
                    count++
                }
            } catch (Exception ex){
                log.error(ex.getMessage())
            }
        }

        return count
    }

    int caricaLoghi(File[] files) {
        int count = 0

        if (caricaLogo(files, ArcParametro.LOGO_CIV)) {
            count++
        }

        if (caricaLogo(files, ArcParametro.LOGO_CER)) {
            count++
        }

        return count
    }

    private boolean caricaLogo(File[] files, String parametroId) {
        try {
            File f = files.find { FilenameUtils.removeExtension(it.getName()).equalsIgnoreCase(parametroId) }
            if (!f) {
                log.info("File non trovato per il parametro ${parametroId}")
                return false
            }

            ArcParametro p = arcParametroRepository.findById(parametroId)
            if (!p) {
                log.info("Parametro ${parametroId} non trovato, aggiornamento non consentito")
                return false
            }

            if (p?.blobAllegato) {
                log.info("Parametro ${parametroId} contiene già un logo, aggiornamento non consentito")
                return false
            }

            String pre = "Caricato automaticamente il ${DataUtils.fromDateToString(DataUtils.dataCorrente)}"
            p.note = "$pre${p.note ? (" - " + p.note) : ""}"
            p.blobAllegato = readFileToByteArray(f)

            arcParametroRepository.save(p)
            return true
        } catch (Exception ex) {
            log.error("Errore durante il caricamento del logo per il parametro ${parametroId}", ex)
            return false
        }
    }

    boolean modelloEtichettaLoaded(){
        if (gestioneTestiGsdModelloRepository.countByGruppoAndAmbito(EGruppo.CIV, EAmbito.ET) > 0) {
            log.info ("La tabella contiene già un modello ET, aggiornamento non consentito")
            return true
        }
        return false
    }

    int caricaModelloEtichetta(File[] files) {
        int count = 0

        if (modelloEtichettaLoaded()) {
            return 0
        }

        List<File> xmlFiles = []
        List<File> modelliFiles = []
        for (File f : files) {
            if (FilenameUtils.getExtension(f.getName()).equalsIgnoreCase(ETipoFile.XML.estensione)){
                xmlFiles.add(f)
            } else {
                modelliFiles.add(f)
            }
        }

        GestioneTestiGsdTipoModello tm = null
        if (xmlFiles.size() == 1){
            tm = gestioneTestiGsdTipoModelloRepository.findByCodice("ETI_PERS")
            if (tm != null) {
                log.info ("La tabella contiene già il tipo modello dell'etichetta, aggiornamento tipo modello non consentito")
            } else {
                File f = xmlFiles[0]
                tm = gestioneTestiGsdTipoModelloRepository.save(new GestioneTestiGsdTipoModello(
                        utenteIns: ConfigurazioneUtils.CODICE_UTENZA_TECNICA,
                        utenteUpd: ConfigurazioneUtils.CODICE_UTENZA_TECNICA,
                        codice: FilenameUtils.removeExtension(f.getName()),
                        descrizione: "Sorgente Dati Etichetta",
                        valido: true,
                        query: readFileToByteArray(f))
                )
                count++
            }
        }

        if (tm == null){
            return 0
        }

        for (File f : modelliFiles) {

            log.info(" - " + f.getName() + "...")

            try {
                GestioneTestiGsdModello m = new GestioneTestiGsdModello(
                        utenteIns: ConfigurazioneUtils.CODICE_UTENZA_TECNICA,
                        utenteUpd: ConfigurazioneUtils.CODICE_UTENZA_TECNICA,
                        codice: tm.codice,
                        descrizione:"Modello etichetta personalizzato",
                        nome: f.getName(),
                        tipo: FilenameUtils.getExtension(f.getName()),
                        ambito: EAmbito.ET,
                        gruppo: EGruppo.CIV,
                        fileTemplate: readFileToByteArray(f),
                        tipoModello: tm,
                        valido: true
                )
                if (m) {
                    gestioneTestiGsdModelloRepository.save(m)
                    count++
                }
            } catch (Exception ex){
                log.error(ex.getMessage())
            }
        }

        return count
    }

    boolean modelliTipoCertificatoLoaded() {
        if (gestioneTestiGsdModelloRepository.countByGruppoAndAmbito(EGruppo.CER, EAmbito.TC) > 0) {
            log.info("La tabella contiene già dei modelli TC, aggiornamento non consentito")
            return true
        }
        return false
    }

/**
 * Carica i modelli ODT nel DB
 *
 * @param files i modelli ODT da caricare
 * @return il numero di modelli caricati con successo
 */
    int caricaModelliTipoCertificato(File[] files) {

        int count = 0

        if (modelliTipoCertificatoLoaded()) {
            return 0
        }

        for (File f : files) {

            log.info(" - " + f.getName() + "...")

            String estensione = FilenameUtils.getExtension(f.getName())
            if (estensione.equalsIgnoreCase(ETipoFile.TXT.estensione)) {
                continue
            }

            String fileBaseName = FilenameUtils.removeExtension(f.getName())
            if (TestoUtils.isVuoto(fileBaseName)) {
                log.error("Il file ${f.getName()} non ha un nome base")
                continue
            }

            String idTipoCertificato = FileUtils.getIdTipoCertificatoFromNomeModello(fileBaseName)
            if (TestoUtils.isVuoto(idTipoCertificato)) {
                log.error("Il file ${f.getName()} non ha un idTipoCertificato")
                continue
            }

            CerTipoCertificato tipoCertificato = cerTipoCertificatoRepository.findById(idTipoCertificato)
            if (!tipoCertificato) {
                log.error("Tipo certificato ${idTipoCertificato} non trovato")
                continue
            }

            GestioneTestiGsdModello modello = new GestioneTestiGsdModello(
                    utenteIns: ConfigurazioneUtils.CODICE_UTENZA_TECNICA,
                    utenteUpd: ConfigurazioneUtils.CODICE_UTENZA_TECNICA,
                    codice: FileUtils.getCodiceModelloTipoCertificatoStandard(idTipoCertificato),
                    nome: f.getName(),
                    tipo: FilenameUtils.getExtension(f.getName()),
                    ambito: EAmbito.TC,
                    gruppo: EGruppo.CER,
                    valido: true,
                    fileTemplate: readFileToByteArray(f)
            )
            GestioneTestiModelloRelazione mr = new GestioneTestiModelloRelazione(modello: modello, tipoCertificato: tipoCertificato)

            count++

            gestioneTestiGsdModelloRepository.save(modello)
            log.info("Registrato modello ${modello.codice}")
            gestioneTestiModelloRelazioneRepository.save(mr)
            log.info("Registrato relazione modello ${mr.modello.codice} <-> tipo certificato ${mr.tipoCertificato.id}")
        }

        return count
    }

}
