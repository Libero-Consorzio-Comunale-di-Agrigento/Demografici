package it.finmatica.de4gsdzk.certificazione

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.ETipoCompetenzaCertificazioneOnLine
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "CERCTC")
class CerCategoriaTipoCertificato extends GsdBaseDomain{

    @Id
    @Column(name = "ID")
    Integer id

    @Column(name = "SIGLA", nullable = false)
    String codice

    @Column(name = "DESCRIZIONE", nullable = false)
    String descrizione

    @Column(name = "SEQUENZA", nullable = true)
    Integer sequenza

    @Enumerated(EnumType.STRING)
    @Column(name = "COMPETENZA", nullable = false)
    ECompetenzaCertificazione competenzaCertificazione

    @Enumerated(EnumType.STRING)
    @Column(name = "COMPETENZA_AN_SC", nullable = false)
    ETipoCompetenzaCertificazioneOnLine tipoCompetenzaOnline

    @OneToOne
    @JoinColumn(name = "ID_PER_MODALITA_RILASCIO", nullable = false)
    CerCategoriaTipoCertificato categoriaTipoCertificatoFiltroModalitaRilascio

    Boolean isStatoCivile() {
        tipoCompetenzaOnline == ETipoCompetenzaCertificazioneOnLine.SC
    }

    Boolean isAnagrafe() {
        tipoCompetenzaOnline == ETipoCompetenzaCertificazioneOnLine.AN
    }

    ////////////////////////////////////////////////////////////////////////
    /////////////////////////////// GENERALI////////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Competenza_On_Line]

}
