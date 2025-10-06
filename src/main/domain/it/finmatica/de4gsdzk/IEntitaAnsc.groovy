package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.utils.ETipoArchivioAnsc
import it.finmatica.de4gsdzk.utils.ETipoAttoAnsc

interface IEntitaAnsc {

    Long getIdAnscUseCase()
    void setIdAnscUseCase(Long l)

    ETipoArchivioAnsc getTipoArchivioAnsc()

    Long getNumeroUnico()
    void setNumeroUnico(Long l)

    ETipoAttoAnsc getTipoAttoAnsc()

    String getIdAttoAnsc()
    void setIdAttoAnsc(String s)

    Boolean getFlagFirmatoUscAnsc()
    void setFlagFirmatoUscAnsc(Boolean b)

}
