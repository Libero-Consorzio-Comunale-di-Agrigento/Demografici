package it.finmatica.de4gsdzk.listeners

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CaricaModelliService
import it.finmatica.de4gsdzk.GsdMenuDitta
import it.finmatica.de4gsdzk.GsdMenuDittaService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.context.event.ContextRefreshedEvent
import org.springframework.context.event.EventListener
import org.springframework.stereotype.Component

import javax.servlet.ServletContext

@Slf4j
@Component
class CaricaModelliListener {

    @Autowired
    CaricaModelliService caricaModelliService

    @Autowired
    GsdMenuDittaService gsdMenuDittaService

    @Autowired
    ServletContext servletContext


    @EventListener
    void handleContextRefreshEvent(ContextRefreshedEvent ctxEvt) {
        if (ctxEvt) {
            log.info("Carica modelli da WEB-INF nel DB (on startup)")

            String subDirDefault = File.separator + "default"
            GsdMenuDitta md = gsdMenuDittaService.getUniqueRecord()
            String subDir = ""
            if ( (md != null) && (md?.id != null) ){
                subDir+= File.separator + md.id
            }

            // Modelli comunicazioni
            if (!(caricaModelliService.modelliComunicazioniLoaded())) {
                String pathBase = "/WEB-INF/modelli/comunicazioni"
                File dir = new File(servletContext.getRealPath(pathBase + (subDir ?: subDirDefault)))
                File[] files = dir.listFiles()
                if (files?.length > 0) {
                    caricaModelliService.caricaModelliComunicazioni(files)
                } else {
                    File dirDefault = new File(servletContext.getRealPath(pathBase + subDirDefault))
                    File[] filesDefault = dirDefault.listFiles()
                    caricaModelliService.caricaModelliComunicazioni(filesDefault)
                }
            }

            // Modelli DAT
            if (!(caricaModelliService.modelliDATLoaded())) {
                File dirDAT = new File(servletContext.getRealPath("/WEB-INF/modelli/DAT"))
                caricaModelliService.caricaModelliDAT(dirDAT.listFiles())
            }

            // Modelli Tipo Certificato
            if (!(caricaModelliService.modelliTipoCertificatoLoaded())) {
                String pathBase = "/WEB-INF/modelli/tipi_certificato"
                File dir = new File(servletContext.getRealPath(pathBase + (subDir ?: subDirDefault)))
                File[] files = dir.listFiles()
                if (files?.length > 0) {
                    caricaModelliService.caricaModelliTipoCertificato(files)
                } else {
                    File dirDefault = new File(servletContext.getRealPath(pathBase + subDirDefault))
                    File[] filesDefault = dirDefault.listFiles()
                    caricaModelliService.caricaModelliTipoCertificato(filesDefault)
                }
            }

            // Loghi
            String pathBaseLoghi = "/WEB-INF/loghi"
            File dirLoghi = new File(servletContext.getRealPath(pathBaseLoghi + (subDir?:subDirDefault)) )
            File[] filesLoghi = dirLoghi.listFiles()
            if (filesLoghi?.length > 0){
                caricaModelliService.caricaLoghi(filesLoghi)
            }

            // Modello etichetta
            if (!(caricaModelliService.modelloEtichettaLoaded())) {
                File dirEti = new File(servletContext.getRealPath("/WEB-INF/modelli/etichette"))
                caricaModelliService.caricaModelloEtichetta(dirEti.listFiles())
            }
        }
    }

}
