package it.finmatica.de4gsdzk.ansc


import it.finmatica.de4gsdzk.ansc.AnscMotivoEsenzioneBollo
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface AnscMotivoEsenzioneBolloRepository extends JpaRepository<AnscMotivoEsenzioneBollo, String> {
    @Query("""SELECT o FROM AnscMotivoEsenzioneBollo o 
                WHERE (:filtro IS NULL OR UPPER(o.descrizione) LIKE UPPER(:filtro) ) """)
    Page<AnscMotivoEsenzioneBollo> findAllByDescrizioneLikeIgnoreCase(@Param("filtro") String filtro, Pageable p)
}