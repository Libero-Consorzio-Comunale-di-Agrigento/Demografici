package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.GestioneTestiGsdModello
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaComunicazionePratica
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaModello
import it.finmatica.de4gsdzk.certificazione.CerTipoCertificato
import org.hibernate.annotations.Check

import javax.persistence.*

@Entity
@CompileStatic
@Table(name = "GTE_GSDDMO_RELAZIONI")
@Check(constraints = "ID_CIVDCA IS NOT NULL OR CODICE_CO IS NOT NULL OR ID_CERDCE IS NOT NULL")
class GestioneTestiModelloRelazione {

    @Id
    @GeneratedValue
    @Column(name = "ID")
    Long id

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_MODELLO", nullable = false)
    GestioneTestiGsdModello modello

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_CIVDCA")
    CivComunicazioneAtto comunicazioneAtto

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_ANAMOD")
    AnaModello modelloAnagrafe

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="CODICE_CO")
    CivComunicazione comunicazione

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_CERDCE")
    CerTipoCertificato tipoCertificato

}
