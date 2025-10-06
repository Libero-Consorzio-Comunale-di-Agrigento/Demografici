package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.IstBaseDomain
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.ETipoModelloIstat
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class IstService {

    private final IstMp4Service istMp4Service

    private final IstMd3MatrimonioService istMd3MatrimonioService

    private final IstMd3PubblicazioneService istMd3PubblicazioneService

    private final IstMd4Service istMd4Service

    private final IstMd4BisService istMd4BisService

    private final IstMd3UProcessoVerbaleService istMd3UProcessoVerbaleService

    private final IstMd3UUnioneCivileService istMd3UUnioneCivileService

    private final IstMscDivorzioService istMscDivorzioService

    private final IstMsuScioglimentoService istMsuScioglimentoService

    private final CivAnnotazioneAttoService civAnnotazioneAttoService

    IstService(IstMp4Service istMp4Service,
               IstMd3PubblicazioneService istMd3PubblicazioneService, IstMd3MatrimonioService istMd3MatrimonioService,
               IstMd3UProcessoVerbaleService istMd3UProcessoVerbaleService, IstMd3UUnioneCivileService istMd3UUnioneCivileService,
               IstMd4Service istMd4Service, IstMd4BisService istMd4BisService,
               IstMscDivorzioService istMscDivorzioService, IstMsuScioglimentoService istMsuScioglimentoService,
               CivAnnotazioneAttoService civAnnotazioneAttoService) {

        this.istMp4Service = istMp4Service
        this.istMd3PubblicazioneService = istMd3PubblicazioneService
        this.istMd3MatrimonioService = istMd3MatrimonioService
        this.istMd3UProcessoVerbaleService = istMd3UProcessoVerbaleService
        this.istMd3UUnioneCivileService = istMd3UUnioneCivileService
        this.istMd4Service = istMd4Service
        this.istMd4BisService = istMd4BisService
        this.istMscDivorzioService = istMscDivorzioService
        this.istMsuScioglimentoService = istMsuScioglimentoService
        this.civAnnotazioneAttoService = civAnnotazioneAttoService
    }

    IstBaseDomain get(ETipoAtto tipoAttoEnum, ETipoModelloIstat tm, Long id){
        IstBaseDomain bd = null
        switch (tm) {
            case ETipoModelloIstat.P4:
                bd = istMp4Service.get(id)
                break
            case ETipoModelloIstat.D3:
                if (tipoAttoEnum == ETipoAtto.PUB){
                    bd = istMd3PubblicazioneService.get(id)
                } else{
                    bd = istMd3MatrimonioService.get(id)
                }
                break
            case ETipoModelloIstat.D4:
                bd = istMd4Service.get(id)
                break
            case ETipoModelloIstat.D4BIS:
                bd = istMd4BisService.get(id)
                break
            case ETipoModelloIstat.D3U:
                if (tipoAttoEnum == ETipoAtto.PVU){
                    bd = istMd3UProcessoVerbaleService.get(id)
                } else{
                    bd = istMd3UUnioneCivileService.get(id)
                }
                break
            case ETipoModelloIstat.SC:
                bd = istMscDivorzioService.get(id)
                break
            case ETipoModelloIstat.PROVV: // dal 2024
            case ETipoModelloIstat.SDSU:  // dal 2024
                if (tipoAttoEnum == ETipoAtto.MAT) {
                    bd = istMscDivorzioService.get(id)
                } else {
                    bd = istMsuScioglimentoService.get(id)
                }
                break
        }
        return bd
    }

    IstBaseDomain getByUkAtto(ETipoAtto tipoAttoEnum, ETipoModelloIstat tm, String identificativoAtto){
        IstBaseDomain bd = null
        switch (tm) {
            case ETipoModelloIstat.P4:
                bd = istMp4Service.getByUkAtto(identificativoAtto)
                break
            case ETipoModelloIstat.D3:
                if (tipoAttoEnum == ETipoAtto.PUB){
                    bd = istMd3PubblicazioneService.getByUkAtto(identificativoAtto)
                } else{
                    bd = istMd3MatrimonioService.getByUkAtto(identificativoAtto)
                }
                break
            case ETipoModelloIstat.D4:
                bd = istMd4Service.getByUkAtto(identificativoAtto)
                break
            case ETipoModelloIstat.D4BIS:
                bd = istMd4BisService.getByUkAtto(identificativoAtto)
                break
            case ETipoModelloIstat.D3U:
                if (tipoAttoEnum == ETipoAtto.PVU){
                    bd = istMd3UProcessoVerbaleService.getByUkAtto(identificativoAtto)
                } else{
                    bd = istMd3UUnioneCivileService.getByUkAtto(identificativoAtto)
                }
                break
            case ETipoModelloIstat.SC:
                bd = istMscDivorzioService.getByUkAtto(identificativoAtto)
                break
            case ETipoModelloIstat.PROVV: // dal 2024
            case ETipoModelloIstat.SDSU:  // dal 2024
                if (tipoAttoEnum == ETipoAtto.MAT) {
                    bd = istMscDivorzioService.getByUkAtto(identificativoAtto)
                } else {
                    bd = istMsuScioglimentoService.getByUkAtto(identificativoAtto)
                }
                break
        }
        return bd
    }

    /*
    IstBaseDomain create(ETipoAtto tipoAttoEnum, ETipoModelloIstat tm, Map params) {
        IstBaseDomain bd = null
        switch (tm) {
            case ETipoModelloIstat.PROVV: // dal 2024
                if (tipoAttoEnum == ETipoAtto.MAT) {
                    bd = istMscDivorzioService.create(tm, params)
                } else {
                    bd = istMsuScioglimentoService.create(tm, params)
                }
                break
        }
        return bd
    }
    */

    List<Long> listAllIdByIdAnnotazione(ETipoAtto tipoAttoEnum, ETipoModelloIstat tm, Long idAnnotazione){
        List<Long> ll = []
        if (idAnnotazione) {
            switch (tm) {
                case ETipoModelloIstat.PROVV: // dal 2024
                    if (tipoAttoEnum == ETipoAtto.MAT) {
                        ll = istMscDivorzioService.listAllIdByIdAnnotazione(idAnnotazione)
                    } else {
                        ll = istMsuScioglimentoService.listAllIdByIdAnnotazione(idAnnotazione)
                    }
                    break
            }
        }
        return ll
    }

    IstBaseDomain save (ETipoAtto tipoAttoEnum, ETipoModelloIstat tm, IstBaseDomain obj, Long pkAtto, boolean force=false) {
        IstBaseDomain bd = null
        switch (tm) {
            case ETipoModelloIstat.P4:
                bd = istMp4Service.save((IstMp4)obj, pkAtto, force)
                break
            case ETipoModelloIstat.D3:
                if (tipoAttoEnum == ETipoAtto.PUB){
                    bd = istMd3PubblicazioneService.save((IstMd3Pubblicazione)obj)
                } else{
                    bd = istMd3MatrimonioService.save((IstMd3Matrimonio)obj)
                }
                break
            case ETipoModelloIstat.D4:
                bd = istMd4Service.save((IstMd4)obj)
                break
            case ETipoModelloIstat.D4BIS:
                bd = istMd4BisService.save((IstMd4Bis)obj)
                break
            case ETipoModelloIstat.D3U:
                if (tipoAttoEnum == ETipoAtto.PVU){
                    bd = istMd3UProcessoVerbaleService.save((IstMd3UProcessoVerbale)obj)
                } else{
                    bd = istMd3UUnioneCivileService.save((IstMd3UUnioneCivile)obj)
                }
                break
            case ETipoModelloIstat.SC:
                bd = istMscDivorzioService.save((IstMscDivorzio) obj, pkAtto)
                break
            case ETipoModelloIstat.PROVV: // dal 2024
                if (tipoAttoEnum == ETipoAtto.MAT) {
                    bd = istMscDivorzioService.save((IstMscDivorzio) obj, pkAtto)
                } else {
                    bd = istMsuScioglimentoService.save((IstMsuScioglimento) obj, pkAtto)
                }
                break
            case ETipoModelloIstat.SDSU:  // dal 2024
                if (tipoAttoEnum == ETipoAtto.MAT) {
                    bd = istMscDivorzioService.save((IstMscDivorzio) obj, pkAtto)
                } else {
                    bd = istMsuScioglimentoService.save((IstMsuScioglimento) obj, pkAtto)
                }
                break
        }
        return bd
    }

}
