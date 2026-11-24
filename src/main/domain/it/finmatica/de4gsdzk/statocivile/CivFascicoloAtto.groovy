package it.finmatica.de4gsdzk.statocivile

import it.finmatica.ad4.autenticazione.Ad4Utente
import it.finmatica.ad4.hibernate.UtenteIns
import it.finmatica.ad4.hibernate.UtenteUpd
import it.finmatica.de4gsdzk.GsdDocumentoEsternoBaseDomain
import it.finmatica.de4gsdzk.IRiferimentoAttoDomain
import it.finmatica.de4gsdzk.utils.Etichette
import org.hibernate.annotations.CreationTimestamp
import org.hibernate.annotations.UpdateTimestamp

import javax.persistence.*

@Entity
@Table(name = "CIVFAS")
class CivFascicoloAtto extends GsdDocumentoEsternoBaseDomain implements IRiferimentoAttoDomain{

    @GeneratedValue
    @Id
    @Column(name = "ID")
    Long id

    @Column(name = "ID_ATTO", nullable = false)
    String idAtto

    @Column(name = "TIPO_ATTO", nullable = false)
    Integer tipoAtto

    @Column(name = "UFFICIO", nullable = false)
    Integer ufficio

    @Column(name = "ANNO", nullable = false)
    Integer anno

    @Column(name = "ATTO", nullable = false)
    Integer atto

    @Column(name = "PARTE", nullable = true)
    Integer parte

    @Column(name = "SERIE", nullable = true)
    String serie

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="ID_CIVDDO", nullable = false)
    CivTipoDocumentoFascicolo tipoDocumentoFascicolo

    @CreationTimestamp
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "DATA_INS", nullable = false)
    Date dateCreated

    @UpdateTimestamp
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "DATA_UPD", nullable = false)
    Date lastUpdated

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "UTENTE_INS", nullable = false)
    @UtenteIns
    Ad4Utente utenteIns

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "UTENTE_UPD", nullable = false)
    @UtenteUpd
    Ad4Utente utenteUpd

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="ID_CIVCOM", nullable = true)
    CivArchivioComunicazione archivioComunicazione

    @Column(name = "NOTE", nullable = true)
    String note

    @Version
    @Column(nullable = false)
    Long version

    String getDescrizioneEstesa(){
        return ( (tipoDocumentoFascicolo?.descrizione?:"") + (archivioComunicazione?" (":"") + (archivioComunicazione?.descrizione?:"")  + (archivioComunicazione?") ":""))
    }

    /////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI /////////////////////////////
    /////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Tipo_Documento"), Etichette.getEtichetta("Categoria"), Etichette.getEtichetta("Note"), Etichette.getEtichetta("Data")]

}
