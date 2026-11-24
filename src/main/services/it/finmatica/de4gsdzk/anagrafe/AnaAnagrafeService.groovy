package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.ISoggettoAnpr
import it.finmatica.de4gsdzk.anagrafe.pratiche.AnaUrnaCineraria
import it.finmatica.de4gsdzk.anagrafe.pratiche.AnaUrnaCinerariaRepository
import it.finmatica.de4gsdzk.archivi.ArcComuneBaseService
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.errors.ErroreRicercaArchivioSoggettoRuntimeException
import it.finmatica.de4gsdzk.statocivile.CivNascita
import it.finmatica.de4gsdzk.utils.*
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.domain.Sort
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

import java.sql.Date

@Transactional
@Service
class AnaAnagrafeService {

	private final ArcParametroService arcParametroService

	private final ArcComuneBaseService arcComuneBaseService

	private final AnaAnagrafeRepository anaAnagrafeRepository

	private final AnaDocumentoService anaDocumentoService

	private final AnaUrnaCinerariaRepository anaUrnaCinerariaRepository

	AnaAnagrafeService(ArcParametroService arcParametroService,
					   ArcComuneBaseService arcComuneBaseService,
					   AnaAnagrafeRepository anaAnagrafeRepository,
					   AnaDocumentoService anaDocumentoService,
					   AnaUrnaCinerariaRepository anaUrnaCinerariaRepository) {
		this.arcParametroService = arcParametroService
		this.arcComuneBaseService = arcComuneBaseService
		this.anaAnagrafeRepository = anaAnagrafeRepository
		this.anaDocumentoService = anaDocumentoService
		this.anaUrnaCinerariaRepository = anaUrnaCinerariaRepository
	}

	AnaAnagrafe get (Integer id, Map params = null){
		return anaAnagrafeRepository.getByParams(id, params)
	}

	Page<AnaAnagrafe> listAllByRicercaSoggetto(RicercaSoggetto r, Boolean soloResidenti, Pageable pageable) {
		if (r.archivio != EArchivioSorgenteSoggetto.ANA) {
			throw new ErroreRicercaArchivioSoggettoRuntimeException()
		}
		EFascia fascia = null
		if (soloResidenti){
			fascia = EFascia.ISCRITTO_APR
		}
		anaAnagrafeRepository.findAll(
				SqlUtils.endsLike(r?.cognome)?.toUpperCase(),
				SqlUtils.endsLike(r?.nome)?.toUpperCase(),
				SqlUtils.endsLike(r?.codiceFiscale)?.toUpperCase(),
				r?.sesso,
				r?.dataNascita,
				fascia,
				pageable)
	}

	Page<AnaAnagrafe> listAllByRicercaIndividuo(RicercaIndividuo r, Pageable pageable) {

		return anaAnagrafeRepository.findAllByRicercaIndividuo(
				SqlUtils.endsLike(r.cognome)?.toUpperCase(),
				SqlUtils.endsLike(r.nome)?.toUpperCase(),
				SqlUtils.endsLike(r.codiceFiscale)?.toUpperCase(),
				r.sesso,
				r.dataNascitaDal,
				r.dataNascitaAl,
				r.matricola,
				r.idSoggettoAnpr,
				r.idUnicoAnpr,
				pageable)
	}

	List<AnaAnagrafe> listAllRettificatiByRicercaIndividuo(RicercaIndividuo r) {

		List<Integer> matricole = anaAnagrafeRepository.findAllRettificatiByRicercaIndividuo(r)
		return anaAnagrafeRepository.findAllByIdIn(matricole)
	}

	List<AnaAnagrafe> listXDatiAnagrafici(CivNascita obj){
		if (obj.isCodRec0() && arcComuneBaseService.isComuneClienteOggi(obj.codiceComuneResidenza, obj.codiceProvinciaResidenza) && ( (obj.natura == ENaturaAtto.O) || (obj.natura == ENaturaAtto.T) ) ) {
			return anaAnagrafeRepository.listXDatiAnagrafici(obj.cognome, obj.nome, obj.dataNascita, obj.sesso)
		}
		return []
	}

	List<AnaAnagrafe> listXDatiAnagraficiSuResidenti(String cognome, String nome, Date dataNascita, ESesso sesso){
		return anaAnagrafeRepository.listXDatiAnagraficiSuResidenti(cognome, nome, dataNascita, sesso)
	}

