package it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni

import it.finmatica.de4gsdzk.anagrafe.ETipoAnagrafe
import it.finmatica.de4gsdzk.utils.ETipoPratica
import org.springframework.data.domain.Page

interface AnaArchivioComunicazioneCustomRepository {

    Page<AnaArchivioComunicazione> listByParams(Map params)

    List<AnaArchivioComunicazione> listAllByUkPratica(ETipoAnagrafe anagrafe, ETipoPratica tipoPratica, Integer numeroPratica, Integer annoPratica, Map params)
}