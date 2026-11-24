package it.finmatica.de4gsdzk.elettorale


import it.finmatica.de4gsdzk.utils.ESesso
import it.finmatica.de4gsdzk.utils.EStatoElettore
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface EleArchivioRepository extends JpaRepository<EleArchivio, String> {

    @Query(value = """SELECT DISTINCT a FROM EleArchivio a
                      LEFT OUTER JOIN FETCH a.tipoLista
                       WHERE (:matricola IS NULL OR a.matricola = :matricola)
                         AND (:cognome IS NULL OR UPPER(a.cognome) LIKE UPPER(:cognome))
                         AND (:nome IS NULL OR UPPER(a.nome) LIKE UPPER(:nome))
                         AND (:sesso IS NULL OR a.sesso = :sesso)
                         AND (:stato IS NULL OR a.stato = :stato)
                         AND (:fascicoloDa IS NULL OR a.fascicolo between :fascicoloDa and :fascicoloA)
                         AND (:anno IS NULL OR a.anno = :anno)
                         AND (:sezioneDa IS NULL OR a.sezione between :sezioneDa and :sezioneA) 
                         AND (:progressivoSezionaleDa IS NULL OR a.progressivoSezionale between :progressivoSezionaleDa and :progressivoSezionaleA) 
                         AND (:progressivoGeneraleDa IS NULL OR a.progressivoGenerale between :progressivoGeneraleDa and :progressivoGeneraleA) 
                         AND (:tesseraDa IS NULL OR a.tessera between :tesseraDa and :tesseraA) 
                         AND (:dataTesseraDa IS NULL OR a.dataTessera between :dataTesseraDa and :dataTesseraA)
                         AND (:tipoLista IS NULL OR a.tipoLista = :tipoLista)
                         AND (:flagGiacenza IS NULL
                              OR (:flagGiacenza = true AND a.flagGiacenza = true)
                              OR (:flagGiacenza = false AND (a.flagGiacenza IS NULL OR a.flagGiacenza <> true)))""",
            countQuery = """SELECT COUNT(a) FROM EleArchivio a
                       WHERE (:matricola IS NULL OR a.matricola = :matricola)  
                         AND (:cognome IS NULL OR UPPER(a.cognome) LIKE UPPER(:cognome))
                         AND (:nome IS NULL OR UPPER(a.nome) LIKE UPPER(:nome))
                         AND (:sesso IS NULL OR a.sesso = :sesso)
                         AND (:stato IS NULL OR a.stato = :stato)
                         AND (:fascicoloDa IS NULL OR a.fascicolo between :fascicoloDa and :fascicoloA)
                         AND (:anno IS NULL OR a.anno = :anno)
                         AND (:sezioneDa IS NULL OR a.sezione between :sezioneDa and :sezioneA) 
                         AND (:progressivoSezionaleDa IS NULL OR a.progressivoSezionale between :progressivoSezionaleDa and :progressivoSezionaleA) 
                         AND (:progressivoGeneraleDa IS NULL OR a.progressivoGenerale between :progressivoGeneraleDa and :progressivoGeneraleA) 
                         AND (:tesseraDa IS NULL OR a.tessera between :tesseraDa and :tesseraA) 
                         AND (:dataTesseraDa IS NULL OR a.dataTessera between :dataTesseraDa and :dataTesseraA)
                         AND (:tipoLista IS NULL OR a.tipoLista = :tipoLista)
                         AND (:flagGiacenza IS NULL
                              OR (:flagGiacenza = true AND a.flagGiacenza = true)
                              OR (:flagGiacenza = false AND (a.flagGiacenza IS NULL OR a.flagGiacenza <> true)))""")
    Page<EleArchivio> listAllByRicercaElettore(
            @Param("matricola") Long matricola,
            @Param("cognome") String cognome,
            @Param("nome") String nome,
            @Param("sesso") ESesso sesso,
            @Param("stato") EStatoElettore stato,
            @Param("fascicoloDa") Long fascicoloDa,
            @Param("fascicoloA") Long fascicoloA,
            @Param("anno") Integer anno,
            @Param("sezioneDa") Integer sezioneDa,
            @Param("sezioneA") Integer sezioneA,
            @Param("progressivoSezionaleDa") Long progressivoSezionaleDa,
            @Param("progressivoSezionaleA") Long progressivoSezionaleA,
            @Param("progressivoGeneraleDa") Long progressivoGeneraleDa,
            @Param("progressivoGeneraleA") Long progressivoGeneraleA,
            @Param("tesseraDa") Long tesseraDa,
            @Param("tesseraA") Long tesseraA,
            @Param("dataTesseraDa") Date dataTesseraDa,
            @Param("dataTesseraA") Date dataTesseraA,
            @Param("tipoLista") EleTipoLista tipoLista,
            @Param("flagGiacenza") Boolean flagGiacenza,
            Pageable pageable)

}