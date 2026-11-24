package it.finmatica.de4gsdzk.elettorale

import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface EleCandidatoWsRepository extends JpaRepository<EleCandidatoWs, Long> {

    @Query(
            value = """
            SELECT e FROM EleCandidatoWs e
            LEFT OUTER JOIN FETCH e.elezioneAds
            WHERE (:elezione IS NULL OR e.elezione = :elezione)
            AND (:elezioneAds IS NULL OR e.elezioneAds = :elezioneAds)
              AND (UPPER(e.cognome) LIKE UPPER(:filtro)
               OR UPPER(e.nome) LIKE UPPER(:filtro))
        """,
            countQuery = """
            SELECT COUNT(e) FROM EleCandidatoWs e
            WHERE (:elezione IS NULL OR e.elezione = :elezione)
            AND (:elezioneAds IS NULL OR e.elezioneAds = :elezioneAds)
              AND (UPPER(e.cognome) LIKE UPPER(:filtro)
               OR UPPER(e.nome) LIKE UPPER(:filtro))
        """
    )
    Page<EleCandidatoWs> findAllByElezioneAndElezioneAdsAndFiltroLike(@Param("elezione") EleElezione elezione,
                                                                      @Param("elezioneAds") De4Elezione elezioneAds,
                                                                      @Param("filtro") String filtro, Pageable pageable)
}
