package it.finmatica.de4gsdzk.elettorale

import it.finmatica.ad4.autenticazione.Ad4Utente
import it.finmatica.ad4.hibernate.UtenteUpd
import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.ETipoLista
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "ELETIM_V")
class EleTimbro extends GsdBaseDomain{

    @Id
    @Column(name = "ID")
    Long id

    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_LISTA", nullable = false)
    ETipoLista tipoLista

    @Column(name = "TIPO_TIM", nullable = true)
    Integer tipo

    @Column(name = "PROGR_TIM", nullable = true)
    Integer progressivo

    @Column(name = "DESCRIZIONE_TIM", nullable = true)
    String descrizione

    @Column(name = "TESTO_TIM", nullable = true)
    String testo

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_DEFAULT", nullable = true)
    Boolean flagDefault

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_DEFAULT_CODE", nullable = true)
    Boolean flagDefaultCode

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_INTESTAZIONE", nullable = true)
    Boolean flagIntestazione

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_FIRME", nullable = true)
    Boolean flagFirme

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_DEFAULT_ESTRATTO", nullable = true)
    Boolean flagDefaultEstratto

    @Column(name = "DES_TIPO_TIM", nullable = true, updatable = false, insertable = false)
    String descrizioneTipoTimbro

    @Column(name = "DES_PROGR_TIM", nullable = true, updatable = false, insertable = false)
    String descrizioneProgressivo

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TERMINALISTA", nullable = false)
    @UtenteUpd
    Ad4Utente terminalista

    static final List<Map> etichetteDomain = [
            Etichette.getEtichetta("Tipo_Lista"),
            Etichette.getEtichetta("Tipo_Timbro"),
            Etichette.getEtichetta("Progressivo"),
            Etichette.getEtichetta("Descrizione"),
            Etichette.getEtichetta("Liste"),
            Etichette.getEtichetta("Code"),
            Etichette.getEtichetta("Estratti"),
            Etichette.getEtichetta("Testo"),
            Etichette.getEtichetta("Intestazione"),
            Etichette.getEtichetta("Firme")
    ]
}