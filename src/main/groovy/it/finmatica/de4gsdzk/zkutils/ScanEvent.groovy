package it.finmatica.de4gsdzk.zkutils

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.utils.CustomEvents
import org.zkoss.zk.ui.Component
import org.zkoss.zk.ui.event.Event

@CompileStatic
class ScanEvent extends Event {

    private final InputStream inputStream
    private final String filename
    private final String contentType

    ScanEvent(Component component, InputStream inputStream, String filename, String contentType) {
        super(CustomEvents.ON_SCAN_COMPLETED, component)
        this.filename = filename
        this.contentType = contentType
        this.inputStream = inputStream
    }

    InputStream getInputStream() {
        return inputStream
    }

    String getFilename() {
        return filename
    }

    String getContentType() {
        return contentType
    }
}
