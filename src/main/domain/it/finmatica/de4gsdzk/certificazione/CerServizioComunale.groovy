package it.finmatica.de4gsdzk.certificazione

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Table

@Entity
@Table(name = "CERSER")
class CerServizioComunale extends GsdBaseDomain {

    @Id
    @Column(name = "COD_SERVIZIO", nullable=false)
    private String id
    String getId() { id }
    void setId(String id) { this.id = id?.toUpperCase() }

    @Column(name = "NOME_SERVIZIO", nullable = false)
    String nome

    @Column(name = "DESCRIZIONE", nullable = false)
    String descrizione

    @Column(name = "RESPONSABILE", nullable = true)
    String responsabile

    @Column(name = "ORARI_1", nullable = true)
    String orari1

    @Column(name = "ORARI_2", nullable = true)
    String orari2

    @Column(name = "ORARI_3", nullable = true)
    String orari3

    @Column(name = "ORARI_4", nullable = true)
    String orari4

    @Column(name = "ORARI_5", nullable = true)
    String orari5

    @Column(name = "ORARI_6", nullable = true)
    String orari6

    @Column(name = "ORARI_7", nullable = true)
    String orari7

    @Column(name = "INDIRIZZO", nullable = true)
    String indirizzo

    @Column(name = "INDIRIZZO_MAIL", nullable = true)
    String indirizzoMail

    @Column(name = "INDIRIZZO_PEC", nullable = true)
    String pec

    @Column(name = "NUMERO_TEL", nullable = true)
    String telefono

    @Column(name = "NUMERO_FAX", nullable = true)
    String fax

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Codice, Etichette.Nome, Etichette.Descrizione, Etichette.Indirizzo, Etichette.Email, Etichette.PEC,
                                              Etichette.Numero_telefono,
                                              Etichette.Responsabile, Etichette.Orari1, Etichette.Orari2,
                                              Etichette.Orari3, Etichette.Orari4, Etichette.Orari5, Etichette.Orari6,
                                              Etichette.Orari7]
}
