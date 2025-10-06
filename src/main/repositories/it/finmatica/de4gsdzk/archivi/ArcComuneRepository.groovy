package it.finmatica.de4gsdzk.archivi

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.archivi.ArcComune
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface ArcComuneRepository extends JpaRepository<ArcComune, String> {

    ArcComune findByCodiceComuneAndCodiceProvincia(Integer codiceComune, Integer codiceProvincia)

    long countByCodiceComuneAndCodiceProvincia(Integer codiceComune, Integer codiceProvincia)

    List<ArcComune> findAllByCodiceComuneFusioneAndCodiceProvinciaFusione(Integer codiceComune, Integer codiceProvincia)

    Page<ArcComune> findAllByDescrizioneComuneLikeIgnoreCase(String filtro, Pageable pageable)

    Page<ArcComune> findAllByIdNotInAndDescrizioneComuneLikeIgnoreCase(List<String> ids, String filtro, Pageable pageable)

    Page<ArcComune> findAllByIdNotIn(List<String> ids, Pageable pageable)

}