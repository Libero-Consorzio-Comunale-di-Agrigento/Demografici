package it.finmatica.de4gsdzk.certificazione.generazione.ansc

import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.certificazione.CerCertificatoEmesso
import it.finmatica.de4gsdzk.certificazione.generazione.ETipoGenerazioneCertificato
import it.finmatica.de4gsdzk.certificazione.generazione.IGenerazioneCertificatoParams
import org.zkoss.zk.ui.event.EventListener
import org.zkoss.zul.Window

class AnscGenerazioneCertificatoParams implements IGenerazioneCertificatoParams {
    CerCertificatoEmesso certificato
    Closure onSuccess
    Closure onFailure

    CivAttoBaseDomain atto
    Window window
    EventListener otpEventListener

    @Override
    ETipoGenerazioneCertificato getTipoGenerazioneCertificato() {
        return ETipoGenerazioneCertificato.ANSC
    }
}
