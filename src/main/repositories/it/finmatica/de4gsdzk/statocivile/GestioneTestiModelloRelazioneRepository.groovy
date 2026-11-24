package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface GestioneTestiModelloRelazioneRepository extends JpaRepository<GestioneTestiModelloRelazione, Long> {

    @Query("""SELECT c FROM GestioneTestiModelloRelazione c JOIN FETCH c.modello m LEFT JOIN FETCH m.tipoModello t
               WHERE c.comunicazioneAtto.id = :idComunicazioneAtto """)
    GestioneTestiModelloRelazione findByIdComunicazioneAtto(@Param("idComunicazioneAtto") String idComunicazioneAtto)

    @Query("""SELECT c FROM GestioneTestiModelloRelazione c JOIN FETCH c.modello m LEFT JOIN FETCH m.tipoModello t
               WHERE c.comunicazione.id = :idComunicazione """)
    GestioneTestiModelloRelazione findByIdComunicazione(@Param("idComunicazione") Integer idComunicazione)


    @Query("""SELECT c FROM GestioneTestiModelloRelazione c JOIN FETCH c.modello m LEFT JOIN FETCH m.tipoModello t
               WHERE c.tipoCertificato.id = :idTipoCertificato """)
    GestioneTestiModelloRelazione findByTipoCertificato(@Param("idTipoCertificato") String idTipoCertificato)

    @Query("""SELECT c FROM GestioneTestiModelloRelazione c JOIN FETCH c.modello m LEFT JOIN FETCH m.tipoModello t
               WHERE c.modelloAnagrafe.id = :idModelloAnagrafe """)
    GestioneTestiModelloRelazione findByIdModelloAnagrafe(@Param("idModelloAnagrafe") String idModelloAnagrafe)

}