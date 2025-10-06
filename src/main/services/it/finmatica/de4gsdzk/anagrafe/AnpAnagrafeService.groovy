package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.GsdAnagrafeBaseDomain
import it.finmatica.de4gsdzk.anpr.AnpAnagrafe
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.ErroreRicercaArchivioSoggettoRuntimeException
import it.finmatica.de4gsdzk.errors.NoRecordFoundRuntimeException
import it.finmatica.de4gsdzk.errors.TooManyRecordsFoundRuntimeException
import it.finmatica.de4gsdzk.statocivile.StatoCivileService
import it.finmatica.de4gsdzk.utils.EArchivioSorgenteSoggetto
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi
import it.finmatica.de4gsdzk.utils.RicercaSoggetto
import it.finmatica.de4gsdzk.utils.TestoUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageImpl
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnpAnagrafeService {

    private final AnpAnagrafeRepository anpAnagrafeRepository

    private final StatoCivileService statoCivileService

    AnpAnagrafeService(AnpAnagrafeRepository anpAnagrafeRepository, StatoCivileService statoCivileService) {
        this.anpAnagrafeRepository = anpAnagrafeRepository
        this.statoCivileService = statoCivileService
    }

    Page<AnpAnagrafe> list(RicercaSoggetto rs, PageRequest pr) {
        if ( ( TestoUtils.isVuoto(rs?.cognome) || TestoUtils.isVuoto(rs?.nome) ) && TestoUtils.isVuoto(rs?.codiceFiscale)  ) {
            throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_ANPR)
        }
        if (rs.archivio != null && rs.archivio != EArchivioSorgenteSoggetto.ANP) {
            throw new ErroreRicercaArchivioSoggettoRuntimeException()
        }
        Long op = statoCivileService.ricercaSoggettoANPR(rs.cognome,rs.nome, rs.codiceFiscale, rs.dataNascita, rs.idSoggettoAnpr)
        if (op != null){
            if (op.compareTo(0L) > 0){
                return anpAnagrafeRepository.findAllByIdOperazione(op, rs.sesso, pr)
            } else {
                throw new NoRecordFoundRuntimeException(EtichetteMessaggi.Errore_Ricerca_ANPR_No_Result)
            }
        } else {
            return null
        }
    }

    Page<AnpAnagrafe> listByRicercaIndividuo(RicercaIndividuo r, PageRequest pr) {
        r.validaDati()

        Long op = statoCivileService.ricercaSoggettoANPR(r.cognome, r.nome, r.codiceFiscale, r.dataNascitaDal, r.idSoggettoAnpr)
        if (op != null) {
            if (op.compareTo(0L) > 0) {
                return anpAnagrafeRepository.findAllByIdOperazione(op, r.sesso, pr)
            } else {
                throw new NoRecordFoundRuntimeException(EtichetteMessaggi.Errore_Ricerca_ANPR_No_Result)
            }
        } else {
            return null
        }
    }

    Page<AnpAnagrafe> listByFamigliaDiAnpAnagrafe(AnpAnagrafe anpAnagrafe, PageRequest pr) {
        if (anpAnagrafe == null) {
            return new PageImpl<AnpAnagrafe>([])
        }

        Long op = statoCivileService.ricercaComponentiANPR(anpAnagrafe.idFamigliaAnpr, anpAnagrafe.tipoSchedaAnpr)
        if (op != null) {
            if (op.compareTo(0L) > 0) {
                return anpAnagrafeRepository.findAllByIdOperazione(op, null, pr)
            } else {
                throw new NoRecordFoundRuntimeException(EtichetteMessaggi.Errore_Ricerca_ANPR_No_Result)
            }
        } else {
            return null
        }
    }

    AnpAnagrafe findBySoggetto(GsdAnagrafeBaseDomain soggetto, boolean flagInserimento = false) {
        if ((TestoUtils.isVuoto(soggetto?.cognome) || TestoUtils.isVuoto(soggetto?.nome)) && TestoUtils.isVuoto(soggetto?.codiceFiscale)) {
            throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_ANPR)
        }
        Long op = statoCivileService.ricercaSoggettoANPR(soggetto.cognome, soggetto.nome, soggetto.codiceFiscale, soggetto.dataNascita, soggetto.idSoggettoAnpr, null, flagInserimento)
        if (op == null) {
            throw new NoRecordFoundRuntimeException(EtichetteMessaggi.Errore_Ricerca_ANPR_No_Result)
        }
        if (op.compareTo(0L) <= 0) {
            throw new NoRecordFoundRuntimeException(EtichetteMessaggi.Errore_Ricerca_ANPR_No_Result)
        }
        PageRequest pr = new PageRequest(0, Integer.MAX_VALUE)
        Page<AnpAnagrafe> p = anpAnagrafeRepository.findAllByIdOperazione(op, soggetto.sesso, pr)

        Long total = (p?.getTotalElements() ?: 0)

        if (total == 0) {
            throw new NoRecordFoundRuntimeException(EtichetteMessaggi.Errore_Ricerca_ANPR_No_Result)
        }

        if (total > 1) {
            throw new TooManyRecordsFoundRuntimeException()
        }

        return p.getContent().get(0)

    }

}
