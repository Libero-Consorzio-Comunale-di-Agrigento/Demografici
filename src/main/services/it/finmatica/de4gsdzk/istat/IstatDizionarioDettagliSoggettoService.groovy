package it.finmatica.de4gsdzk.istat


import it.finmatica.de4gsdzk.utils.ETipoArchivioIstat
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class IstatDizionarioDettagliSoggettoService {

    private final IstatDizionarioDettagliSoggettoRepository istatDizionarioDettagliSoggettoRepository

    IstatDizionarioDettagliSoggettoService(IstatDizionarioDettagliSoggettoRepository istatDizionarioDettagliSoggettoRepository) {
        this.istatDizionarioDettagliSoggettoRepository = istatDizionarioDettagliSoggettoRepository
    }

    List<IstatDizionarioDettagliSoggetto> findAllByArchivioAndData(ETipoArchivioIstat tipoArchivioIstat, Date data) {
        return istatDizionarioDettagliSoggettoRepository.findAllByArchivioAndData(tipoArchivioIstat.id, data)
    }

}
