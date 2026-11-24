package it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "ANADCP_V")
class AnaCondizioneComunicazione extends GsdBaseDomain {

    @Id
    @Column(name = "ID")
    Integer id

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name = "COD_CONDIZIONE", nullable = false)
    AnaCondizioneSql condizioneSql

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="CODICE_CO", nullable = false)
    AnaComunicazione comunicazione

    @Column(name = "DES_CONDIZIONE", nullable = true, updatable = false, insertable = false)
    String descrizioneCondizione

    @Column(name = "TIPO_COMUNICAZIONE", nullable = true, updatable = false, insertable = false)
    String tipoComunicazione


    static final List<Map> etichetteDomain = [
        Etichette.getEtichetta("Codice"),
        Etichette.getEtichetta("Descrizione"),
        Etichette.getEtichetta("Condizione")
    ]

    @Override
    boolean equals(Object obj) {
        if (this.is(obj)) return true
        if (obj == null || getClass() != obj.getClass()) return false
        AnaCondizioneComunicazione that = (AnaCondizioneComunicazione) obj
        return Objects.equals(id, that.id)
    }

    @Override
    int hashCode() {
        return Objects.hash(id)
    }

    @Override
    String toString() {
        return "AnaCondizioneComunicazione{id=${id}, descrizioneCondizione='${descrizioneCondizione}'}"
    }
}