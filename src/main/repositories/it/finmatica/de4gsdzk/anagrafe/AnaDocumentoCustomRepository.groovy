package it.finmatica.de4gsdzk.anagrafe


import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable

interface AnaDocumentoCustomRepository {
    Page<AnaDocumento> findAllByAnagrafe(RicercaDocumento r, Pageable pageable)

    long countByAnagrafe(RicercaDocumento r)
}