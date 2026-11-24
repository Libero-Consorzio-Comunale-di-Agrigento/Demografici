package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.*
import it.finmatica.de4gsdzk.errors.ErroreDatiComunicazioneRuntimeException
import it.finmatica.de4gsdzk.errors.FileNonValidoRuntimeException
import it.finmatica.de4gsdzk.utils.*
import org.apache.commons.io.FilenameUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

import javax.persistence.criteria.JoinType

@Slf4j
@Transactional
@Service
class CivComunicazioneAttoService {

    private final GsdMenuDittaService gsdMenuDittaService

    private final CivAnagrafeService civAnagrafeService

    private final CivArchivioComunicazioneService civArchivioComunicazioneService

	private final CivComunicazioneAttoRepository civComunicazioneAttoRepository

    private final GestioneTestiModelloRelazioneService gestioneTestiModelloRelazioneService

    private final GestioneTestiGsdModelloService gestioneTestiGsdModelloService

    private final GsdService gsdService

    CivComunicazioneAttoService(CivComunicazioneAttoRepository civComunicazioneAttoRepository,
                                GsdMenuDittaService gsdMenuDittaService, CivAnagrafeService civAnagrafeService,
                                CivArchivioComunicazioneService civArchivioComunicazioneService,
                                GestioneTestiGsdModelloService gestioneTestiGsdModelloService,
                                GestioneTestiModelloRelazioneService gestioneTestiModelloRelazioneService,
                                GsdService gsdService
    ) {

		this.civComunicazioneAttoRepository = civComunicazioneAttoRepository
        this.gsdMenuDittaService = gsdMenuDittaService
        this.civAnagrafeService = civAnagrafeService
        this.civArchivioComunicazioneService = civArchivioComunicazioneService
        this.gestioneTestiGsdModelloService = gestioneTestiGsdModelloService
        this.gestioneTestiModelloRelazioneService = gestioneTestiModelloRelazioneService
        this.gsdService = gsdService
	}

	CivComunicazioneAtto get (String id){
		return civComunicazioneAttoRepository.findById(id)
	}

    CivComunicazioneAtto getByUk (ETipoAtto tipoAttoEnum, Integer idCom){
        return civComunicazioneAttoRepository.findByUk(new Integer(tipoAttoEnum.valore), idCom)
    }

    Page<CivComunicazioneAtto> listAllByTipoAtto(Integer tipoAtto, Pageable pageable) {
        return civComunicazioneAttoRepository.findAllByTipoAtto(tipoAtto, pageable)
    }

    List<CivComunicazioneAtto> listAllByComunicazione(CivComunicazione comunicazione) {
        if (comunicazione?.id != null){
            return civComunicazioneAttoRepository.findAllByComunicazione(comunicazione)
        }
        return []
    }

    List<Integer> listAllTipiAttoByComunicazione(CivComunicazione comunicazione) {
        if (comunicazione?.id != null){
            return civComunicazioneAttoRepository.findAllTipiAttoByComunicazione(comunicazione)
        }
        return []
    }

    void sendAllDefaultComunicazioni(ETipoOperazione tipoOperazione, CivAttoBaseDomain obj, CivAnagrafe anagrafe){
        if (tipoOperazione.isInsert() && obj.isCodRec3() ){
            List<CivComunicazioneAtto> listaComunicazioniDaInviare = listAllDefaultComunicazioni(obj, anagrafe)
            for (CivComunicazioneAtto c:listaComunicazioniDaInviare){
                CivArchivioComunicazione ac = civArchivioComunicazioneService.create()
                ac.comunicazione = c.comunicazione
                ac.numeroCopie = c.numeroCopie
                DomainUtils.initFromAtto(ac, obj)
                ac.tipoAttoRif = obj.tipoAtto
                civArchivioComunicazioneService.save(ac)
            }
        }
    }

