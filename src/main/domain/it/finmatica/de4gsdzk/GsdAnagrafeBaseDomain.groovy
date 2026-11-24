package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafe
import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.utils.EArchivioSorgenteSoggetto

import javax.persistence.*

@MappedSuperclass
abstract class GsdAnagrafeBaseDomain extends AnagrafeBaseDomain {

    @Id
    @Column(name = "ID")
    String id

    @ManyToOne(fetch= FetchType.EAGER)
    @JoinColumn(name="MATRICOLA_ANA", nullable = true)
    AnaAnagrafe anagrafe

    Integer getMatricola(){
        return anagrafe?.id
    }

    @Enumerated(EnumType.STRING)
    @Column(name = "ARCHIVIO", nullable = false)
    EArchivioSorgenteSoggetto archivio

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_RES", updatable = false, insertable = false)),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_RES", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_RES", updatable = false, insertable = false)),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_RES", updatable = false, insertable = false))
    ])
    private Comune comuneResidenza

    Comune getComuneResidenza() {
        if (comuneResidenza == null) {
            comuneResidenza = new Comune()
        }
        return comuneResidenza
    }
}
