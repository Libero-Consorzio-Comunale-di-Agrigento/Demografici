package it.finmatica.de4gsdzk.archivi

import it.finmatica.ad4.autenticazione.Ad4Utente
import it.finmatica.ad4.hibernate.UtenteUpd
import it.finmatica.de4gsdzk.GsdBaseDomain

import javax.persistence.*

@Entity
@Table(name = "ARCDNC_V")
class ArcDatiNumerazioneCivico extends GsdBaseDomain {

    @Id
    @Column(name = "ID")
    Long id

    @Column(name = "ELEMENTO", length = 20)
    String elemento

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_ESTERNO", nullable = true)
    Boolean flagEsterno

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_INTERNO", nullable = true)
    Boolean flagInterno

    @Column(name = "SEQUENZA", precision = 2)
    Integer sequenza

    @Column(name = "SEPARATORE", length = 10)
    String separatore

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_VISIBILE", nullable = true)
    Boolean flagVisibile

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "COD_VIA", nullable = true)
    ArcVia via

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_DEFAULT", nullable = true)
    Boolean flagDefault

    @Version
    Long version

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "D_DATA_ULT_AGG")
    Date dataUltimoAggiornamento

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TERMINALISTA", nullable = true)
    @UtenteUpd
    Ad4Utente terminalista

    @Column(name = "WIDTH_ELEMENTO", insertable = false, updatable = false)
    Integer widthElemento

    private static final Set<String> NUMERICI = ['NUM_CIV', 'INTERNO', 'INTERNO2'] as Set
    private static final Set<String> UPPERCASE = ['SUFFISSO', 'SCALA_ESTERNA', 'SCALA', 'PIANO'] as Set

    boolean isFlag() {
        return elemento?.startsWith("FLAG_")
    }

    boolean isNumerico() {
        return elemento in NUMERICI
    }

    String getStyleUppercase() {
        return (elemento in UPPERCASE) ? 'text-transform:uppercase' : ''
    }

    String getProprieta() {
        return snakeToCamel(elemento)
    }

    static String snakeToCamel(String input) {
        if (!input) return null
        input.toLowerCase().replaceAll(/_([a-z0-9])/) { it[1].toUpperCase() }
    }

    @Override
    boolean equals(Object obj) {
        if (this.is(obj)) return true
        if (obj == null || getClass() != obj.getClass()) return false
        ArcDatiNumerazioneCivico that = (ArcDatiNumerazioneCivico) obj
        return id == that.id
    }

    @Override
    int hashCode() {
        return id != null ? id.hashCode() : 0
    }

    @Override
    String toString() {
        return "ArcDatiNumerazioneCivico{" +
                "id=" + id +
                ", elemento='" + elemento + '\'' +
                ", flagEsterno=" + flagEsterno +
                ", flagInterno=" + flagInterno +
                ", sequenza=" + sequenza +
                '}'
    }
}
