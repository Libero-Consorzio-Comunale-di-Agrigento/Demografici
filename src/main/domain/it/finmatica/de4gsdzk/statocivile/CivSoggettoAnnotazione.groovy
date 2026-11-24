package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.utils.*

import javax.persistence.*

@Entity
@Table(name = "CIVALL_V_ANNOTAZIONI")
class CivSoggettoAnnotazione {

    @Id
    @Column(name = "ID")
    String id

    @Column(name = "ID_ATTO", nullable = false)
    String idAtto

    @Column(name = "UFFICIO", nullable = true)
    Integer ufficio

    @Column(name = "ANNO", nullable = true)
    Integer anno

    @Column(name = "ATTO", nullable = false)
    Integer atto

    @Enumerated(EnumType.STRING)
    @Column(name = "NATURA", nullable = false)
    ENaturaAtto natura

    @Column(name = "PARTE", nullable = false)
    Integer parte

    @Column(name = "SERIE", nullable = false)
    String serie

    @Column(name = "COGNOME", nullable = true)
    String cognome

    @Column(name = "NOME", nullable = true)
    String nome

    @Enumerated(EnumType.STRING)
    @Column(name = "SESSO", nullable = true)
    ESesso sesso

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAS", nullable = true)
    Date dataNascita

    @Column(name = "COGNOME_2", nullable = true)
    String cognome2

    @Column(name = "NOME_2", nullable = true)
    String nome2

    @Enumerated(EnumType.STRING)
    @Column(name = "SESSO_2", nullable = true)
    ESesso sesso2

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAS_2", nullable = true)
    Date dataNascita2

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_EVE", nullable = true)
    Date dataEvento

    @Column(name = "ID_ATTO_ANSC", nullable = true)
    String idAttoAnsc

    @Column(name = "TIPO_ATTO_ANN", nullable = false, updatable = false, insertable = false)
    Integer tipoAttoAnnotazione

    @Column(name = "TIPO_ATTO", nullable = false)
    Integer tipoAtto

    @Column(columnDefinition = "char", name = "TIPO_FORMULA", nullable = false)
    String tipoFormula

    @Column(name = "TIPO_COMUNE", nullable = false)
    int tipoComune = 1

    @Column(name="ID_CIVANN", nullable = true)
    Long annotazioneDomainId

    @Column(name = "TIPO_ATTO_RIF", nullable = false)
    Integer tipoAttoRif

    ETipoAtto getTipoAttoAnnotazioneEnum(){
        return TipoAttoUtils.fromValoreDefault(this.tipoAttoAnnotazione.intValue())
    }

    ETipoAtto getTipoAttoRifEnum(){
        return TipoAttoUtils.fromValoreDefault(this.tipoAttoRif.intValue())
    }

    Boolean isAttoDiAltroComune(){
        return TipoAttoUtils.isAttoDiAltroComune(tipoAtto)
    }

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Ufficio"), Etichette.getEtichetta("Anno"), Etichette.getEtichetta("Tipo_Atto"), Etichette.getEtichetta("Id_Atto_Ansc"),
                                              Etichette.getEtichetta("Numero_Atto"), Etichette.getEtichetta("Parte"), Etichette.getEtichetta("Serie"), Etichette.getEtichetta("Natura_Atto"),
                                              Etichette.getEtichetta("Cognome"), Etichette.getEtichetta("Nome"), Etichette.getEtichetta("Sesso"), Etichette.getEtichetta("Data_Evento"),
                                              Etichette.getEtichetta("Cognome_Sposo"), Etichette.getEtichetta("Nome_Sposo"), Etichette.getEtichetta("Cognome_Sposa"), Etichette.getEtichetta("Nome_Sposa")]

}
