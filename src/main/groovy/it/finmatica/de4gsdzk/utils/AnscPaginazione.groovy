package it.finmatica.de4gsdzk.utils

class AnscPaginazione implements IAnscPaginazione {
    private numeroPagina
    private numeroRecordPagina
    private numeroRecordTotali

    AnscPaginazione(Integer numeroPagina, Integer numeroRecordPagina, Integer numeroRecordTotali) {
        this.numeroPagina = numeroPagina
        this.numeroRecordPagina = numeroRecordPagina
        this.numeroRecordTotali = numeroRecordTotali
    }

    @Override
    Integer getNumeroPagina() {
        return numeroPagina
    }

    @Override
    Integer getNumeroRecordPagina() {
        return numeroRecordPagina
    }

    @Override
    Integer getNumeroRecordTotali() {
        return numeroRecordTotali
    }
}
