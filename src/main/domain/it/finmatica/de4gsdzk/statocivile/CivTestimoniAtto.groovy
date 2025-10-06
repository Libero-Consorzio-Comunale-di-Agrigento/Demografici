package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.statocivile.embed.Testimone
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "CIVTTA_V", uniqueConstraints = @UniqueConstraint(columnNames=["TIPO_ATTO", "UFFICIO", "ANNO", "PARTE", "SERIE", "ATTO"]))
class CivTestimoniAtto {

    @Id
    @Column(name = "ID")
    Long id

    @Column(name = "ID_ATTO", nullable = false)
    String idAtto

    @Column(name = "TIPO_ATTO", nullable = false)
    Integer tipoAtto

    @Column(name = "UFFICIO", nullable = true)
    Integer ufficio

    @Column(name = "ANNO", nullable = true)
    Integer anno

    @Column(name = "ATTO", nullable = false)
    Integer atto

    @Column(name = "PARTE", nullable = true)
    Integer parte

    @Column(name = "SERIE", nullable = true)
    String serie

    @Column(name = "NUMERO_TESTIMONI", nullable = true)
    Integer numeroTestimoni

    ////////////////////////////////////////////////////////////////////////
    //////////////////////////// TESTIMONE 1 ///////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    String getCognomeTestimone1() {
        return testimone1?.cognome
    }

    void setCognomeTestimone1(String c) {
        this.testimone1?.cognome = c
    }

    String getNomeTestimone1() {
        return testimone1?.nome
    }

    void setNomeTestimone1(String n) {
        this.testimone1?.nome = n
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "nome", column = @Column(name="NOME_1")),
            @AttributeOverride(name = "cognome", column = @Column(name="COGNOME_1")),
            @AttributeOverride(name = "sesso", column = @Column(name="SESSO_1")),
            @AttributeOverride(name = "dataNascita", column = @Column(name="D_DATA_NAS_1")),
            @AttributeOverride(name = "comuneNascita.codice", column = @Column(name="COD_COM_NAS_1")),
            @AttributeOverride(name = "comuneNascita.descrizione", column = @Column(name="DES_COM_NAS_1", updatable = false, insertable = false)),
            @AttributeOverride(name = "comuneNascita.codiceProvincia", column = @Column(name="COD_PRO_NAS_1")),
            @AttributeOverride(name = "comuneNascita.siglaProvincia", column = @Column(name="SIGLA_PRO_NAS_1", updatable = false, insertable = false)),
            @AttributeOverride(name = "comuneResidenza.codice", column = @Column(name="COD_COM_RES_1")),
            @AttributeOverride(name = "comuneResidenza.descrizione", column = @Column(name="DES_COM_RES_1", updatable = false, insertable = false)),
            @AttributeOverride(name = "comuneResidenza.codiceProvincia", column = @Column(name="COD_PRO_RES_1")),
            @AttributeOverride(name = "comuneResidenza.siglaProvincia", column = @Column(name="SIGLA_PRO_RES_1", updatable = false, insertable = false))
    ])
    @AssociationOverrides([
            @AssociationOverride(name = "nazionalita", joinColumns = @JoinColumn(name = "NAZIONALITA_1"))
    ])
    private Testimone testimone1

    Testimone getTestimone1() {
        if (testimone1 == null){
            testimone1 = new Testimone()
        }
        return testimone1
    }

    void setTestimone1(Testimone t) {
        this.testimone1 = t
    }

    ////////////////////////////////////////////////////////////////////////
    //////////////////////////// TESTIMONE 2 ///////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    String getCognomeTestimone2() {
        return testimone2?.cognome
    }

    void setCognomeTestimone2(String c) {
        this.testimone2?.cognome = c
    }

    String getNomeTestimone2() {
        return testimone2?.nome
    }

    void setNomeTestimone2(String n) {
        this.testimone2?.nome = n
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "nome", column = @Column(name="NOME_2")),
            @AttributeOverride(name = "cognome", column = @Column(name="COGNOME_2")),
            @AttributeOverride(name = "sesso", column = @Column(name="SESSO_2")),
            @AttributeOverride(name = "dataNascita", column = @Column(name="D_DATA_NAS_2")),
            @AttributeOverride(name = "comuneNascita.codice", column = @Column(name="COD_COM_NAS_2")),
            @AttributeOverride(name = "comuneNascita.descrizione", column = @Column(name="DES_COM_NAS_2", updatable = false, insertable = false)),
            @AttributeOverride(name = "comuneNascita.codiceProvincia", column = @Column(name="COD_PRO_NAS_2")),
            @AttributeOverride(name = "comuneNascita.siglaProvincia", column = @Column(name="SIGLA_PRO_NAS_2", updatable = false, insertable = false)),
            @AttributeOverride(name = "comuneResidenza.codice", column = @Column(name="COD_COM_RES_2")),
            @AttributeOverride(name = "comuneResidenza.descrizione", column = @Column(name="DES_COM_RES_2", updatable = false, insertable = false)),
            @AttributeOverride(name = "comuneResidenza.codiceProvincia", column = @Column(name="COD_PRO_RES_2")),
            @AttributeOverride(name = "comuneResidenza.siglaProvincia", column = @Column(name="SIGLA_PRO_RES_2", updatable = false, insertable = false))
    ])
    @AssociationOverrides([
            @AssociationOverride(name = "nazionalita", joinColumns = @JoinColumn(name = "NAZIONALITA_2"))
    ])
    private Testimone testimone2

    Testimone getTestimone2() {
        if (testimone2 == null){
            testimone2 = new Testimone()
        }
        return testimone2
    }

    void setTestimone2(Testimone t) {
        this.testimone2 = t
    }

    ////////////////////////////////////////////////////////////////////////
    //////////////////////////// TESTIMONE 3 ///////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    String getCognomeTestimone3() {
        return testimone3?.cognome
    }

    void setCognomeTestimone3(String c) {
        this.testimone3?.cognome = c
    }

    String getNomeTestimone3() {
        return testimone3?.nome
    }

    void setNomeTestimone3(String n) {
        this.testimone3?.nome = n
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "nome", column = @Column(name="NOME_3")),
            @AttributeOverride(name = "cognome", column = @Column(name="COGNOME_3")),
            @AttributeOverride(name = "sesso", column = @Column(name="SESSO_3")),
            @AttributeOverride(name = "dataNascita", column = @Column(name="D_DATA_NAS_3")),
            @AttributeOverride(name = "comuneNascita.codice", column = @Column(name="COD_COM_NAS_3")),
            @AttributeOverride(name = "comuneNascita.descrizione", column = @Column(name="DES_COM_NAS_3", updatable = false, insertable = false)),
            @AttributeOverride(name = "comuneNascita.codiceProvincia", column = @Column(name="COD_PRO_NAS_3")),
            @AttributeOverride(name = "comuneNascita.siglaProvincia", column = @Column(name="SIGLA_PRO_NAS_3", updatable = false, insertable = false)),
            @AttributeOverride(name = "comuneResidenza.codice", column = @Column(name="COD_COM_RES_3")),
            @AttributeOverride(name = "comuneResidenza.descrizione", column = @Column(name="DES_COM_RES_3", updatable = false, insertable = false)),
            @AttributeOverride(name = "comuneResidenza.codiceProvincia", column = @Column(name="COD_PRO_RES_3")),
            @AttributeOverride(name = "comuneResidenza.siglaProvincia", column = @Column(name="SIGLA_PRO_RES_3", updatable = false, insertable = false))
    ])
    @AssociationOverrides([
            @AssociationOverride(name = "nazionalita", joinColumns = @JoinColumn(name = "NAZIONALITA_3"))
    ])
    private Testimone testimone3

    Testimone getTestimone3() {
        if (testimone3 == null){
            testimone3 = new Testimone()
        }
        return testimone3
    }

    void setTestimone3(Testimone t) {
        this.testimone3 = t
    }

    ////////////////////////////////////////////////////////////////////////
    //////////////////////////// TESTIMONE 4 ///////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    String getCognomeTestimone4() {
        return testimone4?.cognome
    }

    void setCognomeTestimone4(String c) {
        this.testimone4?.cognome = c
    }

    String getNomeTestimone4() {
        return testimone4?.nome
    }

    void setNomeTestimone4(String n) {
        this.testimone4?.nome = n
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "nome", column = @Column(name="NOME_4")),
            @AttributeOverride(name = "cognome", column = @Column(name="COGNOME_4")),
            @AttributeOverride(name = "sesso", column = @Column(name="SESSO_4")),
            @AttributeOverride(name = "dataNascita", column = @Column(name="D_DATA_NAS_4")),
            @AttributeOverride(name = "comuneNascita.codice", column = @Column(name="COD_COM_NAS_4")),
            @AttributeOverride(name = "comuneNascita.descrizione", column = @Column(name="DES_COM_NAS_4", updatable = false, insertable = false)),
            @AttributeOverride(name = "comuneNascita.codiceProvincia", column = @Column(name="COD_PRO_NAS_4")),
            @AttributeOverride(name = "comuneNascita.siglaProvincia", column = @Column(name="SIGLA_PRO_NAS_4", updatable = false, insertable = false)),
            @AttributeOverride(name = "comuneResidenza.codice", column = @Column(name="COD_COM_RES_4")),
            @AttributeOverride(name = "comuneResidenza.descrizione", column = @Column(name="DES_COM_RES_4", updatable = false, insertable = false)),
            @AttributeOverride(name = "comuneResidenza.codiceProvincia", column = @Column(name="COD_PRO_RES_4")),
            @AttributeOverride(name = "comuneResidenza.siglaProvincia", column = @Column(name="SIGLA_PRO_RES_4", updatable = false, insertable = false))
    ])
    @AssociationOverrides([
            @AssociationOverride(name = "nazionalita", joinColumns = @JoinColumn(name = "NAZIONALITA_4"))
    ])
    private Testimone testimone4

    Testimone getTestimone4() {
        if (testimone4 == null){
            testimone4 = new Testimone()
        }
        return testimone4
    }

    void setTestimone4(Testimone t) {
        this.testimone4 = t
    }

    ////////////////////////////////////////////////////////////////////////
    ///////////////////////////////// GENERALI /////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Cognome, Etichette.Nome, Etichette.Sesso, Etichette.Numero_testimoni, Etichette.Testimone]


}