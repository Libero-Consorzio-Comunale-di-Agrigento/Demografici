package it.finmatica.de4gsdzk.statocivile.embed

import it.finmatica.de4gsdzk.ISoggettoCollegato
import it.finmatica.de4gsdzk.anagrafe.AnaCittadinanza
import it.finmatica.de4gsdzk.utils.ESesso
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Embeddable
class Testimone implements ISoggettoCollegato{

    @Column(name = "COGNOME", nullable = true)
    String cognome

    @Column(name = "NOME", nullable = true)
    String nome

    @Enumerated(EnumType.STRING)
    @Column(name = "SESSO")
    ESesso sesso

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAS")
    Date dataNascita

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "COD_COM_NAS")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_NAS", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "COD_PRO_NAS")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_NAS", updatable = false, insertable = false))
    ])
    private Comune comuneNascita

    Comune getComuneNascita() {
        if (comuneNascita == null){
            comuneNascita = new Comune()
        }
        return comuneNascita
    }

    void setComuneNascita(Comune comuneNascita) {
        this.comuneNascita = comuneNascita
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "COD_COM_RES")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_RES", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "COD_PRO_RES")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_RES", updatable = false, insertable = false))
    ])
    private Comune comuneResidenza

    Comune getComuneResidenza() {
        if (comuneResidenza == null){
            comuneResidenza = new Comune()
        }
        return comuneResidenza
    }

    void setComuneResidenza(Comune comuneResidenza) {
        this.comuneResidenza = comuneResidenza
    }

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "NAZIONALITA", nullable = true)
    AnaCittadinanza nazionalita

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Cognome"),Etichette.getEtichetta("Nome")]

}
