package it.finmatica.de4gsdzk.anpr

import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafe
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafeBaseDomain
import it.finmatica.de4gsdzk.anpr.embed.AnpConiuge
import it.finmatica.de4gsdzk.utils.EArchivioSorgenteSoggetto
import it.finmatica.de4gsdzk.utils.Etichette

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

    @Column(name = "TRA_COGNOME", nullable = true)
    String cognomeTraslitterato

    @Column(name = "TRA_NOME", nullable = true)
    String nomeTraslitterato

    @Column(name = "TRA_DENOMINAZIONETOPONIMO", nullable = true)
    String toponimoTraslitterato

    @Column(name = "TRA_DENOMINAZIONECOMUNE", nullable = true)
    String comuneTraslitterato

    @Column(name = "ELE_CERTIFICABILITA", nullable = true)
    String certificabile

    @Column(name = "DES_ELE_CERTIFICABILITA", nullable = true)
    String descrizioneCertificabilita

    @Column(name = "ELE_MOTIVOCANCELLAZIONE", nullable = true)
    String motivoCancellazione

    @Column(name = "DES_ELE_MOTIVOCANCELLAZIONE", nullable = true)
    String descrizioneMotivoCancellazione

    @Column(name = "ELE_NOTECANCELLAZIONE", nullable = true)
    String noteCancellazione

    @Column(name = "DES_SOGGETTOCERTIFICABILE", nullable = true)
    String soggettoCertificabile

    static final List<Map> etichetteDomain = AnaAnagrafeBaseDomain.etichetteDomain +
            [Etichette.getEtichetta("Dati_Traslitterati"), Etichette.getEtichetta("Toponimo"), Etichette.getEtichetta("Certificabile"),
             Etichette.getEtichetta("Dati_Generali"), Etichette.getEtichetta("Certificabile"), Etichette.getEtichetta("Motivo_Cancellazione"), Etichette.getEtichetta("Note_Cancellazione")]


}
