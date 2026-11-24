package it.finmatica.de4gsdzk.utils

enum ETipoFile {

    PDF("pdf", "application/pdf"),
    PDF_A("pdf", "application/pdf"),
    P7M("p7m", "application/x-pkcs7-mime"),
    P7S("p7s", "application/pkcs7-signature"),
    ODT("odt", "application/vnd.oasis.opendocument.text"),
    DOC("doc", "application/msword"),
    DOCX("docx", "application/vnd.openxmlformats-officedocument.wordprocessingml.document"),
    ZIP("zip", "application/zip"),
    // in uso in gsd
    XLS("xls", "application/vnd.ms-excel"),
    CSV("csv", "text/csv"),
    XML("xml", "application/xml"),
    TXT("txt", "text/plain"),
    P12("p12", "application/x-pkcs12")

    final String estensione
    final String contentType

    private ETipoFile(String estensione, String contentType) {
        this.estensione = estensione
        this.contentType = contentType
    }

}