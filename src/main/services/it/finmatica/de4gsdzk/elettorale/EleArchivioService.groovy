package it.finmatica.de4gsdzk.elettorale

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.utils.ETipoSiNo
import it.finmatica.de4gsdzk.utils.SqlUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class EleArchivioService {

    EleArchivioRepository eleArchivioRepository

    EleArchivioService(EleArchivioRepository eleArchivioRepository) {
        this.eleArchivioRepository = eleArchivioRepository
    }

    Page<EleArchivio> listAllByRicercaElettore(RicercaElettore r, Pageable pageable) {
        r.validaDati()
        return eleArchivioRepository.listAllByRicercaElettore(r.matricola,
                                                              SqlUtils.endsLike(r.cognome)?.toUpperCase(),
                                                              SqlUtils.endsLike(r.nome)?.toUpperCase(),
                                                              r.sesso,
                                                              r.stato,
                                                              r.fascicoloDa,
                                                              r.fascicoloA,
                                                              r.anno,
                                                              r.sezioneDa,
                                                              r.sezioneA,
                                                              r.progressivoSezionaleDa,
                                                              r.progressivoSezionaleA,
                                                              r.progressivoGeneraleDa,
                                                              r.progressivoGeneraleA,
                                                              r.tesseraDa,
                                                              r.tesseraA,
                                                              r.dataTesseraDa,
                                                              r.dataTesseraA,
                                                              r.tipoLista,
                                                              (r.giacenza != null ? r.giacenza == ETipoSiNo.SI : null),
                                                              pageable)
    }
}
