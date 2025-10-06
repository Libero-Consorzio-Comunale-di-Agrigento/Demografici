package it.finmatica.de4gsdzk.utils

enum ETipoImage {

    BMP("bmp", "image/bmp"),
    MSBMP("bmp", "image/x-ms-bmp"),
    JPG("jpg", "image/jpg"),
    JPEG("jpeg", "image/jpeg"),
    PNG("png", "image/png"),
    TIF("tif", "image/tif"),
    TIFF("tiff", "image/tiff")

    final String estensione
    final String contentType

    private ETipoImage(String estensione, String contentType) {
        this.estensione = estensione
        this.contentType = contentType
    }

}