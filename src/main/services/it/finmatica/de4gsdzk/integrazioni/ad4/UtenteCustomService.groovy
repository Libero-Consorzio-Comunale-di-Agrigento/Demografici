package it.finmatica.de4gsdzk.integrazioni.ad4

import groovy.util.logging.Slf4j
import it.finmatica.ad4.autenticazione.Ad4Utente
import it.finmatica.ad4.security.login.Ad4SpringSecurityService
import it.finmatica.de4gsdzk.ad4.UtenteCustomRepository
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import org.springframework.jdbc.core.JdbcTemplate
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

import javax.sql.DataSource

@Slf4j
@Transactional
@Service
class UtenteCustomService {

    private final Ad4SpringSecurityService ad4SpringSecurityService

    private final DataSource dataSource

    private final JdbcTemplate jdbcTemplate

    private final UtenteCustomRepository utenteCustomRepository

    UtenteCustomService(JdbcTemplate jdbcTemplate, DataSource dataSource, UtenteCustomRepository utenteCustomRepository,
                        Ad4SpringSecurityService ad4SpringSecurityService) {

        this.jdbcTemplate = jdbcTemplate
        this.dataSource = dataSource
        this.utenteCustomRepository = utenteCustomRepository
        this.ad4SpringSecurityService = ad4SpringSecurityService
    }

    String getLinguaByUtente(String utente) {
        NamedParameterJdbcTemplate np = new NamedParameterJdbcTemplate(dataSource)
        String sqlStatement = "SELECT CASE WHEN LINGUA = '*' THEN 'I' ELSE LINGUA END AS LINGUA FROM AD4_UTENTI WHERE UTENTE = :utente"
        MapSqlParameterSource sqlparams = new MapSqlParameterSource()
        sqlparams.addValue("utente", utente)
        Map<String, Object> lm = np.queryForMap(sqlStatement, sqlparams)
        if (!lm) {
            log.error('lingua utente non trovata:{}', utente)
        }
        return lm?.LINGUA?.toString()
    }

    String getLoggedUserId(){
        return ad4SpringSecurityService.getAuthentication().principal.id
    }

    String getLoggedUserUsername(){
        return ad4SpringSecurityService.getAuthentication().getPrincipal().getUsername()
    }

    Ad4Utente getLoggedUser(){
        Ad4Utente u = ad4SpringSecurityService.getCurrentUser()
        return u
    }

    void updatePassword(String oldPassword, String newPassword, String confermaPassword){
        if (!ad4SpringSecurityService.isLoggedIn()) {
            throw new De4gsdzkRuntimeException("Cambio password non consentito agli utenti non autenticati")
        }

        if (newPassword == oldPassword){
            throw new De4gsdzkRuntimeException("Cambio password fallito")
        }

        if (newPassword != confermaPassword){
            throw new De4gsdzkRuntimeException("Cambio password fallito")
        }

        //checkPassword(newPassword)

        throw new De4gsdzkRuntimeException("Cambio password fallito")
    }

    /*private void checkPassword(String pwd){

    }*/

}
