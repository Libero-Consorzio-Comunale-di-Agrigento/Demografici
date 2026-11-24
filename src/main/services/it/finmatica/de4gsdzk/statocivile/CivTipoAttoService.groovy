package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.ErroreTipoAttoRuntimeException
import it.finmatica.de4gsdzk.utils.*
import org.springframework.data.domain.Page
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivTipoAttoService {

	private final GsdService gsdService

	private final CivTipoAttoRepository civTipoAttoRepository

	private final ArcParametroService arcParametroService

	CivTipoAttoService(CivTipoAttoRepository civTipoAttoRepository, GsdService gsdService, ArcParametroService arcParametroService) {

		this.civTipoAttoRepository = civTipoAttoRepository
		this.gsdService = gsdService
		this.arcParametroService = arcParametroService
	}

	CivTipoAtto get (Long id){
		return civTipoAttoRepository.findById(id)
	}

	CivTipoAtto getPregressoOriginaleByTipoAttoAndParteAndSerie(Integer tipoAtto, Integer parte, String serie) {
		Boolean flagAnsc = arcParametroService.isIntegrazioneAnscAttiva() ?: null
		return civTipoAttoRepository.findByFlagPregressoTrueAndTipoAttoAndParteAndSerieAndFlagAnscAndNaturaInList(tipoAtto, parte, serie, flagAnsc, [ENaturaAtto.O])
	}

	// PARTE PRIMA
	private isPartePrimaOriginale(Integer parte, ENaturaAtto natura){
		return ( (parte.intValue() == 1) && (natura == ENaturaAtto.O) )
	}

	private isPartePrimaSenzaSerieOriginale(Integer parte, String serie, ENaturaAtto natura){
		return ( (parte.intValue() == 1) && ( (serie?:"") == "" ) && (natura == ENaturaAtto.O) )
	}

	private isPrimaAOriginale(Integer parte, String serie, ENaturaAtto natura){
		return ( (parte.intValue() == 1) && ( (serie?:"") == CivTipoAtto.SERIE_A) && (natura == ENaturaAtto.O) )
	}

	private isPrimaBOriginale(Integer parte, String serie, ENaturaAtto natura){
		return ( (parte.intValue() == 1) && ( (serie?:"") == CivTipoAtto.SERIE_B) && (natura == ENaturaAtto.O) )
	}

	// PARTE SECONDA
	private isParteSecondaOriginale(Integer parte, ENaturaAtto natura){
		return ( (parte.intValue() == 2) && (natura == ENaturaAtto.O) )
	}

	private isParteSecondaTrascritto(Integer parte, ENaturaAtto natura){
		return ( (parte.intValue() == 2) && (natura == ENaturaAtto.T) )
	}

	private isParteSecondaDiverso(Integer parte, ENaturaAtto natura){
		return ( (parte.intValue() == 2) && (natura == ENaturaAtto.D) )
	}

	private isSecondaAOriginale(Integer parte, String serie, ENaturaAtto natura){
		return ( (parte.intValue() == 2) && ( (serie?:"") == CivTipoAtto.SERIE_A) && (natura == ENaturaAtto.O) )
	}

	private isSecondaATrascritto(Integer parte, String serie, ENaturaAtto natura){
		return ( (parte.intValue() == 2) && ( (serie?:"") == CivTipoAtto.SERIE_A) && (natura == ENaturaAtto.T) )
	}

	private isSecondaBOriginale(Integer parte, String serie, ENaturaAtto natura){
		return ( (parte.intValue() == 2) && ( (serie?:"") == CivTipoAtto.SERIE_B) && (natura == ENaturaAtto.O) )
	}

	private isSecondaBTrascritto(Integer parte, String serie, ENaturaAtto natura){
		return ( (parte.intValue() == 2) && ( (serie?:"") == CivTipoAtto.SERIE_B) && (natura == ENaturaAtto.T) )
	}
	private isSecondaBBisTrascritto(Integer parte, String serie, ENaturaAtto natura){
		return ( (parte.intValue() == 2) && ((serie?:"").toUpperCase().contains(CivTipoAtto.SERIE_BIS)) && (natura == ENaturaAtto.T) )
	}

	Boolean checkTipoAttoAndParteAndSerieAndNatura(CivAttoBaseDomain atto, CivCategoriaTipoAtto categoriaDomain){

		if (atto.natura == ENaturaAtto.N){
			return Boolean.TRUE
		}

		/*
		- in inserimento di nuovo atto (cod_rec = 3), un atto zk non può non avere la categoria
		- in modifica, il controllo è da fare solo se c'è la categoria
		- in modifica di atto pregresso / consolidato basta controllare se la combinazione di parte / serie / natura è possibile
		  Per le categorie con natura non valorizzata (es ATL - Atti a Testo Libero) non ci sarà blocco in sede di modifica della natura
		*/
		/*
		if ( (atto.codiceRecord.intValue() == 3) && ( (atto.tipoAttoDomain == null) || (categoriaDomain == null ) ) ){
			return Boolean.FALSE
		}
		*/

		Boolean emptyMandatoryFields = Boolean.TRUE
		switch (atto.tipoAttoEnum) {
			// refs #48893: diversamente da quanto indicato nella issue, consento il cambiamento della natura per gli atti con categoria ATL
			// solo se questi ultimi sono stati consolidati (blocco per quelli in inserimento)
			case ETipoAtto.NAS:
			case ETipoAtto.MAT:
			case ETipoAtto.MOR:
			case ETipoAtto.UCI:
				emptyMandatoryFields =
						( (atto.parte == null) || (atto.natura == null) ||
						( (categoriaDomain != null) && (categoriaDomain?.natura != null) && (categoriaDomain.natura != atto.natura) ) ||
						( (atto.tipoAttoDomain != null) && (categoriaDomain?.codice == CivCategoriaTipoAtto.ATL) && (atto.tipoAttoDomain?.natura != atto.natura) && (atto.codiceRecord.intValue() == 3) ) )
				break
			case ETipoAtto.PUB:
				emptyMandatoryFields =  ( (atto.parte == null) || (atto.natura == null) || ( (categoriaDomain != null) && (categoriaDomain?.natura != null) && (atto.natura != categoriaDomain.natura) ) )
				break
			case ETipoAtto.PVU:
			case ETipoAtto.CIT:
				emptyMandatoryFields =  ( (atto.natura == null) || ( (categoriaDomain != null) && (categoriaDomain?.natura != null) && (atto.natura != categoriaDomain.natura) ) )
				break
		}
		if (emptyMandatoryFields){
			return Boolean.FALSE
		}

		Boolean isPrevistoDaOrdinamento = Boolean.FALSE
		switch (atto.tipoAttoEnum) {
			case ETipoAtto.NAS:
				//- parte 1 serie A --> natura Originale
				//- parte 1 serie B --> natura Originale
				//- parte 2 serie A --> natura Trascritto
				//- parte 2 serie B --> natura Originale / Trascritto / Diversi
				//(a livello di pregresso)
				//- parte 1 (senza serie) --> natura Originale
				isPrevistoDaOrdinamento = ( isPrimaAOriginale(atto.parte, atto.serie, atto.natura) || isPrimaBOriginale(atto.parte, atto.serie, atto.natura) || isSecondaATrascritto(atto.parte, atto.serie, atto.natura) ||
										  ( (atto.parte.intValue() == 2) && ( (atto.serie?:"") == CivTipoAtto.SERIE_B ) && NaturaUtils.getValoriNascita().contains(atto.natura) )  ||
						                  ( isPartePrimaSenzaSerieOriginale(atto.parte, atto.serie, atto.natura) && (atto.codiceRecord.intValue() == 0) ) )
				break
			case ETipoAtto.MAT:
				//- parte 1 (senza serie) --> natura Originale
				//- parte 2 serie A       --> natura Originale
				//- parte 2 serie B       --> natura Trascritto
				//- parte 2 serie C       --> natura Originale / Trascritto / Diversi
				isPrevistoDaOrdinamento = ( isPartePrimaSenzaSerieOriginale(atto.parte, atto.serie, atto.natura) || isSecondaAOriginale(atto.parte, atto.serie, atto.natura) || isSecondaBTrascritto(atto.parte, atto.serie, atto.natura) ||
										  ( (atto.parte.intValue() == 2) && ( (atto.serie?:"") == CivTipoAtto.SERIE_C ) && NaturaUtils.getValoriMatrimonio().contains(atto.natura) ) )
				break
			case ETipoAtto.MOR:
				//- parte 1 (senza serie) --> natura Originale
				//- parte 2 serie A --> natura Trascritto
				//- parte 2 serie B --> natura Originale
				//- parte 2 serie C --> natura Originale / Trascritto / Diversi
				//(a livello di pregresso)
				//- parte 2 serie B bis --> natura Trascritto
				isPrevistoDaOrdinamento = ( isPartePrimaSenzaSerieOriginale(atto.parte, atto.serie, atto.natura) || isSecondaATrascritto(atto.parte, atto.serie, atto.natura) || isSecondaBOriginale(atto.parte, atto.serie, atto.natura) ||
										  ( (atto.parte.intValue() == 2) && ( (atto.serie?:"") == CivTipoAtto.SERIE_C ) && NaturaUtils.getValoriDecesso().contains(atto.natura) ) ||
						                  ( isSecondaBBisTrascritto(atto.parte, atto.serie, atto.natura) && (atto.codiceRecord.intValue() == 0) ) )
				break
			case ETipoAtto.PUB:
				//- parte 1 (senza serie) --> natura Originale
				//- parte 2 serie A       --> natura Trascritto
				//- parte 2 serie B       --> natura Originale
				isPrevistoDaOrdinamento = ( isPartePrimaSenzaSerieOriginale(atto.parte, atto.serie, atto.natura) || isSecondaATrascritto(atto.parte, atto.serie, atto.natura) || isSecondaBOriginale(atto.parte, atto.serie, atto.natura) )
				break
			case ETipoAtto.CIT:
				isPrevistoDaOrdinamento = ((atto.parte == null) && ( (atto.serie?:"") == "") && NaturaUtils.getValoriCittadinanza().contains(atto.natura) )
				break
			case ETipoAtto.PVU:
				isPrevistoDaOrdinamento = ((atto.parte == null) && ( (atto.serie?:"") == "") && NaturaUtils.getValoriProcessoVerbale().contains(atto.natura) )
				break
			case ETipoAtto.UCI:
				//- parte 1 (senza serie) --> natura Originale
				//- parte 2 (senza serie) --> natura Originale
				//- parte 2 (senza serie) --> natura Trascritto
				//- parte 2 (senza serie) --> natura Diverso
				isPrevistoDaOrdinamento = (isPartePrimaOriginale(atto.parte, atto.natura) || isParteSecondaOriginale(atto.parte, atto.natura) ||
						                   isParteSecondaTrascritto(atto.parte, atto.natura) || isParteSecondaDiverso(atto.parte, atto.natura) )
				break
		}

		return isPrevistoDaOrdinamento
	}

	List<CivTipoAtto> listAllByTipoAttoAndParteAndSerieAndNatura(Integer tipoAtto, Integer parte, String serie, ENaturaAtto natura){
		return civTipoAttoRepository.findAllByTipoAttoAndParteAndSerieAndNatura(tipoAtto, parte, serie, natura)
	}

	Integer getMaxSequenzaByTipoAtto(Integer tipoAtto) {
		Integer o = civTipoAttoRepository.findMaxSequenzaByTipoAtto(tipoAtto)
		return o
	}

	List<CivTipoAtto> listAllByTipoAttoAndCategoriaAndNaturaInList(Integer tipoAtto, Integer idCategoria, List<ENaturaAtto> ln){
		Boolean flagAnsc = arcParametroService.isIntegrazioneAnscAttiva() ?: null
		return civTipoAttoRepository.findAllByTipoAttoAndCategoriaAndNaturaInListAndFlagAnsc(tipoAtto, idCategoria, ln, flagAnsc)
	}

	List<CivTipoAtto> listAllByTipoAttoAndCategoriaAndNaturaInListAndNotFlagPregressoAndNotFlagDismesso(Integer tipoAtto, Integer idCategoria, List<ENaturaAtto> ln){
		Boolean flagAnsc = arcParametroService.isIntegrazioneAnscAttiva() ?: null
		List<CivTipoAtto> lAll = civTipoAttoRepository.findAllByTipoAttoAndCategoriaAndNaturaInListAndFlagAnsc(tipoAtto, idCategoria, ln, flagAnsc)
		List<CivTipoAtto> subList = []
		for (CivTipoAtto ta: lAll){
			if ( (!(ta.flagPregresso)) && (!(ta.flagDismesso)) ){
				subList.add(ta)
			}
		}
		return subList
	}

	Page<CivTipoAtto> list (Integer tipoAtto, Map params) {
		if (tipoAtto != null){
			return civTipoAttoRepository.listByParams(tipoAtto, params)
		}
		return null
	}

	private void validaDati(CivTipoAtto obj, ETipoAtto tipoAttoEnumSource) {
		if ((obj.tipoAtto == null) || (obj.natura == null)){
			throw new CampoMandatoryRuntimeException()
		}

		Boolean emptyMandatoryFields = Boolean.TRUE
		switch (tipoAttoEnumSource) {
			case ETipoAtto.NAS:
			case ETipoAtto.PUB:
			case ETipoAtto.MAT:
			case ETipoAtto.MOR:
			case ETipoAtto.UCI:
				emptyMandatoryFields = ((obj.parte == null) || (obj.categoriaDomain?.id == null))
				break
			case ETipoAtto.PVU:
			case ETipoAtto.CIT:
				emptyMandatoryFields = (obj.categoriaDomain?.id == null)
				break
		}
		if (emptyMandatoryFields){
			throw new CampoMandatoryRuntimeException()
		}

		if (obj.categoriaDomain.divorzio && (obj.natura != ENaturaAtto.D) ){
			throw new ErroreTipoAttoRuntimeException(Etichette.getEtichetta("Errore_natura_vs_categoria"))
		}
		// Duplico il controllo perché il campo di db FLAG_DIVORZIO è stato creato fin da principio sulla CIVCTA
		// e solo in un secondo momento sulla CIVDTA
		if (obj.divorzio && (obj.natura != ENaturaAtto.D) ){
			throw new ErroreTipoAttoRuntimeException(Etichette.getEtichetta("Errore_natura_vs_categoria"))
		}

		if ( (tipoAttoEnumSource == ETipoAtto.MAT) && obj.divorzio ){
			if (obj.tipoDivorzio == null) {
				throw new CampoMandatoryRuntimeException()
			}
			Boolean isRiconciliazione = ( obj.isSecondaC() && ((obj.categoriaDomain?.codice?:"") == CivCategoriaTipoAtto.RCN) )
			if (isRiconciliazione && (obj.tipoDivorzio != ETipoDivorzio.A)){
				throw new ErroreTipoAttoRuntimeException(Etichette.getEtichetta("Errore_tipo_divorzio"))
			}
		}
	}

	CivTipoAtto save (CivTipoAtto obj, ETipoAtto tipoAttoEnumSource){
		validaDati(obj, tipoAttoEnumSource)

		if (obj.id == null){
			// solo in caso di inserimento
			obj.id = gsdService.getIdFromSequence(obj)
		}

        log.info("Lancio salvataggio su CIVDTA per id " + obj.id)
		return civTipoAttoRepository.save(obj)
	}

	void delete(CivTipoAtto obj){
		if  ( (obj.categoriaDomain?.codice?:"") == CivCategoriaTipoAtto.ATL ){
			String s = gsdService.existsAttoXIdTipoAtto(obj.tipoAtto, obj.id)
			if ((s?.trim()?: "") != "") {
				throw new ErroreTipoAttoRuntimeException(Etichette.getEtichetta("Errore_cancellazione_tipo_atto"))
			} else {
				civTipoAttoRepository.delete(obj)
			}
		} else {
			throw new ErroreTipoAttoRuntimeException(Etichette.getEtichetta("Errore_cancellazione_tipo_atto"))
		}
	}

}
