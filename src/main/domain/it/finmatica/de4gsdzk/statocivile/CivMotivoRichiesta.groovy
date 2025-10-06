package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.ETipoRichiesta
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.TipoAttoUtils

import javax.persistence.*

@Entity
@Table(name = "CIVDMC_V")
class CivMotivoRichiesta extends GsdBaseDomain{

    @Id
    @Column(name = "ID")
    Long id

    @Column(name = "DESCRIZIONE", nullable = false)
    String descrizione

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_DOCUMENTO_IDENTITA", nullable = true)
    Boolean flagDocumentoIdentita

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_PUBBLICO_IMPIEGO", nullable = true)
    Boolean flagPubblicoImpiego

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_ASCENDENTE", nullable = true)
    Boolean flagAscendente

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_RICORRENTE", nullable = true)
    Boolean flagRicorrente

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_RICONOSCIMENTO", nullable = true)
    Boolean flagRiconoscimento

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_ESTREMI_RICONOSCIMENTO", nullable = true)
    Boolean flagEstremiRiconoscimento

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_PADRE", nullable = true)
    Boolean flagPadre

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_MADRE", nullable = true)
    Boolean flagMadre

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_ENTE_ESTERO", nullable = true)
    Boolean flagEnteEstero

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_RESIDENZA", nullable = true)
    Boolean flagResidenza

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_ACCERTAMENTO", nullable = true)
    Boolean flagAccertamento

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_AUTORITA", nullable = true)
    Boolean flagAutorita

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_AUTORITA_ESTREMI", nullable = true)
    Boolean flagAutoritaEstremi

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_DATA_TRASCRIZIONE_OBBL", nullable = true)
    Boolean flagDataTrascrizioneMandatory

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_ESTREMI_GIURAMENTO", nullable = true)
    Boolean flagEstremiGiuramento

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_CONSOLATO", nullable = true)
    Boolean flagConsolato

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_CAMBIO_GENERALITA", nullable = true)
    Boolean flagCambioGeneralita

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_CAMBIO_GENERALITA_OBBL", nullable = true)
    Boolean flagCambioGeneralitaMandatory

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_MINORE", nullable = true)
    Boolean flagMinore

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_ANNOTAZIONE", nullable = true)
    Boolean flagAnnotazione

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_ESTREMI_ATTO_NASCITA", nullable = true)
    Boolean flagEstremiAttoNascita

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_TIPO_RICHIESTA_TRAS", nullable = true)
    Boolean flagTipoRichiestaTrascrizione

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_TIPO_RICHIESTA_TRAS_OBBL", nullable = true)
    Boolean flagTipoRichiestaTrascrizioneMandatory

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_NAZ_PADRE_MADRE_OBBL", nullable = true)
    Boolean flagNazionalitaPadreMadreMandatory

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="ID_CIVCTA", nullable = true)
    CivCategoriaTipoAtto categoriaDomain

    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_RICHIESTA", nullable=true)
    ETipoRichiesta tipoRichiesta

    @Column(name = "DESCRIZIONE_USECASE", nullable = true, updatable = false, insertable = false)
    String descrizioneUseCase

    @Column(name = "TIPO_ATTO", nullable = false, updatable = false, insertable = false)
    Integer tipoAtto

    ETipoAtto getTipoAttoEnum() {
        return TipoAttoUtils.fromValoreDefault(this.tipoAtto.intValue())
    }

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Codice, Etichette.Tipo, Etichette.Documento_riconoscimento, Etichette.Documentazione_PU,
                                              Etichette.Descrizione, Etichette.Ricorrente, Etichette.Estremi_riconoscimento, Etichette.Caso_Uso_Ansc]

}

