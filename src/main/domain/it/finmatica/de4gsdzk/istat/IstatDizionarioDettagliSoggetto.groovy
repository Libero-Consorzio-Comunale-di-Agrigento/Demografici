package it.finmatica.de4gsdzk.istat

import it.finmatica.de4gsdzk.anagrafe.EGruppoTitoloStudio
import it.finmatica.de4gsdzk.utils.ETipoArchivioIstat

import javax.persistence.*

@Entity
@Table(name = "ISTMAP_V_DIZ")
class IstatDizionarioDettagliSoggetto {

    @Id
    @Column(name = "ID")
    String id

    @Enumerated(EnumType.STRING)
    @Column(name = "COD_ARCHIVIO")
    ETipoArchivioIstat archivioIstat

    @Column(name ="DES_ARCHIVIO")
    String descrizioneArchivio

    @Column(name ="CODICE_ISTAT")
    Integer codiceIstat

    @Column(name ="DESCRIZIONE")
    String descrizione

    @Temporal(TemporalType.DATE)
    @Column(name= "D_DA_DATA", nullable = true)
    Date dataDa

    @Temporal(TemporalType.DATE)
    @Column(name= "D_A_DATA", nullable = true)
    Date dataA

    @Enumerated(EnumType.STRING)
    @Column(name = "CODICE_ADS", length = 2)
    EGruppoTitoloStudio gruppo


}
