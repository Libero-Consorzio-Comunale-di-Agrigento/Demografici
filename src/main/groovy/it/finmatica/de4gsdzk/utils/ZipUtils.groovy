package it.finmatica.de4gsdzk.utils

import groovy.util.logging.Slf4j

import java.util.zip.ZipEntry
import java.util.zip.ZipOutputStream

@Slf4j
class ZipUtils {

    /**
     * A simple container for virtual files that hold a filename and its content.
     */
    static class VirtualFile {
        String name
        InputStream inputStream

        VirtualFile(String name, InputStream inputStream) {
            this.name = name
            this.inputStream = inputStream
        }
    }

    /**
     * Compresses the given list of virtual files into a single ZIP archive represented as a byte array.
     *
     * @param files List of VirtualFile objects.
     * @return A byte array representing the ZIP archive.
     * @throws IOException If an I/O error occurs.
     */
    static byte[] zipFiles(List<VirtualFile> files) throws IOException {
        ByteArrayOutputStream baos = new ByteArrayOutputStream()
        ZipOutputStream zos = new ZipOutputStream(baos)
        try {
            for (VirtualFile file : files) {
                try {
                    ZipEntry zipEntry = new ZipEntry(file.name)
                    zos.putNextEntry(zipEntry)

                    byte[] buffer = new byte[1024]
                    int bytesRead
                    while ((bytesRead = file.inputStream.read(buffer)) != -1) {
                        zos.write(buffer, 0, bytesRead)
                    }

                    zos.closeEntry()
                } catch (IOException e) {
                    log.error("Error processing file: ${file.name}", e)
                }
            }
        } catch (IOException e) {
            log.error("Error during zipping process", e)
            throw e
        } finally {
            try {
                zos.close()
            } catch (IOException e) {
                log.error("Error closing ZipOutputStream", e)
            }
        }

        return baos.toByteArray()
    }
}
