package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.ErroreOrarioRuntimeException
import it.finmatica.de4gsdzk.errors.ErroreProtocollazioneRuntimeException
import it.finmatica.de4gsdzk.errors.NumeroProtocolloException
import it.finmatica.de4gsdzk.statocivile.CivTrasportoESeppellimentoRepository
import it.finmatica.de4gsdzk.utils.ETipoSiNo
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi
import it.finmatica.de4gsdzk.utils.OrarioUtils
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivTrasportoESeppellimentoService {

	private final StatoCivileService statoCivileService

	private final CivNumerazioneDocumentiUscitaService civNumerazioneDocumentiUscitaService

	private final CivTrasportoESeppellimentoRepository civTrasportoESeppellimentoRepository

    CivTrasportoESeppellimentoService(CivTrasportoESeppellimentoRepository civTrasportoESeppellimentoRepository,
									  CivNumerazioneDocumentiUscitaService civNumerazioneDocumentiUscitaService,
									  StatoCivileService statoCivileService) {

		this.civTrasportoESeppellimentoRepository = civTrasportoESeppellimentoRepository
		this.civNumerazioneDocumentiUscitaService = civNumerazioneDocumentiUscitaService
		this.statoCivileService = statoCivileService
	}

	CivTrasportoESeppellimento get(Long id) {
		return civTrasportoESeppellimentoRepository.findById(id)
	}

	CivTrasportoESeppellimento getByUkAtto(String identificativoAtto) {
		return civTrasportoESeppellimentoRepository.findByUkAtto(identificativoAtto)
	}

	CivTrasportoESeppellimento getOrCreateByUkAtto(String identificativoAtto) {
		CivTrasportoESeppellimento m = getByUkAtto(identificativoAtto)
		if (!(m)){
			m = new CivTrasportoESeppellimento(trasporto: ETipoSiNo.NO, cremazione: ETipoSiNo.NO)
		}
		return m
	}

	List<String> listAllDistinctCimiteroByCimiteroLike(String filtro){
		return civTrasportoESeppellimentoRepository.findAllDistinctCimiteroByCimiteroLike((filtro?:""))
	}

	List<String> listAllDistinctDittaOnoranzeByDittaOnoranzeLike(String filtro){
		return civTrasportoESeppellimentoRepository.findAllDistinctDittaOnoranzeByDittaOnoranzeLike((filtro?:""))
	}

	private boolean sameRegistroProtocollo(CivRegistroDocumentiUscita ru1, CivRegistroDocumentiUscita ru2){
		return ( (ru1?.id != null) && (ru2?.id != null) && (ru1.id.compareTo(ru2.id) == 0) )
	}

	private boolean sameAnnoProtocollo(Integer anno1, Integer anno2){
		return ( (anno1 != null) && (anno2 != null) && (anno1.compareTo(anno2) == 0) )
	}

	private boolean sameRegistroAnnoProtocollo(CivRegistroDocumentiUscita ru1, CivRegistroDocumentiUscita ru2, Integer anno1, Integer anno2){
		return ( sameRegistroProtocollo(ru1, ru2) && sameAnnoProtocollo(anno1, anno2) )
	}

	private void validaDati(CivTrasportoESeppellimento obj, Boolean ignoreProtocolliDiversi) {
		String sezioneTrasporto = "( Dati Trasporto )"
		if ( !(OrarioUtils.isOraValida(obj.oraTrasporto)) ){
			throw new ErroreOrarioRuntimeException(EtichetteMessaggi.Errore_valore_ora, sezioneTrasporto)
		}

		if ( !(OrarioUtils.isMinutoValido(obj.minutoTrasporto)) ){
			throw new ErroreOrarioRuntimeException(EtichetteMessaggi.Errore_valore_minuti, sezioneTrasporto)
		}

		String sezioneOnoranze = "( Estremi Onoranze Funebri )"
		if ( !(OrarioUtils.isOraValida(obj.oraOnoranze)) ){
			throw new ErroreOrarioRuntimeException(EtichetteMessaggi.Errore_valore_ora, sezioneOnoranze)
		}

		if ( !(OrarioUtils.isMinutoValido(obj.minutoOnoranze)) ){
			throw new ErroreOrarioRuntimeException(EtichetteMessaggi.Errore_valore_minuti, sezioneOnoranze)
		}

		String sezioneCremazione = "( Dati Cremazione )"
		if ( !(OrarioUtils.isOraValida(obj.oraCremazione)) ){
			throw new ErroreOrarioRuntimeException(EtichetteMessaggi.Errore_valore_ora, sezioneCremazione)
		}

		if ( !(OrarioUtils.isMinutoValido(obj.minutoCremazione)) ){
			throw new ErroreOrarioRuntimeException(EtichetteMessaggi.Errore_valore_minuti, sezioneCremazione)
		}

		//-------------------- Controllo Numeri Protocollo -------------------
		if (!(ignoreProtocolliDiversi)) {
			// Trasporto e Cremazione
			if ( sameRegistroAnnoProtocollo(obj.registroTrasporto, obj.registroCremazione, obj.annoProtocolloTrasporto, obj.annoProtocolloCremazione) ){
				if ( 	(obj.numeroProtocolloTrasporto != null) && (obj.numeroProtocolloCremazione != null) &&
						(obj.numeroProtocolloTrasporto.compareTo(obj.numeroProtocolloCremazione) != 0)){
					throw new ErroreProtocollazioneRuntimeException(EtichetteMessaggi.Errore_Protocollo_TC)
				}
			}
			// Trasporto e Seppellimento
			if ( sameRegistroAnnoProtocollo(obj.registroTrasporto, obj.registroSeppellimento, obj.annoProtocolloTrasporto, obj.annoProtocolloSeppellimento) ){
				if ( 	(obj.numeroProtocolloTrasporto != null) && (obj.numeroProtocolloSeppellimento != null) &&
						(obj.numeroProtocolloTrasporto.compareTo(obj.numeroProtocolloSeppellimento) != 0)){
					throw new ErroreProtocollazioneRuntimeException(EtichetteMessaggi.Errore_Protocollo_TS)
				}
			}
			// Seppellimento e Cremazione
			if ( sameRegistroAnnoProtocollo(obj.registroCremazione, obj.registroSeppellimento, obj.annoProtocolloCremazione, obj.annoProtocolloSeppellimento) ){
				if ( 	(obj.numeroProtocolloCremazione != null) && (obj.numeroProtocolloSeppellimento != null) &&
						(obj.numeroProtocolloCremazione.compareTo(obj.numeroProtocolloSeppellimento) != 0)){
					throw new ErroreProtocollazioneRuntimeException(EtichetteMessaggi.Errore_Protocollo_CS)
				}
			}
        }
		//
		// Trasporto
		if (obj.getNumeroProtocolloTrasporto() && obj.getAnnoProtocolloTrasporto()) {
			List<CivTrasportoESeppellimento> listaTS =
					civTrasportoESeppellimentoRepository.findAllByIdNotAndRegistroTrasportoAndAnnoProtocolloTrasportoAndNumeroProtocolloTrasporto(
							obj.id?:-1, obj.getRegistroTrasporto(), obj.getAnnoProtocolloTrasporto(), obj.getNumeroProtocolloTrasporto())
			if (!listaTS.isEmpty()) {
				throw new NumeroProtocolloException(obj.getNumeroProtocolloTrasporto(), "(Trasporto)", listaTS)
			}
		}
		//
		// Seppellimento
		if (obj.getNumeroProtocolloSeppellimento() && obj.getAnnoProtocolloSeppellimento()) {
			List<CivTrasportoESeppellimento> listaTS =
					civTrasportoESeppellimentoRepository.findAllByIdNotAndRegistroSeppellimentoAndAnnoProtocolloSeppellimentoAndNumeroProtocolloSeppellimento(
							obj.id?:-1, obj.getRegistroSeppellimento(), obj.getAnnoProtocolloSeppellimento(), obj.getNumeroProtocolloSeppellimento())
			if (!listaTS.isEmpty()) {
				throw new NumeroProtocolloException(obj.getNumeroProtocolloSeppellimento(), "(Seppellimento)", listaTS)
			}
		}
		//
		// Cremazione
		if (obj.getNumeroProtocolloCremazione() && obj.getAnnoProtocolloCremazione()) {
			List<CivTrasportoESeppellimento> listaTS =
					civTrasportoESeppellimentoRepository.findAllByIdNotAndRegistroCremazioneAndAnnoProtocolloCremazioneAndNumeroProtocolloCremazione(
							obj.id?:-1, obj.getRegistroCremazione(), obj.getAnnoProtocolloCremazione(), obj.getNumeroProtocolloCremazione())
			if (!listaTS.isEmpty()) {
				throw new NumeroProtocolloException(obj.getNumeroProtocolloCremazione(), "(Cremazione)", listaTS)
			}
		}
		//
		//---------------- Fine Controllo Numeri Protocollo -------------------

		Boolean emptyMandatoryFields = ( (obj.ufficio == null) || (obj.anno == null) || (obj.atto == null) || (obj.parte == null) )

		if (emptyMandatoryFields){
			throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_trasporto)
		}
	}

	/**
	 * Salva {@link CivTrasportoESeppellimento}, o lo cancella
	 * se 'trasporto' e 'cremazione' sono entrambi "NO"
	 *
	 * @param obj l'oggetto
	 * @param ndu le numerazioni protocollo aggiornate
	 * @return l'oggetto salvato, oppure null se 'trasporto' e 'cremazione'
	 * 		sono entrambi "NO"
	 */
	CivTrasportoESeppellimento save (CivTrasportoESeppellimento obj, Map<String, CivNumerazioneDocumentiUscita> ndu, Boolean ignoreProtocolliDiversi = Boolean.TRUE) {

		validaDati(obj, ignoreProtocolliDiversi)

		if (obj.trasporto == ETipoSiNo.SI || obj.cremazione == ETipoSiNo.SI) {

			if (obj.id == null) {
				// solo in caso di inserimento
				obj.id = statoCivileService.getIdFromSequence(obj)
			}

			List<CivNumerazioneDocumentiUscita> nduToSave = []
			for (entry in ndu) {
				CivNumerazioneDocumentiUscita n = ndu[entry.key]
				if (n == null){
					continue
				}
				boolean saveOn = true
				for (CivNumerazioneDocumentiUscita ns : nduToSave) {
					if (sameRegistroAnnoProtocollo(n.registro, ns.registro, n.anno, ns.anno)) {
						if (n.numero.compareTo(ns.numero) == 0) {
							saveOn = false
							break
						}
						if ((!(ignoreProtocolliDiversi)) && (sameRegistroProtocollo(ndu[CivTipoRegistro.ID_TRASPORTO]?.registro, ndu[CivTipoRegistro.ID_CREMAZIONE]?.registro))) {
							throw new ErroreProtocollazioneRuntimeException(EtichetteMessaggi.Errore_Protocollo_TC)
						}
						if ((!(ignoreProtocolliDiversi)) && (sameRegistroProtocollo(ndu[CivTipoRegistro.ID_TRASPORTO]?.registro, ndu[CivTipoRegistro.ID_SEPPELLIMENTO]?.registro))) {
							throw new ErroreProtocollazioneRuntimeException(EtichetteMessaggi.Errore_Protocollo_TS)
						}
						if ((!(ignoreProtocolliDiversi)) && (sameRegistroProtocollo(ndu[CivTipoRegistro.ID_CREMAZIONE]?.registro, ndu[CivTipoRegistro.ID_SEPPELLIMENTO]?.registro))) {
							throw new ErroreProtocollazioneRuntimeException(EtichetteMessaggi.Errore_Protocollo_CS)
						}
					}
				}
				if (saveOn){
					nduToSave.add(n)
				}
			}
			for (CivNumerazioneDocumentiUscita n:nduToSave){
				civNumerazioneDocumentiUscitaService.save(n)
			}

			log.info("Lancio salvataggio su CIVDTS per id " + obj.id)
			return  civTrasportoESeppellimentoRepository.save(obj)

		} else if (obj.id) {

			log.info("Tento cancellazione su CIVDTS per id " + obj.id)
			civTrasportoESeppellimentoRepository.delete(obj)
			return null

		} else {
            return null
        }
	}

}
