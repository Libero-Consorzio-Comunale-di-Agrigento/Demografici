package it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.anagrafe.ETipoAnagrafe
import it.finmatica.de4gsdzk.anagrafe.pratiche.AnaPratica
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.RecordDuplicatoRuntimeException
import it.finmatica.de4gsdzk.utils.ETipoOperazione
import it.finmatica.de4gsdzk.utils.ETipoPratica
import it.finmatica.de4gsdzk.utils.Etichette
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

import javax.persistence.criteria.JoinType

@Slf4j
@Transactional
@Service
class AnaComunicazionePraticaService {

    private final AnaArchivioComunicazioneService anaArchivioComunicazioneService

    private final AnaComunicazionePraticaRepository anaComunicazionePraticaRepository

    private final GsdService gsdService

    AnaComunicazionePraticaService(AnaComunicazionePraticaRepository anaComunicazionePraticaRepository,
                                   AnaArchivioComunicazioneService anaArchivioComunicazioneService,
                                   GsdService gsdService
    ) {

        this.anaComunicazionePraticaRepository = anaComunicazionePraticaRepository
        this.anaArchivioComunicazioneService = anaArchivioComunicazioneService
        this.gsdService = gsdService
    }

    AnaComunicazionePratica get(String id) {
        return anaComunicazionePraticaRepository.findById(id)
    }

    AnaComunicazionePratica getByUk(ETipoAnagrafe archivioAnagrafe, ETipoPratica tipoPratica, Integer idCom) {
        return anaComunicazionePraticaRepository.findByUk(archivioAnagrafe, tipoPratica, idCom)
    }

    List<AnaComunicazionePratica> findAllByComunicazione(AnaComunicazione comunicazione){
        return anaComunicazionePraticaRepository.findAllByComunicazione(comunicazione)
    }


    String sendAllDefaultComunicazioni(ETipoAnagrafe archivioAnagrafe, ETipoPratica tipoPratica, Integer annoPratica, Integer numeroPratica, Boolean priorita, Integer codiceCo) {
        String esito = gsdService.inserisciAggiornaComunicazioniAdempimenti(archivioAnagrafe, tipoPratica, annoPratica, numeroPratica, priorita, codiceCo)
        log.info(esito)
        return esito
    }

    List<AnaComunicazionePratica> listAllDefaultComunicazioni(AnaPratica obj) {
        List<AnaArchivioComunicazione> lArcComGestite = (anaArchivioComunicazioneService.listAllByUkPratica(obj.archivioAnagrafe, obj.tipoPratica, obj.numero, obj.anno, [:]) ?: [])

        if (lArcComGestite && (lArcComGestite.size() > 0)) {
            return []
        }

        List<AnaComunicazionePratica> lCa = anaComunicazionePraticaRepository.findAllByArchivioAnagrafeAndTipoPratica(obj.archivioAnagrafe, obj.tipoPratica)

        return lCa
    }

    List<AnaComunicazionePratica> listAllNotSelected(AnaPratica obj, Boolean priorita) {

        List<AnaComunicazionePratica> lCa = anaComunicazionePraticaRepository.findAllByArchivioAnagrafeAndTipoPraticaAndFlagPriorita(obj.archivioAnagrafe, obj.tipoPratica, priorita)

        if(priorita) {
            List<AnaComunicazionePratica> lRet = []

            //Estraggo solo le comunicazioni già presenti associate alla pratica
            List<AnaArchivioComunicazione> lArcComGestite = (anaArchivioComunicazioneService.listAllByUkPratica(obj.archivioAnagrafe, obj.tipoPratica, obj.numero, obj.anno,
                    [priorita: priorita, stampaEseguita: Boolean.FALSE, pratica: Boolean.TRUE, fetch: [[campo: 'comunicazione', tipo: JoinType.LEFT]]]) ?: [])

            for (AnaComunicazionePratica ca : lCa) {
                Boolean found = Boolean.FALSE
                for (AnaArchivioComunicazione ac : lArcComGestite) {
                    if (ac.comunicazione.id.compareTo(ca.comunicazione.id) == 0) {
                        found = Boolean.TRUE
                        break
                    }
                }
                if (!found) {
                    lRet.add(ca)
                }
            }
            return lRet
        } else {
            return lCa
        }

    }


    void validaDati(ETipoOperazione tipoOperazione, AnaComunicazionePratica obj) {
       if(obj.comunicazione == null || obj.archivioAnagrafe == null || obj.tipoPratica == null || obj.numeroCopie == null) {
           throw new CampoMandatoryRuntimeException()
       }

        // Verifica duplicati
        if (tipoOperazione.isInsert()) {
            AnaComunicazionePratica existing = anaComunicazionePraticaRepository.findByUk(
                    obj.archivioAnagrafe,
                    obj.tipoPratica,
                    obj.comunicazione.id
            )
            if (existing) {
                throw new RecordDuplicatoRuntimeException(Etichette.getEtichetta("Errore_Inserimento_Record_duplicato"))
            }
        }
    }


    AnaComunicazionePratica save(ETipoOperazione tipoOperazione, AnaComunicazionePratica obj) {
        validaDati(tipoOperazione, obj)

       if(tipoOperazione.isInsert()) {
           obj.id = gsdService.getIdComunicazionePratica(obj.archivioAnagrafe, obj.tipoPratica, obj.comunicazione.id)
       }
        return anaComunicazionePraticaRepository.save(obj)

    }

    void delete(AnaComunicazionePratica obj) {
        anaComunicazionePraticaRepository.delete(obj)
    }
}
