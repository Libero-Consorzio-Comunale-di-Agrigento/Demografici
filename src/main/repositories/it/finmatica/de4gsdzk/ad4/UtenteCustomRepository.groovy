package it.finmatica.de4gsdzk.ad4

import groovy.transform.CompileStatic
import it.finmatica.ad4.autenticazione.Ad4Utente
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface UtenteCustomRepository extends JpaRepository<Ad4Utente, String> {

    @Query("SELECT distinct u FROM Ad4Utente u JOIN FETCH u.ruoli r WHERE u.tipoUtente = :tipoUtente AND r.ruolo IN (:ruoli) ORDER BY nominativo")
    List<Ad4Utente> findAllByTipoUtenteAndRuoliIn(@Param("tipoUtente") String tipoUtente, @Param("ruoli") List<String> ruoli)

    @Query("SELECT distinct u FROM Ad4Utente u JOIN FETCH u.ruoli r WHERE u.utente = :id")
    Ad4Utente findByUtenteFetchRuoli(@Param("id") String id)

    @Query("SELECT u FROM Ad4Utente u WHERE u.utente = :id")
    Ad4Utente findByUtente(@Param("id") String id)

}