package it.finmatica.de4gsdzk.anagrafe.pratiche

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.anagrafe.AnaCodiceEvento
import it.finmatica.de4gsdzk.anagrafe.ETipoAnagrafe
import it.finmatica.de4gsdzk.utils.ETipoPratica

import javax.persistence.*

@Entity
@Table(name = "ANADCE_V")
class AnaVariazione {

    @Id
    @Column(name = "CODICE")
    Integer id

    @Convert(converter = ETipoAnagrafe.EnumTipoAnagrafeToStringConverter.class)
    @Column(name ="ANAGRAFE")
    ETipoAnagrafe anagrafe

    @Convert(converter = ETipoPratica.EnumTipoPraticaToStringConverter.class)
    @Column(name ="TIPO_EVENTO")
    ETipoPratica tipoPratica

    @Column(name ="COD_VARIAZIONE")
    String codiceVariazione

    @Column(name ="DESCRIZIONE")
    String descrizione

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_TPR", nullable = true)
    Boolean flagTpr

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_APR4", nullable = true)
    Boolean flagApr4

    @Column(name ="TIPO_EVENTO_TPR")
    String codiceVariazioneTpr

    @Column(name ="TIPO_EVENTO_ISTAT")
    String tipoEventoIstat

    @Column(name ="TIPO_RICHIESTA_APR4")
    String tipoRichiestaDefault

    @Column(name ="RICHIESTA_APR4")
    Integer codiceRichiestaDefault

    @Column(name ="PROVVEDIMENTO_APR4")
    Integer codiceProvvedimentoDefault

    @Column(name ="MOTIVO_APR4")
    String motivoDefault

    @Column(name ="DES_EVENTO_TPR")
    String descrizioneTpr

    @Column(name ="SEQ_EVENTO_TPR")
    Integer sequenzaEventoTpr

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "COD_EVE")
    AnaCodiceEvento evento

    @Column(name ="COD_MOV")
    Integer codiceMovimento

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_PRELIMINARE", nullable = true, updatable = false, insertable = false)
    Boolean flagPreliminare

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_REIMMIGRAZIONE_AIRE", nullable = true, updatable = false, insertable = false)
    Boolean flagReimmigrazioneAire


}
