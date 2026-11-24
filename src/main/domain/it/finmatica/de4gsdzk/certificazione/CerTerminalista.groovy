package it.finmatica.de4gsdzk.certificazione

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.Etichette
import org.hibernate.annotations.Formula

import javax.persistence.*

@Entity
@Table(name = "CERDTE")
class CerTerminalista extends GsdBaseDomain {

    @Id
    @Column(name = "COD_UTENTE", nullable=false)
    private String id
    String getId() { id }
    void setId(String id) { this.id = id?.toUpperCase() }

    @Column(name = "COGNOME", nullable = false)
    String cognome

    @Column(name = "NOME", nullable = false)
    String nome

    @Column(name = "QUALIFICA", nullable = true)
    String qualifica

    @Column(name = "INDIRIZZO_MAIL", nullable = true)
    String indirizzoMail

    @Column(name = "NUMERO_TEL", nullable = true)
    String telefono

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "IN_STAMPA", nullable = true)
    Boolean flagInStampa

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_UFFICIALE_CIV", nullable = true)
    Boolean flagUfficialeStatoCivile

    @Column(name = "FIRMAREMOTA_USR", nullable = true)
    String utenteFirmaRemota

    @Column(name = "FIRMAREMOTA_PWD", nullable = true)
    String pwdFirmaRemota

    @Formula("""CASE WHEN COGNOME IS NOT NULL 
                     THEN CASE WHEN NOME IS NOT NULL THEN CONCAT(COGNOME, CONCAT(' ', NOME)) ELSE COGNOME END 
                     ELSE COALESCE(NOME, '') END""")
    String cognomeNome

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_FONDO_CASSA", nullable = true)
    Boolean flagFondoCassa

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Codice_Utente"), Etichette.getEtichetta("Cognome"), Etichette.getEtichetta("Nome"), Etichette.getEtichetta("Cognome_Nome"),
                                              Etichette.getEtichetta("Qualifica"), Etichette.getEtichetta("Email"), Etichette.getEtichetta("Numero_telefono"), Etichette.getEtichetta("Nominativo_Stampa"),
                                              Etichette.getEtichetta("Fondo_Cassa")]
}
