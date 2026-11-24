package it.finmatica.de4gsdzk.ansc

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.statocivile.CivAttoService
import it.finmatica.de4gsdzk.statocivile.CivDatiProvenienzaAtto
import it.finmatica.de4gsdzk.statocivile.CivDatiProvenienzaAttoService
import it.finmatica.de4gsdzk.utils.ETipoArchivioAnsc
import it.finmatica.de4gsdzk.utils.ETipoAtto
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController

@Slf4j
@RestController
class AnscController {

    private final AnscEndPointServizioService anscEndPointServizioService
    private final AnscUtenteService anscUtenteService
    private final CivDatiProvenienzaAttoService civDatiProvenienzaAttoService
    private final AnscComunicazioneService anscComunicazioneService
    private final CivAttoService civAttoService

    AnscController(AnscEndPointServizioService anscEndPointServizioService, AnscUtenteService anscUtenteService,
                   CivDatiProvenienzaAttoService civDatiProvenienzaAttoService,
                   AnscComunicazioneService anscComunicazioneService, CivAttoService civAttoService) {
        this.anscEndPointServizioService = anscEndPointServizioService
        this.anscUtenteService = anscUtenteService
        this.civDatiProvenienzaAttoService = civDatiProvenienzaAttoService
        this.anscComunicazioneService = anscComunicazioneService
        this.civAttoService = civAttoService
    }

    @PostMapping(value="/richiestaANSC", consumes = "application/json")
    ResponseEntity<AnscInfoComunicazioneServizio> richiestaANSC(@RequestBody String jOld,
                                                                @RequestParam("tipoArchivioComunicazione") String taRifCom,
                                                                @RequestParam("idServizio") String idServizio,
                                                                @RequestParam("tipoArchivioComunicazionePrec") String taRifComPrec,
                                                                @RequestParam("idServizioPrec") String idServizioPrec,
                                                                @RequestParam("idRifPrec") Long idRifPrec,
                                                                @RequestParam("idUseCase") Long idUseCase,
                                                                @RequestParam("tipoAtto")String tipoAtto,
                                                                @RequestParam("pkAtto") Long pkAtto,
                                                                @RequestParam("idRif") Long idRif,
                                                                @RequestParam("operatore") String operatore,
                                                                @RequestParam("otp") String otp,
                                                                @RequestParam("idOperazione") Long idOperazione) throws Exception {
        if (jOld){
            log.info("jOld non gestito")
        }

        ETipoArchivioAnsc tac
        try {
            tac = ETipoArchivioAnsc.valueOf(taRifCom)
        } catch (IllegalArgumentException e) {
            log.warn("Valore non valido per tipoArchivioComunicazione: ${taRifCom}")
            return ResponseEntity.badRequest().build()
        }

        ETipoArchivioAnsc tacPrec = null
        if ( (taRifComPrec?:"") != ""){
            try {
                tacPrec = ETipoArchivioAnsc.valueOf(taRifComPrec)
            } catch (IllegalArgumentException e) {
                log.warn("Valore non valido per tipoArchivioComunicazionePrec: ${taRifComPrec}")
                return ResponseEntity.badRequest().build()
            }
        }

        AnscEndPointServizio epServizio = anscEndPointServizioService.get(idServizio)
        AnscEndPointServizio epServizioPrec = null
        if (idServizioPrec != null){
            epServizioPrec = anscEndPointServizioService.get(idServizioPrec)
        }
        List<Long> idRifPrecs = null
        if (idRifPrec != null){
            idRifPrecs = [idRifPrec]
        }

        ETipoAtto tipoAttoEnum
        try {
            tipoAttoEnum = ETipoAtto.valueOf(tipoAtto)
        } catch (IllegalArgumentException e) {
            log.warn("Valore non valido per tipoAtto: ${tipoAtto}")
            return ResponseEntity.badRequest().build()
        }
        CivAttoBaseDomain atto = civAttoService.getAtto(tipoAttoEnum, pkAtto)
        CivDatiProvenienzaAtto datiProvenienza = civDatiProvenienzaAttoService.getByUkAtto(atto.idAtto)
        String tipoDocumentoCdu = AnscUtils.getTipoDocumentoCdu(atto, datiProvenienza)

        AnscUtente ansUte = anscUtenteService.get(operatore)
        AnscCredenziali cre = new AnscCredenziali(ansUte, otp)

        AnscInfoComunicazioneServizio iCom = anscComunicazioneService.inviaComunicazioneAtto(tacPrec, epServizioPrec, idRifPrecs, tac, epServizio, idRif, idUseCase, tipoDocumentoCdu, atto, idOperazione, cre)
        return ResponseEntity.ok(iCom)
    }
}