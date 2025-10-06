package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivCategoriaTipoAtto
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivCategoriaTipoAttoRepository extends JpaRepository<CivCategoriaTipoAtto, Integer>, CivCategoriaTipoAttoCustomRepository {

    List<CivCategoriaTipoAtto> findAllByIdIn(List<Integer> ids)

    @Query("""SELECT n FROM CivCategoriaTipoAtto n 
                WHERE n.tipoAtto = :tipoAtto 
                  AND n.flagFormule IS NULL 
                  AND (COALESCE(n.flagAnsc, :flagAnsc) IS NULL OR n.flagAnsc = :flagAnsc)
              ORDER BY n.descrizione ASC""")
    List<CivCategoriaTipoAtto> findAllByTipoAttoAndFlagFormuleIsNullAndFlagAnscOrderByDescrizione(@Param("tipoAtto") Integer tipoAtto, @Param("flagAnsc") Boolean flagAnsc)

}