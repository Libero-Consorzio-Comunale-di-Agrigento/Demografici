package it.finmatica.de4gsdzk.anagrafe

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.utils.ETipoPratica
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnaSoggettoModelloApr4Repository extends JpaRepository<AnaSoggettoModelloApr4, String> {

    @Query("""SELECT a FROM AnaSoggettoModelloApr4 a 
              WHERE a.numeroDic = :numeroDic 
              AND a.annoDic = :annoDic 
              AND a.tipoEvento = :tipoPratica
              ORDER BY a.p1_1""")
    List<AnaSoggettoModelloApr4> findAllByNumeroDicAndAnnoDicAndTipoEvento(@Param("numeroDic") Integer numeroDic,
                                                                           @Param("annoDic") Integer annoDic,
                                                                           @Param("tipoPratica") ETipoPratica tipoPratica)

    List<AnaSoggettoModelloApr4> findAllByNumeroDicAndAnnoDic(Integer numeroDic, Integer annoDic)
}