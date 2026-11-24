package it.finmatica.de4gsdzk.anagrafe.pratiche

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafe
import it.finmatica.de4gsdzk.anagrafe.AnaDettaglioProvvedimento
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnaDettaglioProvvedimentoRepository extends JpaRepository<AnaDettaglioProvvedimento, Integer> {

    @Query(value = """SELECT a FROM AnaDettaglioProvvedimento a
                        LEFT JOIN FETCH a.ente
                        LEFT JOIN FETCH a.motivo
                        LEFT JOIN FETCH a.tipo
                        WHERE a.pratica = :pratica
                        AND a.soggetto = :soggetto""")
    AnaDettaglioProvvedimento findByPraticaAndSoggetto(@Param("pratica") AnaPratica pratica,
                                                       @Param("soggetto") AnaAnagrafe soggetto)

    @Query(value = """SELECT a FROM AnaDettaglioProvvedimento a
                        LEFT JOIN FETCH a.ente
                        LEFT JOIN FETCH a.motivo
                        LEFT JOIN FETCH a.tipo
                        WHERE a.archivioAnagrafe = 'ANP'
                        AND a.soggetto = :soggetto""")
    AnaDettaglioProvvedimento findBySoggettoANPR(@Param("soggetto") AnaAnagrafe soggetto)

}