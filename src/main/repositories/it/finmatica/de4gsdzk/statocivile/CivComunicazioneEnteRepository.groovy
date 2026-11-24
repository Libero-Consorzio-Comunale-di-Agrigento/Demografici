package it.finmatica.de4gsdzk.statocivile


import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface CivComunicazioneEnteRepository extends JpaRepository<CivComunicazioneEnte, Long> {

    @Query("SELECT ce FROM CivComunicazioneEnte ce JOIN FETCH ce.comunicazione c JOIN FETCH ce.ente e WHERE ce.id = :id ")
    CivComunicazioneEnte findById(@Param("id") Long id)

    CivComunicazioneEnte findByTipoAttoAndComunicazioneAndEnte(Integer tipoAtto, CivComunicazione comunicazione, CivEnte ente)

    @Query(value = """
              SELECT ce FROM CivComunicazioneEnte ce 
                JOIN FETCH ce.comunicazione c JOIN FETCH ce.ente e 
               WHERE ce.tipoAtto = :tipoAtto 
                 AND ce.comunicazione = :comunicazione""",
            countQuery = """SELECT count(ce) FROM CivComunicazioneEnte ce  
                              JOIN ce.comunicazione c JOIN ce.ente e 
                             WHERE ce.tipoAtto = :tipoAtto AND ce.comunicazione = :comunicazione  """ )
    Page<CivComunicazioneEnte> findAllByTipoAttoAndComunicazione(@Param("tipoAtto") tipoAtto, @Param("comunicazione") comunicazione, Pageable pageable)

    @Query(value = """
        SELECT ce FROM CivComunicazioneEnte ce 
          JOIN FETCH ce.comunicazione c JOIN FETCH ce.ente e 
         WHERE ce.tipoAtto = :tipoAtto""",
            countQuery = """SELECT count(ce) FROM CivComunicazioneEnte ce  
                          JOIN ce.comunicazione c JOIN ce.ente e 
                         WHERE ce.tipoAtto = :tipoAtto """ )
    Page<CivComunicazioneEnte> findAllByTipoAtto(@Param("tipoAtto") Integer tipoAtto, Pageable pageable)

}