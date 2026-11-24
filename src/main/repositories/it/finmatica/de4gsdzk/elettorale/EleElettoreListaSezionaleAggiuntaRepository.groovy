package it.finmatica.de4gsdzk.elettorale


import it.finmatica.de4gsdzk.utils.EStatoElettore
import org.springframework.data.domain.Sort
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface EleElettoreListaSezionaleAggiuntaRepository extends JpaRepository<EleElettoreListaSezionaleAggiunta, Long> {


    @Query("""
        SELECT e FROM EleElettoreListaSezionaleAggiunta e
        LEFT OUTER JOIN FETCH e.tipoLista
        WHERE  e.sezione = :sezione
        AND (:progressivoDa IS NULL OR :progressivoA IS NULL OR e.progressivoSezionale BETWEEN :progressivoDa AND :progressivoA)
        AND (:stato IS NULL OR e.stato = :stato)
        AND (:tipoLista IS NULL OR e.tipoLista = :tipoLista)
        AND (UPPER(SUBSTRING(e.cognomeNome, 1, 1)) BETWEEN :cognomeDa AND :cognomeA)
    """)
    List<EleElettoreListaSezionaleBaseDomain> findAllByParams(@Param("sezione") Integer sezione,
                                                             @Param("progressivoDa") Long progressivoDa,
                                                             @Param("progressivoA") Long progressivoA,
                                                             @Param("stato") EStatoElettore stato,
                                                             @Param("cognomeDa") String cognomeDa,
                                                             @Param("cognomeA") String cognomeA,
                                                             @Param("tipoLista") EleTipoLista tipoLista,
                                                             Sort sort)

    @Query("""
        SELECT e FROM EleElettoreListaSezionaleAggiunta e
        LEFT OUTER JOIN FETCH e.tipoLista
        WHERE  e.sezione = :sezione
        AND (:progressivoDa IS NULL OR :progressivoA IS NULL OR e.progressivoSezionale BETWEEN :progressivoDa AND :progressivoA)
        AND (:stato IS NULL OR e.stato = :stato)
        AND (:tipoLista IS NULL OR e.tipoLista = :tipoLista)
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
                                                                            @Param("tipoLista") EleTipoLista tipoLista,
                                                                            @Param("flagAmministrative") Boolean flagAmministrative,
                                                                            Sort sort)

    @Query("""
        SELECT COUNT(e) FROM EleElettoreListaSezionaleAggiunta e
        WHERE  e.sezione = :sezione
        AND (:progressivoDa IS NULL OR :progressivoA IS NULL OR e.progressivoSezionale BETWEEN :progressivoDa AND :progressivoA)
        AND (:stato IS NULL OR e.stato = :stato)
        AND (:tipoLista IS NULL OR e.tipoLista = :tipoLista)
        AND (UPPER(SUBSTRING(e.cognomeNome, 1, 1)) BETWEEN :cognomeDa AND :cognomeA)
    """)
    int countByParams(@Param("sezione") Integer sezione,
                      @Param("progressivoDa") Long progressivoDa,
                      @Param("progressivoA") Long progressivoA,
                      @Param("stato") EStatoElettore stato,
                      @Param("cognomeDa") String cognomeDa,
                      @Param("cognomeA") String cognomeA,
                      @Param("tipoLista") EleTipoLista tipoLista)

    @Query("""
        SELECT COUNT(e) FROM EleElettoreListaSezionaleAggiunta e
        WHERE  e.sezione = :sezione
        AND (:progressivoDa IS NULL OR :progressivoA IS NULL OR e.progressivoSezionale BETWEEN :progressivoDa AND :progressivoA)
        AND (:stato IS NULL OR e.stato = :stato)
        AND (:tipoLista IS NULL OR e.tipoLista = :tipoLista)
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
                                    @Param("tipoLista") EleTipoLista tipoLista,
                                    @Param("flagAmministrative") Boolean flagAmministrative)

}
