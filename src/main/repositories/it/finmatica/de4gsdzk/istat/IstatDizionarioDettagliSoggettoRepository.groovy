package it.finmatica.de4gsdzk.istat


import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface IstatDizionarioDettagliSoggettoRepository extends JpaRepository<IstatDizionarioDettagliSoggetto, String> {

    @Query(value = """
    SELECT d.* 
    FROM ISTMAP_V_DIZ d
    WHERE  d.COD_ARCHIVIO = :archivioIstat
    AND :data BETWEEN d.D_DA_DATA AND d.D_A_DATA
    ORDER BY d.DESCRIZIONE ASC
    """, nativeQuery = true)
    List<IstatDizionarioDettagliSoggetto> findAllByArchivioAndData(
            @Param("archivioIstat") String archivioIstat,
            @Param("data") Date data
    )

}