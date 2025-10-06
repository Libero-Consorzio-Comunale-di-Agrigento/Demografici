package it.finmatica.de4gsdzk.anpr

import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafe
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafeBaseDomain
import it.finmatica.de4gsdzk.anpr.embed.AnpConiuge
import it.finmatica.de4gsdzk.utils.EArchivioSorgenteSoggetto

import javax.persistence.*

@Entity
@Table(name = "ANAANA_ANPR_V")
class AnpAnagrafe extends AnaAnagrafeBaseDomain {

    @Id @Column(name = "ID")
    Long id

    @Column(name = "ID_OPERAZIONE", nullable = false)
    Long idOperazione

    @Column(name = "ID_FAMIGLIA_ANPR", nullable = false)
    Long idFamigliaAnpr

    @Column(name = "TIPO_SCHEDA_ANPR", nullable = false)
    Long tipoSchedaAnpr

    @ManyToOne(fetch=FetchType.EAGER)
    @JoinColumn(name="MATRICOLA", nullable = true)
    AnaAnagrafe anagrafe

    Integer getMatricola(){
        return anagrafe?.id
    }

    @Override
    EArchivioSorgenteSoggetto getArchivio() {
        return EArchivioSorgenteSoggetto.ANP
    }

    @Embedded
    AnpConiuge coniuge

}
