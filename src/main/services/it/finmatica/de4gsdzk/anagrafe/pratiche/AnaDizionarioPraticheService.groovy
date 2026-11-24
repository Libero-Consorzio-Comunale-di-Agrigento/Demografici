package it.finmatica.de4gsdzk.anagrafe.pratiche

import it.finmatica.de4gsdzk.anagrafe.ETipoAnagrafe
import it.finmatica.de4gsdzk.utils.ETipoPratica
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnaDizionarioPraticheService {

    private final AnaDizionarioPraticheRepository anaDizionarioPraticheRepository

    AnaDizionarioPraticheService(AnaDizionarioPraticheRepository anaDizionarioPraticheRepository) {
        this.anaDizionarioPraticheRepository = anaDizionarioPraticheRepository
    }

    List<AnaDizionarioPratiche> findAllByArchivioAnagrafeAndTipoPraticaAndCodiceArchivio(ETipoAnagrafe tipoArchivioAnagrafe, ETipoPratica tipoPratica, ETipoArchivioDizionario tipoArchivioDizionario) {
        return anaDizionarioPraticheRepository.findAllByArchivioAnagrafeAndTipoPraticaAndCodiceArchivioOrderBySequenza(tipoArchivioAnagrafe, tipoPratica, tipoArchivioDizionario)
    }

    AnaDizionarioPratiche findByCodiceAndArchivioAnagrafeAndTipoPraticaAndCodiceArchivio(String codice, ETipoAnagrafe tipoArchivioAnagrafe, ETipoPratica tipoPratica, ETipoArchivioDizionario tipoArchivioDizionario) {
        return anaDizionarioPraticheRepository.findByCodiceAndArchivioAnagrafeAndTipoPraticaAndCodiceArchivio(codice, tipoArchivioAnagrafe, tipoPratica, tipoArchivioDizionario)
    }
}
