package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.errors.RecordDuplicatoRuntimeException
import it.finmatica.de4gsdzk.integrazioni.ad4.UtenteCustomService
import it.finmatica.de4gsdzk.integrazioni.documentale.EModelloGdm
import it.finmatica.de4gsdzk.utils.ETipoOperazione
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.SortUtils
import it.finmatica.de4gsdzk.utils.SqlUtils
import it.finmatica.de4gsdzk.utils.TestoUtils
import it.finmatica.de4gsdzk.zkutils.ETipoDocumentoAnagrafeFiltro
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnaTipoDocumentoService {

	private final AnaTipoDocumentoRepository anaTipoDocumentoRepository

    private final UtenteCustomService utenteCustomService

	AnaTipoDocumentoService(AnaTipoDocumentoRepository anaTipoDocumentoRepository,
                            UtenteCustomService utenteCustomService) {
		this.anaTipoDocumentoRepository = anaTipoDocumentoRepository
        this.utenteCustomService = utenteCustomService
	}

	List<AnaTipoDocumento> findAll(){
		return anaTipoDocumentoRepository.findAll(new Sort(SortUtils.descrizioneAsc))
	}

	AnaTipoDocumento get (String id){
		return anaTipoDocumentoRepository.findByIdWithFetch(id)
	}

	Page<AnaTipoDocumento> listAllByFiltroLike(String filtro, PageRequest p) {
		if ((filtro?.trim() ?: "") != "") {
			return anaTipoDocumentoRepository.findAllByFiltroLike(SqlUtils.beginsAndEndsLike(filtro), p)
		} else {
			return anaTipoDocumentoRepository.findAllByFiltroLike("%", p)
		}
	}

    List<AnaTipoDocumento> findAllByFlagConvivenzaDiFattoNull() {
        return anaTipoDocumentoRepository.findAllByFlagConvivenzaDiFattoNullOrderByDescrizioneAsc()
    }

	private void validaDati(ETipoOperazione tipoOperazione, AnaTipoDocumento obj) {
		if ( (obj.id == null) || TestoUtils.isVuoto(obj?.descrizione) ){
			throw new CampoMandatoryRuntimeException()
		}

		if (tipoOperazione.isInsert()){
			long n = anaTipoDocumentoRepository.countById(obj.id)
			if (n > 0) {
				throw new RecordDuplicatoRuntimeException(Etichette.getEtichetta("Errore_Inserimento_Record_duplicato"))
			}
		}
	}

	AnaTipoDocumento save(ETipoOperazione tipoOperazione, AnaTipoDocumento obj) {
		validaDati(tipoOperazione, obj)
        obj.terminalista = utenteCustomService.getLoggedUser()
		return anaTipoDocumentoRepository.save(obj)
	}

	void delete(AnaTipoDocumento obj) {
		anaTipoDocumentoRepository.delete(obj)
	}

	Page<AnaTipoDocumento> listAllByDocumentoIdentita(ETipoDocumentoAnagrafeFiltro filtro, String filtroDescrizione, PageRequest p) {
		if (filtro == null) {
			return null
		}
		if (filtro == ETipoDocumentoAnagrafeFiltro.IDENTITA) {
			return anaTipoDocumentoRepository.findAllByDescrizioneEstesaLikeIgnoreCaseAndFlagIdentitaIsTrue(filtroDescrizione, p)
		}
		if (filtro == ETipoDocumentoAnagrafeFiltro.RICONOSCIMENTO) {
			return anaTipoDocumentoRepository.findAllByDescrizioneEstesaLikeIgnoreCaseAndFlagRiconoscimentoIsTrue(filtroDescrizione, p)
		}
		if (filtro == ETipoDocumentoAnagrafeFiltro.ALLEGABILITA_CERTIFICAZIONE) {
			return anaTipoDocumentoRepository.findAllByDescrizioneEstesaLikeIgnoreCaseAndIdIn(filtroDescrizione, [AnaTipoDocumento.CE, AnaTipoDocumento.U1, AnaTipoDocumento.U2], p)
		}
		return null
	}

	EModelloGdm getModelloGdm(AnaTipoDocumento tipoDocumento) {
		switch (tipoDocumento.id) {
			case AnaTipoDocumento.CE:
				return EModelloGdm.CarteIdentitaElettronica
			case AnaTipoDocumento.CI:
				return EModelloGdm.CarteIdentita
			case AnaTipoDocumento.U1:
				return EModelloGdm.SoggiornoUe
			case AnaTipoDocumento.U2:
				return EModelloGdm.SoggiornoPermanenteUe
			case AnaTipoDocumento.CA:
				return EModelloGdm.CarteIdentitaDaConsolato
			case AnaTipoDocumento.CS:
				return EModelloGdm.CartaSoggiorno
			case AnaTipoDocumento.DC:
				return EModelloGdm.DocumentoConsolare
			case AnaTipoDocumento.DI:
				return EModelloGdm.DocumentoIdentita
			case AnaTipoDocumento.DV:
				return EModelloGdm.AttoDivorzio
			case AnaTipoDocumento.MA:
				return EModelloGdm.AttoMatrimonio
			case AnaTipoDocumento.MO:
				return EModelloGdm.AttoMorte
			case AnaTipoDocumento.NA:
				return EModelloGdm.AttoNascita
			case AnaTipoDocumento.PP:
				return EModelloGdm.Passaporto
			case AnaTipoDocumento.PS:
				return EModelloGdm.PermessoSoggiorno
			case AnaTipoDocumento.RP:
				return EModelloGdm.Pso
			case AnaTipoDocumento.SD:
				return EModelloGdm.StoricoDocumenti
			case AnaTipoDocumento.XX:
				return EModelloGdm.CdFIstituzionale
			case AnaTipoDocumento.XR:
				return EModelloGdm.CdFRisoluzione
			case AnaTipoDocumento.ZI:
				return EModelloGdm.ContrattoConvivenza
			case AnaTipoDocumento.ZR:
				return EModelloGdm.RisoluzioneContrattoConvivenza
			default:
				throw new De4gsdzkRuntimeException("Tipo documento ${tipoDocumento.descrizione} non gestito")
		}
	}

	List<AnaTipoDocumento> findAllByFlagConvivenzaDiFattoNotNull(){
		return anaTipoDocumentoRepository.findAllByFlagConvivenzaDiFattoNotNullOrderByDescrizioneAsc()
	}


}
