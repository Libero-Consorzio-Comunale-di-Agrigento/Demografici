package it.finmatica.de4gsdzk.utils

import groovy.transform.CompileStatic

@CompileStatic
class FileInputStreamDeleteOnClose extends InputStream {

    @Delegate
    private InputStream inputStream
    private File file

    FileInputStreamDeleteOnClose(File file) {
        this.file = file
        inputStream = file.newInputStream()
    }

    void close() {
        inputStream.close()
        file.delete()
    }
}