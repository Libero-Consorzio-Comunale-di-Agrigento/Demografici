package it.finmatica.de4gsdzk.utils

import it.finmatica.de4gsdzk.anagrafe.AnaCodiceEvento
import it.finmatica.de4gsdzk.anagrafe.ECodiceMovimento

interface ICodiceMovimentoEvento {
    ECodiceMovimento getCodiceMovimento()

    AnaCodiceEvento getCodiceEvento()
}