package it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni

import groovy.transform.CompileStatic
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnaCondizioneComunicazioneRepository extends JpaRepository<AnaCondizioneComunicazione, Integer> {

    @Query("""SELECT c FROM AnaCondizioneComunicazione c
                JOIN FETCH c.comunicazione
                JOIN FETCH c.condizioneSql
                WHERE c.id = :id """)
    AnaCondizioneComunicazione findById(@Param("id") Integer id)

    @Query("""SELECT c FROM AnaCondizioneComunicazione c
                JOIN FETCH c.comunicazione
               WHERE c.condizioneSql.id = :codiceCondizione AND c.comunicazione.id = :idCom """)
    AnaCondizioneComunicazione findByUk(@Param("codiceCondizione") Integer codiceCondizione, @Param("idCom") Integer idCom)

    @Query("""SELECT c
              FROM AnaCondizioneComunicazione c
              INNER JOIN FETCH c.comunicazione
              INNER JOIN FETCH c.condizioneSql
              WHERE c.comunicazione = :comunicazione""")
    List<AnaCondizioneComunicazione> findAllByComunicazione(@Param("comunicazione") AnaComunicazione comunicazione)

    long countByCondizioneSqlAndComunicazione(AnaCondizioneSql condizione, AnaComunicazione comunicazione)

    @Query("""SELECT c.condizioneSql.id
              FROM AnaCondizioneComunicazione c
              INNER JOIN c.condizioneSql
              WHERE c.comunicazione.id = :codiceCo""")
    List<Integer> getCodiciCondizioneByComunicazione(@Param("codiceCo") Integer codiceCo)
}