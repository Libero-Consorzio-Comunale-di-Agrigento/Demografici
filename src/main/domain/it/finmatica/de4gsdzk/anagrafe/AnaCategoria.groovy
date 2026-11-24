package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.ad4.autenticazione.Ad4Utente
import it.finmatica.ad4.hibernate.UtenteUpd
import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "ANADCA")
class AnaCategoria {

    @Id
    @Column(name = "COD_CA")
    Integer codice

    @Column(name = "DESCRIZIONE")
    String descrizione

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TIPO_DOCUMENTO")
    AnaTipoDocumento tipoDocumento

    @Convert(converter= GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_REALE", nullable = true)
    Boolean flagReale

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TERMINALISTA", nullable = false)
    @UtenteUpd
    Ad4Utente terminalista

    static List<Map> etichetteDomain = [Etichette.getEtichetta("Codice"),
                                        Etichette.getEtichetta("Descrizione"),
                                        Etichette.getEtichetta("Tipo_Documento"),
                                        Etichette.getEtichetta("Reale")]
}
