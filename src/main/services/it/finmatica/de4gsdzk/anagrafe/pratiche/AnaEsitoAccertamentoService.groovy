package it.finmatica.de4gsdzk.anagrafe.pratiche


import it.finmatica.de4gsdzk.utils.ETipoPratica
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import org.zkoss.zhtml.Filedownload

@Transactional
@Service
class AnaEsitoAccertamentoService {

    private final AnaEsitoAccertamentoRepository anaEsitoAccertamentoRepository

    AnaEsitoAccertamentoService(AnaEsitoAccertamentoRepository anaEsitoAccertamentoRepository) {
        this.anaEsitoAccertamentoRepository = anaEsitoAccertamentoRepository
    }

    Page<AnaEsitoAccertamento> findAllByTipoPratica(ETipoPratica tipoPratica, PageRequest p) {
        return anaEsitoAccertamentoRepository.findAllByTipoPratica(tipoPratica, p)

    }

    static void downloadDocumenti(AnaEsitoAccertamento accertamento) {
        Filedownload.save(accertamento.blobAllegato, null, accertamento.nomeAllegato ?: "${accertamento.tipoPratica.getEtichettaDesc()}_${accertamento.id}")
    }


}
