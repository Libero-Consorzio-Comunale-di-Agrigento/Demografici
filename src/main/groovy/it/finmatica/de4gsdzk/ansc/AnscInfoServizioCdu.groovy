package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.IAnscComunicazione
import it.finmatica.de4gsdzk.utils.ETipoArchivioAnsc

class AnscInfoServizioCdu implements IAnscOggettoInvio{

    private final AnscEndPointServizioArchivio servizioCdu
    private final ETipoArchivioAnsc tipoArchivioComunicazione
    private final Long idDomain
    private final List<IAnscComunicazione> comunicazioni

    AnscInfoServizioCdu(AnscEndPointServizioArchivio servizioCdu, ETipoArchivioAnsc tipoArchivioComunicazione, Long idDomain, List<IAnscComunicazione> comunicazioni){
        this.servizioCdu = servizioCdu
        this.tipoArchivioComunicazione = tipoArchivioComunicazione
        this.idDomain = idDomain
        this.comunicazioni = comunicazioni
    }

    AnscEndPointServizioArchivio getServizioCdu() {
        return servizioCdu
    }

    ETipoArchivioAnsc getTipoArchivioComunicazione() {
        return tipoArchivioComunicazione
    }

    Long getIdDomain() {
        return idDomain
    }

    List<IAnscComunicazione> getComunicazioni() {
        return comunicazioni
    }

    IAnscComunicazione getUltimaComunicazione(){
        IAnscComunicazione ultima = null
        if (comunicazioni?.size()>0){
            for (IAnscComunicazione cal:comunicazioni){
                if (cal.flagUltima) {
                    ultima = cal
                    break
                }
            }
        }
        return ultima
    }
}
