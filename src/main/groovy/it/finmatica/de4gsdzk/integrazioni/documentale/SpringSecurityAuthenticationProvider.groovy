package it.finmatica.de4gsdzk.integrazioni.documentale

import it.finmatica.smartdoc.api.login.AuthenticationProvider
import it.finmatica.smartdoc.api.login.Utente
import it.finmatica.so4.login.So4SpringSecurityService
import it.finmatica.so4.login.So4UserDetail

class SpringSecurityAuthenticationProvider implements AuthenticationProvider {

    private final So4SpringSecurityService so4SpringSecurityService

    SpringSecurityAuthenticationProvider(So4SpringSecurityService so4SpringSecurityService) {
        this.so4SpringSecurityService = so4SpringSecurityService
    }

    @Override
    public Utente getUtente() {
        // accedo all'utente direttamente dal principal così non scatta una nuova transazione.
        // utile soprattutto per lo storico envers (una transaction fa fallire la PostUpdateEventListener)
        So4UserDetail userDetails = so4SpringSecurityService.getPrincipal()
        return new Utente(userDetails.getId())
    }

    @Override
    public void login(Utente utente) {
    }

}
