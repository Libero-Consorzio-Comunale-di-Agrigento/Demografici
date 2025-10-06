package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.NumeroProtocolloException
import it.finmatica.de4gsdzk.statocivile.CivDisposizioniAnticipateTrattamentoRepository
import it.finmatica.de4gsdzk.utils.ETipoSN
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi
import it.finmatica.de4gsdzk.utils.ValidationUtils
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivDisposizioniAnticipateTrattamentoService {

    private final CivDisposizioniAnticipateTrattamentoRepository civDisposizioniAnticipateTrattamentoRepository

    private final StatoCivileService statoCivileService

    private final CivNumerazioneDocumentiEntrataService civNumerazioneDocumentiEntrataService

    CivDisposizioniAnticipateTrattamentoService(CivDisposizioniAnticipateTrattamentoRepository civDisposizioniAnticipateTrattamentoRepository,
                                                CivNumerazioneDocumentiEntrataService civNumerazioneDocumentiEntrataService,
                                                StatoCivileService statoCivileService) {
        this.civDisposizioniAnticipateTrattamentoRepository = civDisposizioniAnticipateTrattamentoRepository
        this.civNumerazioneDocumentiEntrataService = civNumerazioneDocumentiEntrataService
        this.statoCivileService = statoCivileService
    }

    CivDisposizioniAnticipateTrattamento get(Integer id) {
        return civDisposizioniAnticipateTrattamentoRepository.findById(id)
    }

    private void validaDati(CivDisposizioniAnticipateTrattamento obj) {
        ValidationUtils.validaDatiObbligatori(obj)

        if (obj.tipoAttoDAT == null) {
            throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_tipo_atto)
        }
        if ( (obj.tipoAttoDAT.id.intValue() == 99) && ( (obj.noteTipoAtto?:"") == "")){
            throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_note)
        }

        if (obj.consensoInvioDAT == null) {
            throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Errore_Consenso_Invio_DAT)
        }

        if ( (obj.consensoInvioDAT == ETipoSN.N) && (!((obj.reperibilitaDAT?:"").trim())) ){
            throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Errore_Reperibilita_DAT)
        }

        if ( (!((obj.disponente.cognome?:"").trim())) ||
             (!((obj.disponente.nome?:"").trim())) ||
             (!(obj.disponente.sesso)) ||
             (!(obj.disponente.dataNascita)) ||
             (!((obj.disponente.codiceFiscale?:"").trim())) ||
             (obj.disponente.comuneNascita.codice == null) ||
             (obj.disponente.comuneNascita.codiceProvincia == null) ) {
            throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Errore_Disponente_DAT)
        }

        if ( obj.disponente.cognome || obj.disponente.nome ) {
            if (obj.disponente.consensoTrattamento == null) {
                throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Errore_Consenso_Disponente)
            }
        }

        if ( obj.fiduciario1.cognome || obj.fiduciario1.nome ){
            if (obj.fiduciario1.sottoscrittoDAT == null){
                throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Errore_Sottoscrizione_DAT_Fiduciario_1)
            }
            if (obj.fiduciario1.consensoTrattamento == null){
                throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Errore_Consenso_Fiduciario_1)
            }
        }

        if ( obj.fiduciario2.cognome || obj.fiduciario2.nome ){
            if (obj.fiduciario2.sottoscrittoDAT == null){
                throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Errore_Sottoscrizione_DAT_Fiduciario_2)
            }
            if (obj.fiduciario2.consensoTrattamento == null){
                throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Errore_Consenso_Fiduciario_2)
            }
        }

        if ( (obj.protocollo.anno != null) && (obj.protocollo.numero != null) ){
            List<CivDisposizioniAnticipateTrattamento> listaDAT = civDisposizioniAnticipateTrattamentoRepository.findAllByIdNotAndProtocollo( obj.id, obj.protocollo.anno, obj.protocollo.numero)
            if (!listaDAT.isEmpty()) {
                throw new NumeroProtocolloException(obj.protocollo.numero, "", listaDAT)
            }
        }
    }

    CivDisposizioniAnticipateTrattamento save(CivDisposizioniAnticipateTrattamento obj, CivNumerazioneDocumentiEntrata nde) {
        validaDati(obj)

        if (obj.id == null) {
            // solo in caso di inserimento
            obj.id = statoCivileService.getIntegerIdFromSequence(obj)
        }

        if (nde){
            civNumerazioneDocumentiEntrataService.save(nde)
        }

        log.info("Lancio salvataggio su CIVDAT per id " + obj.id)
        return civDisposizioniAnticipateTrattamentoRepository.save(obj)
    }

    void delete(CivDisposizioniAnticipateTrattamento obj){
        if (obj.id != null){
            log.info("Tento cancellazione su CIVDAT per id " + obj.id)
            civDisposizioniAnticipateTrattamentoRepository.delete(obj)
        }
    }
}
