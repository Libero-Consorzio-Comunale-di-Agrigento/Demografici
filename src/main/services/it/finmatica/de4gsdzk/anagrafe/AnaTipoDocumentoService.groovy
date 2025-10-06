package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.integrazioni.documentale.EModelloGdm
import it.finmatica.de4gsdzk.anagrafe.AnaTipoDocumentoRepository
import it.finmatica.de4gsdzk.zkutils.ETipoDocumentoAnagrafeFiltro
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnaTipoDocumentoService {

	private final AnaTipoDocumentoRepository anatipoDocumentoRepository

	AnaTipoDocumentoService(AnaTipoDocumentoRepository anatipoDocumentoRepository) {
		this.anatipoDocumentoRepository = anatipoDocumentoRepository
	}

	AnaTipoDocumento get (String id){
		return anatipoDocumentoRepository.findById(id)
	}

	Page<AnaTipoDocumento> listAllByDocumentoIdentita(ETipoDocumentoAnagrafeFiltro filtro, String filtroDescrizione, PageRequest p) {
		if (filtro == null) {
			return null
		}
		if (filtro == ETipoDocumentoAnagrafeFiltro.IDENTITA) {
			return anatipoDocumentoRepository.findAllByDescrizioneEstesaLikeIgnoreCaseAndFlagIdentitaIsTrue(filtroDescrizione, p)
		}
		if (filtro == ETipoDocumentoAnagrafeFiltro.RICONOSCIMENTO) {
			return anatipoDocumentoRepository.findAllByDescrizioneEstesaLikeIgnoreCaseAndFlagRiconoscimentoIsTrue(filtroDescrizione, p)
		}
		if (filtro == ETipoDocumentoAnagrafeFiltro.ALLEGABILITA_CERTIFICAZIONE) {
			return anatipoDocumentoRepository.findAllByDescrizioneEstesaLikeIgnoreCaseAndIdIn(filtroDescrizione, [AnaTipoDocumento.CE, AnaTipoDocumento.U1, AnaTipoDocumento.U2], p)
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

	/**
	 * Disabilitare il controllo sulla competenza permette ai documenti gdm di essere manipolati da utenti diversi
	 * Controllo non necessario per quei documenti che vengono solo creati.
	 * Controllo necessario per quei documenti che vengono modificati e/o di cui vengono aggiunti file (allegati).
	 * */
	boolean shouldCheckCompetenza(AnaTipoDocumento tipoDocumento) {
		if (tipoDocumento.id in [AnaTipoDocumento.CE]) {
			return true
		}
		return false
	}

}