    List<CivComunicazioneAtto> listAllDefaultComunicazioni(CivAttoBaseDomain obj, CivAnagrafe anagrafe){
        List<CivArchivioComunicazione> lArcComGestite = (civArchivioComunicazioneService.listAllByUkAttoAndTipoAtto(obj.getTipoAtto(), obj.ufficio, obj.anno, obj.atto, obj.parte, obj.serie, [:])?:[])

        if (lArcComGestite && (lArcComGestite.size() > 0) ){
            return []
        }

        List<ETipoIndividuiAtto> listaTipoIndividui = getTipiIndividuiAtto(obj, anagrafe)
        List<CivComunicazioneAtto> lCa = civComunicazioneAttoRepository.findAllByTipoAttoAndNaturaAndTipoIndividui(obj.tipoAtto, obj.natura, listaTipoIndividui)

        return lCa
    }

    List<CivComunicazioneAtto> listAllNotSelected(CivAttoBaseDomain obj, Boolean priorita){
        List<CivComunicazioneAtto> lRet = []

        CivAnagrafe anagrafe = civAnagrafeService.getByUkAttoAndTipoAtto(obj.idAtto, obj.tipoAtto)

        List<ETipoIndividuiAtto> listaTipoIndividui = getTipiIndividuiAtto(obj, anagrafe)
        List<CivComunicazioneAtto> lCa = civComunicazioneAttoRepository.findAllByTipoAttoAndNaturaAndTipoIndividuiAndFlagPriorita(obj.tipoAtto, obj.natura, listaTipoIndividui, priorita)

        List<CivArchivioComunicazione> lArcComGestite = (civArchivioComunicazioneService.listAllByUkAttoAndTipoAtto(obj.getTipoAtto(), obj.ufficio, obj.anno, obj.atto, obj.parte, obj.serie,
                [priorita: priorita, stampaEseguita:Boolean.FALSE, fetch: [[campo:'comunicazione', tipo: JoinType.INNER]] ])?:[])

        for (CivComunicazioneAtto ca: lCa){
            Boolean found = Boolean.FALSE
            for (CivArchivioComunicazione ac: lArcComGestite){
                if (ac.comunicazione.id.compareTo(ca.comunicazione.id) == 0){
                    found = Boolean.TRUE
                    break
                }
            }
            if (!found){
                lRet.add(ca)
            }
        }
        return lRet
    }

    private Map<ETipoIndividuiAtto, Boolean> checkResidenteNonResidenteSogg1(GsdMenuDitta m, ISoggettoAtto1 sogg){
        //Controllo che comune cliente e comune di residenza siano valorizzati  prima di definire r/n
        Map<ETipoIndividuiAtto, Boolean> map = [(ETipoIndividuiAtto.R): null, (ETipoIndividuiAtto.N):null]
        if (m && ( sogg.codiceComuneResidenza1 != null) && ( sogg.codiceProvinciaResidenza1 != null) ){
            Boolean isR = ( (m.comuneCliente.compareTo(sogg.codiceComuneResidenza1) == 0) && (m.provinciaCliente.compareTo(sogg.codiceProvinciaResidenza1) == 0) )
            map[ETipoIndividuiAtto.R] = isR
            map[ETipoIndividuiAtto.N] = (!(isR))
        }
        return map
    }

    private Map<ETipoIndividuiAtto, Boolean> checkResidenteNonResidenteSogg2(GsdMenuDitta m, ISoggettoAtto2 sogg){
        Map<ETipoIndividuiAtto, Boolean> map = [(ETipoIndividuiAtto.R): null, (ETipoIndividuiAtto.N):null]
        //Controllo che comune cliente e comune di residenza siano valorizzati  prima di definire r/n
        if (m && ( sogg.codiceComuneResidenza2 != null) && ( sogg.codiceProvinciaResidenza2 != null) ){
            Boolean isR = ( (m.comuneCliente.compareTo(sogg.codiceComuneResidenza2) == 0) && (m.provinciaCliente.compareTo(sogg.codiceProvinciaResidenza2) == 0) )
            map[ETipoIndividuiAtto.R] = isR
            map[ETipoIndividuiAtto.N] = (!(isR))
        }
        return map
    }

