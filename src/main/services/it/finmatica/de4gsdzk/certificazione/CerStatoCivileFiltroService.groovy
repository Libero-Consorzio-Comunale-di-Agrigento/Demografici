package it.finmatica.de4gsdzk.certificazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdAnagrafeBaseDomain
import it.finmatica.de4gsdzk.certificazione.CerStatoCivileFiltroRepository
import it.finmatica.de4gsdzk.utils.ETipoAtto
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CerStatoCivileFiltroService {

    private final CerStatoCivileFiltroRepository cerStatoCivileFiltroRepository

    CerStatoCivileFiltroService(CerStatoCivileFiltroRepository cerStatoCivileFiltroRepository) {
        this.cerStatoCivileFiltroRepository = cerStatoCivileFiltroRepository
    }

    List<CerStatoCivileFiltro> listAllByTipoAttoAndFiltroAndAnagrafe(ETipoAtto tipoAtto, CerFiltro filtro, GsdAnagrafeBaseDomain anagrafe) {
        cerStatoCivileFiltroRepository.findAllByTipoArchivioAndFiltroAndCognomeAndNomeAndDataNascitaAndSesso(tipoAtto.valore, filtro, anagrafe.cognome, anagrafe.nome, anagrafe.dataNascita, anagrafe.sesso)
    }
}
