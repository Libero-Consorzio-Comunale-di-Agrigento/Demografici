package it.finmatica.de4gsdzk.certificazione

import it.finmatica.de4gsdzk.GsdBaseDomain

import javax.persistence.*

@Entity
@Table(name = "CERDTR")
class CerTipoRichiedente extends GsdBaseDomain {

    @Id
    @Column(name = "ID", nullable = false)
    Integer id

    @Column(name = "DESCRIZIONE", nullable = false)
    String descrizione

    @Column(name = "SEQUENZA", nullable = false)
    Integer sequenza

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_VISIBILE", nullable = true)
    Boolean flagVisibile

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_RICHIEDENTE", nullable = true)
    Boolean flagRichiedente

    Boolean isAltroRichiedente() {
        return flagRichiedente ?: Boolean.FALSE
    }

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_AUTORITA", nullable = true)
    Boolean flagAutorita

    // TODO: gestire il tipo richiedente di tipo autorita
    Boolean isAutorita() {
        return flagAutorita ?: Boolean.FALSE
    }

    Boolean isAttivaSezioneEnte() {
        return id == ISTANZA_DI_UFFICIO
    }

    Boolean isIstanzaDiUfficio() {
        return id == ISTANZA_DI_UFFICIO
    }

    public static final Integer ISTANZA_DI_PARTE = 1
    public static final Integer ALTRO_RICHIEDENTE = 2
    public static final Integer ISTANZA_DI_UFFICIO = 3
    public static final Integer ALTRO_ENTE = 4

}
