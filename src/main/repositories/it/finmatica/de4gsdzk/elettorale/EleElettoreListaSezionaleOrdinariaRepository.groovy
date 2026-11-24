package it.finmatica.de4gsdzk.elettorale


import it.finmatica.de4gsdzk.utils.EStatoElettore
import org.springframework.data.domain.Sort
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface EleElettoreListaSezionaleOrdinariaRepository extends JpaRepository<EleElettoreListaSezionaleOrdinaria, Long> {


    @Query("""
        SELECT e FROM EleElettoreListaSezionaleOrdinaria e
        WHERE  e.sezione = :sezione
        AND (:progressivoDa IS NULL OR :progressivoA IS NULL OR e.progressivoSezionale BETWEEN :progressivoDa AND :progressivoA)
        AND (:stato IS NULL OR e.stato = :stato)
        AND (UPPER(SUBSTRING(e.cognomeNome, 1, 1)) BETWEEN :cognomeDa AND :cognomeA)
    """)
    List<EleElettoreListaSezionaleBaseDomain> findAllByParams(@Param("sezione") Integer sezione,
                                                             @Param("progressivoDa") Long progressivoDa,
                                                             @Param("progressivoA") Long progressivoA,
                                                             @Param("stato") EStatoElettore stato,
                                                             @Param("cognomeDa") String cognomeDa,
                                                             @Param("cognomeA") String cognomeA,
                                                             Sort sort)

    @Query("""
        SELECT e FROM EleElettoreListaSezionaleOrdinaria e
        WHERE  e.sezione = :sezione
        AND (:progressivoDa IS NULL OR :progressivoA IS NULL OR e.progressivoSezionale BETWEEN :progressivoDa AND :progressivoA)
        AND (:stato IS NULL OR e.stato = :stato)
        AND e.flagDepennatoArt33 IS NULL
        AND (:flagAmministrative = true or e.flagVotoEstero IS NULL or e.flagOpzioneVotoItalia = java.lang.Boolean.TRUE)
        AND (:flagAmministrative = true or e.flagFuoriSede IS NULL)
        AND (UPPER(SUBSTRING(e.cognomeNome, 1, 1)) BETWEEN :cognomeDa AND :cognomeA)
    """)
    List<EleElettoreListaSezionaleBaseDomain> findAllElettoriAttiviByParams(@Param("sezione") Integer sezione,
                                                                            @Param("progressivoDa") Long progressivoDa,
                                                                            @Param("progressivoA") Long progressivoA,
                                                                            @Param("stato") EStatoElettore stato,
                                                                            @Param("cognomeDa") String cognomeDa,
                                                                            @Param("cognomeA") String cognomeA,
                                                                            @Param("flagAmministrative") Boolean flagAmministrative,
                                                                            Sort sort)

    @Query("""
        SELECT COUNT(e) FROM EleElettoreListaSezionaleOrdinaria e
        WHERE  e.sezione = :sezione
        AND (:progressivoDa IS NULL OR :progressivoA IS NULL OR e.progressivoSezionale BETWEEN :progressivoDa AND :progressivoA)
        AND (:stato IS NULL OR e.stato = :stato)
        AND (UPPER(SUBSTRING(e.cognomeNome, 1, 1)) BETWEEN :cognomeDa AND :cognomeA)
    """)
    int countByParams(@Param("sezione") Integer sezione,
                      @Param("progressivoDa") Long progressivoDa,
                      @Param("progressivoA") Long progressivoA,
                      @Param("stato") EStatoElettore stato,
                      @Param("cognomeDa") String cognomeDa,
                      @Param("cognomeA") String cognomeA)

    @Query("""
        SELECT COUNT(e) FROM EleElettoreListaSezionaleOrdinaria e
        WHERE  e.sezione = :sezione
        AND (:progressivoDa IS NULL OR :progressivoA IS NULL OR e.progressivoSezionale BETWEEN :progressivoDa AND :progressivoA)
        AND (:stato IS NULL OR e.stato = :stato)
        AND e.flagDepennatoArt33 IS NULL
        AND (:flagAmministrative = true or e.flagVotoEstero IS NULL or e.flagOpzioneVotoItalia = java.lang.Boolean.TRUE)
        AND (:flagAmministrative = true or e.flagFuoriSede IS NULL)
        AND (UPPER(SUBSTRING(e.cognomeNome, 1, 1)) BETWEEN :cognomeDa AND :cognomeA)
    """)
    int countElettoriAttiviByParams(@Param("sezione") Integer sezione,
                                    @Param("progressivoDa") Long progressivoDa,
                                    @Param("progressivoA") Long progressivoA,
                                    @Param("stato") EStatoElettore stato,
                                    @Param("cognomeDa") String cognomeDa,
                                    @Param("cognomeA") String cognomeA,
                                    @Param("flagAmministrative") Boolean flagAmministrative)

}
