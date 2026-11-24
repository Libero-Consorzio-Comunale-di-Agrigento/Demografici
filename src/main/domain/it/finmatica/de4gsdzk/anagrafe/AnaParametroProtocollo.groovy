package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaModello
import it.finmatica.de4gsdzk.utils.EInvioProtocollo
import it.finmatica.de4gsdzk.utils.EModalita
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name="PARAMETRI_PROTOCOLLO_V_ANA")
class AnaParametroProtocollo extends GsdBaseDomain{

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

    @Column(name="COD_FASE_ANA", updatable = false, insertable = false)
    String codiceFaseAnagrafe

    @Column(name="DES_FASE_ANA", updatable = false, insertable = false)
    String descrizioneFaseAnagrafe

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="ID_ANAMOD_ANA", updatable = false, insertable = false)
    AnaModello modello

    ////////////////////////////////////////////////////////////////////////
    ///////////////////////////////// GENERALI /////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [
            Etichette.getEtichetta("Funzione"), Etichette.getEtichetta("Riferimento"),
            Etichette.getEtichetta("Tipo_Documento"), Etichette.getEtichetta("Modalita"), Etichette.getEtichetta("Invio"),
            Etichette.getEtichetta("Classificazione"), Etichette.getEtichetta("Numero_Fascicolo"), Etichette.getEtichetta("Anno_Fascicolo"),
            Etichette.getEtichetta("Documentale"), Etichette.getEtichetta("Albo_Pretorio"), Etichette.getEtichetta("Modello")
    ]

    @Override
    boolean equals(Object obj) {
        if (this.is(obj)) return true
        if (obj == null || getClass() != obj.getClass()) return false
        AnaParametroProtocollo that = (AnaParametroProtocollo) obj
        return Objects.equals(id, that.id)
    }

    @Override
    int hashCode() {
        return Objects.hash(id)
    }

    @Override
    String toString() {
        return "AnaParametroProtocollo{id=${id}, fase='${fase}', funzione='${funzione}'}"
    }
}