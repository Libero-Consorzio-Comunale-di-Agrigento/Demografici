package it.finmatica.de4gsdzk

import groovy.util.logging.Slf4j
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

import javax.servlet.ServletContext

@Slf4j
@Transactional
@Service
class AmbienteService {

    private final ServletContext servletContext

    AmbienteService(ServletContext servletContext) {
        this.servletContext = servletContext
    }

    File[] getFilesFromServer(String dirPath){
        File dirOri = new File(servletContext.getRealPath(dirPath))
        return dirOri.listFiles()
    }

}
