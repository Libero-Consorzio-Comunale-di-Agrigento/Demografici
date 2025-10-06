package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.ad4.autenticazione.Ad4Utente
import it.finmatica.ad4.hibernate.UtenteUpd
import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.Etichette
import jdk.nashorn.internal.ir.annotations.Immutable

import javax.persistence.*

@Entity
@Immutable
@Table(name = "ANAMOV_X_ANASEN")
class AnaProvvedimentoAnagrafe extends GsdBaseDomain {

    @Id
    @Column(name = "ID")
    String id

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MATRICOLA")
    AnaAnagrafe anagrafe

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_EVE")
    Date dataEvento

    @Column(name = "DES_EVENTO")
    String descrizione

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TERMINALISTA", nullable = false)
    @UtenteUpd
    Ad4Utente utenteUpd

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "SEN_PRIVACY", nullable = true)
    Boolean privato

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Data_Evento, Etichette.Descrizione, Etichette.Terminalista]
}
