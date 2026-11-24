package it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.RecordDuplicatoRuntimeException
import it.finmatica.de4gsdzk.utils.ETipoOperazione
import it.finmatica.de4gsdzk.utils.Etichette
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnaCondizioneComunicazioneService {

    private final AnaCondizioneComunicazioneRepository anaCondizioneComunicazioneRepository

    private final GsdService gsdService

    AnaCondizioneComunicazioneService(AnaCondizioneComunicazioneRepository anaCondizioneComunicazioneRepository,
                                      GsdService gsdService) {

        this.anaCondizioneComunicazioneRepository = anaCondizioneComunicazioneRepository
        this.gsdService = gsdService

    }

    List<AnaCondizioneComunicazione> findAllByComunicazione(AnaComunicazione comunicazione){
        return anaCondizioneComunicazioneRepository.findAllByComunicazione(comunicazione)
    }

    AnaCondizioneComunicazione findById(Integer id) {
        return anaCondizioneComunicazioneRepository.findById(id)
    }

    AnaCondizioneComunicazione findByUk(Integer codiceCondizione, Integer idCom) {
        return anaCondizioneComunicazioneRepository.findByUk(codiceCondizione, idCom)
    }

    long countByCondizioneSqlAndComunicazione(AnaCondizioneSql condizione, AnaComunicazione comunicazione) {
        return anaCondizioneComunicazioneRepository.countByCondizioneSqlAndComunicazione(condizione,comunicazione )
    }

    List<Integer> getCodiciCondizioneByComunicazione(Integer codcieCo) {
        return anaCondizioneComunicazioneRepository.getCodiciCondizioneByComunicazione(codcieCo)
    }

    private void validaDati(ETipoOperazione tipoOperazione, AnaCondizioneComunicazione condizione) {
        // Campi obbligatori
        if (condizione.condizioneSql == null || condizione.comunicazione == null) {
            throw new CampoMandatoryRuntimeException()
        }

        // Verifica duplicati
        if (tipoOperazione.isInsert()) {
            long count = countByCondizioneSqlAndComunicazione(
                    condizione.condizioneSql,
                    condizione.comunicazione
            )
            if (count > 0) {
                throw new RecordDuplicatoRuntimeException(Etichette.getEtichetta("Errore_Inserimento_Record_duplicato"))
            }
        }
    }

    AnaCondizioneComunicazione save(ETipoOperazione tipoOperazione, AnaCondizioneComunicazione condizione) {
        validaDati(tipoOperazione,condizione )

        if(tipoOperazione.isInsert()) {
            condizione.id = gsdService.getIntegerIdFromSequence(condizione, condizione.getTableName())
        }
        return anaCondizioneComunicazioneRepository.save(condizione)
    }
    void delete(AnaCondizioneComunicazione condizione) {
        anaCondizioneComunicazioneRepository.delete(condizione)
    }
}
