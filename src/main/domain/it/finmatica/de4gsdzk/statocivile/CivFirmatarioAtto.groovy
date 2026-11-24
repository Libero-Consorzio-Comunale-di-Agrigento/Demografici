package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.ETipoFirmaAnsc
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "CIVFIR_V")
class CivFirmatarioAtto extends GsdBaseDomain{

    @Id
    @Column(name = "ID")
    Long id

    @Column(name = "COGNOME", nullable = true)
    String cognome

    @Column(name = "NOME", nullable = false)
    String nome

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAS", nullable = false)
    Date dataNascita

    @Column(name = "ID_ATTO", nullable = false)
    String idAtto

    @Column(name = "INDIRIZZO_MAIL", nullable = true)
    String indirizzoMail

    @Column(name = "DES_RUOLO", nullable = true, updatable = false, insertable = false)
    String descrizioneRuolo

    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_FIRMA", nullable = true)
    ETipoFirmaAnsc tipoFirma

    @Column(name = "SEQUENZA", nullable = true)
    Integer sequenza

    @Column(name = "ID_PRESA_VISIONE_ANSC", nullable = true)
    Long idAnscPresaVisione

    @Column(name = "STATO_PRESA_VISIONE_ANSC", nullable = true)
    Integer statoAnscPresaVisione

    String getNominativo(){
        return ( (this.cognome?:"") + ((this.cognome && this.nome)?" ":"") + (this.nome?:"") )
    }

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Cognome"), Etichette.getEtichetta("Nome"), Etichette.getEtichetta("Data_Nascita"),
                                              Etichette.getEtichetta("Email"), Etichette.getEtichetta("Ruolo"), Etichette.getEtichetta("Firmatario"), Etichette.getEtichetta("Tipo_firma")]

}

