package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ParametroProtocolloDiz
import it.finmatica.de4gsdzk.ParametroProtocolloDizRepository
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.utils.EGruppo
import it.finmatica.de4gsdzk.utils.ValidationUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivParametroProtocolloService {

    private final CivParametroProtocolloRepository civParametroProtocolloRepository

    private final ParametroProtocolloDizRepository parametroProtocolloDizRepository

    private final GsdService gsdService

    CivParametroProtocolloService(CivParametroProtocolloRepository civParametroProtocolloRepository,
                                  ParametroProtocolloDizRepository parametroProtocolloDizRepository,
                                  GsdService gsdService) {
        this.civParametroProtocolloRepository = civParametroProtocolloRepository
        this.parametroProtocolloDizRepository = parametroProtocolloDizRepository
        this.gsdService = gsdService
    }

    CivParametroProtocollo get(Long id) {
        return civParametroProtocolloRepository.findById(id)
    }

    /** Calcola la lista di tutti codici fase */
    Map<String, String> listAllCodiciFase() {
        Map<String, String> mapCodiciFase = [:]
        List<ParametroProtocolloDiz> listaDiz = parametroProtocolloDizRepository.findAllByModulo(EGruppo.CIV.name())
        for (ParametroProtocolloDiz diz : listaDiz) {
            mapCodiciFase.put(diz.getCodiceFase(), diz.getDescrizioneFase())
        }
        return mapCodiciFase
    }

    Map<String, String> getMapCodiciTipoAtto(String codiceFase) {
        Map<String, String> mapCodiciTipoAtto = [:]

        List<ParametroProtocolloDiz> listaDiz = parametroProtocolloDizRepository.findAllByModulo(EGruppo.CIV.name())

        Map<String, String> tempMap = [:]
        for (ParametroProtocolloDiz diz : listaDiz) {
            if (diz.codiceFase == codiceFase) {
                tempMap.put(diz.codiceTipoAtto, diz.descrizioneTipoAtto)
            }
        }
        //ordina la mappa per valore
        mapCodiciTipoAtto.putAll(tempMap.toSorted(new Comparator<Map.Entry<String, String>>() {
            @Override
            int compare(Map.Entry<String, String> e1, Map.Entry<String, String> e2) {
                return e1.value <=> e2.value
            }
        }))

        return mapCodiciTipoAtto
    }

    void calcolaFaseEFunzione(CivParametroProtocollo p) {
        if (p.codiceFase == ParametroProtocolloDiz.CODICE_FASE_W) {
            p.fase = ParametroProtocolloDiz.FASE_SCPW
            String codiceTipoAtto = p.codiceTipoAtto
            try {
                int tipoAtto = Integer.parseInt(p.codiceTipoAtto)
                if (tipoAtto == -4){
                    codiceTipoAtto = ParametroProtocolloDiz.CODICE_TIPO_ATTO_UCI
                }
                p.funzione = ParametroProtocolloDiz.CODICE_FASE_W + codiceTipoAtto + String.format("%02d", p.comunicazione.id)
            } catch(Exception e) {
                p.funzione = null
            }
        } else {
            p.fase = p.codiceFase + p.codiceTipoAtto
            p.funzione = p.fase
        }
    }

    Page<CivParametroProtocollo> listAllByCodiceFase(String codiceFase, Pageable p) {
        civParametroProtocolloRepository.findAllByCodiceFase(codiceFase, p)
    }

    void validaDati(CivParametroProtocollo obj) {
        ValidationUtils.validaDatiObbligatori(obj, [
                comunicazione: obj.codiceFase==ParametroProtocolloDiz.CODICE_FASE_W
        ])
    }

    CivParametroProtocollo save(CivParametroProtocollo obj) {
        validaDati(obj)

        if (obj.id == null) {
            obj.id = gsdService.getIdFromSequence(obj, "PARAMETRI_PROTOCOLLO")
        }

        civParametroProtocolloRepository.save(obj)
    }

    void delete(CivParametroProtocollo obj) {
        log.info("Tento cancellazione su PARAMETRO_PROTOCOLLO_V_CIV per id " + obj.id)
        civParametroProtocolloRepository.delete(obj)
    }

}
