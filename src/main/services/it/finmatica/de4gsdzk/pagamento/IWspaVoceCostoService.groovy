package it.finmatica.de4gsdzk.pagamento


import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest

interface IWspaVoceCostoService {

    WspaVoceCosto create()

    void sincronizza()

    WspaVoceCosto get(Long id)

    Page<WspaVoceCosto> listAllByDescrizioneLike(String parametroLike, PageRequest p)

    WspaVoceCosto save(WspaVoceCosto obj)

    void delete(WspaVoceCosto obj)
}