	String checkCoerenzaAnprAnagrafe(ISoggettoAnpr soggettoAnpr, AnaAnagrafe soggettoAnagrafe, String soggetto, Boolean statoCivile){
		String anomalia = ""
		String recuperoMsg = "\nVerranno recuperati i dati di provenienza ANPR\n"
		if ( (soggettoAnpr.getMatricola() != null) && ( (soggettoAnagrafe?.cognome?.trim()?:"").toLowerCase() != (soggettoAnpr.cognome?.trim()?:"").toLowerCase() ) ) {
			anomalia += "- Risulta un'incongruenza fra il cognome del " + soggetto + " in ANPR e quello dello stesso soggetto censito in anagrafe ( " +
					"" + soggettoAnpr.cognome + " / " + soggettoAnagrafe?.cognome + " )." + recuperoMsg
		}
		if ( (soggettoAnpr.getMatricola() != null) && ( (soggettoAnagrafe?.nome?.trim()?:"").toLowerCase() != (soggettoAnpr.nome?.trim()?:"").toLowerCase() ) ) {
			anomalia += "- Risulta un'incongruenza fra il nome del " + soggetto + " in ANPR e quello dello stesso soggetto censito in anagrafe ( " +
					"" + soggettoAnpr.nome + " / " + soggettoAnagrafe?.nome + " )." + recuperoMsg
		}
		if ( (soggettoAnpr.getMatricola() != null) && ( soggettoAnagrafe?.dataNascita != soggettoAnpr.dataNascita ) ) {
			anomalia += "- Risulta un'incongruenza fra la data di nascita del " + soggetto + " in ANPR e quella dello stesso soggetto censito in anagrafe (" +
					"" + DataUtils.fromDateToString(soggettoAnpr.dataNascita) + " / " + DataUtils.fromDateToString(soggettoAnagrafe?.dataNascita) + ")." + recuperoMsg
		}
		// refs #69052
		if ( (soggettoAnpr.getMatricola() != null) &&
				( ( soggettoAnagrafe?.comuneNascita?.codice != soggettoAnpr.codiceComuneNascita ) ||
				( soggettoAnagrafe?.comuneNascita?.codiceProvincia != soggettoAnpr.codiceProvinciaNascita ) ||
				( soggettoAnagrafe?.comuneNascita?.descrizione != soggettoAnpr.descrizioneComuneNascita ) ) ) {
			anomalia += "- Risulta un'incongruenza fra il comune di nascita del " + soggetto + " in ANPR e quello dello stesso soggetto censito in anagrafe." + recuperoMsg
			if ( statoCivile && (soggettoAnpr.codiceComuneNascita != null) && (soggettoAnpr.codiceProvinciaNascita != null) &&
				 (!(arcComuneBaseService.existsByCodiceComuneAndCodiceProvincia(soggettoAnpr.codiceComuneNascita, soggettoAnpr.codiceProvinciaNascita))) ){
				anomalia += "\nIl comune con codice ${soggettoAnpr.codiceProvinciaNascita}-${soggettoAnpr.codiceComuneNascita} non risulta presente in archivio!\n\n"
			}
			// refs #71811
			// Controllo che la denominazione non differisca a parità di codice comune e codice provincia
			if (statoCivile &&  (soggettoAnagrafe?.comuneNascita?.codice != null) && (soggettoAnpr.codiceComuneNascita != null) &&
				(soggettoAnagrafe?.comuneNascita?.codiceProvincia != null) && (soggettoAnpr.codiceProvinciaNascita != null) &&
				(soggettoAnagrafe?.comuneNascita?.codice?.compareTo(soggettoAnpr.codiceComuneNascita) == 0) &&
				(soggettoAnagrafe?.comuneNascita?.codiceProvincia?.compareTo(soggettoAnpr.codiceProvinciaNascita) == 0) ) {
				if (soggettoAnagrafe?.comuneNascita?.descrizione != soggettoAnpr.descrizioneComuneNascita) {
					anomalia += "\nRisulta un disallineamento fra la denominazione del comune presente in archivio con codice ${soggettoAnpr.codiceProvinciaNascita}-${soggettoAnpr.codiceComuneNascita} e la denominazione dello stesso comune in ANPR!\n\n"
				}
			}
		}
		// refs #69052
		if ( (soggettoAnpr.getMatricola() != null) &&
				( ( soggettoAnagrafe?.comuneResidenza?.codice != soggettoAnpr.codiceComuneResidenza ) ||
				( soggettoAnagrafe?.comuneResidenza?.codiceProvincia != soggettoAnpr.codiceProvinciaResidenza ) ||
				( soggettoAnagrafe?.comuneResidenza?.descrizione != soggettoAnpr.descrizioneComuneResidenza ) ) ) {
			anomalia += "- Risulta un'incongruenza fra il comune di residenza del " + soggetto + " in ANPR e quello dello stesso soggetto censito in anagrafe." + recuperoMsg
			if ( statoCivile &&  (soggettoAnpr.codiceComuneResidenza != null) && (soggettoAnpr.codiceProvinciaResidenza != null) &&
				 (!(arcComuneBaseService.existsByCodiceComuneAndCodiceProvincia(soggettoAnpr.codiceComuneResidenza, soggettoAnpr.codiceProvinciaResidenza))) ){
				anomalia += "\nIl comune con codice ${soggettoAnpr.codiceProvinciaResidenza}-${soggettoAnpr.codiceComuneResidenza} non risulta presente in archivio!\n\n"
			}
			// refs #71811
			// Controllo che la residenza sia valorizzata per tener conto degli emigrati o dei cancellati non deceduti che in anaana_v
			// non hanno gli estremi di residenza; inoltre controllo che la denominazione non differisca a parità di codice comune e codice provincia
			if (statoCivile &&  (soggettoAnagrafe?.comuneResidenza?.codice != null) && (soggettoAnpr.codiceComuneResidenza != null) &&
				(soggettoAnagrafe?.comuneResidenza?.codiceProvincia != null) && (soggettoAnpr.codiceProvinciaResidenza != null) &&
				(soggettoAnagrafe?.comuneResidenza?.codice?.compareTo(soggettoAnpr.codiceComuneResidenza) == 0) &&
				(soggettoAnagrafe?.comuneResidenza?.codiceProvincia?.compareTo(soggettoAnpr.codiceProvinciaResidenza) == 0) ) {
				if (soggettoAnagrafe?.comuneResidenza?.descrizione != soggettoAnpr.descrizioneComuneResidenza) {
					anomalia += "\nRisulta un disallineamento fra la denominazione del comune di residenza presente in archivio con codice ${soggettoAnpr.codiceProvinciaResidenza}-${soggettoAnpr.codiceComuneResidenza} e la denominazione dello stesso comune in ANPR!\n\n"
				}
			}
		}
		return anomalia
	}

