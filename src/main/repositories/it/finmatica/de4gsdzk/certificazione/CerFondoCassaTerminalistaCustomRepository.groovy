package it.finmatica.de4gsdzk.certificazione


import it.finmatica.de4gsdzk.certificazione.CerFondoCassaTerminalista
import it.finmatica.de4gsdzk.certificazione.CerTerminalista

interface CerFondoCassaTerminalistaCustomRepository {

    CerFondoCassaTerminalista findByTerminalistaAndData(CerTerminalista terminalista, Date data)

    boolean existsByTerminalistaAndData(CerTerminalista terminalista, Date data)
}