package it.finmatica.de4gsdzk

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.ErroreDatiComunicazioneRuntimeException
import it.finmatica.de4gsdzk.errors.FileNonValidoRuntimeException
import it.finmatica.de4gsdzk.utils.EStatoInvioAlbo
import it.finmatica.de4gsdzk.utils.EStatoProtocollazione
import it.finmatica.de4gsdzk.utils.Etichette

@Slf4j
trait TraitArchivioComunicazioneService {

    abstract IArchivioComunicazioneRepository getArchivioComunicazioneRepository()

    abstract GsdService getGsdService()

    abstract void validaDati(IArchivioComunicazione obj, Boolean ignoreStampaEseguita, Boolean ignoreStato)
    abstract String protocollaComunicazione(Long id)
    abstract String inviaAlboComunicazione(IArchivioComunicazione obj)

    IArchivioComunicazione get(Long id) {
        return archivioComunicazioneRepository.findById(id)
    }

    EStatoProtocollazione getStatoProtocollazione(Long id) {
        return archivioComunicazioneRepository.findStatoProtocollazione(id)
    }

    EStatoInvioAlbo getStatoInvioAlbo(Long id) {
        return archivioComunicazioneRepository.findStatoInvioAlbo(id)
    }

    Boolean getStampaEseguita(Long id) {
        return archivioComunicazioneRepository.findStampaEseguita(id)
    }

    Boolean checkAllegatoPrincipale(Long idArcCom) {
        Integer n = archivioComunicazioneRepository.checkAllegatoPrincipale(idArcCom)
        return (n.intValue() == 1)
    }


    void bloccaSeProtocollata(IArchivioComunicazione obj) {
        EStatoProtocollazione sp = getStatoProtocollazione(obj.id)
        if ((sp != null) && (sp == EStatoProtocollazione.P)) {
            throw new ErroreDatiComunicazioneRuntimeException(Etichette.getEtichetta("Errore_modifica_comunicazioni_protocollate"))
        }
    }

    void bloccaSeInviataAlbo(IArchivioComunicazione obj) {
        EStatoInvioAlbo si = getStatoInvioAlbo(obj.id)
        if ((si != null) && (si == EStatoInvioAlbo.I)) {
            throw new ErroreDatiComunicazioneRuntimeException(Etichette.getEtichetta("Errore_modifica_comunicazioni_inviate_albo"))
        }
    }

    void bloccaSeStampaEseguita(IArchivioComunicazione obj) {
        Boolean se = getStampaEseguita(obj.id)
        if (se) {
            throw new ErroreDatiComunicazioneRuntimeException(Etichette.getEtichetta("Errore_modifica_comunicazioni_eseguite"))
        }
    }

    void bloccaSeConNumerazioneProvvisoria(IArchivioComunicazione obj) {
        if (obj.numero.compareTo(new Integer(0)) < 0) {
            throw new ErroreDatiComunicazioneRuntimeException(Etichette.getEtichetta("Errore_protocollazione_comunicazioni_provvisorie"))
        }
    }

    String protocolla(IArchivioComunicazione obj) {
        validaDati(obj, Boolean.FALSE, Boolean.FALSE)
        bloccaSeConNumerazioneProvvisoria(obj)

        String s
        Boolean hasPrincipale = checkAllegatoPrincipale(obj.id)
        if (hasPrincipale) {
            s = protocollaComunicazione(obj.id)
        } else {
            throw new FileNonValidoRuntimeException(Etichette.getEtichetta("Errore_testo_principale_comunicazione"))
        }
        return s
    }

    String inviaAlbo(IArchivioComunicazione obj) {
        validaDati(obj, Boolean.FALSE, Boolean.FALSE)
        bloccaSeConNumerazioneProvvisoria(obj)

        String s
        Boolean hasPrincipale = checkAllegatoPrincipale(obj.id)
        if (hasPrincipale) {
            s = inviaAlboComunicazione(obj)
        } else {
            throw new FileNonValidoRuntimeException(Etichette.getEtichetta("Errore_testo_principale_comunicazione"))
        }
        return s
    }

    String firmaComunicazione(List<IArchivioComunicazione> listaArcCom, String idsArcCom, Long idAlle, String codUte, String otp) {
        for (IArchivioComunicazione arcCom : listaArcCom) {
            validaDati(arcCom, Boolean.FALSE, Boolean.FALSE)
        }
        return gsdService.firmaComunicazione(idsArcCom, idAlle, codUte, otp)
    }
}
