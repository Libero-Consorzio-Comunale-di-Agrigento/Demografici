package it.finmatica.de4gsdzk.anagrafe

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.anagrafe.AnaTipoDocumento
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnaTipoDocumentoRepository extends JpaRepository<AnaTipoDocumento, String> {

    AnaTipoDocumento findById(@Param("id") String id)

    Page<AnaTipoDocumento> findAllByDescrizioneEstesaLikeIgnoreCaseAndFlagIdentitaIsTrue(String filtro, Pageable pageable)

    Page<AnaTipoDocumento> findAllByDescrizioneEstesaLikeIgnoreCaseAndFlagRiconoscimentoIsTrue(String filtro, Pageable pageable)

    Page<AnaTipoDocumento> findAllByDescrizioneEstesaLikeIgnoreCaseAndIdIn(String filtro, List<String> ids, Pageable pageable)

}