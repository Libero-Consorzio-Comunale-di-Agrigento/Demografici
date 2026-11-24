package it.finmatica.de4gsdzk.anagrafe.pratiche

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafe
import it.finmatica.de4gsdzk.anagrafe.AnaTipoDocumento
import it.finmatica.de4gsdzk.certificazione.CerTerminalista
import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.AttributeOverride
import javax.persistence.AttributeOverrides
import javax.persistence.Column
import javax.persistence.Embedded
import javax.persistence.Entity
import javax.persistence.FetchType
import javax.persistence.Id
import javax.persistence.JoinColumn
import javax.persistence.ManyToOne
import javax.persistence.Table

@Entity
@Table(name = "ANAARI_V_ZK")
class AnaRecapito extends GsdBaseDomain{

    @Id
    @Column(name = "ID")
    Integer id

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MATRICOLA", nullable = false)
    AnaAnagrafe anagrafe

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TIPO_RECAPITO", nullable = false)
    AnaTipoRecapito tipoRecapito

    @Column(name = "INDIRIZZO_REC", nullable = true)
    String indirizzo

    @Column(name = "NUMERO_TELEFONICO", nullable = true)
    String numeroTelefonico

    @Column(name = "NOTE", nullable = true)
    String note

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TERMINALISTA", nullable = true)
    CerTerminalista terminalista

    @Embedded
    @AttributeOverrides([@AttributeOverride(name = "codice", column = @Column(name = "COD_COM_REC")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_REC", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_REC")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_REC", updatable = false, insertable = false))])
    private Comune comuneRecapito

    Comune getComuneRecapito() {
        if (comuneRecapito == null) {
            comuneRecapito = new Comune()
        }
        return comuneRecapito
    }

    void setComuneRecapito(Comune c) {
        this.comuneRecapito = c
    }


    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Recapiti"), Etichette.getEtichetta("Tipo_Recapito"), Etichette.getEtichetta("Indirizzo"), Etichette.getEtichetta("Numero_Telefonico"),
                                              Etichette.getEtichetta("Comune"), Etichette.getEtichetta("Note"), Etichette.getEtichetta("Nessun_Recapito_Presente")]


}
