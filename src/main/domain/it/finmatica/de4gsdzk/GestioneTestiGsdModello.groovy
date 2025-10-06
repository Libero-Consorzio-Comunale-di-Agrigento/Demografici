package it.finmatica.de4gsdzk

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.utils.EAmbito
import it.finmatica.de4gsdzk.utils.EFormatoTesto
import it.finmatica.de4gsdzk.utils.EGruppo
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.gestionetesti.TipoFile
import org.hibernate.annotations.CreationTimestamp
import org.hibernate.annotations.Type
import org.hibernate.annotations.UpdateTimestamp

import javax.persistence.*

@Entity
@Table(name = "GTE_GSDDMO")
@CompileStatic
class GestioneTestiGsdModello {

    public static final String PREFISSO_MODELLI_STANDARD = "CIVW"
    public static final String PREFISSO_MODELLI_TIPO_CERTIFICATO = "CERW"
    public static final String SUFFISSO_MODELLI_DEFAULT = "_modello"
    public static final String TIPO_MODELLI_DEFAULT = "odt"

    @GeneratedValue
    @Id
    @Column(name = "ID")
    Long id

    @CreationTimestamp
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "DATA_INS", nullable = false)
    Date dateCreated

    @Column(name = "DESCRIZIONE", nullable = true)
    String descrizione

    @Column(name = "FILE_TEMPLATE", nullable = false)
    @Lob
    byte[] fileTemplate

    @UpdateTimestamp
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "DATA_UPD", nullable = false)
    Date lastUpdated

    @Column(nullable = false)
    String codice

    @Column(nullable = false)
    String nome

    @Column(nullable = false)
    String tipo

    @Column @Enumerated(EnumType.STRING)
    EFormatoTesto formatoTesto

    @Enumerated(EnumType.STRING)
    @Column(name = "AMBITO", nullable = false)
    EAmbito ambito

    @Enumerated(EnumType.STRING)
    @Column(name = "GRUPPO", nullable = false)
    EGruppo gruppo

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TIPO_MODELLO", nullable = true)
    GestioneTestiGsdTipoModello tipoModello

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

    @Version
    Long version

    @PreUpdate
    void preUpdate() {
        validoAl = valido ? null : (validoAl ?: new Date())
    }

    @PrePersist
    void preInsert() {
        validoAl = valido ? null : (validoAl ?: new Date())
        validoDal = validoDal ?: new Date()
    }

    String getContentType() {
        return TipoFile.getInstanceByEstensione(tipo).contentType
    }

    String getNomeFile() {
        return (nome + "." + tipo)
    }

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map<String, String>> etichetteDomain = [Etichette.Descrizione, Etichette.Modello, Etichette.Formato_testo]
}
