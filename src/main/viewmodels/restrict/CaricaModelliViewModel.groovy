package restrict

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CaricaModelliService
import it.finmatica.de4gsdzk.GsdMenuDitta
import it.finmatica.de4gsdzk.GsdMenuDittaService
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver

import javax.servlet.ServletContext

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class CaricaModelliViewModel {

    String count, total
    String countDAT, totalDAT
    String countEti, totalEti

    @WireVariable
    CaricaModelliService caricaModelliService

    @WireVariable
    GsdMenuDittaService gsdMenuDittaService

    @WireVariable
    ServletContext servletContext

    @Init init() {
        GsdMenuDitta md = gsdMenuDittaService.getUniqueRecord()

        // Modelli comunicazioni
        String pathBase = "/WEB-INF/modelli/comunicazioni"
        String subDirDefault = File.separator + "default"
        String subDir = ""
        if ( (md != null) && (md?.id != null) ){
            subDir+= File.separator + md.id
        }
        File[] files = getDirFiles(pathBase + (subDir?:subDirDefault))
        if (files?.length > 0){
            count = caricaModelliService.caricaModelliComunicazioni(files)
            total = files?files.length:0
        } else {
            File[] filesDefault = getDirFiles(pathBase + subDirDefault)
            count = caricaModelliService.caricaModelliComunicazioni(filesDefault)
            total = filesDefault?filesDefault.length:0
        }

        // Modelli DAT
        File[] filesDAT = getDirFiles("/WEB-INF/modelli/DAT")
        countDAT = caricaModelliService.caricaModelliDAT(filesDAT)
        totalDAT = filesDAT?filesDAT.length:0

        // Modello etichetta (verticale)
        File[] filesEti = getDirFiles("/WEB-INF/modelli/etichette")
        countEti = caricaModelliService.caricaModelloEtichetta(filesEti)
        totalEti = filesEti?filesEti.length:0

        // Modelli tipo certificato
        String pathBaseTc = "/WEB-INF/modelli/tipi_certificato"
        String subDirDefaultTc = File.separator + "default"
        String subDirTc = ""
        if ((md != null) && (md?.id != null)) {
            subDirTc += File.separator + md.id
        }
        File[] filesTc = getDirFiles(pathBaseTc + (subDirTc ?: subDirDefaultTc))
        if (filesTc?.length > 0) {
            count = caricaModelliService.caricaModelliTipoCertificato(filesTc)
            total = filesTc ? filesTc.length : 0
        } else {
            File[] filesDefaultTc = getDirFiles(pathBaseTc + subDirDefaultTc)
            count = caricaModelliService.caricaModelliTipoCertificato(filesDefaultTc)
            total = filesDefaultTc ? filesDefaultTc.length : 0
        }
    }

    File[] getDirFiles(String relativePath){
        File dir = new File(servletContext.getRealPath(relativePath))
        File[] files = dir.listFiles()
        return files
    }

}
