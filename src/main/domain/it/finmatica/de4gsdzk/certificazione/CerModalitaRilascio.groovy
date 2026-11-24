package it.finmatica.de4gsdzk.certificazione

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.ETipoSiNo
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "CERDRI_V")
class CerModalitaRilascio extends GsdBaseDomain {

    @Id
    @Column(name = "COD_RI")
    Integer id

    @Column(name = "DESCRIZIONE_1", nullable = false)
    String descrizione

    @Column(name = "DESCRIZIONE_ESTESA", nullable = true, updatable = false, insertable = false)
    String descrizioneEstesa

    @Column(name = "DESCR_STAMPA_1", nullable = false)
    String descrizioneStampa

    @Enumerated(EnumType.STRING)
    @Column(name = "ESENZIONE_DIRITTI", nullable = true)
    ETipoSiNo esenzioneDiritti

    @Column(name = "FASCIA_TARIFFARIA")
    Integer fasciaTariffaria

    Boolean isInBollo() {
        return fasciaTariffaria != null
    }

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_ON_LINE", nullable = true)
    Boolean flagOnLine

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_CERCTC", nullable = true)
    CerCategoriaTipoCertificato categoriaTipoCertificato

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="CODICE_ANPR", nullable = false)
    CerMotivoEsenzioneBolloBaseDomain motivoEsenzioneBollo

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_DISMESSO", nullable = true)
    Boolean flagDismesso

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_USO_INTERNO", insertable = false, updatable = false)
    Boolean flagUsoInterno

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_DESCR_STAMPA_LIBERA", nullable = true)
    Boolean flagModalitaStampaLibera

    Boolean isModalitaStampaLiberaAttiva() {
        return flagModalitaStampaLibera == Boolean.TRUE
    }

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Codice"), Etichette.getEtichetta("Descrizione"), Etichette.getEtichetta("Descrizione_stampa"), Etichette.getEtichetta("Categoria_Tipo_Certificato"),
                                              Etichette.getEtichetta("Esenzione_diritti"), Etichette.getEtichetta("Pagamento_bollo"), Etichette.getEtichetta("Fascia_tariffaria_Bollo"), Etichette.getEtichetta("Uso"),
                                              Etichette.getEtichetta("Specifica_Esenzione_Libera"), Etichette.getEtichetta("Dismesso"), Etichette.getEtichetta("Uso_interno")]
}
