package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Table

@Entity
@Table(name = "CIVOCC")
class CivOcchiello {

    @Id
    @Column(name = "ID")
    Long id

    @Column(name = "ID_ATTO", nullable = false)
    String idAtto

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

    @Column(name = "TIPO_ATTO", nullable = false)
    Integer tipoAtto

    @Column(name = "COGNOME", nullable = true)
    String cognome

    @Column(name = "NOME", nullable = true)
    String nome

    @Column(name = "COGNOME_CN", nullable = true)
    String cognomeConiuge

    @Column(name = "NOME_CN", nullable = true)
    String nomeConiuge

    @Column(name = "SESSO", nullable = true)
    String descrizioneSesso

    @Column(name = "NATO_MORTO", nullable = true)
    String descrizioneStatoNascita

    /////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI /////////////////////////////
    /////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Numero, Etichette.Cognome, Etichette.Nome, Etichette.Sesso, Etichette.Anno, Etichette.Numero_Atto, Etichette.Parte, Etichette.Serie]
}