	List<AnaAnagrafe> listAllByFamiglia(AnaFamiglia famiglia) {
		Sort sort = new Sort(SortUtils.anagrafeSoggettoFamiliareAsc)
		boolean showCancellati = arcParametroService.isVisualizzazioneFamiliariCancellatiAttiva()
		return anaAnagrafeRepository.findAllByFamiglia(famiglia, showCancellati, sort)
	}

	List<AnaFamiglia> listAllFamiglieById(Integer id) {
		anaAnagrafeRepository.findAllFamiglieById(id)
	}

	AnaAnagrafe findByIdSoggetto(Integer id){
		AnaAnagrafe ana = anaAnagrafeRepository.findByIdSoggetto(id)
		return ana
	}

	List<AnaDocumento> getDocumentiCDF(AnaAnagrafe anagrafe) {
		return anaDocumentoService.listDocumentiCDFByAnagrafe(anagrafe)
	}

	List<AnaDocumento> getDocumentiSoggetto(AnaAnagrafe anagrafe) {
		return anaDocumentoService.listDocumentiSoggettoByAnagrafe(anagrafe)
	}

	List<AnaUrnaCineraria> getUrneCinerarie(AnaAnagrafe anagrafe) {
		return anaUrnaCinerariaRepository.findByMatricola(anagrafe)
	}

	AnaAnagrafe findById(Integer id){
		return anaAnagrafeRepository.findById(id)
	}

	AnaAnagrafe findByIdWithStato(Integer id){
		return anaAnagrafeRepository.findByIdWithStato(id)
	}

	void saveOrUpdate(AnaAnagrafe anagrafe) {
		anaAnagrafeRepository.save(anagrafe)
	}

	Boolean refreshFlagPatente(Integer id){
		return anaAnagrafeRepository.refreshFlagPatente(id)
	}

	Boolean refreshFlagCC(Integer id){
		return anaAnagrafeRepository.refreshFlagCC(id)
	}

    List<AnaAnagrafe> listAllFamigliariAttiviByFamiglia(AnaFamiglia famiglia) {
        Sort sort = new Sort(SortUtils.anagrafeSoggettoFamiliareAsc)
        boolean showCancellati = arcParametroService.isVisualizzazioneFamiliariCancellatiAttiva()
        return anaAnagrafeRepository.findAllFamigliariAttiviByFamiglia(famiglia, sort)
    }
}
