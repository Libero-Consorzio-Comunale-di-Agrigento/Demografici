package it.finmatica.de4gsdzk.certificazione

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.certificazione.CerCertificatoEmesso
import it.finmatica.de4gsdzk.certificazione.CerTerminalista
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Modifying
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CerCertificatoEmessoRepository extends JpaRepository<CerCertificatoEmesso, Long>, CerCertificatoEmessoCustomRepository {

    @Query("""SELECT c 
                FROM CerCertificatoEmesso c 
                    LEFT JOIN FETCH c.tipoCertificato tc
                    LEFT JOIN FETCH tc.tipoCertificatoTariffaDirittoList
                    LEFT JOIN FETCH c.modalitaRilascio
                    LEFT JOIN FETCH c.tipoPagamento
                    LEFT JOIN FETCH c.richiedente.nazionalita
                    LEFT JOIN FETCH c.richiedente.tipoDocumento
                    LEFT JOIN FETCH c.terminalista
                    LEFT JOIN FETCH c.terminalistaAnnullamento
                    LEFT JOIN FETCH c.pagamentoInviatoDettaglio pid
                    LEFT JOIN FETCH pid.pagamentoInviato pi
               WHERE c.id = :id""")
    CerCertificatoEmesso findById(@Param("id") Long id)

    @Modifying
    @Query("""UPDATE CerCertificatoEmesso c SET 
                c.annullamento = it.finmatica.de4gsdzk.utils.ETipoSiNo.SI, 
                c.terminalistaAnnullamento = :terminalistaAnnullamento, 
                c.dataAnnullamento = :dataAnnullamento, 
                c.noteAnnullamento = :noteAnnullamento 
                WHERE c.id = :id""")
    void annullaCertificato(@Param("id") Long id,
                            @Param("terminalistaAnnullamento") CerTerminalista terminalistaAnnullamento,
                            @Param("dataAnnullamento") Date dataAnnullamento,
                            @Param("noteAnnullamento") String noteAnnullamento)

    @Modifying
    @Query("""UPDATE CerCertificatoEmesso c SET 
                c.annullamento = it.finmatica.de4gsdzk.utils.ETipoSiNo.NO,
                c.terminalistaAnnullamento = null,
                c.dataAnnullamento = null,
                c.noteAnnullamento = null,
                c.utenteRipristino = :utenteRipristino, 
                c.dataRipristino = :dataRipristino
                WHERE c.id = :id""")
    void ripristinaCertificato(@Param("id") Long id,
                               @Param("utenteRipristino") String utenteRipristino,
                               @Param("dataRipristino") Date dataRipristino)

}