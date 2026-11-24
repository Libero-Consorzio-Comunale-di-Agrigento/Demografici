package it.finmatica.de4gsdzk.anagrafe

import groovy.transform.CompileStatic
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnaConvivenzaDiFattoRepository extends JpaRepository<AnaConvivenzaDiFatto, Integer> {

    @Query(""" SELECT o FROM AnaConvivenzaDiFatto o
               LEFT JOIN FETCH o.convivente
               WHERE o.id = :id""")
    AnaConvivenzaDiFatto findById(@Param('id') Integer id)

    @Query("""SELECT a FROM AnaConvivenzaDiFatto a
                LEFT JOIN FETCH a.convivente
                WHERE a.matricola = :id
                AND a.cognomeConvivente = :cognomeConvivente
                AND a.nomeConvivente = :nomeConvivente
                ORDER BY a.codCdf DESC""")
    List<AnaConvivenzaDiFatto> getCdF(@Param("id") Integer id,
                                @Param("cognomeConvivente") String cognomeConvivente,
                                @Param("nomeConvivente") String nomeConvivente)
}
