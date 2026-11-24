package it.finmatica.de4gsdzk.anagrafe

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.ParametroProtocolloDiz
import it.finmatica.de4gsdzk.ParametroProtocolloDizRepository
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaComunicazionePratica
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaModello
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaModelloService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.RecordDuplicatoRuntimeException
import it.finmatica.de4gsdzk.utils.EGruppo
import it.finmatica.de4gsdzk.utils.ETipoModello
import it.finmatica.de4gsdzk.utils.ETipoOperazione
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.ValidationUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnaParametroProtocolloService {

    private final AnaParametroProtocolloRepository anaParametroProtocolloRepository

    private final ParametroProtocolloDizRepository parametroProtocolloDizRepository

    private final AnaModelloService anaModelloService

    private final GsdService gsdService

    AnaParametroProtocolloService(AnaParametroProtocolloRepository anaParametroProtocolloRepository,
                                  ParametroProtocolloDizRepository parametroProtocolloDizRepository,
                                  AnaModelloService anaModelloService,
                                  GsdService gsdService) {
        this.anaParametroProtocolloRepository = anaParametroProtocolloRepository
        this.parametroProtocolloDizRepository = parametroProtocolloDizRepository
        this.anaModelloService = anaModelloService
        this.gsdService = gsdService
    }

    AnaParametroProtocollo get(Long id) {
        return anaParametroProtocolloRepository.findById(id)
    }

    /** Calcola la lista di tutti codici fase per modulo ANA */
    Map<String, String> listAllCodiciFase() {
        Map<String, String> mapCodiciFase = [:]
        List<ParametroProtocolloDiz> listaDiz = parametroProtocolloDizRepository.findAllByModulo(EGruppo.ANA.name())
        for (ParametroProtocolloDiz diz : listaDiz) {
            mapCodiciFase.put(diz.getCodiceFase(), diz.getDescrizioneFase())
        }
        return mapCodiciFase
    }

    Map<String, String> getMapCodiciAnagrafe(String codiceFase) {
        Map<String, String> mapCodiciFaseAnagrafe = [:]

        List<ParametroProtocolloDiz> listaDiz = parametroProtocolloDizRepository.findAllByModulo(EGruppo.ANA.name())

        Map<String, String> tempMap = [:]
        for (ParametroProtocolloDiz diz : listaDiz) {
            if (diz.codiceFase == codiceFase) {
                tempMap.put(diz.codiceFaseAnagrafe, diz.descrizioneFaseAnagrafe)
            }
        }
        //ordina la mappa per valore
        mapCodiciFaseAnagrafe.putAll(tempMap.toSorted(new Comparator<Map.Entry<String, String>>() {
            @Override
            int compare(Map.Entry<String, String> e1, Map.Entry<String, String> e2) {
                return e1.value <=> e2.value
            }
        }))

        return mapCodiciFaseAnagrafe
    }

    /**
     * Carica i modelli filtrati per tipoModello basato su codiceFase
     * @param codiceFase il codice fase ('C' o 'P')
     * @return lista di modelli filtrati
     */
    List<AnaModello> getModelliByCodiceFase(String codiceFase) {
        ETipoModello tipoModello = ETipoModello.valueOf(codiceFase)
        return anaModelloService.findAllByTipoModello(tipoModello)
    }

    void calcolaFaseEFunzione(AnaParametroProtocollo p) {
        p.funzione = ParametroProtocolloDiz.CODICE_FASE_W + p.modello.codModello
        p.fase = p.codiceFaseAnagrafe
    }

    Page<AnaParametroProtocollo> listAllByCodiceFase(String codiceFase, Pageable p) {
        anaParametroProtocolloRepository.findAllByCodiceFase(codiceFase, p)
    }

    void validaDati(ETipoOperazione tipoOperazione, AnaParametroProtocollo obj) {
        if(obj.codiceFase == null || obj.descrizioneFase == null || obj.modello == null) {
            throw new CampoMandatoryRuntimeException()
        }

        // Verifica duplicati
        if (tipoOperazione.isInsert()) {
            long n = anaParametroProtocolloRepository.countByFaseAndFunzione(obj.fase, obj.funzione)
            if (n > 0) {
                throw new RecordDuplicatoRuntimeException(Etichette.getEtichetta("Errore_Inserimento_Record_duplicato"))
            }
        }

    }

    AnaParametroProtocollo save(ETipoOperazione tipoOperazione, AnaParametroProtocollo obj) {
        validaDati(tipoOperazione, obj)

        if (tipoOperazione == ETipoOperazione.INS) {
            obj.id = gsdService.getIdFromSequence(obj, "PARAMETRI_PROTOCOLLO")
        }

        anaParametroProtocolloRepository.save(obj)
    }

    void delete(AnaParametroProtocollo obj) {
        log.info("Tento cancellazione su PARAMETRO_PROTOCOLLO_V_ANA per id " + obj.id)
        anaParametroProtocolloRepository.delete(obj)
    }

}