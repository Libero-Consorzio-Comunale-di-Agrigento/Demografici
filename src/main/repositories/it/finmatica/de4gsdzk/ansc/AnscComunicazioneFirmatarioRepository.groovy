package it.finmatica.de4gsdzk.ansc


import it.finmatica.de4gsdzk.ansc.AnscComunicazioneFirmatario
import it.finmatica.de4gsdzk.ansc.AnscEndPointServizio
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface AnscComunicazioneFirmatarioRepository extends JpaRepository<AnscComunicazioneFirmatario, Long> {

    @Query("""SELECT c FROM AnscComunicazioneFirmatario c INNER JOIN FETCH c.comunicazione
               WHERE c.idFirmatario = :idFirmatario AND c.comunicazione.servizio = :servizio 
               ORDER BY c.comunicazione.dataInvio DESC""")
    List<AnscComunicazioneFirmatario> findAllByServizioAndIdFirmatarioOrderByDataInvio(@Param("servizio") AnscEndPointServizio servizio,
                                                                                       @Param("idFirmatario") Long idFirmatario)

}