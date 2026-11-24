package it.finmatica.de4gsdzk.anagrafe

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.utils.ESesso
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.domain.Sort
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnaAnagrafeRepository extends JpaRepository<AnaAnagrafe, Integer>, AnaAnagrafeCustomRepository {

    @Query("""SELECT a FROM AnaAnagrafe a WHERE a.cognome = :cognome AND a.nome = :nome 
                                            AND a.dataNascita = :dataNascita AND a.sesso = :sesso """)
    List<AnaAnagrafe> listXDatiAnagrafici(@Param("cognome") String cognome, @Param("nome") String nome,
                                          @Param("dataNascita") Date dataNascita, @Param("sesso") ESesso sesso)

    @Query("""SELECT a FROM AnaAnagrafe a WHERE a.cognome = :cognome AND a.nome = :nome 
                                            AND a.dataNascita = :dataNascita AND a.sesso = :sesso AND a.fascia = it.finmatica.de4gsdzk.anagrafe.EFascia.ISCRITTO_APR """)
    List<AnaAnagrafe> listXDatiAnagraficiSuResidenti(@Param("cognome") String cognome, @Param("nome") String nome,
                                                     @Param("dataNascita") Date dataNascita, @Param("sesso") ESesso sesso)

    @Query(value = """SELECT c FROM AnaAnagrafe c 
                        LEFT OUTER JOIN FETCH c.nazionalita
                        LEFT OUTER JOIN FETCH c.coniuge.anagrafe cc
                        LEFT OUTER JOIN FETCH cc.nazionalita
                       WHERE (:cognome IS NULL OR c.cognomeRicerca LIKE :cognome)  
                         AND (:nome IS NULL OR c.nomeRicerca LIKE :nome)
                         AND (:codiceFiscale IS NULL OR c.codiceFiscale LIKE :codiceFiscale)
                         AND (:sesso IS NULL OR c.sesso = :sesso)
                         AND (:dataNascita IS NULL OR c.dataNascita = :dataNascita) 
                         AND (:fascia IS NULL OR c.fascia = :fascia) """,
            countQuery = """SELECT count(c) FROM AnaAnagrafe c 
                              LEFT OUTER JOIN c.nazionalita 
                              LEFT OUTER JOIN c.coniuge.anagrafe cc
                              LEFT OUTER JOIN cc.nazionalita
                             WHERE (:cognome IS NULL OR c.cognomeRicerca LIKE :cognome)  
                               AND (:nome IS NULL OR c.nomeRicerca LIKE :nome)
                               AND (:codiceFiscale IS NULL OR c.codiceFiscale LIKE :codiceFiscale)
                               AND (:sesso IS NULL OR c.sesso = :sesso)
                               AND (:dataNascita IS NULL OR c.dataNascita = :dataNascita) 
                               AND (:fascia IS NULL OR c.fascia = :fascia) """)
    Page<AnaAnagrafe> findAll(
            @Param("cognome") String cognome,
            @Param("nome") String nome,
            @Param("codiceFiscale") String codiceFiscale,
            @Param("sesso") ESesso sesso,
            @Param("dataNascita") Date dataNascita,
            @Param("fascia") EFascia fascia,
            Pageable pageable)

    @Query(value = """SELECT c FROM AnaAnagrafe c 
                        LEFT OUTER JOIN FETCH c.nazionalita
                        LEFT OUTER JOIN FETCH c.famiglia
                        LEFT OUTER JOIN FETCH c.coniuge.anagrafe cc
                        LEFT OUTER JOIN FETCH cc.nazionalita
                       WHERE (:cognome IS NULL OR c.cognomeRicerca LIKE :cognome)  
                         AND (:nome IS NULL OR c.nomeRicerca LIKE :nome)
                         AND (:codiceFiscale IS NULL OR c.codiceFiscale LIKE :codiceFiscale)
                         AND (:sesso IS NULL OR c.sesso = :sesso)
                         AND (:dataNascitaDal IS NULL OR c.dataNascita >= :dataNascitaDal)
                         AND (:dataNascitaAl IS NULL OR c.dataNascita <= :dataNascitaAl)
                         AND (:matricola IS NULL OR c.id = :matricola)
                         AND (:idSoggettoAnpr IS NULL OR c.idSoggettoAnpr = :idSoggettoAnpr) 
                         AND (:idUnicoAnpr IS NULL OR c.idUnicoAnpr = :idUnicoAnpr) """,
            countQuery = """SELECT count(c) FROM AnaAnagrafe c
                             WHERE (:cognome IS NULL OR c.cognomeRicerca LIKE :cognome)
                               AND (:nome IS NULL OR c.nomeRicerca LIKE :nome)
                               AND (:codiceFiscale IS NULL OR c.codiceFiscale LIKE :codiceFiscale)
                               AND (:sesso IS NULL OR c.sesso = :sesso)
                               AND (:dataNascitaDal IS NULL OR c.dataNascita >= :dataNascitaDal)
                               AND (:dataNascitaAl IS NULL OR c.dataNascita <= :dataNascitaAl)
                               AND (:matricola IS NULL OR c.id = :matricola)
                               AND (:idSoggettoAnpr IS NULL OR c.idSoggettoAnpr = :idSoggettoAnpr)
                               AND (:idUnicoAnpr IS NULL OR c.idUnicoAnpr = :idUnicoAnpr)""")
    Page<AnaAnagrafe> findAllByRicercaIndividuo(
            @Param("cognome") String cognome,
            @Param("nome") String nome,
            @Param("codiceFiscale") String codiceFiscale,
            @Param("sesso") ESesso sesso,
            @Param("dataNascitaDal") Date dataNascitaDal,
            @Param("dataNascitaAl") Date dataNascitaAl,
            @Param("matricola") Integer matricola,
            @Param("idSoggettoAnpr") Long idSoggettoAnpr,
            @Param("idUnicoAnpr") String idUnicoAnpr,
            Pageable pageable)


    @Query(value = """SELECT c FROM AnaAnagrafe c 
                        LEFT OUTER JOIN FETCH c.nazionalita 
                        LEFT OUTER JOIN FETCH c.rapportoParentela 
                        LEFT OUTER JOIN FETCH c.famiglia 
                       WHERE c.famiglia = :famiglia 
                        AND ( :showCancellati = true 
                              OR c.fascia NOT IN (
                                  it.finmatica.de4gsdzk.anagrafe.EFascia.CANCELLATO_APR, 
                                  it.finmatica.de4gsdzk.anagrafe.EFascia.CANCELLATO_AIRE
                              )
                        ) """)
    List<AnaAnagrafe> findAllByFamiglia(@Param("famiglia") AnaFamiglia famiglia,
                                        @Param("showCancellati") boolean showCancellati,
                                        Sort sort)


    @Query(value = """SELECT c.famiglia FROM AnaStoricoFamiglia c
                       WHERE c.anagrafe.id = :id """)
    List<AnaFamiglia> findAllFamiglieById(@Param("id") Integer id)

    AnaAnagrafe findById(Integer id)

    @Query("""SELECT a FROM AnaAnagrafe a
              JOIN FETCH a.stato
              WHERE a.id = :id""")
    AnaAnagrafe findByIdWithStato(@Param("id") Integer id)

    @Query("""SELECT a FROM AnaAnagrafe a
                LEFT JOIN FETCH a.nazionalita
                LEFT JOIN FETCH a.madre
                LEFT JOIN FETCH a.padre
                LEFT JOIN FETCH a.famiglia
                LEFT JOIN FETCH a.coniuge c
                LEFT JOIN FETCH c.anagrafe
                LEFT JOIN FETCH a.rapportoParentela
                LEFT JOIN FETCH a.convivenzaDiFatto cdf
                LEFT JOIN FETCH cdf.convivente
                LEFT JOIN FETCH a.titoloStudio
                LEFT JOIN FETCH a.professione
                LEFT JOIN FETCH a.attivita
                LEFT JOIN FETCH a.posizioneProfessionale
                LEFT JOIN FETCH a.recapiti r
                LEFT JOIN FETCH r.tipoRecapito
                WHERE a.id = :id""")
    AnaAnagrafe findByIdSoggetto(@Param("id") Integer id)

    @Query("""SELECT a.possessoPatente
              FROM AnaAnagrafe a
              WHERE a.id = :id""")
    Boolean refreshFlagPatente(@Param("id") Integer id)

    @Query("""SELECT a.possessoCartaCircolazione
              FROM AnaAnagrafe a
              WHERE a.id = :id""")
    Boolean refreshFlagCC(@Param("id") Integer id)


    List<AnaAnagrafe> findAllByIdIn(List<Integer> matricole)

    @Query(value = """SELECT c FROM AnaAnagrafe c
                        LEFT OUTER JOIN FETCH c.nazionalita
                        LEFT OUTER JOIN FETCH c.rapportoParentela
                        LEFT OUTER JOIN FETCH c.famiglia
                        LEFT OUTER JOIN FETCH c.stato
                       WHERE c.famiglia = :famiglia
                        AND c.fascia NOT IN (
                                  it.finmatica.de4gsdzk.anagrafe.EFascia.CANCELLATO_APR,
                                  it.finmatica.de4gsdzk.anagrafe.EFascia.CANCELLATO_AIRE
                              ) """)
    List<AnaAnagrafe> findAllFamigliariAttiviByFamiglia(@Param("famiglia") AnaFamiglia famiglia,
                                                        Sort sort)
}