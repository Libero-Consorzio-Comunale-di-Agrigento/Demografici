package it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni

import it.finmatica.ad4.autenticazione.Ad4Utente
import it.finmatica.ad4.hibernate.UtenteUpd
import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.GsdBaseDomain.BooleanToStringConverter
import it.finmatica.de4gsdzk.IEnte
import it.finmatica.de4gsdzk.anagrafe.AnpCodiceEnte
import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.utils.ESiglaEnteAnagrafe
import it.finmatica.de4gsdzk.utils.ETipoEnteDestinatario
import it.finmatica.de4gsdzk.utils.Etichette
import org.hibernate.annotations.Formula

import javax.persistence.AttributeOverride
import javax.persistence.AttributeOverrides
import javax.persistence.Column
import javax.persistence.Convert
import javax.persistence.Embedded
import javax.persistence.Entity
import javax.persistence.EnumType
import javax.persistence.Enumerated
import javax.persistence.FetchType
import javax.persistence.Id
import javax.persistence.JoinColumn
import javax.persistence.ManyToOne
import javax.persistence.Table

@Entity
@Table(name = "ANADEN_V")
class AnaEnte extends GsdBaseDomain implements IEnte {

    @Id
    @Column(name = "COD_EN")
    Integer id

    Integer getCodice() {
        return id
    }

    @Column(name = "DESCRIZIONE")
    String descrizione

    @Column(name = "INDIRIZZO_ENTE")
    String indirizzo

    @Column(name = "CAP_ENTE")
    String cap

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_ENTE")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_ENTE", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_ENTE")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_ENTE", updatable = false, insertable = false))
    ])
    Comune comune

    Comune getComune() {
        if (comune == null) {
            comune = new Comune()
        }
        return comune
    }

    void setComune(Comune comune) {
        this.comune = comune
    }

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_CDF", nullable = true)
    Boolean cdf

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "CODICE_ANPR", referencedColumnName = "CODICE")
    AnpCodiceEnte codiceAnpr

    @Enumerated(EnumType.STRING)
    @Column(name = "SIGLA")
    ESiglaEnteAnagrafe sigla

    @Column(name = "INDIRIZZO_PEC")
    String pec

    @Column(name = "COD_AMM")
    String codAmm

    @Column(name = "COD_AOO")
    String codAOO

    @Column(name = "COD_UO")
    String codiceUo

    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_ENTE", nullable = true, updatable = false, insertable = false)
    ETipoEnteDestinatario tipoEnteDestinatario

    @Formula("CONCAT(COD_EN, CONCAT(CASE WHEN DESCRIZIONE IS NULL THEN '' ELSE ' - ' END, COALESCE(DESCRIZIONE, '')))")
    String descrizioneEstesa

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TERMINALISTA", nullable = false)
    @UtenteUpd
    Ad4Utente terminalista

    static List<Map> etichetteDomain = [
            Etichette.getEtichetta("Codice"),
            Etichette.getEtichetta("Descrizione"),
            Etichette.getEtichetta("Indirizzo"),
            Etichette.getEtichetta("PEC"),
            Etichette.getEtichetta("CAP"),
            Etichette.getEtichetta("Comune"),
            Etichette.getEtichetta("Provincia"),
            Etichette.getEtichetta("CdF"),
            Etichette.getEtichetta("Codice_ANPR"),
            Etichette.getEtichetta("Riferimento"),
            Etichette.getEtichetta("Indirizzo_PEC"),
            Etichette.getEtichetta("Codice_AMM"),
            Etichette.getEtichetta("Codice_AOO"),
            Etichette.getEtichetta("Codice_UO")
    ]

    static final Integer COMUNE = 1

    @Override
    boolean equals(Object obj) {
        if (this.is(obj)) return true
        if (obj == null || getClass() != obj.getClass()) return false
        AnaEnte that = (AnaEnte) obj
        return Objects.equals(codice, that.codice)
    }

    @Override
    int hashCode() {
        return Objects.hash(codice)
    }

    @Override
    String toString() {
        return "AnaEnte{codice=${codice}, descrizione='${descrizione}'}"
    }
}
