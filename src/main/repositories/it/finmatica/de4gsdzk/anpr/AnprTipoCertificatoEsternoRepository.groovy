package it.finmatica.de4gsdzk.anpr

import it.finmatica.de4gsdzk.anpr.AnprTipoCertificatoEsterno
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface AnprTipoCertificatoEsternoRepository extends JpaRepository<AnprTipoCertificatoEsterno, String> {

    @Query("""SELECT o FROM AnprTipoCertificatoEsterno o 
                WHERE (:filtro IS NULL OR UPPER(o.descrizione) LIKE UPPER(:filtro) ) """)
    Page<AnprTipoCertificatoEsterno> findAllByDescrizioneLikeIgnoreCase(@Param("filtro") String filtro, Pageable p)
}