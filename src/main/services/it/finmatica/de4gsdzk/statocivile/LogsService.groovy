package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.*
import it.finmatica.de4gsdzk.utils.ETipoLog
import it.finmatica.de4gsdzk.utils.SqlUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class LogsService {

    private final LogDocAreaRepository logDocAreaRepository
    private final LogFirmaRemotaRepository logFirmaRemotaRepository
    private final LogIstatRepository logIstatRepository
    private final LogANPRRepository logANPRRepository
    private final LogAnscRepository logAnscRepository
    private final LogGestioneTestiRepository logGestioneTestiRepository
    private final LogWspaRepository logWspaRepository
    private final LogGsdRepository logGsdRepository
    private final StatoCivileService statoCivileService

    LogsService(LogDocAreaRepository logDocAreaRepository, LogFirmaRemotaRepository logFirmaRemotaRepository,
                LogIstatRepository logIstatRepository, LogANPRRepository logANPRRepository,
                LogAnscRepository logAnscRepository, LogGestioneTestiRepository logGestioneTestiRepository,
                LogWspaRepository logWspaRepository, LogGsdRepository logGsdRepository,
                StatoCivileService statoCivileService) {
        this.logDocAreaRepository = logDocAreaRepository
        this.logFirmaRemotaRepository = logFirmaRemotaRepository
        this.logIstatRepository = logIstatRepository
        this.logANPRRepository = logANPRRepository
        this.logAnscRepository = logAnscRepository
        this.logGestioneTestiRepository = logGestioneTestiRepository
        this.logWspaRepository = logWspaRepository
        this.logGsdRepository = logGsdRepository
        this.statoCivileService = statoCivileService
    }

    Page<LogProjection> listAllByTipoLog(ETipoLog tipoLog, PageRequest pageRequest) {
        switch (tipoLog) {
            case ETipoLog.Doc_Area:
                return logDocAreaRepository.findAllNoClob(pageRequest)
            case ETipoLog.Firma_Remota:
                return logFirmaRemotaRepository.findAllNoClob(pageRequest)
            case ETipoLog.Istat:
                return logIstatRepository.findAllNoClob(pageRequest)
            case ETipoLog.ANPR:
                return logANPRRepository.findAllNoClob(pageRequest)
            case ETipoLog.ANSC:
                return logAnscRepository.findAllNoClob(pageRequest)
            case ETipoLog.Gestione_Testi:
                return logGestioneTestiRepository.findAllNoClob(pageRequest)
            case ETipoLog.Wspa:
                return logWspaRepository.findAllNoClob(pageRequest)
            case ETipoLog.Gsd:
                return logGsdRepository.findAllNoClob(pageRequest)
        }
    }

    Page<LogProjection> listAllByTipoLog(ETipoLog tipoLog, String filter, PageRequest pageRequest) {

        if (filter==null || filter.isEmpty())
            return listAllByTipoLog(tipoLog, pageRequest)

        filter = SqlUtils.getFiltroLike(filter)

        switch (tipoLog) {
            case ETipoLog.Doc_Area:
                return logDocAreaRepository.findAllNoClobFilter(filter, pageRequest)
            case ETipoLog.Firma_Remota:
                return logFirmaRemotaRepository.findAllNoClobFilter(filter, pageRequest)
            case ETipoLog.Istat:
                return logIstatRepository.findAllNoClobFilter(filter, pageRequest)
            case ETipoLog.ANPR:
                return logANPRRepository.findAllNoClobFilter(filter, pageRequest)
            case ETipoLog.ANSC:
                return logAnscRepository.findAllNoClobFilter(filter, pageRequest)
            case ETipoLog.Gestione_Testi:
                return logGestioneTestiRepository.findAllNoClobFilter(filter, pageRequest)
            case ETipoLog.Wspa:
                return logWspaRepository.findAllNoClobFilter(filter, pageRequest)
            case ETipoLog.Gsd:
                return logGsdRepository.findAllNoClobFilter(filter, pageRequest)
        }
    }

    LogBaseDomain get(ETipoLog tipoLog, Long id) {
        switch(tipoLog) {
            case ETipoLog.Doc_Area:
                return logDocAreaRepository.findOne(id) // forza eager
            case ETipoLog.Firma_Remota:
                return logFirmaRemotaRepository.findOne(id) // forza eager
            case ETipoLog.Istat:
                return logIstatRepository.findOne(id) // forza eager
            case ETipoLog.ANPR:
                return logANPRRepository.findOne(id) // forza eager
            case ETipoLog.ANSC:
                return logAnscRepository.findOne(id) // forza eager
            case ETipoLog.Gestione_Testi:
                return logGestioneTestiRepository.findOne(id) // forza eager
            case ETipoLog.Wspa:
                return logWspaRepository.findOne(id) // forza eager
            case ETipoLog.Gsd:
                return logGsdRepository.findOne(id) // forza eager
        }
    }

    LogBaseDomain save (ETipoLog tipoLog, LogBaseDomain obj){
        //validaDati(obj)
        switch(tipoLog) {
            case ETipoLog.ANSC:
                if (obj.id == null){
                    obj.id = statoCivileService.getIdFromSequence(obj)
                }
                return logAnscRepository.save((LogAnsc)obj)
            case ETipoLog.Gsd:
                if (obj.id == null){
                    obj.id = statoCivileService.getIdFromSequence(obj)
                }
                return logGsdRepository.save((LogGsd)obj)
        }
        return null
    }

}
