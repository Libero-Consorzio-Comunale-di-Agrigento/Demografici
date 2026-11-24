package it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni

import it.finmatica.ad4.autenticazione.Ad4Utente
import it.finmatica.ad4.hibernate.UtenteUpd
import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.IComunicazione
import it.finmatica.de4gsdzk.anagrafe.AnaTipoDocumento
import it.finmatica.de4gsdzk.utils.ETipoComunicazioneAnagrafe
import it.finmatica.de4gsdzk.utils.Etichette
import org.hibernate.annotations.NotFound
import org.hibernate.annotations.NotFoundAction

import javax.persistence.*

@Entity
@Table(name = "ANADCO_V_ZK")
class AnaComunicazione extends GsdBaseDomain implements  IComunicazione {

    @Id
    @Column(name = "CODICE_CO")
    Integer id

    @Column(name = "DESCRIZIONE")
    String descrizione

    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_COMUNICAZIONE")
    ETipoComunicazioneAnagrafe tipoComunicazione

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_PRIORITA", nullable = true, updatable = false, insertable = false)
    Boolean priorita

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_SOGGETTO", nullable = true, updatable = false, insertable = false)
    Boolean flagSoggetto

    @Column(name = "DESCRIZIONE_ESTESA", nullable = true, updatable = false, insertable = false)
    String descrizioneEstesa

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="ID_ANAMOD", nullable = true, updatable = false, insertable = false)
    AnaModello modello

    @Column(name = "COD_MODELLO")
    String codiceModello

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="ENTE_DESTINATARIO")
    AnaEnte enteDestinatario

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="TIPO_DOCUMENTO_RIF")
    AnaTipoDocumento tipoDocumento

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TERMINALISTA", nullable = true)
    @UtenteUpd
    @NotFound(action = NotFoundAction.IGNORE)
    Ad4Utente terminalista

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [
        Etichette.getEtichetta("Codice"),
        Etichette.getEtichetta("Modello"),
        Etichette.getEtichetta("Descrizione"),
        Etichette.getEtichetta("Tipo_Comunicazione"),
        Etichette.getEtichetta("Adempimenti"),
        Etichette.getEtichetta("Associazioni"),
        Etichette.getEtichetta("Ente_Destinatario"),
        Etichette.getEtichetta("Tipo_Documento"),
        Etichette.getEtichetta("Tipo")
    ]

    @Override
    boolean equals(Object obj) {
        if (this.is(obj)) return true
        if (obj == null || getClass() != obj.getClass()) return false
        AnaComunicazione that = (AnaComunicazione) obj
        return Objects.equals(id, that.id)
    }

    @Override
    int hashCode() {
        return Objects.hash(id)
    }

    @Override
    String toString() {
        return "AnaComunicazione{id=${id}, descrizione='${descrizione}', tipoComunicazione=${tipoComunicazione}}"
    }
}
