package it.finmatica.de4gsdzk.certificazione

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.certificazione.CerTerminalista
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.domain.Sort
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CerTerminalistaRepository extends JpaRepository<CerTerminalista, String> {

    CerTerminalista findById(String id)

    CerTerminalista findByIdAndUtenteFirmaRemotaNotNullAndPwdFirmaRemotaNotNull(String id)

    List<CerTerminalista> findAllByUtenteFirmaRemotaNotNullAndPwdFirmaRemotaNotNull(Sort s)

    Page<CerTerminalista> findAllByIdLikeIgnoreCaseOrCognomeLikeIgnoreCaseOrNomeLikeIgnoreCase(String filtroId, String filtroCognome, String filtroNome, Pageable pageable)

    Page<CerTerminalista> findAllByIdLikeIgnoreCaseOrCognomeNomeLikeIgnoreCase(String filtroId, String filtroCognomeNome, Pageable pageable)

    long countById(String idTerminalista)

}