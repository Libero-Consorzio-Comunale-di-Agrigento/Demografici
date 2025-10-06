package it.finmatica.de4gsdzk

import it.finmatica.ad4.autenticazione.Ad4Utente
import it.finmatica.ad4.hibernate.UtenteUpd
import it.finmatica.de4gsdzk.utils.Etichette
import org.hibernate.annotations.UpdateTimestamp

import javax.persistence.*

@Entity
@Table(name = "GSDETI")
class GsdEtichetta {

    @Id
    @Column(name = "CODICE")
    String id;

    @Column(name = "VALORE_ITA")
    String valoreIta;

    @Column(name = "VALORE_DEU")
    String valoreDeu;

    @Column(name = "VALORE_LAD")
    String valoreLad

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TERMINALISTA", nullable = false)
    @UtenteUpd
    Ad4Utente utenteUpd

    @UpdateTimestamp
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "DATA_UPD", nullable = false)
    Date lastUpdated

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Codice, Etichette.Italiano]
}
