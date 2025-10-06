package it.finmatica.de4gsdzk


import it.finmatica.de4gsdzk.certificazione.ECompetenzaCertificazione
import it.finmatica.de4gsdzk.utils.ERuoloAd4
import it.finmatica.de4gsdzk.utils.ERuoloSo4
import it.finmatica.so4.login.So4SpringSecurityService
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class CompetenzaService {

	private final So4SpringSecurityService so4SpringSecurityService

	CompetenzaService(So4SpringSecurityService so4SpringSecurityService) {
		this.so4SpringSecurityService = so4SpringSecurityService
	}

	private Boolean hasRuolo(ERuoloSo4 ruolo) {
		if (ruolo in [ERuoloSo4.CIV_SUPERUSER, ERuoloSo4.CER_SUPERUSER, ERuoloSo4.ANA_SUPERUSER] &&
				so4SpringSecurityService.principal.uo().isEmpty() &&
				so4SpringSecurityService.principal.utente.ruoli*.ruolo.contains(ERuoloAd4.RGSD.id)) {
			return true
		}
		return so4SpringSecurityService.principal.hasRuolo(ruolo.id)
	}

	Boolean isCivSuperUser(){
		return hasRuolo(ERuoloSo4.CIV_SUPERUSER)
	}

	Boolean isCivAny() {
		return ERuoloSo4.statoCivile.any { hasRuolo(it) }
	}

	Boolean isCerSuperUser() {
		return hasRuolo(ERuoloSo4.CER_SUPERUSER)
	}

	Boolean isCerAny() {
		return ERuoloSo4.certificazione.any { hasRuolo(it) }
	}

	Boolean isAnaSuperUser() {
		return hasRuolo(ERuoloSo4.ANA_SUPERUSER)
	}

	Boolean isAnaAny() {
		return ERuoloSo4.anagrafe.any { hasRuolo(it) }
	}

	Set<ECompetenzaCertificazione> getCompetenzeCertificazioneByRuoli() {
		if (!isCerAny()) {
			return new HashSet<ECompetenzaCertificazione>()
		}
		if (isCerSuperUser()) {
			Set<ECompetenzaCertificazione> competenze = new HashSet<>()
			competenze.add(ECompetenzaCertificazione.AN)
			competenze.add(ECompetenzaCertificazione.EL)
			competenze.add(ECompetenzaCertificazione.LM)
			competenze.add(ECompetenzaCertificazione.SC)
			return competenze
		}

		Set<ECompetenzaCertificazione> competenze = new HashSet<>()
		ERuoloSo4.certificazione.each {
			if (hasRuolo(it)) {
				switch (it) {
					case ERuoloSo4.CER_ANAGRAFE:
						competenze.add(ECompetenzaCertificazione.AN)
						break
					case ERuoloSo4.CER_ELETTORALE:
						competenze.add(ECompetenzaCertificazione.EL)
						break
					case ERuoloSo4.CER_LEVA_MILITARE:
						competenze.add(ECompetenzaCertificazione.LM)
						break
					case ERuoloSo4.CER_STATO_CIVILE:
						competenze.add(ECompetenzaCertificazione.SC)
				}
			}
		}
		return competenze
	}

}