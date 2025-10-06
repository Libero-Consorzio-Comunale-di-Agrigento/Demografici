package it.finmatica.de4gsdzk.export

class ReportExportResult {

    private final int pages
    private int errorCode = -1

    ReportExportResult(int pages){
        this.pages = pages
    }

    int getPages() {
        return pages
    }

    int getErrorCode() {
        return errorCode
    }

    void setErrorCode(int errorCode) {
        this.errorCode = errorCode
    }
}
