package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.ansc.AnscCasoUsoNascita
import it.finmatica.de4gsdzk.utils.*
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface AnscCasoUsoNascitaRepository extends JpaRepository<AnscCasoUsoNascita, Long> {

    AnscCasoUsoNascita findById(Long id)

    AnscCasoUsoNascita findByTipoAttoAnscAndFlagServizioIsTrue(ETipoAttoAnsc tipoAttoAnsc)

    @Query("""SELECT c FROM AnscCasoUsoNascita c 
            WHERE COALESCE(c.codiceCategoria, :siglaCategoria) = :siglaCategoria
              AND c.tipoAttoAnsc = :tipoAttoAnsc
              AND c.flagVisibile = java.lang.Boolean.TRUE
              AND (:filtro IS NULL OR UPPER(c.descrizione) LIKE UPPER(:filtro) ) """)
    Page<AnscCasoUsoNascita> findAllByCategoriaAndTipoAttoAnscAndFlagVisibileIsTrueAndDescrizioneLike(@Param("filtro") String filtro,
                                                                                                      @Param("siglaCategoria") String siglaCategoria,
                                                                                                      @Param("tipoAttoAnsc") ETipoAttoAnsc tipoAttoAnsc,
                                                                                                      Pageable pageable)

    List<AnscCasoUsoNascita> findAllByCodiceCategoriaLikeAndTipoAttoAnscAndFlagVisibileIsTrueAndDescrizioneLikeIgnoreCase(String categoria, ETipoAttoAnsc tipoAttoAnsc, String filtro)

    @Query("""SELECT c.id FROM AnscCasoUsoNascita c 
               WHERE (:siglaCategoria IS NULL OR UPPER(c.codiceCategoria) = UPPER(:siglaCategoria) )
                 AND (:parte IS NULL OR c.parte = :parte ) 
                 AND (:serie IS NULL OR c.serie = :serie ) 
                 AND c.flagVisibile = java.lang.Boolean.TRUE
                 AND (:tipoAttoAnsc IS NULL OR c.tipoAttoAnsc = :tipoAttoAnsc )  
                 AND (((COALESCE(c.natoMorto, :natoMorto) IS NULL OR c.natoMorto = :natoMorto)
                   AND (:tipoFiliazione IS NULL OR COALESCE(c.tipoFiliazione, :tipoFiliazione ) = :tipoFiliazione )  
                   AND (:tipoDichiarante IS NULL OR COALESCE(c.tipoDichiarante, :tipoDichiarante ) = :tipoDichiarante )
                   AND (:tipoComparente IS NULL OR COALESCE(c.tipoComparente, :tipoComparente ) = :tipoComparente OR (c.tipoComparenteAltroSoggetto IS NOT NULL AND COALESCE(c.tipoComparenteAltroSoggetto, :tipoComparente ) = :tipoComparente ))  
                   AND (COALESCE(c.attoNotarile, :attoNotarile) IS NULL OR c.attoNotarile = :attoNotarile)
                   AND (:dichiarazioneGiudiziale IS NULL OR COALESCE(c.dichiarazioneGiudiziale, :dichiarazioneGiudiziale ) = :dichiarazioneGiudiziale )  
                   AND (:fasciaEtaFiglio IS NULL OR COALESCE(c.fasciaEtaFiglio, :fasciaEtaFiglio ) = :fasciaEtaFiglio ) 
                   AND ((COALESCE(c.tipoConsenso, :tipoConsenso) IS NULL OR c.tipoConsenso = :tipoConsenso) OR (COALESCE(c.tipoConsenso2, :tipoConsenso) IS NULL OR c.tipoConsenso2 = :tipoConsenso))  
                   AND (COALESCE(c.tipoRiconoscimento, :tipoRiconoscimento) IS NULL OR c.tipoRiconoscimento = :tipoRiconoscimento)  
                   AND (COALESCE(c.flagExArt19, :flagExArt19) IS NULL OR c.flagExArt19 = :flagExArt19)
                   AND (COALESCE(c.idMotivoAdozione, :idMotivoAdozione) IS NULL OR c.idMotivoAdozione = :idMotivoAdozione) 
                   AND (:isCentroNascita IS NULL))
                   OR (:isCentroNascita IS NOT NULL)) 
                   AND (COALESCE(c.flagInViaggio, :flagInViaggio) IS NULL OR c.flagInViaggio = :flagInViaggio) 
                   AND (COALESCE(c.flagFiglioDiIgnoti, :flagFiglioDiIgnoti) IS NULL OR c.flagFiglioDiIgnoti = :flagFiglioDiIgnoti)""")
    List<Long> findAllByAllFiltri(@Param("siglaCategoria") String siglaCategoria,
                                  @Param("parte") Integer parte,
                                  @Param("serie") String serie,
                                  @Param("tipoAttoAnsc") ETipoAttoAnsc tipoAttoAnsc,
                                  @Param("natoMorto") ETipoSiNo natoMorto,
                                  @Param("tipoFiliazione") ETipoFiliazione tipoFiliazione,
                                  @Param("tipoDichiarante") String tipoDichiarante,
                                  @Param("tipoComparente") String tipoComparente,
                                  @Param("attoNotarile") ETipoSiNo attoNotarile,
                                  @Param("dichiarazioneGiudiziale") ETipoSiNo dichiarazioneGiudiziale,
                                  @Param("fasciaEtaFiglio") ETipoFasciaEta fasciaEtaFiglio,
                                  @Param("tipoConsenso") ETipoConsenso tipoConsenso,
                                  @Param("tipoRiconoscimento") ETipoRiconoscimentoPrenatale tipoRiconoscimento,
                                  @Param("flagExArt19") Boolean flagExArt19,
                                  @Param("idMotivoAdozione") Long idMotivoAdozione,
                                  @Param("isCentroNascita") Boolean isCentroNascita,
                                  @Param("flagInViaggio") Boolean flagInViaggio,
                                  @Param("flagFiglioDiIgnoti") Boolean flagFiglioDiIgnoti)
}