    List<ETipoIndividuiAtto> getTipiIndividuiAtto(CivAttoBaseDomain obj, CivAnagrafe anagrafe){
        Boolean findResidenti = Boolean.FALSE
        Boolean findNonResidenti = Boolean.FALSE

        List<ETipoIndividuiAtto> listaTipoIndividui = [ETipoIndividuiAtto.T]

        GsdMenuDitta m = gsdMenuDittaService.getUniqueRecord()

        // La fascia = 1 vuol dire che il soggetto è residente, cioè abita nel comune utente
        // La fascia = 3 vuol dire che il soggetto è iscritto AIRE
        // Per completezza, la fascia = 2 vuol dire che il soggetto era residente ed è stato cancellato (logicamente)
        // dall'anagrafe per diversi motivi (es morte)
        // La fascia 4 ha lo stesso significato della 2 ma solo per un soggetto che prima era AIRE
        switch (obj.getTipoAttoEnum()) {
            case ETipoAtto.CIT:
                Map<ETipoIndividuiAtto, Boolean> map = checkResidenteNonResidenteSogg1(m, obj)
                findResidenti = map.get(ETipoIndividuiAtto.R)
                findNonResidenti = map.get(ETipoIndividuiAtto.N)
                break
            case ETipoAtto.NAS:
                Integer fasciaMadre = anagrafe?.anagrafe2?.fascia?.id
                Integer fasciaPadre = (anagrafe?.anagrafe1?.fascia?.id?:new Integer(0))

                Map<ETipoIndividuiAtto, Boolean> map = checkResidenteNonResidenteSogg1(m, obj)
                Integer fasciaConfronto = ((fasciaMadre != null)?fasciaMadre:fasciaPadre)
                findResidenti = (map.get(ETipoIndividuiAtto.R) || (fasciaConfronto.intValue() == 3) )

                if ( (fasciaMadre == null) && ( ((CivNascita) obj).codiceComuneResidenzaMadre != null) && ( ((CivNascita) obj).codiceProvinciaResidenzaMadre != null) ){
                    Boolean isRMadre = ( (m.comuneCliente.compareTo(((CivNascita) obj).codiceComuneResidenzaMadre) == 0) && (m.provinciaCliente.compareTo(((CivNascita) obj).codiceProvinciaResidenzaMadre) == 0) )
                    findNonResidenti = ( map.get(ETipoIndividuiAtto.N) && (!(isRMadre)) )
                } else {
                    // fasciaMadre non nulla oppure fasciaMadre nulla e residenza madre non valorizzata
                    findNonResidenti = ( map.get(ETipoIndividuiAtto.N) && (fasciaConfronto.intValue() != 1) && (fasciaConfronto.intValue() != 3) )
                }
                break
            case ETipoAtto.MOR:
                Integer fasciaConfronto = anagrafe?.anagrafe1?.fascia?.id?:(new Integer(0))

                Map<ETipoIndividuiAtto, Boolean> map = checkResidenteNonResidenteSogg1(m, obj)
                findResidenti = ( map.get(ETipoIndividuiAtto.R) || (fasciaConfronto.intValue() == 3) )
                findNonResidenti = ( map.get(ETipoIndividuiAtto.N) && (fasciaConfronto.intValue() != 1) && (fasciaConfronto.intValue() != 3) )
                break
            case ETipoAtto.PUB:
            case ETipoAtto.PVU:
                Map<ETipoIndividuiAtto, Boolean> map1 = checkResidenteNonResidenteSogg1(m, obj)
                Map<ETipoIndividuiAtto, Boolean> map2 = checkResidenteNonResidenteSogg2(m, obj)
                findResidenti = (map1.get(ETipoIndividuiAtto.R) || map2.get(ETipoIndividuiAtto.R))
                findNonResidenti = (map1.get(ETipoIndividuiAtto.N) && map2.get(ETipoIndividuiAtto.N))
                break
            case ETipoAtto.MAT:
            case ETipoAtto.UCI:
                Integer fasciaSoggetto1 = anagrafe?.anagrafe1?.fascia?.id?:new Integer(0)
                Integer fasciaSoggetto2 = anagrafe?.anagrafe2?.fascia?.id?:new Integer(0)

                Map<ETipoIndividuiAtto, Boolean> map1 = checkResidenteNonResidenteSogg1(m, obj)
                Map<ETipoIndividuiAtto, Boolean> map2 = checkResidenteNonResidenteSogg2(m, obj)
                findResidenti = (map1.get(ETipoIndividuiAtto.R) || (fasciaSoggetto1.intValue() == 3) || map2.get(ETipoIndividuiAtto.R) || (fasciaSoggetto2.intValue() == 3) )

                findNonResidenti = (map1.get(ETipoIndividuiAtto.N) && (fasciaSoggetto1.intValue() != 1) && (fasciaSoggetto1.intValue() != 3) &&
                                    map2.get(ETipoIndividuiAtto.N) && (fasciaSoggetto2.intValue() != 1) && (fasciaSoggetto2.intValue() != 3) )
                break
        }

        if (findResidenti){
            listaTipoIndividui.add(ETipoIndividuiAtto.R)
        }
        if (findNonResidenti){
            listaTipoIndividui.add(ETipoIndividuiAtto.N)
        }

        return listaTipoIndividui
    }

