package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.EInvioProtocollo
import it.finmatica.de4gsdzk.utils.EModalita
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name="PARAMETRI_PROTOCOLLO_V_CIV")
class CivParametroProtocollo extends GsdBaseDomain{

    @Id Long id

    @Column(nullable=false) String fase

    @Column(nullable=false) String funzione

    @Column(nullable=true) String tipoDocumento

    @Column @Enumerated(EnumType.STRING) EModalita modalita

    @Column String classificazione

    @Column String numeroFascicolo

    @Column Integer annoFascicolo

    @Column(name="NUMERO_PREC") Integer numeroPrecedente

    @Column(name="ANNO_PREC") Integer annoPrecedente

    @Column String destinatario

    @Column @Enumerated(EnumType.STRING) EInvioProtocollo invioProtocollo

    @Convert(converter=BooleanToStringConverter.class)
    @Column Boolean flagWorkflow

    @Convert(converter=BooleanToStringConverter.class)
    @Column Boolean flagDocumentale

    @Convert(converter=BooleanToStringConverter.class)
    @Column Boolean flagAlboPretorio

    @Column(name="COD_FASE", updatable = false, insertable = false)
    String codiceFase

    @Column(name="DES_FASE", updatable = false, insertable = false)
    String descrizioneFase

    @Column(name="COD_TIPO_ATTO_CIV", updatable = false, insertable = false)
    String codiceTipoAtto

    @Column(name="DES_TIPO_ATTO_CIV", updatable = false, insertable = false)
    String descrizioneTipoAtto

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="CODICE_CO_CIV", updatable = false, insertable = false)
    CivComunicazione comunicazione

    ////////////////////////////////////////////////////////////////////////
    ///////////////////////////////// GENERALI /////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [
            Etichette.Funzione, Etichette.Riferimento,
            Etichette.Tipo_Documento, Etichette.Modalita, Etichette.Invio,
            Etichette.Classificazione, Etichette.Numero_Fascicolo, Etichette.Anno_Fascicolo,
            Etichette.Documentale, Etichette.Albo_Pretorio, Etichette.Comunicazione
    ]

}
