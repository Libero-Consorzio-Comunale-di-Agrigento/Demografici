package it.finmatica.de4gsdzk.utils

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.*
import it.finmatica.de4gsdzk.statocivile.embed.Comune

import java.util.regex.Pattern

/**
 * Implementazione temporanea per la validazione automatica
 *
 * TODO: integrare ZK o javax.validation
 */
@Slf4j
class ValidationUtils {

    /**
     * Controlla i campi obbligatori. Se specificati nelle condizioni
     *
     * @param entity l'entity
     * @param conditions (opzionale) una lista di campi da controllare condizionalmente,
     *      indipendentemente dalle annotazioni sull'entity
     * @throws it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
     */
    static <T> void validaDatiObbligatori(T entity, Map conditions=[:]) {

        for (final ClassUtils.ClassField it : ClassUtils.getAllFields(entity)) {

            String name = it.field.getName()

            // salta campi opzionali o introdotti da hibernate/framework
            if (conditions.get(name)==false || it.isBoilerPlate()) {
                continue
            }

            try {
                if (it.isEmpty()) {
                    if (conditions.containsKey(name) || it.isRequired()) {
                        //throw new CampoMandatoryRuntimeException("(" + it.getLabel() + ")")
                        throw new CampoMandatoryRuntimeException()
                    }
                }
            } catch(De4gsdzkRuntimeException exc) {
                throw exc
            } catch(NoSuchMethodException ignore) {
                //ok
            } catch(Throwable e) {
                log.error("Errore validazione", e)
            }

        }
    }

    static boolean isEmailAddressValid(String emailAddress) {
        String regexPattern= '^([a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,})$'
        return Pattern.compile(regexPattern).matcher(emailAddress).matches()
    }

    static boolean isComuneAndDataFormazioneValid(Comune comune, Date dataFormazione){
        if ( (comune.codice == null) || (comune.codiceProvincia == null) || (dataFormazione == null) ){
            return false
        }
        return true
    }

    static void validaDatiAnnotazione(DatiValidazioneAnnotazione eac, String sezione) {
        Boolean isAttoAnalogAnyFilled = (eac.numeroAtto != null || eac.parteAtto != null || !TestoUtils.isVuoto(eac.serieAtto) || eac.annoAtto != null || eac.ufficioAtto)
        Boolean isAttoDigitalAnyFilled = !TestoUtils.isVuoto(eac.idAttoAnsc)
        Boolean isComuneAnyFilled = eac.codiceComune != null && eac.codiceProvincia != null
        Boolean isFormulaAnyFilled = !TestoUtils.isVuoto(eac.formula)
        if (!eac.datiAnnotazioneMandatory && !isAttoAnalogAnyFilled && !isAttoDigitalAnyFilled && !isComuneAnyFilled && !isFormulaAnyFilled) {
            throw new ValidazioneEstremiAttoEmptyRuntimeException()
        }
        validaEstremiAtto(eac.datiValidazioneEstremi, sezione)
        validaEstremiAttoComune(eac.datiValidazioneComune, sezione)
        validaEstremiAttoData(eac.datiValidazioneDataAtto, sezione)
        if (eac.formulaMandatory) {
            if (TestoUtils.isVuoto(eac.formula)) {
                throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezione)
            }
        }
    }

    static void validaEstremiAtto(DatiValidazioneEstremi eac, String sezione) {
        Boolean isAttoAnalogAnyFilled = (eac.numeroAtto != null || eac.parteAtto != null || !TestoUtils.isVuoto(eac.serieAtto) || eac.annoAtto != null || eac.ufficioAtto)
        Boolean isAttoDigitalAnyFilled = !TestoUtils.isVuoto(eac.idAttoAnsc)
        if (eac.estremiMandatory && !(isAttoAnalogAnyFilled || isAttoDigitalAnyFilled)) {
            throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezione)
        }
        if (isAttoAnalogAnyFilled && isAttoDigitalAnyFilled) {
            Map<String, String> etichetta = EtichetteMessaggi.Errore_atto_analogico_digitale
            String additionalInfo = etichetta.defaultValue + " ( " + sezione + " )"
            throw new De4gsdzkRuntimeException(etichetta, additionalInfo)
        }
        if (isAttoAnalogAnyFilled) {
            if (!(TipoAttoUtils.isAttoOk(eac.numeroAtto))) {
                throw new ErroreLunghezzaCampiRuntimeException("Atto in " + sezione)
            }
            if (!(TipoAttoUtils.isAttoOk(eac.numeroAtto, false))) {
                throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezione)
            }
            if (!(TipoAttoUtils.isAnnoOk(eac.annoAtto))) {
                throw new ErroreLunghezzaCampiRuntimeException("Anno in " + sezione)
            }
            if (!(TipoAttoUtils.isAnnoOk(eac.annoAtto, false))) {
                throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezione)
            }
            if (!(TipoAttoUtils.isParteOk(eac.tipoAtto, eac.parteAtto))) {
                throw new ErroreValoreParteSerieException(EtichetteMessaggi.Errore_parte, "( " + sezione + " )")
            }
            if (!(TipoAttoUtils.isParteOk(eac.tipoAtto, eac.parteAtto, false))) {
                throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezione)
            }
            Boolean serieOk = TipoAttoUtils.isSerieOk(eac.tipoAtto, eac.serieAtto)
            if (!(serieOk)) {
                throw new ErroreValoreParteSerieException(EtichetteMessaggi.Errore_serie, "Serie in " + sezione)
            }
            if (eac.ufficioMandatory) {
                if (TestoUtils.isVuoto(eac.ufficioAtto)) {
                    throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezione)
                }
            }
        }
        if (isAttoDigitalAnyFilled) {
            if (TestoUtils.isVuoto(eac.idAttoAnsc)) {
                throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezione)
            }
        }
    }

    static void validaEstremiAttoData(DatiValidazioneDataAtto eac, String sezione) {
        if (eac.dataAttoMandatory) {
            if (eac.dataAtto == null) {
                throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezione)
            }
        }
    }

    static void validaEstremiAttoComune(DatiValidazioneComune eac, String sezione) {
        if (eac.comuneMandatory) {
            if (eac.codiceComune == null || eac.codiceProvincia == null) {
                throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezione)
            }
        }
    }


}
