package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.AnagrafeBaseDomain
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.anpr.AnpAnagrafe
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.ErroreRicercaArchivioSoggettoRuntimeException
import it.finmatica.de4gsdzk.errors.NoRecordFoundRuntimeException
import it.finmatica.de4gsdzk.errors.TooManyRecordsFoundRuntimeException
import it.finmatica.de4gsdzk.utils.EArchivioSorgenteSoggetto
import it.finmatica.de4gsdzk.utils.Etichette
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

    private final GsdService gsdService

    AnpAnagrafeService(AnpAnagrafeRepository anpAnagrafeRepository, GsdService gsdService) {
        this.anpAnagrafeRepository = anpAnagrafeRepository
        this.gsdService = gsdService
    }

    Page<AnpAnagrafe> list(RicercaSoggetto rs, PageRequest pr) {
        if ( ( TestoUtils.isVuoto(rs?.cognome) || TestoUtils.isVuoto(rs?.nome) ) && TestoUtils.isVuoto(rs?.codiceFiscale)  ) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_ANPR"))
        }
        if (rs.archivio != null && rs.archivio != EArchivioSorgenteSoggetto.ANP) {
            throw new ErroreRicercaArchivioSoggettoRuntimeException()
        }
        Long op = gsdService.ricercaSoggettoANPR(rs.cognome,rs.nome, rs.codiceFiscale, rs.dataNascita, rs.idSoggettoAnpr, null)
        if (op != null){
            if (op.compareTo(0L) > 0){
                return anpAnagrafeRepository.findAllByIdOperazione(op, rs.sesso, pr)
            } else {
                throw new NoRecordFoundRuntimeException(Etichette.getEtichetta("Errore_Ricerca_ANPR_No_Result"))
            }
        } else {
            return null
        }
    }

    Page<AnpAnagrafe> listByRicercaIndividuo(RicercaIndividuo r, PageRequest pr) {
        r.validaDati()

        Long op = gsdService.ricercaSoggettoANPR(r.cognome, r.nome, r.codiceFiscale, r.dataNascitaDal, r.idSoggettoAnpr, r.idUnicoAnpr)
        if (op != null) {
            if (op.compareTo(0L) > 0) {
                return anpAnagrafeRepository.findAllByIdOperazione(op, r.sesso, pr)
            } else {
                throw new NoRecordFoundRuntimeException(Etichette.getEtichetta("Errore_Ricerca_ANPR_No_Result"))
            }
        } else {
            return null
        }
    }

    Page<AnpAnagrafe> listByFamigliaDiAnpAnagrafe(AnpAnagrafe anpAnagrafe, Date dataRiferimento, PageRequest pr) {
        if (anpAnagrafe == null) {
            return new PageImpl<AnpAnagrafe>([])
        }

        Long op = gsdService.ricercaComponentiANPR(anpAnagrafe.idFamigliaAnpr, anpAnagrafe.tipoSchedaAnpr, dataRiferimento)
        if (op != null) {
            if (op.compareTo(0L) > 0) {
                return anpAnagrafeRepository.findAllByIdOperazione(op, null, pr)
            } else {
                throw new NoRecordFoundRuntimeException(Etichette.getEtichetta("Errore_Ricerca_ANPR_No_Result"))
            }
        } else {
            return null
        }
    }

    AnpAnagrafe findBySoggetto(AnagrafeBaseDomain soggetto, boolean flagInserimento = false, Date dataRiferimento = null) {
        if ((TestoUtils.isVuoto(soggetto?.cognome) || TestoUtils.isVuoto(soggetto?.nome)) && TestoUtils.isVuoto(soggetto?.codiceFiscale)) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_ANPR"))
        }
        Long op = gsdService.ricercaSoggettoANPR(soggetto.cognome, soggetto.nome, soggetto.codiceFiscale, soggetto.dataNascita, soggetto.idSoggettoAnpr,soggetto.idUnicoAnpr, dataRiferimento, flagInserimento)
        if (op == null) {
            throw new NoRecordFoundRuntimeException(Etichette.getEtichetta("Errore_Ricerca_ANPR_No_Result"))
        }
        if (op.compareTo(0L) <= 0) {
            throw new NoRecordFoundRuntimeException(Etichette.getEtichetta("Errore_Ricerca_ANPR_No_Result"))
        }
        PageRequest pr = new PageRequest(0, Integer.MAX_VALUE)
        Page<AnpAnagrafe> p = anpAnagrafeRepository.findAllByIdOperazione(op, soggetto.sesso, pr)

        Long total = (p?.getTotalElements() ?: 0)

        if (total == 0) {
            throw new NoRecordFoundRuntimeException(Etichette.getEtichetta("Errore_Ricerca_ANPR_No_Result"))
        }

        if (total > 1) {
            throw new TooManyRecordsFoundRuntimeException()
        }

        return p.getContent().get(0)

    }

}
