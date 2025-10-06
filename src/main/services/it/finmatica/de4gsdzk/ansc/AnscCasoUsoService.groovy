package it.finmatica.de4gsdzk.ansc

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.IAttoAnsc
import it.finmatica.de4gsdzk.IAttoMatUci
import it.finmatica.de4gsdzk.ansc.*
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import org.apache.commons.lang.time.DateUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnscCasoUsoService {

    private final AnscCasoUsoNascitaRepository anscCasoUsoNascitaRepository

    private final AnscCasoUsoMorteRepository anscCasoUsoMorteRepository

    private final AnscCasoUsoMatrimonioRepository anscCasoUsoMatrimonioRepository

    private final AnscCasoUsoUnioneCivileRepository anscCasoUsoUnioneCivileRepository

    private final AnscCasoUsoCittadinanzaRepository anscCasoUsoCittadinanzaRepository

    AnscCasoUsoService(AnscCasoUsoNascitaRepository anscCasoUsoNascitaRepository, AnscCasoUsoMorteRepository anscCasoUsoMorteRepository,
                       AnscCasoUsoMatrimonioRepository anscCasoUsoMatrimonioRepository, AnscCasoUsoCittadinanzaRepository anscCasoUsoCittadinanzaRepository,
                       AnscCasoUsoUnioneCivileRepository anscCasoUsoUnioneCivileRepository
    ) {
        this.anscCasoUsoNascitaRepository = anscCasoUsoNascitaRepository
        this.anscCasoUsoMorteRepository = anscCasoUsoMorteRepository
        this.anscCasoUsoMatrimonioRepository = anscCasoUsoMatrimonioRepository
        this.anscCasoUsoUnioneCivileRepository = anscCasoUsoUnioneCivileRepository
        this.anscCasoUsoCittadinanzaRepository = anscCasoUsoCittadinanzaRepository
    }

    AnscCasoUsoBaseDomain getCasoUsoServizio(ETipoAtto tipoAttoEnum, ETipoAttoAnsc tipoAttoAnsc, Map params) {
        String siglaCategoria = (params?.categoria ?: null)
        switch (tipoAttoEnum) {
            case ETipoAtto.NAS: return anscCasoUsoNascitaRepository.findByTipoAttoAnscAndFlagServizioIsTrue(tipoAttoAnsc)
            case ETipoAtto.MOR: return anscCasoUsoMorteRepository.findByTipoAttoAnscAndFlagServizioIsTrue(tipoAttoAnsc)
            case ETipoAtto.MAT: return anscCasoUsoMatrimonioRepository.findByTipoAttoAnscAndCategoriaAndFlagServizioIsTrue(tipoAttoAnsc, siglaCategoria)
            case ETipoAtto.UCI: return anscCasoUsoUnioneCivileRepository.findByTipoAttoAnscAndFlagServizioIsTrue(tipoAttoAnsc)
            case ETipoAtto.CIT: return anscCasoUsoCittadinanzaRepository.findByTipoAttoAnscAndFlagServizioIsTrue(tipoAttoAnsc)
        }
        return null
    }

    Page<AnscCasoUsoBaseDomain> listAllByCategoriaAndTipoAttoAnscAndFlagVisibileIsTrueAndDescrizioneLike(ETipoAtto tipoAttoEnum, CivCategoriaTipoAtto categoria, ETipoAttoAnsc tipoAttoAnsc, String filtro, Pageable pageable) {
        switch (tipoAttoEnum) {
            case ETipoAtto.NAS: return anscCasoUsoNascitaRepository.findAllByCategoriaAndTipoAttoAnscAndFlagVisibileIsTrueAndDescrizioneLike(filtro, categoria?.codice, tipoAttoAnsc, pageable)
            case ETipoAtto.MOR: return anscCasoUsoMorteRepository.findAllByCategoriaAndTipoAttoAnscAndFlagVisibileIsTrueAndDescrizioneLike(filtro, categoria?.codice, tipoAttoAnsc, pageable)
            case ETipoAtto.MAT: return anscCasoUsoMatrimonioRepository.findAllByCategoriaAndTipoAttoAnscAndFlagVisibileIsTrueAndDescrizioneLike(filtro, categoria?.codice, tipoAttoAnsc, pageable)
            case ETipoAtto.UCI: return anscCasoUsoUnioneCivileRepository.findAllByCategoriaAndTipoAttoAnscAndFlagVisibileIsTrueAndDescrizioneLike(filtro, categoria?.codice, tipoAttoAnsc, pageable)
            case ETipoAtto.CIT: return anscCasoUsoCittadinanzaRepository.findAllByCategoriaAndTipoAttoAnscAndFlagVisibileIsTrueAndDescrizioneLike(filtro, categoria?.codice, tipoAttoAnsc, pageable)
        }
        return null
    }

    List<AnscCasoUsoBaseDomain> listAllByCategoriaLikeAndTipoAttoAnscAndFlagVisibileIsTrueAndDescrizioneLike(ETipoAtto tipoAttoEnum, String categoria, ETipoAttoAnsc tipoAttoAnsc, String filtro) {
        switch (tipoAttoEnum) {
            case ETipoAtto.NAS: return anscCasoUsoNascitaRepository.findAllByCodiceCategoriaLikeAndTipoAttoAnscAndFlagVisibileIsTrueAndDescrizioneLikeIgnoreCase(categoria, tipoAttoAnsc, filtro)
            case ETipoAtto.MOR: return anscCasoUsoMorteRepository.findAllByCodiceCategoriaLikeAndTipoAttoAnscAndFlagVisibileIsTrueAndDescrizioneLikeIgnoreCase(categoria, tipoAttoAnsc, filtro)
            case ETipoAtto.MAT: return anscCasoUsoMatrimonioRepository.findAllByCodiceCategoriaLikeAndTipoAttoAnscAndFlagVisibileIsTrueAndDescrizioneLikeIgnoreCase(categoria, tipoAttoAnsc, filtro)
            case ETipoAtto.UCI: return anscCasoUsoUnioneCivileRepository.findAllByCodiceCategoriaLikeAndTipoAttoAnscAndFlagVisibileIsTrueAndDescrizioneLikeIgnoreCase(categoria, tipoAttoAnsc, filtro)
            case ETipoAtto.CIT: return anscCasoUsoCittadinanzaRepository.findAllByCodiceCategoriaLikeAndTipoAttoAnscAndFlagVisibileIsTrueAndDescrizioneLikeIgnoreCase(categoria, tipoAttoAnsc, filtro)
        }
        return null
    }

    List<Long> listCasiUso(ETipoAtto tipoAttoEnum, Map params) {
        String siglaCategoria = (params?.categoria ?: null)
        Integer parte = ((params?.parte != null) ? (Integer) params.parte : null)
        String serie = (params?.serie ?: null)
        ETipoAttoAnsc tipoAttoAnsc = ((ETipoAttoAnsc) params.tipoAttoAnsc ?: null)
        Boolean flagExArt19 = (params.flagExArt19 ?: null)
        Boolean flagInViaggio = (params.flagInViaggio ?: null)
        Boolean isCentroNascita = (params.isCentroNascita ?: null)
        switch (tipoAttoEnum) {
            case ETipoAtto.NAS:
                ETipoSiNo natoMorto = null
                if (params?.natoMorto == EStatoNascita.Nato_morto) {
                    natoMorto = ETipoSiNo.SI
                } else if (params?.natoMorto == EStatoNascita.Vivo_morto) {
                    natoMorto = ETipoSiNo.NO
                }
                ETipoFiliazione tipoFiliazione = ((params?.tipoFiliazione) ? (ETipoFiliazione) params.tipoFiliazione : null)
                String tipoDichiarante = (params?.tipoDichiarante ?: null)
                String tipoComparente = (params?.tipoComparente ?: null)
                ETipoSiNo attoNotarile = ((params?.attoNotarile == ETipoSiNo.SI) ? (ETipoSiNo) params.attoNotarile : null)
                ETipoSiNo dichiarazioneGiudiziale = ((params?.dichiarazioneGiudiziale) ? (ETipoSiNo) params.dichiarazioneGiudiziale : null)
                ETipoFasciaEta fasciaEtaFiglio = ((params?.fasciaEtaFiglio) ? (ETipoFasciaEta) params.fasciaEtaFiglio : null)
                ETipoConsenso tipoConsenso = ((params?.tipoConsenso) ? (ETipoConsenso) params.tipoConsenso : null)
                ETipoRiconoscimentoPrenatale tipoRiconoscimento = ((params?.tipoRiconoscimento) ? (ETipoRiconoscimentoPrenatale) params.tipoRiconoscimento : null)
                Boolean flagFiglioDiIgnoti = (params.flagFiglioDiIgnoti ?: null)
                // Bug #76439:  Quando tipo riconoscimento è PD, ricado nei casi d'uso che corrispondono al tipo riconoscimento PDMD
                //              Differenzio eventualmente il payload tramite civnas_v_json
                if (tipoRiconoscimento == ETipoRiconoscimentoPrenatale.PD) {
                    tipoRiconoscimento = ETipoRiconoscimentoPrenatale.PDMD
                }
                Long idMotivoAdozione = ((params?.idMotivoAdozione) ? (Long) params.idMotivoAdozione : null)
                return anscCasoUsoNascitaRepository.findAllByAllFiltri(siglaCategoria, parte, serie, tipoAttoAnsc, natoMorto, tipoFiliazione, tipoDichiarante,
                        tipoComparente, attoNotarile, dichiarazioneGiudiziale, fasciaEtaFiglio, tipoConsenso, tipoRiconoscimento, flagExArt19, idMotivoAdozione,
                        isCentroNascita, flagInViaggio, flagFiglioDiIgnoti)
            case ETipoAtto.MAT:
                Boolean flagRitoCattolico = (params.flagRitoCattolico ?: null)
                Boolean flagCasaComunale = (params.flagCasaComunale ?: null)
                ETipoSiNo riconoscimentoFigli = (params?.riconoscimentoFigli ? (ETipoSiNo) params.riconoscimentoFigli : ETipoSiNo.NO)
                String tipoDivorzio = (params?.tipoDivorzio ? SqlUtils.beginsAndEndsLike(((ETipoDivorzio) params.tipoDivorzio).name()) : "%")
                String tipoDivorzioAltro = ((params?.tipoDivorzioAltro != null) ? SqlUtils.beginsAndEndsLike(((ETipoDivorzioAltro) params.tipoDivorzioAltro).name()) : null)
                Boolean flagStranieriNonResidenti = (params.flagStranieriNonResidenti ?: null)
                return anscCasoUsoMatrimonioRepository.findAllByAllFiltri(SqlUtils.beginsAndEndsLike(siglaCategoria), parte, serie, tipoAttoAnsc, flagRitoCattolico, flagCasaComunale, flagExArt19, riconoscimentoFigli, tipoDivorzio, tipoDivorzioAltro, flagStranieriNonResidenti, flagInViaggio)
            case ETipoAtto.MOR:
                ETipoSiNo estremiDecessoNoti = (params?.estremiDecessoNoti ? (ETipoSiNo) params.estremiDecessoNoti : null)
                ETipoSiNo morteViolenta = ((params?.morteViolenta) ? (ETipoSiNo) params.morteViolenta : null)
                return anscCasoUsoMorteRepository.findAllByAllFiltri(siglaCategoria, parte, serie, estremiDecessoNoti, morteViolenta, flagExArt19, flagInViaggio)
            case ETipoAtto.CIT:
                Long idMotivoCittadinanza = ((params?.idMotivoCittadinanza != null) ? (Long) params.idMotivoCittadinanza : null)
                return anscCasoUsoCittadinanzaRepository.findAllByAllFiltri(siglaCategoria, idMotivoCittadinanza)
            case ETipoAtto.UCI:
                Boolean flagCasaComunale = (params.flagCasaComunale ?: null)
                String tipoDichiarante = (params?.tipoDichiarante ? SqlUtils.beginsAndEndsLike((String) params.tipoDichiarante) : null)
                ETipoDivorzioAltro tipoDivorzioAltro = ((params?.tipoDivorzioAltro != null) ? (ETipoDivorzioAltro) params.tipoDivorzioAltro : null)
                return anscCasoUsoUnioneCivileRepository.findAllByAllFiltri(siglaCategoria, parte, flagCasaComunale, tipoDichiarante, tipoDivorzioAltro, flagExArt19)
        }
        return []
    }

    AnscCasoUsoBaseDomain get(ETipoAtto tipoAttoEnum, Long pkCu) {
        switch (tipoAttoEnum) {
            case ETipoAtto.NAS: return anscCasoUsoNascitaRepository.findById(pkCu)
            case ETipoAtto.MOR: return anscCasoUsoMorteRepository.findById(pkCu)
            case ETipoAtto.MAT: return anscCasoUsoMatrimonioRepository.findById(pkCu)
            case ETipoAtto.UCI: return anscCasoUsoUnioneCivileRepository.findById(pkCu)
            case ETipoAtto.CIT: return anscCasoUsoCittadinanzaRepository.findById(pkCu)
        }
        return null
    }

    AnscCasoUsoBaseDomain findByAtto(CivAttoBaseDomain atto, CivDatiProvenienzaAtto datiProvenienza) {
        if (atto instanceof IAttoAnsc) {
            IAttoAnsc attoAnsc = (IAttoAnsc) atto
            if ((attoAnsc.getIdAnscUseCase() != null) && ((attoAnsc.getIdAttoAnsc() ?: "") != "")) {
                return get(attoAnsc.getTipoAttoEnum(), attoAnsc.getIdAnscUseCase())
            } else {
                List<Long> lc = listCasiUso(atto.getTipoAttoEnum(), getCasoUsoParams(atto, datiProvenienza))
                if (lc.size() == 1) {
                    get(atto.getTipoAttoEnum(), lc.get(0))
                } else {
                    getCasoUsoServizio(atto.getTipoAttoEnum(), atto.getTipoAttoAnsc(), getCasoUsoParams(atto, datiProvenienza))
                }
            }
        }
    }

    private Map getCasoUsoParams(CivAttoBaseDomain atto, CivDatiProvenienzaAtto datiProvenienza) {
        switch (atto.tipoAttoEnum) {
            case ETipoAtto.NAS:
                CivNascita nascita = (CivNascita) atto
                Map params = [parte             : nascita.parte,
                              serie             : nascita.serie,
                              categoria         : nascita.tipoAttoDomain?.categoriaDomain?.codice,
                              tipoAttoAnsc      : nascita.getTipoAttoAnsc(),
                              tipoFiliazione    : nascita.tipoFiliazione,
                              natoMorto         : nascita.natoMorto,
                              tipoConsenso      : nascita.tipoConsenso,
                              tipoRiconoscimento: nascita.tipoRiconoscimento,
                              flagFiglioDiIgnoti: nascita.flagFiglioDiIgnoti]
                params.put("tipoDichiarante", datiProvenienza.tipoDichiarante)
                params.put("tipoComparente", datiProvenienza.tipoComparente)
                params.put("attoNotarile", datiProvenienza.attoNotarile)
                params.put("dichiarazioneGiudiziale", datiProvenienza.dichiarazioneGiudiziale)

                if (nascita.dataNascita) {
                    Date dataConfrontoFasciaEta = datiProvenienza.dataAtto != null ? datiProvenienza.dataAtto : DataUtils.getDataCorrente()
                    if (DataUtils.addYears(nascita.dataNascita, 14) > dataConfrontoFasciaEta) {
                        params.put("fasciaEtaFiglio", ETipoFasciaEta.IQ)
                    } else if (DataUtils.addYears(nascita.dataNascita, 18) > dataConfrontoFasciaEta) {
                        params.put("fasciaEtaFiglio", ETipoFasciaEta.SQ)
                    } else if (DataUtils.addYears(nascita.dataNascita, 18) <= dataConfrontoFasciaEta) {
                        params.put("fasciaEtaFiglio", ETipoFasciaEta.MG)
                    } else {
                        params.put("fasciaEtaFiglio", null)
                    }
                } else {
                    params.put("fasciaEtaFiglio", null)
                }

                if (datiProvenienza.flagExArt19) {
                    params.put("flagExArt19", datiProvenienza.flagExArt19)
                }
                if (nascita.isAdozione()) {
                    params.put("idMotivoAdozione", nascita.motivoNascita.id)
                }
                if (nascita.isCentroNascita()) {
                    params.put("isCentroNascita", nascita.isCentroNascita())
                }
                if(datiProvenienza.flagInViaggio){
                    params.put("flagInViaggio", datiProvenienza.flagInViaggio)
                }
                return params
            case ETipoAtto.MOR:
                CivMorte morte = (CivMorte) atto
                Map params = [parte             : morte.parte,
                              serie             : morte.serie,
                              categoria         : morte.tipoAttoDomain?.categoriaDomain?.codice,
                              tipoAttoAnsc      : morte.getTipoAttoAnsc(),
                              morteViolenta     : morte.morteViolenta,
                              estremiDecessoNoti: morte.estremiDecessoNoti]
                if (datiProvenienza.flagExArt19) {
                    params.put("flagExArt19", datiProvenienza.flagExArt19)
                }
                if(datiProvenienza.flagInViaggio){
                    params.put("flagInViaggio", datiProvenienza.flagInViaggio)
                }
                return params
            case ETipoAtto.MAT:
                if (atto instanceof IAttoMatUci) {
                    if (((IAttoMatUci) atto).divorzio) {
                        CivMatrimonio matrimonio = (CivMatrimonio) atto

                        Map params = [parte       : matrimonio.parte,
                                      serie       : matrimonio.serie,
                                      categoria   : matrimonio.tipoAttoDomain?.categoriaDomain?.codice,
                                      tipoAttoAnsc: matrimonio.getTipoAttoAnsc(),
                                      divorzio    : Boolean.TRUE]
                        params.put("tipoDivorzio", datiProvenienza.tipoDivorzio)
                        params.put("tipoDivorzioAltro", datiProvenienza.tipoDivorzioAltro)
                        return params
                    } else {
                        CivMatrimonio matrimonio = (CivMatrimonio) atto

                        Map params = [parte              : matrimonio.parte,
                                      serie              : matrimonio.serie,
                                      tipoAttoAnsc       : matrimonio.getTipoAttoAnsc(),
                                      riconoscimentoFigli: matrimonio.riconoscimentoFigli]
                        params.put("categoria", matrimonio.tipoAttoDomain?.categoriaDomain?.codice)
                        params.put("flagRitoCattolico", datiProvenienza.flagRitoCattolico)
                        params.put("flagCasaComunale", datiProvenienza.flagCasaComunale)
                        if (datiProvenienza.flagExArt19) {
                            params.put("flagExArt19", datiProvenienza.flagExArt19)
                        }
                        if (datiProvenienza.flagStranieriNonResidenti) {
                            params.put("flagStranieriNonResidenti", datiProvenienza.flagStranieriNonResidenti)
                        }
                        if(datiProvenienza.flagInViaggio){
                            params.put("flagInViaggio", datiProvenienza.flagInViaggio)
                        }
                        return params
                    }
                }
                break
            case ETipoAtto.UCI:
                if (atto instanceof IAttoMatUci) {
                    if (((IAttoMatUci) atto).divorzio) {
                        CivUnioneCivile uci = (CivUnioneCivile) atto

                        Map params = [parte    : uci.parte,
                                      serie    : uci.serie,
                                      categoria: uci.tipoAttoDomain?.categoriaDomain?.codice,
                                      divorzio : Boolean.TRUE]
                        params.put("tipoDichiarante", datiProvenienza.tipoDichiarante)
                        params.put("tipoDivorzioAltro", datiProvenienza.tipoDivorzioAltro)
                        return params
                    } else {
                        CivUnioneCivile uci = (CivUnioneCivile) atto

                        Map params = [parte       : uci.parte,
                                      serie       : uci.serie,
                                      categoria   : uci.tipoAttoDomain?.categoriaDomain?.codice,
                                      tipoAttoAnsc: uci.getTipoAttoAnsc()]
                        params.put("flagCasaComunale", datiProvenienza.flagCasaComunale)
                        if (datiProvenienza.flagExArt19) {
                            params.put("flagExArt19", datiProvenienza.flagExArt19)
                        }
                        return params
                    }
                }
                break
            case ETipoAtto.CIT:
                CivCittadinanza cittadinanza = (CivCittadinanza) atto
                Map params = [categoria           : cittadinanza.tipoAttoDomain?.categoriaDomain?.codice,
                              tipoAttoAnsc        : cittadinanza.getTipoAttoAnsc(),
                              idMotivoCittadinanza: cittadinanza.motivoCittadinanza?.id]
                return params
        }
        return [:]
    }


}
