package it.finmatica.de4gsdzk.anagrafe


import it.finmatica.de4gsdzk.anagrafe.pratiche.AnaRapportoParentela
import it.finmatica.de4gsdzk.anagrafe.pratiche.AnaRecapito
import it.finmatica.de4gsdzk.anagrafe.pratiche.AnaUrnaCineraria
import it.finmatica.de4gsdzk.integrazioni.documentale.IDocumentoEsterno
import it.finmatica.de4gsdzk.statocivile.embed.AnaConiuge
import it.finmatica.de4gsdzk.utils.EArchivioSorgenteSoggetto
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.IDownloadable

import javax.persistence.*

@Entity
@Table(name = "ANAANA_V")
class AnaAnagrafe extends AnaAnagrafeBaseDomain implements IDocumentoEsterno, IDownloadable {

    //usa MATRICOLA come id
    @Id
    @Column(name = "MATRICOLA")
    Integer id

    Integer getMatricola() {
        return id
    }

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "SENZA_COGNOME", nullable = true)
    Boolean senzaCognome

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "SENZA_NOME", nullable = true)
    Boolean senzaNome

    @Column(name = "COGNOME_NOME", nullable = true)
    private String cognomeNome

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "SENZA_COGNOME_PD", nullable = true)
    Boolean senzaCognomePadre

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "SENZA_NOME_PD", nullable = true)
    Boolean senzaNomePadre

    @Column(name = "PATERNITA", nullable = true)
    private String cognomeNomePadre

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "SENZA_COGNOME_MD", nullable = true)
    Boolean senzaCognomeMadre

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "SENZA_NOME_MD", nullable = true)
    Boolean senzaNomeMadre

    @Column(name = "MATERNITA", nullable = true)
    private String cognomeNomeMadre

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "ANNO_NAS", nullable = true)
    Boolean annoNascitaValido

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "MESE_ANNO_NAS", nullable = true)
    Boolean meseAnnoNascitaValido

    @Override
    EArchivioSorgenteSoggetto getArchivio() {
        return EArchivioSorgenteSoggetto.ANA
    }

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "COD_FAM_UNIQUE", nullable = true)
    AnaFamiglia famiglia

    @Column(name = "COD_FAM", nullable = true)
    Long codFamiglia

    @Embedded
    AnaConiuge coniuge

    AnaConiuge getConiuge() {
        if (coniuge == null) {
            coniuge = new AnaConiuge()
        }
        return coniuge
    }

    void setConiuge(AnaConiuge c) {
        this.coniuge = c
    }

    @Column(name = "ID_DOCUMENTO_GDM", nullable = true)
    Long idDocumentoEsterno

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "anagrafe")
    List<AnaAnagrafeAllegato> allegati

    @Override
    boolean canDownload() {
        return allegati.any({ it.canDownload() })
    }

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_ANACDF", nullable = true, updatable = false, insertable = false)
    AnaConvivenzaDiFatto convivenzaDiFatto

    AnaAnagrafe getConvivente() {
        return convivenzaDiFatto?.conviventi?.find { it.id != id }
    }

    @Column(name = "DES_COD_PROF", nullable = true, updatable = false, insertable = false)
    String descrizioneProfessione

    @Column(name = "DES_TITOLO_STUDIO", nullable = true, updatable = false, insertable = false)
    String descrizioneTitoloStudio

    @Convert(converter = BooleanToIntegerConverter.class)
    @Column(name = "PENSIONATO", nullable = false)
    Boolean pensionato

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_NUCLEO_COABITANTE", nullable = true, updatable = false, insertable = false)
    Boolean nucleoCoabitante

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_VAL_ESPATRIO", nullable = true)
    Date dataInterdizione

    @Column(name = "DOMICILIO_DIGITALE", nullable = true, updatable = false, insertable = false)
    String domicilioDigitale

    @Column(name = "NOTE", nullable = true)
    String note

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_DATA_CONVENZIONALE_RES", nullable = true, updatable = false, insertable = false)
    Boolean flagDataConvenzionaleRes

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_DATA_CONVENZIONALE_FAM", nullable = true, updatable = false, insertable = false)
    Boolean flagDataConvenzionaleFam

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "ANNO_NAS", nullable = true, updatable = false, insertable = false)
    Boolean flagAnnoNascita

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "ANNO_MAT", nullable = true, updatable = false, insertable = false)
    Boolean flagAnnoMatrimonio

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_ESISTE_DOC_PT", nullable = true, updatable = false, insertable = false)
    Boolean possessoPatente

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_ESISTE_DOC_CC", nullable = true, updatable = false, insertable = false)
    Boolean possessoCartaCircolazione

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TITOLO_STUDIO", nullable = true)
    AnaTitoloStudio titoloStudio

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_ANADPR", nullable = true, updatable = false, insertable = false)
    AnaProfessione professione

    @Column(name = "COD_PROF", nullable = true)
    Integer codProf

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ATTIVITA_PROF", nullable = true)
    AnaAttivita attivita

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "POSIZIONE_PROF", nullable = true)
    AnaPosizioneProfessionale posizioneProfessionale

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_ULT_EVE", nullable = true)
    Date dataUltimoEvento

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "anagrafe", cascade = CascadeType.ALL, orphanRemoval = true)
    List<AnaRecapito> recapiti = new ArrayList<>()

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_ANADRP", nullable = true, updatable = false, insertable = false)
    AnaRapportoParentela rapportoParentela

    @Column(name = "RAPPORTO_PAR", nullable = true)
    String codRp

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "COD_FAM_UNIQUE_COABITANTE", nullable = true, updatable = false, insertable = false)
    AnaFamiglia coabitante

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "anagrafe")
    List<AnaUrnaCineraria> urneCinerarie

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_REG", nullable = true)
    Date dataRegistrazione


    static final List<Map> etichetteDomain = AnaAnagrafeBaseDomain.etichetteDomain +
            [Etichette.getEtichetta("Senza_Cognome"), Etichette.getEtichetta("Senza_Nome"), Etichette.getEtichetta("Validi"),
             Etichette.getEtichetta("Solo_Anno"), Etichette.getEtichetta("Solo_Mese_Anno"), Etichette.getEtichetta("Documenti"),
             Etichette.getEtichetta("Possesso_Autoveicoli"), Etichette.getEtichetta("Titolare_Patente"), Etichette.getEtichetta("Rapporto_Parentela_Istat"),
             Etichette.getEtichetta("Condizione_Non_Professionale_Istat"), Etichette.getEtichetta("Titolo_Studio_Istat"), Etichette.getEtichetta("Attivita_Istat"),
             Etichette.getEtichetta("Posizione_Professionale"), Etichette.getEtichetta("Informazioni_Generali"),
             Etichette.getEtichetta("Data_Convenzionale_tooltip"), Etichette.getEtichetta("Data_Non_Significativa_tooltip"), Etichette.getEtichetta("Convivenza_di_fatto"),
             Etichette.getEtichetta("Famiglia_Coabitante"), Etichette.getEtichetta("Intestatario_Famiglia_Coabitante"), Etichette.getEtichetta("Affidamento_Urne_Cinerarie"), Etichette.getEtichetta("Urne_Cinerarie")] as List<Map>

    @PrePersist
    void beforeInsert() {
        this.cognomeNome = (cognome ?: "") + ((cognome || nome) ? "/" : "") + (nome ?: "")
        this.cognomeNomePadre = (cognomePadre ?: "") + ((cognomePadre || nomePadre) ? "/" : "") + (nomePadre ?: "")
        this.cognomeNomeMadre = (cognomeMadre ?: "") + ((cognomeMadre || nomeMadre) ? "/" : "") + (nomeMadre ?: "")
        this.coniuge.cognomeNome = (coniuge.cognome ?: "") + ((coniuge.cognome || coniuge.nome) ? "/" : "") + (coniuge.nome ?: "")
    }

    @PreUpdate
    void beforeUpdate() {
        this.cognomeNome = (cognome ?: "") + ((cognome || nome) ? "/" : "") + (nome ?: "")
        this.cognomeNomePadre = (cognomePadre ?: "") + ((cognomePadre || nomePadre) ? "/" : "") + (nomePadre ?: "")
        this.cognomeNomeMadre = (cognomeMadre ?: "") + ((cognomeMadre || nomeMadre) ? "/" : "") + (nomeMadre ?: "")
        this.coniuge.cognomeNome = (coniuge.cognome ?: "") + ((coniuge.cognome || coniuge.nome) ? "/" : "") + (coniuge.nome ?: "")
    }
}
