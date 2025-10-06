package it.finmatica.de4gsdzk.archivi

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.pagamento.EServizioPagamento
import it.finmatica.de4gsdzk.utils.EGruppo
import it.finmatica.de4gsdzk.utils.ETipoSN
import it.finmatica.de4gsdzk.utils.SqlUtils
import it.finmatica.de4gsdzk.utils.TestoUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class ArcParametroService {

	private final ArcParametroRepository arcParametroRepository

    ArcParametroService(ArcParametroRepository arcParametroRepository) {
		this.arcParametroRepository = arcParametroRepository
	}

	ArcParametro get (String id){
		return arcParametroRepository.findById(id)
	}

	Boolean isIntegrazioneAnscAttiva() {
		ArcParametro p = arcParametroRepository.findById(ArcParametro.ANSC)
		return (p?.valore?.trim()?.toUpperCase() == ETipoSN.S.name())
	}

	Boolean isIntegrazioneIstatAttiva() {
		ArcParametro p = arcParametroRepository.findById(ArcParametro.ISTATEL)
		return (p?.valore?.trim()?.toUpperCase() == ETipoSN.S.name())
	}

	Boolean isGestioneMultilingueAttiva() {
		ArcParametro p = arcParametroRepository.findById(ArcParametro.MULTILANG)
		return ((p?.valore?.trim()?.toUpperCase()?:ETipoSN.N.name()) == ETipoSN.S.name())
	}

	Boolean isRecuperoOtpProtocollazioneAttivo() {
		ArcParametro p = arcParametroRepository.findById(ArcParametro.FIRMA_OTP)
		return ((p?.valore?.trim()?.toUpperCase()?:ETipoSN.N.name()) == ETipoSN.S.name())
	}

	Boolean isSegnalazioneModificaAttoAttiva() {
		ArcParametro p = arcParametroRepository.findById(ArcParametro.ATTI_ALERT)
		return ((p?.valore?.trim()?.toUpperCase()?:ETipoSN.S.name()) == ETipoSN.S.name())
	}

	Boolean isCorniceStampaAttiva() {
		ArcParametro p = arcParametroRepository.findById(ArcParametro.ATTI_A4_FR)
		return ((p?.valore?.trim()?.toUpperCase()?:ETipoSN.S.name()) == ETipoSN.S.name())
	}

	Boolean isRicercaSoggettoInANPRAttiva() {
		ArcParametro p = arcParametroRepository.findById(ArcParametro.CIV_ANPR)
		return ( (p?.valore?.trim()?.toUpperCase()?:ETipoSN.S.name()) == ETipoSN.S.name())
	}

	Boolean isFirmaRemotaAutomaticaAttiva() {
		// Né utente, né pwd
		ArcParametro p = arcParametroRepository.findById(ArcParametro.FIRMA_AUTO)
		return ((p?.valore?.trim()?.toUpperCase()?:ETipoSN.S.name()) == ETipoSN.S.name())
	}

	Boolean isModificaAllegatoPrincipaleComunicazioneAttiva() {
		ArcParametro p = arcParametroRepository.findById(ArcParametro.CIV_COM_PR)
		return ((p?.valore?.trim()?.toUpperCase()?:ETipoSN.N.name()) == ETipoSN.S.name())
	}

	Boolean isGestioneCognomeAutomaticoAttiva() {
		ArcParametro p = arcParametroRepository.findById(ArcParametro.ANAS_COGN)
		return ((p?.valore?.trim()?.toUpperCase() ?: ETipoSN.S.name()) == ETipoSN.S.name())
	}

	Boolean iStampaAnnotazioneSuAttoAttiva() {
		ArcParametro p = arcParametroRepository.findById(ArcParametro.RANN_ATTO)
		return ((p?.valore?.trim()?.toUpperCase() ?: ETipoSN.S.name()) == ETipoSN.S.name())
	}

	Boolean iStampaAnnotazioneSuEstrattoAttiva() {
		ArcParametro p = arcParametroRepository.findById(ArcParametro.RANN_ESTR)
		return ((p?.valore?.trim()?.toUpperCase() ?: ETipoSN.S.name()) == ETipoSN.S.name())
	}

	Boolean isListaFirmatariAttiva() {
		ArcParametro p = arcParametroRepository.findById(ArcParametro.FIRMA_LIST)
		return ((p?.valore?.trim()?.toUpperCase() ?: ETipoSN.N.name()) == ETipoSN.S.name())
	}

	String getCsvCharsetName(){
		ArcParametro p = arcParametroRepository.findById(ArcParametro.CSV_CHRSET)
		if (TestoUtils.isVuoto(p?.valore?.trim()) ){
			return null
		}
		return p.valore.trim()
	}

	String getAttiLi(){
		ArcParametro p = arcParametroRepository.findById(ArcParametro.ATTI_LI)
		return (p?.valore?:"")
	}

	String getGestioneDataFirmaEtichettaAnnotazione(){
		ArcParametro p = arcParametroRepository.findById(ArcParametro.SEAW_DATA)
		return (p?.valore?:"")
	}

	String getAnnotazioniBloccate(){
		ArcParametro p = arcParametroRepository.findById(ArcParametro.TANN_BLOC)
		return (p?.valore?:"")
	}

	Boolean isModuloCertificazioneAttivo() {
		ArcParametro p = arcParametroRepository.findById(ArcParametro.MODULO_CER)
		return ((p?.valore?.trim()?.toUpperCase()?:ETipoSN.N.name()) == ETipoSN.S.name())
	}

	Boolean isNuovaGestioneAnnotazioniSuAttoAttiva() {
		ArcParametro p = arcParametroRepository.findById(ArcParametro.ATTI_ANN_N)
		return ((p?.valore?.trim()?.toUpperCase() ?: ETipoSN.N.name()) == ETipoSN.S.name())
	}

	Boolean isIntegrazionePagamentiAttiva() {
		try{
			return getServizioPagamento() != null
		}catch (Exception e){
			log.error("Errore in isIntegrazionePagamentiAttiva", e)
			return false
		}
	}

	EServizioPagamento getServizioPagamento() {
		ArcParametro p = arcParametroRepository.findById(ArcParametro.WSPA)
		try {
			return EServizioPagamento.valueOf(p?.valore?.trim()?.toUpperCase())
		} catch (Exception e) {
			throw new IllegalStateException("Servizio di pagamento ${p?.valore?.trim()?.toUpperCase()} non configurato", e)
		}
	}

	@Deprecated
	Boolean isAperturaAnnotazioniSuCertificazioneAttiva() {
		ArcParametro p = arcParametroRepository.findById(ArcParametro.CERT_SANN)
		return ((p?.valore?.trim()?.toUpperCase() ?: ETipoSN.N.name()) == ETipoSN.S.name())
	}

	Boolean isVisualizzazioneFamiliariCancellatiAttiva() {
		ArcParametro p = arcParametroRepository.findById(ArcParametro.VANA_2FAM)
		return ((p?.valore?.trim()?.toUpperCase() ?: ETipoSN.N.name()) == ETipoSN.S.name())
	}

	URI getStatsUri() {
		ArcParametro p = arcParametroRepository.findById(ArcParametro.STATS_URL)
		try {
			return new URI(p?.valore ?: "")
		} catch (URISyntaxException ex) {
			log.error("Errore in getStatsUri", ex)
			return new URI("")
		}
	}

	void checkMinuscoleOn(Map map){
		ArcParametro p = arcParametroRepository.findById(ArcParametro.ATTI_MINUS)
		Boolean minuscoleOn = ((p?.valore?.trim()?.toUpperCase()?:ETipoSN.N.name()) == ETipoSN.S.name())
		if (minuscoleOn){
			for (entry in map) {
				map[entry.key] = Boolean.TRUE
			}
		}
	}

	Page<ArcParametro> listAllByGruppoInAndDescrizioneLike (List<EGruppo> gruppi, String filtro, PageRequest p){
		if ( (filtro?.trim()?:"") != "") {
			return arcParametroRepository.findAllByGruppoInAndDescrizioneLike(gruppi, filtro, p)
		} else {
			return arcParametroRepository.findAllByGruppoIn(gruppi, p)
		}
	}

	List<ArcParametro> listAllByIdIn (List<String> ids){
		return arcParametroRepository.findAllByIdIn(ids)
	}

	List<ArcParametro> listAllByIdLikeOrId (String parametroLike, String parametroEq){
		return arcParametroRepository.findAllByIdLikeOrId(SqlUtils.endsLike(parametroLike), parametroEq)
	}

	Map<String, String> mapValoreByIdLike(String parametroLike) {
		Map<String, String> ret = [:]
		for (ArcParametro p : arcParametroRepository.findAllByIdLike(parametroLike)) {
			ret.put(p.getId(), p.getValore())
		}
		return ret
	}

	void updateValoreByIdLike(String parametroLike, Map<String, String> values) {
		//aggiorna i parametri già presenti
		for (ArcParametro p : arcParametroRepository.findAllByIdLike(parametroLike)) {
			if (values.containsKey(p.getId())) {
				Object val = values.remove(p.getId())
				p.setValore(val)
				save(p)
			}
		}
		//inserisce i parametri non presenti
		for (Map.Entry<String, String> p : values) {
			save(new ArcParametro(id: p.getKey(), valore: p.getValue()))
		}
	}

	ArcParametro save(ArcParametro obj) {
		return arcParametroRepository.save(obj)
	}

	void delete(ArcParametro obj){
		if (obj.id != null){
			arcParametroRepository.delete(obj)
		}
	}

}