    void validaDati(CivComunicazioneAtto obj, GestioneTestiModelloRelazione modelloRelazione, boolean force) {
        if (obj.getComunicazione()?.getId()==0) {
            throw new ErroreDatiComunicazioneRuntimeException(Etichette.getEtichetta("Errore_modifica_comunicazione"))
        }
        String nomeModelloCaricato = FilenameUtils.removeExtension(modelloRelazione.modello.nome)
        String nomeModelloStandard = FileUtils.getNomeModelloComunicazioneAttoStandard(obj.tipoAtto, obj.comunicazione.id)
        if ( (nomeModelloCaricato != nomeModelloStandard) && (!(force) ) ){
            throw new FileNonValidoRuntimeException(Etichette.getEtichetta("Warn_file_modello_comunicazione"), "(Nome file atteso: ${nomeModelloStandard})")
        }
        ValidationUtils.validaDatiObbligatori(obj)
    }

    /**
     * Salva un record
     * @param obj il record
     * @param modelloRelazione la relazione (eventuale) col modello
     * @return il record (aggiornato)
     */
    CivComunicazioneAtto save(CivComunicazioneAtto obj, GestioneTestiModelloRelazione modelloRelazione, boolean force=false) {
        validaDati(obj, modelloRelazione, force)

        // In modifica non è possibile cambiare il tipo atto o la comunicazione.
        // In ogni caso è bene tenere la chiave allineata nel backend
        obj.id = gsdService.getIdComunicazioneAtto(obj)
        // comunicazione atto
        CivComunicazioneAtto c = civComunicazioneAttoRepository.save(obj)

        // modello
        if (modelloRelazione.modello.fileTemplate != null) {
            modelloRelazione.modello.codice = FileUtils.getCodiceModelloComunicazioneAttoStandard(c.tipoAtto, c.comunicazione.id)
            modelloRelazione.modello = gestioneTestiGsdModelloService.save(modelloRelazione.modello)
            modelloRelazione.comunicazioneAtto = c
            // relazione
            gestioneTestiModelloRelazioneService.save(modelloRelazione)
        }

        return c
    }

    /**
     * Cancella un record (incluso il modello collegato)
     * @see GestioneTestiModelloRelazione
     * @param obj il record
     */
    void delete(CivComunicazioneAtto obj) {
        GestioneTestiModelloRelazione r = gestioneTestiModelloRelazioneService.getByIdComunicazioneAtto(obj.id)
        if (r) {
            gestioneTestiModelloRelazioneService.delete(r)//cascade su comunicazioneAtto
            gestioneTestiGsdModelloService.delete(r.modello)//non c'è cascade sul modello
        }
        log.info("Tento cancellazione su CIVDCA per id " + obj.id)
        civComunicazioneAttoRepository.delete(obj)
    }
}
