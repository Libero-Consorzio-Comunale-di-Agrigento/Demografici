package it.finmatica.de4gsdzk

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafe
import it.finmatica.de4gsdzk.anpr.AnpAnagrafe
import it.finmatica.de4gsdzk.utils.EFase

import javax.persistence.*

@Entity
@Table(name = "GSDLOG_V")
@CompileStatic
class LogGsd extends LogBaseDomain {

    @Enumerated(EnumType.STRING)
    @Column(name = "FASE")
    EFase fase

    @Column(name = "PARAMETRI", nullable = true)
    String parametri

    static LogGsd createLogGsdVisualizzazioneIndividuoAna(AnaAnagrafe anagrafe) {
        LogGsd log = new LogGsd()
        log.fase = EFase.VANA
        log.parametri = "matricola: $anagrafe.matricola ($anagrafe.nome $anagrafe.cognome - $anagrafe.sesso - $anagrafe.dataNascita)"
        return log
    }

    static LogGsd createLogGsdVisualizzazioneIndividuoAnp(AnpAnagrafe anagrafe) {
        LogGsd log = new LogGsd()
        log.fase = EFase.VANP
        log.parametri = "matricola: $anagrafe.matricola ($anagrafe.nome $anagrafe.cognome - $anagrafe.sesso - $anagrafe.dataNascita)"
        return log
    }
}
