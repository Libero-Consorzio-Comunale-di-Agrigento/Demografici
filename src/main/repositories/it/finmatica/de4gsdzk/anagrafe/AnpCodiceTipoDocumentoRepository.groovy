package it.finmatica.de4gsdzk.anagrafe

import org.springframework.data.domain.Sort
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@Repository
interface AnpCodiceTipoDocumentoRepository extends JpaRepository<AnpCodiceTipoDocumento, Integer> {

    AnpCodiceTipoDocumento findByCodice(Integer codice)

    List<AnpCodiceTipoDocumento> findAll(Sort sort)
}