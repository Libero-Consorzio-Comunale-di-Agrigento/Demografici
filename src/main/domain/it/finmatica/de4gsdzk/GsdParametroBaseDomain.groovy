package it.finmatica.de4gsdzk

import org.hibernate.annotations.Formula

import javax.persistence.Column
import javax.persistence.Convert
import javax.persistence.Id
import javax.persistence.Lob
import javax.persistence.MappedSuperclass

@MappedSuperclass
abstract class GsdParametroBaseDomain extends GsdBaseDomain{

    @Id
    @Column(name = "PARAMETRO")
    private String id

    String getId() {
        return id
    }

    void setId(String val) {
        this.id = (val?.toUpperCase())
    }

    @Column(name = "DESCRIZIONE")
    String descrizione

    @Column(name = "VALORE", nullable = true)
    String valore

    @Formula("CONCAT(PARAMETRO, CONCAT(CASE WHEN DESCRIZIONE IS NULL THEN '' ELSE ' - ' END, COALESCE(DESCRIZIONE, '')))")
    String descrizioneEstesa

    @Column(name = "ALLEGATO_BLOB", nullable = true)
    @Lob
    byte[] blobAllegato

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_VISIBILE", nullable = true)
    Boolean flagVisibile
}
