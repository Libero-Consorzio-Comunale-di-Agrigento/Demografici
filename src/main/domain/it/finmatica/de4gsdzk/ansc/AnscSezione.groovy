package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.GsdBaseDomain

import javax.persistence.*

@Entity
@Table(name = "ANSJSN_SEZIONI_V")
class AnscSezione extends GsdBaseDomain{

    @Id
    @Column(name = "ID")
    Long id

    //FIXME FK
    @Column(name = "SERVIZIO", nullable = true)
    String servizio

    @Column(name = "TIPO_ATTO", nullable = false)
    Integer tipoAtto

    @Column(name = "SEZIONE", nullable = false)
    String nomeSezione

    @Column(name = "LIVELLO", nullable = false)
    Integer livello

    @Column(name = "SEQUENZA", nullable = false)
    Integer sequenza

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_PADRE", nullable = true)
    AnscSezione sezionePadre

    @Column(name = "VISTA_DB", nullable = true)
    String vista

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_ARRAY", nullable = true)
    Boolean isArray

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_ESISTE_CAMPO", nullable = true)
    Boolean hasCampi

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_OTP_FIRMA", nullable = true)
    Boolean flagOtpFirma

    @Column(name = "PARAMETRO_VISTA_DB", nullable = true)
    String parametro

    @Column(name = "CAMPO_DB", nullable = true)
    String campoDb

    @Column(name = "USECASES_ESCLUSI", nullable = true)
    String useCasesEsclusi

    @Column(name = "USECASE", nullable = true)
    Long useCase

}

