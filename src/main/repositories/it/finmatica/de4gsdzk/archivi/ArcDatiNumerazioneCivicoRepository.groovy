package it.finmatica.de4gsdzk.archivi

import groovy.transform.CompileStatic
import org.springframework.data.domain.Sort
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface ArcDatiNumerazioneCivicoRepository extends JpaRepository<ArcDatiNumerazioneCivico, Long> {

    List<ArcDatiNumerazioneCivico> findAllByViaIsNullAndFlagVisibileTrueOrderBySequenza()

    List<ArcDatiNumerazioneCivico> findAllByViaIdAndFlagVisibileTrueOrderBySequenza(Long codVia)

    List<ArcDatiNumerazioneCivico> findAllByViaIsNull(Sort sort)

    @Query("SELECT d FROM ArcDatiNumerazioneCivico d JOIN FETCH d.via WHERE d.via.id = :codVia")
    List<ArcDatiNumerazioneCivico> findAllByViaId(@Param("codVia") Long codVia, Sort sort)

    @Query("SELECT d FROM ArcDatiNumerazioneCivico d JOIN FETCH d.via")
    List<ArcDatiNumerazioneCivico> findAllByViaIsNotNull(Sort sort)

    @Query("SELECT d FROM ArcDatiNumerazioneCivico d LEFT JOIN FETCH d.via WHERE d.id = :id")
    ArcDatiNumerazioneCivico findOneWithVia(@Param("id") Long id)

    boolean existsByViaIdAndElemento(Long codVia, String elemento)

    boolean existsByViaIsNullAndElemento(String elemento)
}
