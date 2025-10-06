package it.finmatica.de4gsdzk.utils

import org.springframework.data.domain.Sort

class OrderBy {

    private final String etichetta
    private final List<Sort.Order> campi

    OrderBy(String etichetta, List<Sort.Order> campi) {
        super()
        this.etichetta = etichetta
        this.campi = campi
    }

    String getEtichetta() {
        return etichetta
    }

    List<Sort.Order> getCampi() {
        return campi
    }
}
