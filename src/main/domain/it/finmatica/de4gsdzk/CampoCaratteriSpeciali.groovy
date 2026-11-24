package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.certificazione.CerTerminalista
import it.finmatica.de4gsdzk.utils.Etichette
import org.hibernate.annotations.Nationalized

import javax.persistence.*

@Entity
@Table(name = "GSDANA_UNICODE")
class CampoCaratteriSpeciali extends GsdBaseDomain{

    @Id
    @Column(name = "ID")
    Long id

    @Column(name = "TABELLA_RIF")
    String tabella

    @Column(name = "ID_RIF")
    String idRif

    @Column(name = "CAMPO_RIF")
    String campo

    @Nationalized
    @Column(name = "COGNOME", nullable = true)
    String cognome

    @Nationalized
    @Column(name = "NOME", nullable = true)
    String nome

    @Nationalized
    @Column(name = "COGNOME_NOME", nullable = true)
    private String cognomeNome

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="TERMINALISTA", nullable = false)
    CerTerminalista terminalista

    static List<Map> etichetteDomain = [Etichette.getEtichetta("Caratteri_Speciali"), Etichette.getEtichetta("Campo"), Etichette.getEtichetta("Cognome"), Etichette.getEtichetta("Nome"), Etichette.getEtichetta("Nessun_Campo_Inserito")]


    @PrePersist
    void beforeInsert() {
        this.cognomeNome = (cognome ?: "") + ((cognome || nome) ? "/" : "") + (nome ?: "")
    }

    @PreUpdate
    void beforeUpdate() {
        this.cognomeNome = (cognome ?: "") + ((cognome || nome) ? "/" : "") + (nome ?: "")
    }


}
