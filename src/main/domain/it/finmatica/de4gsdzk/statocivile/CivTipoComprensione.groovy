package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.ansc.AnscTipoComprensione

import javax.persistence.*

@Entity
@Table(name = "CIVDCD")
class CivTipoComprensione extends GsdBaseDomain{

    @Id
    @Column(name = "COD_CD")
    String id

    void setId(String val) {
        this.id = val
    }

    @Column(name = "DESCRIZIONE")
    String descrizione

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_MOTIVAZIONE", nullable = true)
    Boolean flagMotivazioneImpedimento

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="CODICE_ANSC", nullable = true)
    AnscTipoComprensione tipoComprensioneANSC
}

