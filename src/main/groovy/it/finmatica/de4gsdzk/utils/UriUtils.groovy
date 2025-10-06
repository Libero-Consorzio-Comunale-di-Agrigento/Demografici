package it.finmatica.de4gsdzk.utils

import groovy.util.logging.Slf4j
import org.zkoss.zk.ui.Execution
import org.zkoss.zk.ui.Executions

@Slf4j
class UriUtils {

    static URI resolveUri(URI uri) {
        if (uri == null) {
            throw new IllegalArgumentException("URI cannot be null")
        }

        if (uri.isAbsolute()) {
            return uri
        }

        try {
            Execution execution = Executions.getCurrent()
            URI baseUri = new URI(
                    execution.getScheme(),
                    null,
                    execution.getServerName(),
                    execution.getServerPort() == 80 || execution.getServerPort() == 443 ? -1 : execution.getServerPort(),
                    null,  // Base with root path
                    null,
                    null
            )

            if (uri.toString().isEmpty()) {
                String currentPage = execution.getContextPath()
                return baseUri.resolve(currentPage)
            }

            URI relativeUri = new URI(uri.getPath().startsWith("/") ? uri.toString() : "/" + uri.toString())
            return baseUri.resolve(relativeUri).normalize()

        } catch (URISyntaxException ex) {
            log.error("Failed to construct URI: " + uri.toString(), ex)
            throw new IllegalArgumentException("Failed to construct URI: " + uri.toString(), ex)
        }
    }
}
