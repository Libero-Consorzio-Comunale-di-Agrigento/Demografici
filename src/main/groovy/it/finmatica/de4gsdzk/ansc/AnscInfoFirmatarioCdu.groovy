package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.IAnscComunicazione
import it.finmatica.de4gsdzk.utils.ETipoArchivioAnsc

class AnscInfoFirmatarioCdu implements IAnscOggettoInvio{

    private final AnscEndPointServizioArchivio servizioCdu
    private final Long idFirmatario
    private final String nominativo
    private final Date dataNascita
    private final String indirizzoMail
    private final Long idAnscPresaVisione
    private final List<IAnscComunicazione> comunicazioni

    AnscInfoFirmatarioCdu(AnscEndPointServizioArchivio servizioCdu, Long idFirmatario, String nominativo, Date dataNascita, String indirizzoMail, Long idAnscPresaVisione,
                          List<IAnscComunicazione> comunicazioni){
        this.servizioCdu = servizioCdu
        this.idFirmatario = idFirmatario
        this.nominativo = nominativo
        this.dataNascita = dataNascita
        this.indirizzoMail = indirizzoMail
        this.idAnscPresaVisione = idAnscPresaVisione
        this.comunicazioni = comunicazioni
    }

    AnscEndPointServizioArchivio getServizioCdu() {
        return servizioCdu
    }

    ETipoArchivioAnsc getTipoArchivioComunicazione() {
        ETipoArchivioAnsc.FIR
    }

    Long getIdFirmatario() {
        return idFirmatario
    }

    Long getIdDomain() {
        return idFirmatario
    }

    String getNominativo(){
        return nominativo
    }

    Date getDataNascita() {
        return dataNascita
    }

    String getIndirizzoMail() {
        return indirizzoMail
    }

    Long getIdAnscPresaVisione() {
        return idAnscPresaVisione
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
