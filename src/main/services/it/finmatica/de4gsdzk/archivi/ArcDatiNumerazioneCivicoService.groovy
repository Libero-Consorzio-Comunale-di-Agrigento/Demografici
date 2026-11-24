package it.finmatica.de4gsdzk.archivi

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.SortUtils
import it.finmatica.de4gsdzk.utils.TestoUtils
import org.springframework.data.domain.Sort
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class ArcDatiNumerazioneCivicoService {

    private final ArcDatiNumerazioneCivicoRepository arcDatiNumerazioneCivicoRepository
    private final ArcViaRepository arcViaRepository
    private final GsdService gsdService

    ArcDatiNumerazioneCivicoService(ArcDatiNumerazioneCivicoRepository arcDatiNumerazioneCivicoRepository,
                                    ArcViaRepository arcViaRepository,
                                    GsdService gsdService) {
        this.arcDatiNumerazioneCivicoRepository = arcDatiNumerazioneCivicoRepository
        this.arcViaRepository = arcViaRepository
        this.gsdService = gsdService
    }

    private List<ArcDatiNumerazioneCivico> getElementiVisibili(Long codVia = null) {
        List<ArcDatiNumerazioneCivico> result = null
        if (codVia != null) {
            result = arcDatiNumerazioneCivicoRepository.findAllByViaIdAndFlagVisibileTrueOrderBySequenza(codVia)
        }
        return result ?: arcDatiNumerazioneCivicoRepository.findAllByViaIsNullAndFlagVisibileTrueOrderBySequenza()
    }

    Map<String, List<ArcDatiNumerazioneCivico>> getElementiVisibiliPartizionati(Long codVia = null) {
        List<ArcDatiNumerazioneCivico> esterno = []
        List<ArcDatiNumerazioneCivico> interno = []
        getElementiVisibili(codVia).each {
            if (it.flagEsterno) esterno << it
            if (it.flagInterno) interno << it
        }
        return [esterno: esterno, interno: interno]
    }

    List<ArcDatiNumerazioneCivico> listTutte(Sort sort) {
        return arcDatiNumerazioneCivicoRepository.findAllByViaIsNotNull(sort)
    }

    List<ArcDatiNumerazioneCivico> listPerComune(Sort sort) {
        return arcDatiNumerazioneCivicoRepository.findAllByViaIsNull(sort)
    }

    List<ArcDatiNumerazioneCivico> listPerVia(Long codVia, Sort sort) {
        if (codVia == null) {
            return listTutte(sort)
        }
        return arcDatiNumerazioneCivicoRepository.findAllByViaId(codVia, sort)
    }

    ArcDatiNumerazioneCivico get(Long id) {
        return arcDatiNumerazioneCivicoRepository.findOneWithVia(id)
    }

    ArcDatiNumerazioneCivico update(ArcDatiNumerazioneCivico entity) {
        return arcDatiNumerazioneCivicoRepository.save(entity)
    }

    ArcDatiNumerazioneCivico insert(ArcDatiNumerazioneCivico entity) {
        if (TestoUtils.isVuoto(entity.elemento)) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Elemento"))
        }
        boolean duplicato = entity.via != null
                ? arcDatiNumerazioneCivicoRepository.existsByViaIdAndElemento(entity.via.id, entity.elemento)
                : arcDatiNumerazioneCivicoRepository.existsByViaIsNullAndElemento(entity.elemento)
        if (duplicato) {
            Map<String, String> etichetta = Etichette.getEtichetta("Elemento_gia_presente_per_via")
            throw new De4gsdzkRuntimeException(etichetta, (String) etichetta?.defaultValue)
        }
        entity.id = gsdService.getIdFromSequence(entity)
        return arcDatiNumerazioneCivicoRepository.save(entity)
    }

    int popolaDaTemplate(Long codVia) {
        if (codVia == null) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Via"))
        }
        ArcVia via = arcViaRepository.findById(codVia)
        if (via == null) {
            Map<String, String> etichetta = Etichette.getEtichetta("Via")
            throw new De4gsdzkRuntimeException(etichetta, (String) etichetta?.defaultValue)
        }
        Set<String> esistenti = arcDatiNumerazioneCivicoRepository.findAllByViaId(via.id, new Sort(SortUtils.sequenzaAsc))
                .collect { it.elemento } as Set<String>
        int inserted = 0
        arcDatiNumerazioneCivicoRepository.findAllByViaIsNull(new Sort(SortUtils.sequenzaAsc)).each { tpl ->
            if (TestoUtils.isVuoto(tpl.elemento)) return
            if (esistenti.contains(tpl.elemento)) return
            ArcDatiNumerazioneCivico entity = new ArcDatiNumerazioneCivico(
                    elemento: tpl.elemento,
                    via: via,
                    sequenza: tpl.sequenza,
                    separatore: tpl.separatore,
                    flagEsterno: tpl.flagEsterno,
                    flagInterno: tpl.flagInterno,
                    flagVisibile: tpl.flagVisibile,
                    flagDefault: tpl.flagDefault
            )
            entity.id = gsdService.getIdFromSequence(entity)
            arcDatiNumerazioneCivicoRepository.save(entity)
            inserted++
        }
        return inserted
    }
}
