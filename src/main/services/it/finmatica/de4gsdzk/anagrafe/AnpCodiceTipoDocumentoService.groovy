package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.utils.SortUtils
import org.springframework.data.domain.Sort
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnpCodiceTipoDocumentoService {

    private final AnpCodiceTipoDocumentoRepository anpCodiceTipoDocumentoRepository

    AnpCodiceTipoDocumentoService(AnpCodiceTipoDocumentoRepository anpCodiceTipoDocumentoRepository) {
        this.anpCodiceTipoDocumentoRepository = anpCodiceTipoDocumentoRepository
    }

    List<AnpCodiceTipoDocumento> listAll() {
        return anpCodiceTipoDocumentoRepository.findAll(new Sort(SortUtils.codiceAsc))
    }

    AnpCodiceTipoDocumento get(Integer codice) {
        return anpCodiceTipoDocumentoRepository.findByCodice(codice)
    }
}