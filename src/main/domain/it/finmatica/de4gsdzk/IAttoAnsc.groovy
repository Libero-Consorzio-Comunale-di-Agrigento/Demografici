package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.utils.EMotivoRecupero
import it.finmatica.de4gsdzk.utils.ETipoSiNo

interface IAttoAnsc extends IEntitaAnsc{

    //ETipoEventoAnsc getTipoEventoAnsc()

    EMotivoRecupero getMotivoRecuperoAnsc()
    void setMotivoRecuperoAnsc(EMotivoRecupero m)

    ETipoSiNo getMotivoRecuperoAnscValorizzato()
    void setMotivoRecuperoAnscValorizzato(ETipoSiNo t)

    // Per gestione specifica cdu
    Boolean isTrascrizioneEsteroDaPrivato()

    Boolean isTrascrizioneEsteroDaAutorita()

    Boolean isEnteStranieroEnabled()

    Boolean isDatiRichiedenteEnabled()

    Boolean isAutoritaMittenteEnabled()

    Boolean isConsolatoMandatory()

}
