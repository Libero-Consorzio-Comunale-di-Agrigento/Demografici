package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.ansc.AnscTipoCertificatoEsterno
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface AnscTipoCertificatoEsternoRepository extends JpaRepository<AnscTipoCertificatoEsterno, String> {

    @Query("""SELECT o FROM AnscTipoCertificatoEsterno o 
                WHERE (:filtro IS NULL OR UPPER(o.descrizione) LIKE UPPER(:filtro) ) """)
    Page<AnscTipoCertificatoEsterno> findAllByDescrizioneLikeIgnoreCase(@Param("filtro") String filtro, Pageable p)
}