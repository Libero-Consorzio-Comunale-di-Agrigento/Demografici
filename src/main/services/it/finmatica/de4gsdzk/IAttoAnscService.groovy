package it.finmatica.de4gsdzk

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.utils.EMotivoRecupero

@CompileStatic
interface IAttoAnscService extends IAttoService{

    CivAttoBaseDomain getByIdAttoAnsc(String idAttoAnsc)

    void updateIdAnscUseCase(Long id, Long idAnscUseCase)

    void updateMotivoRecuperoAnsc(Long id, EMotivoRecupero motivoRecuperoAnsc)

    void updateIdAttoAnsc(Long id, String idAttoAnsc)

    EMotivoRecupero getMotivoRecuperoAnsc(Long id)

    Boolean isInviatoAnsc(Long id)

    Boolean isFirmatoUscAnsc(Long id)

    Boolean isFirmatoCartaceoAnsc(Long id)

    Boolean hasAllegatiInviatiAnsc(Long id)

    Boolean isConformeAnsc(Long id)

    Boolean existsIdAttoAnsc(String idAttoAnsc)

}
