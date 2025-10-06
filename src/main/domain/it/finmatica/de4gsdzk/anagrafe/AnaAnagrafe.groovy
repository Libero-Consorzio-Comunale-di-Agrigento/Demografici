package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.integrazioni.documentale.IDocumentoEsterno
import it.finmatica.de4gsdzk.statocivile.embed.AnaConiuge
import it.finmatica.de4gsdzk.utils.EArchivioSorgenteSoggetto
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.IDownloadable
import org.hibernate.annotations.Formula
import org.hibernate.annotations.Type

import javax.persistence.*

@Entity
@Table(name = "ANAANA_V")
class AnaAnagrafe extends AnaAnagrafeBaseDomain implements IDocumentoEsterno, IDownloadable {

    //usa MATRICOLA come id
    @Id
    @Column(name = "MATRICOLA")
    Integer id

    Integer getMatricola(){
        return id
    }

    @Override
    EArchivioSorgenteSoggetto getArchivio() {
        return EArchivioSorgenteSoggetto.ANA
    }

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "COD_FAM_UNIQUE", nullable = false)
    AnaFamiglia famiglia

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "ANAFAM_STORICO_X_MATRICOLA",
            joinColumns = @JoinColumn(name = "MATRICOLA"),
            inverseJoinColumns = @JoinColumn(name = "COD_FAM_UNIQUE"))
    @OrderBy("sequenza ASC")
    List<AnaFamiglia> famiglie

    @Embedded
    AnaConiuge coniuge

    @Column(name = "ID_DOCUMENTO_GDM", nullable = true)
    Long idDocumentoEsterno

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "anagrafe")
    List<AnaAnagrafeAllegato> allegati

    @Override
    boolean canDownload() {
        return allegati.any({ it.canDownload() })
    }

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "COD_CDF", nullable = true)
    AnaConvivenzaDiFatto convivenzaDiFatto

    AnaAnagrafe getConvivente() {
        return convivenzaDiFatto?.conviventi?.find { it.id != id }
    }

    @Column(name = "DES_COD_PROF", nullable = true)
    String descrizioneProfessione

    @Column(name = "DES_TITOLO_STUDIO", nullable = true)
    String descrizioneTitoloStudio

    @Formula("CASE WHEN COALESCE(PENSIONATO , 0) = 0 THEN 0 ELSE 1 END")
    @Type(type = "numeric_boolean")
    Boolean pensionato

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_NUCLEO_COABITANTE", nullable = true)
    Boolean nucleoCoabitante

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_VAL_ESPATRIO", nullable = true)
    Date dataInterdizione

    @Column(name = "DOMICILIO_DIGITALE", nullable = true)
    String domicilioDigitale

    @Column(name = "NOTE", nullable = true)
    String note

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_DATA_CONVENZIONALE_RES", nullable = true)
    Boolean flagDataConvenzionaleRes

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_DATA_CONVENZIONALE_FAM", nullable = true)
    Boolean flagDataConvenzionaleFam

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "ANNO_NAS", nullable = true, updatable = false, insertable = false)
    Boolean flagAnnoNascita

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "ANNO_MAT", nullable = true, updatable = false, insertable = false)
    Boolean flagAnnoMatrimonio

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "COD_FAM_UNIQUE_COABITANTE", nullable = false)
    AnaFamiglia coabitante

    static final List<Map> etichetteDomain = AnaAnagrafeBaseDomain.etichetteDomain +
            [Etichette.Data_Convenzionale_tooltip, Etichette.Data_Non_Significativa_tooltip, Etichette.Convivenza_di_fatto,
            Etichette.Cognome_Coabitante, Etichette.Nome_Coabitante] as List<Map>
}
