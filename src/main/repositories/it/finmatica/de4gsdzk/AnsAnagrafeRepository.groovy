package it.finmatica.de4gsdzk

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.utils.EArchivioSorgenteSoggetto
import it.finmatica.de4gsdzk.utils.ESesso
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnsAnagrafeRepository extends JpaRepository<AnsAnagrafe, String> {

    AnsAnagrafe findById(String id)

    @Query(value = """SELECT c FROM AnsAnagrafe c 
                            LEFT OUTER JOIN FETCH c.nazionalita
                        WHERE (:cognome IS NULL OR c.cognomeRicerca LIKE :cognome)  
                          AND (:nome IS NULL OR c.nomeRicerca LIKE :nome)
                          AND (:codiceFiscale IS NULL OR c.codiceFiscale LIKE :codiceFiscale)
                          AND (:sesso IS NULL OR c.sesso = :sesso)
                          AND (:dataNascitaDal IS NULL OR c.dataNascita >= :dataNascitaDal)
                          AND (:dataNascitaAl IS NULL OR c.dataNascita <= :dataNascitaAl)
                          AND (:archivio IS NULL OR c.archivio = :archivio) """,
            countQuery = """SELECT COUNT(c) FROM AnsAnagrafe c 
                                LEFT OUTER JOIN c.nazionalita
                            WHERE (:cognome IS NULL OR c.cognomeRicerca LIKE :cognome)  
                              AND (:nome IS NULL OR c.nomeRicerca LIKE :nome)
                              AND (:codiceFiscale IS NULL OR c.codiceFiscale LIKE :codiceFiscale)
                              AND (:sesso IS NULL OR c.sesso = :sesso)
                              AND (:dataNascitaDal IS NULL OR c.dataNascita >= :dataNascitaDal)
                              AND (:dataNascitaAl IS NULL OR c.dataNascita <= :dataNascitaAl)
                              AND (:archivio IS NULL OR c.archivio = :archivio) """)
    Page<AnsAnagrafe> findAll(
            @Param("cognome") String cognome,
            @Param("nome") String nome,
            @Param("codiceFiscale") String codiceFiscale,
            @Param("sesso") ESesso sesso,
            @Param("dataNascitaDal") Date dataNascitaDal,
            @Param("dataNascitaAl") Date dataNascitaAl,
            @Param("archivio") EArchivioSorgenteSoggetto archivio,
            Pageable pageable)
}