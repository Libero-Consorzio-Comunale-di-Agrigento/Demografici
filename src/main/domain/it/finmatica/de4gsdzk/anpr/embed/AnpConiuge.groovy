package it.finmatica.de4gsdzk.anpr.embed


import it.finmatica.de4gsdzk.anagrafe.AnaNazionalita
import it.finmatica.de4gsdzk.anagrafe.IConiuge
import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.utils.ESesso

import javax.persistence.*

@Embeddable
class AnpConiuge implements IConiuge {

    @Column(name = "MATRICOLA_CN", nullable = true)
    Integer idAnagrafe

    @Column(name = "COGNOME_CN", nullable = true)
    String cognome

    @Column(name = "NOME_CN", nullable = true)
    String nome

    @Enumerated(EnumType.STRING)
    @Column(name = "SESSO_CN", nullable = true)
    ESesso sesso

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAS_CN", nullable = false)
    Date dataNascita

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_NAS_CN")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_NAS_CN", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_NAS_CN")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_NAS_CN", updatable = false, insertable = false))
    ])
    private Comune comuneNascita

    Comune getComuneNascita() {
        if (comuneNascita == null) {
            comuneNascita = new Comune()
        }
        return comuneNascita
    }

    void setComuneNascita(Comune c) {
        this.comuneNascita = c
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_RES_CN")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_RES_CN", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_RES_CN")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_RES_CN", updatable = false, insertable = false))
    ])
    private Comune comuneResidenza

    Comune getComuneResidenza() {
        if (comuneResidenza == null) {
            comuneResidenza = new Comune()
        }
        return comuneResidenza
    }

    void setComuneResidenza(Comune c) {
        this.comuneResidenza = c
    }

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "NAZIONALITA_CN", nullable = true)
    AnaNazionalita nazionalita
}
