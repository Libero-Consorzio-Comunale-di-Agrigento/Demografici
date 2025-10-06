package it.finmatica.de4gsdzk.utils

import spock.lang.Specification

import java.util.zip.ZipEntry
import java.util.zip.ZipInputStream

class ZipUtilsSpec extends Specification {

    def "zipFiles correctly compresses a list of VirtualFile objects into a ZIP archive"() {
        given: "A list of VirtualFile objects with known content as InputStreams"
        def file1 = new ZipUtils.VirtualFile("file1.txt", new ByteArrayInputStream("Hello World".getBytes("UTF-8")))
        def file2 = new ZipUtils.VirtualFile("file2.txt", new ByteArrayInputStream("Spock and Groovy".getBytes("UTF-8")))
        def files = [file1, file2]

        when: "The zipFiles method is called"
        byte[] zipData = ZipUtils.zipFiles(files)

        then: "The returned byte array represents a valid ZIP archive containing the expected files"
        zipData.length > 0

        and: "The ZIP archive contains the correct files with their respective contents"
        def foundFiles = [:]
        ZipInputStream zis = new ZipInputStream(new ByteArrayInputStream(zipData))

        try {
            ZipEntry entry
            while ((entry = zis.nextEntry) != null) {
                ByteArrayOutputStream baos = new ByteArrayOutputStream()
                byte[] buffer = new byte[1024]
                int bytesRead
                while ((bytesRead = zis.read(buffer)) != -1) {
                    baos.write(buffer, 0, bytesRead)
                }
                foundFiles[entry.name] = new String(baos.toByteArray(), "UTF-8")
            }
        } finally {
            zis.close()
        }

        foundFiles.size() == 2
        foundFiles["file1.txt"] == "Hello World"
        foundFiles["file2.txt"] == "Spock and Groovy"
    }
}
