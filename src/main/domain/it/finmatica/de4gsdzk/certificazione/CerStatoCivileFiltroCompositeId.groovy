package it.finmatica.de4gsdzk.certificazione

class CerStatoCivileFiltroCompositeId implements Serializable {

    Integer tipoArchivio
    Long id
    CerFiltro filtro

    @Override
    boolean equals(Object obj) {
        if (this == obj) return true
        if (obj == null || getClass() != obj.getClass()) return false
        CerStatoCivileFiltroCompositeId entity = (CerStatoCivileFiltroCompositeId) obj
        return Objects.equals(this.tipoArchivio, entity.tipoArchivio) &&
                Objects.equals(this.id, entity.id) &&
                Objects.equals(this.filtro, entity.filtro)
    }

    @Override
    int hashCode() {
        return Objects.hash(tipoArchivio, id)
    }

}