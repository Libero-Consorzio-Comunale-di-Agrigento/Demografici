package it.finmatica.de4gsdzk.certificazione

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.certificazione.CerAnagrafeFiltro
import it.finmatica.de4gsdzk.utils.ESesso
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CerAnagrafeFiltroRepository extends JpaRepository<CerAnagrafeFiltro, Integer> {

    @Query(""" SELECT c FROM CerAnagrafeFiltro c
                    INNER JOIN FETCH c.categoriaTipoCertificato
                    LEFT JOIN FETCH c.filtro
                WHERE c.matricola = :matricola""")
    List<CerAnagrafeFiltro> findAllByMatricola(@Param("matricola") Integer matricola)

    @Query(""" SELECT c FROM CerAnagrafeFiltro c
                    INNER JOIN FETCH c.categoriaTipoCertificato
                    LEFT JOIN FETCH c.filtro
                WHERE c.matricola IS NULL
                  AND c.cognome = :cognome
                  AND c.nome = :nome
                  AND c.sesso = :sesso
                  AND (:dataNascita IS NULL OR c.dataNascita = :dataNascita) """)
    List<CerAnagrafeFiltro> findAllByCognomeAndNomeAndSessoAndDataNascita(@Param("cognome") String cognome,
                                                                          @Param("nome") String nome,
                                                                          @Param("sesso") ESesso sesso,
                                                                          @Param("dataNascita") Date dataNascita)
}