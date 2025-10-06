package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.ETipoComunicazione
import it.finmatica.de4gsdzk.utils.ETipoSN
import it.finmatica.de4gsdzk.utils.Etichette
import org.hibernate.annotations.Formula
import org.hibernate.annotations.Type

import javax.persistence.*

@Entity
@Table(name = "CIVDCO")
class CivComunicazione extends GsdBaseDomain{

    @Id
    @Column(name = "CODICE_CO")
    Integer id

    @Column(name = "DESCRIZIONE")
    String descrizione

    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_COMUNICAZIONE", nullable = false)
    ETipoComunicazione tipoComunicazione

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_ATTO_ALLEGATO", nullable = true)
    Boolean attoAllegato

    @Enumerated(EnumType.STRING)
    @Column(name = "FLAG_PRIORITA", nullable = true)
    private ETipoSN prioritaDb

    @Formula("CASE WHEN COALESCE(FLAG_PRIORITA, 'N') = 'N' THEN 0 ELSE 1 END")
    @Type(type="numeric_boolean")
    private Boolean priorita

    Boolean getPriorita() {
        return this.priorita
    }

    void setPriorita(Boolean val) {
        this.priorita = val
        this.prioritaDb = (val? ETipoSN.S: null)
    }

    @Formula("CONCAT(CODICE_CO, CONCAT(' - ', DESCRIZIONE))")
    String descrizioneEstesa

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Codice, Etichette.Descrizione, Etichette.Tipo_Comunicazione, Etichette.Adempimenti]

}
