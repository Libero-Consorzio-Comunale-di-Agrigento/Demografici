package it.finmatica.de4gsdzk.export

import groovy.util.logging.Slf4j
import net.sf.jasperreports.engine.JRPrintElement
import net.sf.jasperreports.engine.JRPrintImage
import net.sf.jasperreports.engine.JRPrintPage
import net.sf.jasperreports.engine.JasperPrint
import net.sf.jasperreports.engine.export.JRPdfExporter
import net.sf.jasperreports.export.SimpleExporterInput
import net.sf.jasperreports.export.SimpleOutputStreamExporterOutput

/**
 * Classe di utilità per l'esportazione di un report in PDF
 */
@Slf4j
class JasperExporter extends Thread {

    private JasperPrint print

    private PipedOutputStream out

    private PipedInputStream exportStream

    private Listener listener

    static interface Listener extends EventListener {
        void onFinishReport()
    }

    JasperExporter(JasperPrint print, Listener listener=null) {
        this.print = print
        out = new PipedOutputStream()
        exportStream = new PipedInputStream(out)
        setDaemon(true)
        this.listener = listener
    }

    /**
     * Modifica una stampa creando un'impaginazione a specchio tra pagine dispari e pagine pari.
     *
     * Gli oggetti di primo livello vengono specchiati sulle pagine pari
     * (o dispari se il flag mirrorStart è impostato a 1)
     *
     * @param start 0 (default) oppure 1 se comincia a specchiare il layout già dalla prima pagina
     *  (specchia le pagine dispari)
     * @param columnCount specchia su più colonne (di default 1)
     */
    void mirror(int start = 0, boolean onlyMargins = false, List<Map> mirrorExcluded=[]) {
        int pag = 0
        int width = print.getPageWidth()-1
        for (JRPrintPage page : print.getPages()) {
            //specchia le pagine pari se start=0, dispari se =1
            if (++pag % 2 == start) {
                for (JRPrintElement element : page.getElements()) {
                    if ( (!(mirrorExcluded?.isEmpty())) && element instanceof JRPrintImage && mirrorExcluded*.get("tipo").contains("image") ) {
                        Map c = mirrorExcluded.find { t -> t.tipo == "image"}
                        element.setX(element.getX() + (pag % 2 == start?(c.delta?:0):0) )
                        continue
                    }
                    element.setX(onlyMargins
                            ? element.getX() + print.getRightMargin() - print.getLeftMargin()
                            : width - element.getX() - element.getWidth())
                }
            }
        }
    }

    /**
     * @return il numero totale di pagine del report
     */
    int getPages() {
        print.getPages().size()
    }

    /**
     * Fa partire il processo di export
     * @return l'{@link InputStream}
     */
    InputStream exportStream() {
        start()
        return exportStream
    }

    void run() {
        try {
            JRPdfExporter exporter = new JRPdfExporter()
            exporter.setExporterInput(new SimpleExporterInput(print))
            exporter.setExporterOutput(new SimpleOutputStreamExporterOutput(out))
            exporter.exportReport()
        } catch(Exception e) {
            log.error("Errore stampa jasper", e)
        } finally {
            out.close()
            try {
                if (listener) listener.onFinishReport()
            } catch(Throwable t) {
                log.error("Errore finalizzazione report", t)
            }
        }
    }

}