package it.finmatica.de4gsdzk.certificazione

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.certificazione.CerFiltro
import it.finmatica.de4gsdzk.certificazione.CerStatoCivileFiltro
import it.finmatica.de4gsdzk.utils.ESesso
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CerStatoCivileFiltroRepository extends JpaRepository<CerStatoCivileFiltro, Long> {

    @Query("""SELECT n FROM CerStatoCivileFiltro n 
                WHERE n.filtro = :filtro
                  AND n.tipoArchivio = :tipoArchivio
                  AND (:cognome IS NULL OR n.cognome = :cognome) 
                  AND (:nome IS NULL OR n.nome = :nome) 
                  AND (:dataNascita IS NULL OR n.dataNascita = :dataNascita)
                  AND (:sesso IS NULL OR n.sesso = :sesso)""")
    List<CerStatoCivileFiltro> findAllByTipoArchivioAndFiltroAndCognomeAndNomeAndDataNascitaAndSesso(@Param("tipoArchivio") Integer tipoArchivio,
                                                                                                     @Param("filtro") CerFiltro filtro,
                                                                                                     @Param("cognome") String cognome,
                                                                                                     @Param("nome") String nome,
                                                                                                     @Param("dataNascita") Date dataNascita,
                                                                                                     @Param("sesso") ESesso sesso)
}