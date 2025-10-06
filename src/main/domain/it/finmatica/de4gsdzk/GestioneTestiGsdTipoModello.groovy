package it.finmatica.de4gsdzk

import groovy.transform.CompileStatic
import org.hibernate.annotations.CreationTimestamp
import org.hibernate.annotations.Type
import org.hibernate.annotations.UpdateTimestamp

import javax.persistence.*

@Entity
@Table(name = "GTE_TIPI_MODELLO")
@CompileStatic
class GestioneTestiGsdTipoModello {

    static final String TIPO_ETICHETTA_ANNOTAZIONE = "ETI_ANN"

    @Id
    String codice

    @Version
    Long version

    @CreationTimestamp
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "DATA_INS", nullable = false)
    Date dateCreated

    @Column(nullable = false)
    String descrizione

    @UpdateTimestamp
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "DATA_UPD", nullable = false)
    Date lastUpdated

    @Column(nullable = false)
    @Lob
    byte[] query

    @Column(name = "UTENTE_INS", nullable = false)
    String utenteIns

    @Column(name = "UTENTE_UPD", nullable = false)
    String utenteUpd

    @Type(type = "yes_no")
    @Column(nullable = false)
    boolean valido

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "VALIDO_AL")
    Date validoAl

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "VALIDO_DAL", nullable = false)
    Date validoDal

    String getId() {
        return codice
    }

    @PreUpdate
    void preUpdate() {
        validoAl = valido ? null : (validoAl ?: new Date())
    }

    @PrePersist
    void preInsert() {
        validoAl = valido ? null : (validoAl ?: new Date())
        validoDal = validoDal ?: new Date()
    }
}
