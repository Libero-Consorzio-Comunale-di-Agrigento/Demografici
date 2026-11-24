package it.finmatica.de4gsdzk.elettorale

import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface EleComunicazioneWsRepository extends JpaRepository<EleComunicazioneWs, Long> {

    @Query(
            value = """
            SELECT e FROM EleComunicazioneWs e
            LEFT OUTER JOIN FETCH e.elezioneAds
            WHERE (:elezione IS NULL OR e.elezione = :elezione)
            AND (:elezioneAds IS NULL OR e.elezioneAds = :elezioneAds)
              AND UPPER(e.descrizione) LIKE UPPER(:filtro)
        """,
            countQuery = """
            SELECT COUNT(e) FROM EleComunicazioneWs e
            WHERE (:elezione IS NULL OR e.elezione = :elezione)
            AND (:elezioneAds IS NULL OR e.elezioneAds = :elezioneAds)
              AND UPPER(e.descrizione) LIKE UPPER(:filtro)
        """
    )
    Page<EleComunicazioneWs> findAllByElezioneAndElezioneAdsAndFiltroLike(@Param("elezione") EleElezione elezione,
                                                                          @Param("elezioneAds") De4Elezione elezioneAds,
                                                                          @Param("filtro") String filtro, Pageable pageable)
}
