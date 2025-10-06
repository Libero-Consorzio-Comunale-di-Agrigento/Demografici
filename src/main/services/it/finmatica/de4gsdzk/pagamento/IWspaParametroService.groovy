package it.finmatica.de4gsdzk.pagamento


import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest

interface IWspaParametroService {

    @Deprecated
    WspaParametro create()

    void sincronizza()

    WspaParametro get(String id)

    Page<WspaParametro> listAllByDescrizioneLike(String parametroLike, PageRequest p)

    WspaParametro save(WspaParametro obj)

    void delete(WspaParametro obj)
}
