package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivRubricaNascite
import it.finmatica.de4gsdzk.utils.ESesso
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivRubricaNasciteRepository extends JpaRepository<CivRubricaNascite, Long> {

    @Query("""SELECT 1 FROM CivRubricaNascite c 
                        WHERE (:id IS NULL OR c.id != :id) 
                        AND c.attoNascita.anno = :anno 
                        AND c.attoNascita.atto = :atto  
                        AND c.attoNascita.parte = :parte 
                        AND (:serie IS NULL OR c.attoNascita.serie = :serie) 
                        AND (:ufficio IS NULL OR c.attoNascita.ufficio = :ufficio) 
                        AND (:idAttoAnsc IS NULL OR c.attoNascita.idAttoAnsc = :idAttoAnsc) 
                        AND c.codiceComuneAttoNascita = :codiceComuneAtto 
                        AND c.codiceProvinciaAttoNascita = :codiceProvinciaAtto """)
    Integer existsByUkAtto(@Param("id") Long id,
                           @Param("anno") Integer anno,
                           @Param("atto") Integer atto,
                           @Param("parte") Integer parte,
                           @Param("serie") String serie,
                           @Param("ufficio") Integer ufficio,
                           @Param("idAttoAnsc") String idAttoAnsc,
                           @Param("codiceComuneAtto") Integer codiceComuneAtto,
                           @Param("codiceProvinciaAtto") Integer codiceProvinciaAtto)

    @Query("""SELECT c
            FROM CivRubricaNascite c 
            WHERE (:annoRegistrazione IS NULL OR c.annoRegistrazione = :annoRegistrazione)
            AND (:annoRegistrazioneDa IS NULL OR c.annoRegistrazione >= :annoRegistrazioneDa)
            AND (:annoRegistrazioneA IS NULL OR c.annoRegistrazione <= :annoRegistrazioneA)
            AND (:codiceComuneAttoNascita IS NULL OR (
                c.codiceComuneAttoNascita = :codiceComuneAttoNascita AND
                c.codiceProvinciaAttoNascita = :codiceProvinciaAttoNascita))
            AND (:ufficio IS NULL OR c.attoNascita.ufficio = :ufficio)
            AND (:anno IS NULL OR c.attoNascita.anno = :anno)
            AND (:atto IS NULL OR c.attoNascita.atto = :atto)
            AND (:parte IS NULL OR c.attoNascita.parte = :parte)
            AND (:serie IS NULL OR c.attoNascita.serie = :serie)
            AND (:idAttoAnsc IS NULL OR c.attoNascita.idAttoAnsc = :idAttoAnsc)
            AND (:sesso IS NULL OR c.sesso = :sesso)
            AND (:dataNascitaDa IS NULL OR c.dataNascita >= :dataNascitaDa)
            AND (:dataNascitaA IS NULL OR c.dataNascita <= :dataNascitaA)
            AND (:dataRegistrazioneDa IS NULL OR c.dataRegistrazione >= :dataRegistrazioneDa)
            AND (:dataRegistrazioneA IS NULL OR c.dataRegistrazione <= :dataRegistrazioneA)
            AND (:cognome IS NULL OR UPPER(c.cognome) LIKE :cognome)  
            AND (:nome IS NULL OR UPPER(c.nome) LIKE :nome)""")
    Page<CivRubricaNascite> findAll(
            @Param("annoRegistrazione") Integer annoRegistrazione,
            @Param("annoRegistrazioneDa") Integer annoRegistrazioneDa,
            @Param("annoRegistrazioneA") Integer annoRegistrazioneA,
            @Param("codiceComuneAttoNascita") Integer codiceComuneAttoNascita,
            @Param("codiceProvinciaAttoNascita") Integer codiceProvinciaAttoNascita,
            @Param("ufficio") Integer ufficio,
            @Param("anno") Integer anno,
            @Param("atto") Integer atto,
            @Param("parte") Integer parte,
            @Param("serie") String serie,
            @Param("idAttoAnsc") String idAttoAnsc,
            @Param("sesso") ESesso sesso,
            @Param("dataNascitaDa") Date dataNascitaDa,
            @Param("dataNascitaA") Date dataNascitaA,
            @Param("dataRegistrazioneDa") Date dataRegistrazioneDa,
            @Param("dataRegistrazioneA") Date dataRegistrazioneA,
            @Param("cognome") String cognome,
            @Param("nome") String nome, Pageable pageable)

}


