package it.finmatica.de4gsdzk

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.ErroreAllegatoDocumentaleRuntimeException
import it.finmatica.de4gsdzk.errors.ErroreDatiComunicazioneRuntimeException
import it.finmatica.de4gsdzk.utils.Etichette

@Slf4j
trait TraitComunicazioneAllegatoService {

    abstract IComunicazioneAllegatoRepository getComunicazioneAllegatoRepository()

    abstract IArchivioComunicazioneService getArchivioComunicazioneService()

    abstract GsdService getGsdService()

    abstract void deleteAllegato(IComunicazioneAllegato obj)

    IComunicazioneAllegato get(Long id) {
        return comunicazioneAllegatoRepository.findById(id)
    }

    IComunicazioneAllegato getPrincipale(Long idArcCom) {
        return comunicazioneAllegatoRepository.findPrincipale(idArcCom)
    }

    List<IComunicazioneAllegato> listAllMetadatiByArchivioComunicazione(Long idArcCom) {
        return comunicazioneAllegatoRepository.findAllMetadatiByArchivioComunicazione(idArcCom)
    }

    Integer getNumAllegatiComunicazioneByNome(Long idArcCom, Long idComAlle, String nome) {
        if (idArcCom != null) {
            return comunicazioneAllegatoRepository.getNumAllegatiComunicazioneByNome(idArcCom, idComAlle, nome)
        }
        return null
    }

    Boolean checkAllegatiDaFirmare(List<Long> idsArcCom) {
        Integer n = comunicazioneAllegatoRepository.checkAllegatiDaFirmare(idsArcCom)
        return (n.intValue() > 0)
    }

    void validaDatiPre(IComunicazioneAllegato obj, Boolean ignoreStato = Boolean.FALSE, Boolean ignoreStampaEseguita = Boolean.FALSE) {
        if (!(ignoreStato)) {
            archivioComunicazioneService.bloccaSeProtocollata(obj.archivioComunicazione)
            archivioComunicazioneService.bloccaSeInviataAlbo(obj.archivioComunicazione)
        }

        if (!(ignoreStampaEseguita)) {
            archivioComunicazioneService.bloccaSeStampaEseguita(obj.archivioComunicazione)
        }
    }

    void validaDati(IComunicazioneAllegato obj, Boolean ignoreStato = Boolean.FALSE, Boolean ignoreStampaEseguita = Boolean.FALSE) {

        validaDatiPre(obj, ignoreStato, ignoreStampaEseguita)

        if (!ignoreStampaEseguita) {
            Boolean hasPrincipale = archivioComunicazioneService.checkAllegatoPrincipale(obj.archivioComunicazione.id)
            if (obj.principale && hasPrincipale) {
                throw new ErroreDatiComunicazioneRuntimeException(Etichette.getEtichetta("Errore_salvataggio_testo_comunicazione"))
            }
        }

        // Check nome allegato
        Integer nAlle = getNumAllegatiComunicazioneByNome(obj.archivioComunicazione.id, obj.id, obj.nome)
        if (nAlle == null) {
            nAlle = new Integer(0)
        }
        if (nAlle.intValue() > 0) {
            throw new ErroreAllegatoDocumentaleRuntimeException(Etichette.getEtichetta("Errore_inserimento_nome_allegato_comunicazione"))
        }
    }


    void deleteComunicazioneEAllegati(IArchivioComunicazione arcCom) {
        List<IComunicazioneAllegato> l = listAllMetadatiByArchivioComunicazione(arcCom.id) as List<IComunicazioneAllegato>
        for (IComunicazioneAllegato a : l) {
            deleteAllegato(get(a.id))
        }

        archivioComunicazioneService.deleteComunicazione(arcCom)
    }
    

}