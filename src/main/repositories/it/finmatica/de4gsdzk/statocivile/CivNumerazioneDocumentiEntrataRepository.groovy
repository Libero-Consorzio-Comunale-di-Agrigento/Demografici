package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivNumerazioneDocumentiEntrata
import it.finmatica.de4gsdzk.statocivile.CivRegistroDocumentiEntrata
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivNumerazioneDocumentiEntrataRepository extends JpaRepository<CivNumerazioneDocumentiEntrata, Long> {

    @Query("""SELECT c FROM CivNumerazioneDocumentiEntrata c WHERE c.registro.id = :idRegistro """)
    List<CivNumerazioneDocumentiEntrata> findAllByIdRegistro(@Param("idRegistro") Integer idRegistro)

    //@Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("""SELECT c FROM CivNumerazioneDocumentiEntrata c JOIN FETCH c.registro
                      WHERE c.registro = :registro 
                        AND c.anno = :anno """)
    CivNumerazioneDocumentiEntrata findByAnnoAndRegistro(@Param("anno") Integer anno, @Param("registro") CivRegistroDocumentiEntrata registro)

}