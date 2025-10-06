package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.ansc.AnscParametro
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository

interface AnscParametroRepository extends JpaRepository<AnscParametro, String> {

    AnscParametro findById(String id)

    Page<AnscParametro> findAllByFlagVisibileTrueAndIdLike(String parametro, Pageable pageable)

    List<AnscParametro> findAllByIdIn(List<String> lista)

}