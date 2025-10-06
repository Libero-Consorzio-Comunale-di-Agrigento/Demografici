package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.ansc.AnscSezione
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface AnscSezioneRepository extends JpaRepository<AnscSezione, Long> {

    @Query("""SELECT c FROM AnscSezione c
                      WHERE c.servizio = :servizio 
                        AND (:tipoAtto is null OR COALESCE(c.tipoAtto, :tipoAtto) = :tipoAtto)
                        AND (:idCdu is null OR COALESCE(c.useCase, :idCdu) = :idCdu)
                        AND c.livello = :livello
                        AND c.sezionePadre = :sezione
                      ORDER BY sequenza """)
    List<AnscSezione> findAllByServizioAndTipoAttoAndUseCaseAndLivelloAndSezionePadreOrderBySequenza(
            @Param("servizio") String servizio,
            @Param("tipoAtto") Integer tipoAtto,
            @Param("idCdu") Long idCdu,
            @Param("livello") Integer livello,
            @Param("sezione") AnscSezione sezione)

    @Query("""SELECT c FROM AnscSezione c 
                      WHERE (:tipoAtto is null OR COALESCE(c.tipoAtto, :tipoAtto) = :tipoAtto)
                        AND (:idCdu is null OR COALESCE(c.useCase, :idCdu) = :idCdu)
                        AND c.servizio = :servizio 
                        AND c.livello = :livello
                      ORDER BY sequenza """)
    List<AnscSezione> findAllByServizioAndTipoAttoAndUseCaseAndLivelloOrderBySequenza(@Param("servizio") String servizio,
                                                                                      @Param("tipoAtto") Integer tipoAtto,
                                                                                      @Param("idCdu") Long idCdu,
                                                                                      @Param("livello") Integer livello)

    List<AnscSezione> findAllByServizioIsNullAndTipoAttoIsNullAndUseCaseIsNullAndLivelloOrderBySequenza(Integer livello)

}