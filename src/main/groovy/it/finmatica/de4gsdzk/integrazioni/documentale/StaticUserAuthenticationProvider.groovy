package it.finmatica.de4gsdzk.integrazioni.documentale

import it.finmatica.smartdoc.api.login.AuthenticationProvider
import it.finmatica.smartdoc.api.login.Utente

class StaticUserAuthenticationProvider implements AuthenticationProvider {

    static String USER_GDM = "GDM"

    @Override
    public Utente getUtente() {
        return new Utente(USER_GDM)
    }

    @Override
    public void login(Utente utente) {
    }

}
