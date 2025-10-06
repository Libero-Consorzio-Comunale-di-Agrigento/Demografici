package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.IAnscComunicazione
import it.finmatica.de4gsdzk.utils.ETipoArchivioAnsc

interface IAnscOggettoInvio {

    ETipoArchivioAnsc getTipoArchivioComunicazione()

    Long getIdDomain()

    List<IAnscComunicazione> getComunicazioni()

    IAnscComunicazione getUltimaComunicazione()

    AnscEndPointServizioArchivio getServizioCdu()

}
