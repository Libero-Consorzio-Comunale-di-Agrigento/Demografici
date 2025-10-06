package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.ansc.AnscTipoAllegato
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.TipoAttoUtils
import org.hibernate.annotations.Formula
import org.hibernate.annotations.Type

import javax.persistence.*

@Entity
@Table(name = "CIVDDO")
class CivTipoDocumentoFascicolo extends GsdBaseDomain{

    @Id
    @Column(name = "ID")
    Long id

    @Column(name = "TIPO_ATTO", nullable = false)
    Integer tipoAtto

    @Column(name = "COD_DO", nullable = false)
    private String codice

    String getCodice() {
        return codice
    }

    void setCodice(String codice) {
        this.codice = codice?.toUpperCase()
    }

    @Column(name = "DESCRIZIONE", nullable = true)
    private String descrizione

    String getDescrizione() {
        return descrizione
    }

    void setDescrizione(String descrizione) {
        this.descrizione = descrizione?.toUpperCase()
    }

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_PVU", nullable = true)
    Boolean isProcessoVerbale

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_RICORRENTE", nullable = true)
    Boolean flagRicorrente

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="CODICE_ANSC", nullable = true)
    AnscTipoAllegato tipoAllegatoANSC

    @Formula("CASE WHEN CODICE_ANSC IS NULL THEN 0 ELSE 1 END")
    @Type(type="numeric_boolean")
    Boolean validoPerANSC

    @Version
    Long version

    ETipoAtto getTipoAttoEnum(){
        return TipoAttoUtils.fromValoreDefault(this.tipoAtto.intValue())
    }

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Tipo_Documento, Etichette.Codice, Etichette.Tipo_Atto, Etichette.Valido_ANSC,
                                              Etichette.Descrizione, Etichette.Ricorrente, Etichette.Tipo_Documento_Fascicolo]

}
