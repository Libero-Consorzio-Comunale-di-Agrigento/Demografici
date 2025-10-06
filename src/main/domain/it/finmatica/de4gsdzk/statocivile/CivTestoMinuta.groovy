package it.finmatica.de4gsdzk.statocivile

import javax.persistence.*

/**
 * Testo della minuta, ricavato dalla vista anziché dalla tabella CIVISM perché
 * sono obsoleti tutti i record con COD_RIGA diverso da 1.
 */
@Entity
@Table(name = "CIVISM_V")
class CivTestoMinuta {

    @Id
    @Column(name = "ID")
    Long id

    /**
     * Campo ricavabile dalla minuta, non necessario, potrebbe essere rimosso
     */
    @Column(name = "COD_MI", nullable = false)
    Integer codice

    /**
     * Campo ricavabile dalla minuta, non necessario, potrebbe essere rimosso
     */
    @Column(name = "TIPO_ATTO", nullable = false)
    Integer tipoAtto

    @Lob
    @Column(name = "RIGA_CLOB", nullable = false)
    String clob

    /**
     * Relazione 1-1 con la minuta
     */
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_CIVDMI", nullable = false)
    CivMinuta minuta

}
