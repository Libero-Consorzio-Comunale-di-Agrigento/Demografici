package it.finmatica.de4gsdzk.anagrafe

import groovy.transform.CompileStatic
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnaConvivenzaDiFattoRepository extends JpaRepository<AnaConvivenzaDiFatto, Long> {
    @Query(""" SELECT o FROM AnaConvivenzaDiFatto o
                  WHERE o.id = :id""")
    AnaConvivenzaDiFatto findById(@Param('id') Long id)
}
