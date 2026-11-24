package it.finmatica.de4gsdzk.elettorale

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.JoinColumn
import javax.persistence.OneToOne
import javax.persistence.Table

@Entity
@Table(name = "WS_MININT_ELECAN_V")
class EleCandidatoWs extends GsdBaseDomain {

    @Id
    @Column(name = "ID", updatable = false, insertable = false)
    Long id

    @Column(name = "NUMERO_PROGRESSIVO_AREA_LISTE")
    Long numeroProgressivoAreaListe

    @Column(name = "CODICE_PROVINCIA")
    Long codiceProvincia

    @Column(name = "DESCRIZIONE_PROVINCIA")
    String descrizioneProvincia

    @Column(name = "CODICE_LISTA")
    Long codiceLista

    @Column(name = "DESCRIZIONE_LISTA")
    String descrizioneLista

    @Column(name = "CODICE_CANDIDATO")
    Long codiceCandidato

    @Column(name = "COGNOME")
    String cognome

    @Column(name = "NOME")
    String nome

    @Column(name = "LUOGO_NASCITA")
    String luogoNascita

    @Column(name = "DATA_NASCITA")
    String dataNascita

    @Column(name = "SESSO")
    String sesso

    @OneToOne
    @JoinColumn(name = "ELEZIONE_ADS", nullable = false)
    De4Elezione elezioneAds

    @Column(name = "LISTA_ADS")
    Long listaAds

    @Column(name = "CANDIDATO_ADS")
    Long candidatoAds

    @OneToOne
    @JoinColumn(name = "ID_ELEDCE_ADS", nullable = false, updatable = false, insertable = false)
    EleElezione elezione

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Numero_Progressivo_Area_Liste"), Etichette.getEtichetta("Codice_Lista"),
                                              Etichette.getEtichetta("Descrizione_Lista"), Etichette.getEtichetta("Codice_Candidato"),
                                              Etichette.getEtichetta("Cognome"), Etichette.getEtichetta("Nome"), Etichette.getEtichetta("Luogo_Nascita"),
                                              Etichette.getEtichetta("Data_Nascita"), Etichette.getEtichetta("Sesso"),
                                              Etichette.getEtichetta("Lista_Ads"), Etichette.getEtichetta("Candidato_Ads"),
                                              Etichette.getEtichetta("Elezione_Ads")]

}