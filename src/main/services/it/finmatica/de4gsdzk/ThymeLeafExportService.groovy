package it.finmatica.de4gsdzk

import org.springframework.stereotype.Service
import org.thymeleaf.context.Context
import org.thymeleaf.spring4.SpringTemplateEngine
import org.thymeleaf.templateresolver.ITemplateResolver

@Service
class ThymeLeafExportService {

    private final ITemplateResolver xmlTemplateResolver
    private final Context xmlContext

    ThymeLeafExportService(ITemplateResolver xmlTemplateResolver, Context xmlContext) {
        this.xmlTemplateResolver = xmlTemplateResolver
        this.xmlContext = xmlContext
    }

    /**
     * Genera un XML con ThymeLeaf usando il template specificato
     *
     * @param templateName il template (file .xml)
     * @param variables (le variabili da sostituire)
     * @return il testo dell'XML generato
     */
    String createXML(String templateName, Map<String, Object> variables) {
        xmlContext.clearVariables()
        for (Map.Entry<String, Object> var : variables)
            xmlContext.setVariable(var.getKey(), var.getValue())

        SpringTemplateEngine engine = new SpringTemplateEngine()
        engine.setTemplateResolver(xmlTemplateResolver)
        return engine.process(templateName, xmlContext)
    }

}
