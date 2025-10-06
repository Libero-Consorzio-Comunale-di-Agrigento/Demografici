package it.finmatica.de4gsdzk.export

class ExportField {

    private final String campo
    private final String etichetta
    private final String tipo
    private final Closure exportClosure

    ExportField(String campo, String etichetta = campo, String tipo = ExportUtils.STRING_FORMAT, Closure exportClosure = null){
        this.campo = campo
        this.etichetta = etichetta
        this.tipo = tipo
        this.exportClosure = exportClosure
    }

    String getCampo() {
        return campo
    }

    String getEtichetta() {
        return etichetta
    }

    String getTipo() {
        return tipo
    }

    Closure getExportClosure() {
        return exportClosure
    }

}
