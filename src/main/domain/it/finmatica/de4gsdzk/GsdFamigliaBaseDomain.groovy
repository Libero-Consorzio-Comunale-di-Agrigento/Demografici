package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.anagrafe.*
import it.finmatica.de4gsdzk.anagrafe.pratiche.AnaTipoConvivenza
import it.finmatica.de4gsdzk.statocivile.embed.indirizzo.famiglia.IndirizzoNonResidenteFamiglia
import it.finmatica.de4gsdzk.statocivile.embed.indirizzo.famiglia.IndirizzoResidenteEsteroFamiglia
import it.finmatica.de4gsdzk.statocivile.embed.indirizzo.famiglia.IndirizzoResidenteFamiglia
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.IDownloadable
import it.finmatica.de4gsdzk.utils.IIndirizzo

import javax.persistence.*

@MappedSuperclass
abstract class GsdFamigliaBaseDomain extends GsdDocumentoEsternoBaseDomain implements IIndirizzo, IDownloadable {

    @Id
    @Column(name = "COD_FAM_UNIQUE", nullable = false)
    String id

    @Column(name = "COD_FAM", nullable = false)
    Long codice

    @Convert(converter = ETipoAnagrafe.EnumTipoAnagrafeToStringConverter.class)
    @Column(name = "ANAGRAFE", nullable = false, updatable = false, insertable = false)
    ETipoAnagrafe tipoAnagrafe

    @Convert(converter = EFascia.EnumFasciaToIntConverter.class)
    @Column(name = "FASCIA", nullable = false)
    EFascia fascia

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MATRICOLA_CF", nullable = false, updatable = false, insertable = false)
    AnaAnagrafe capoFamiglia

    // Convivenza

    @Convert(converter = BooleanToIntegerConverter.class)
    @Column(name = "TIPO_FAM", nullable = false)
    Boolean convivenza

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TIPO_CONVIVENZA", nullable = true)
    AnaTipoConvivenza tipoConvivenza

    @Column(name = "CONVIVENZA", nullable = false)
    String descrizioneConvivenza

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_ISTITUZIONE", nullable = false)
    Date dataIstituzioneConvivenza

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MATRICOLA_INTESTATARIO", nullable = false)
    AnaAnagrafe intestatarioConvivenza

    @Column(name = "COGNOME_INTESTATARIO", nullable = false)
    String cognomeIntestatario

    @Column(name = "NOME_INTESTATARIO", nullable = false)
    String nomeIntestatario

    @Column(name = "PROGR_ELIMINAZIONE", nullable = false)
    Integer progressivoEliminazione

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_INTESTATARIO", nullable = false)
    Date dataIntestatarioConvivenza

    @Column(name = "INTESTATARIO", nullable = false)
    String intestatario

    // Indirizzo

    @Embedded
    private IndirizzoResidenteFamiglia indirizzoResidente

    @Embedded
    private IndirizzoResidenteEsteroFamiglia indirizzoResidenteEstero

    @Embedded
    private IndirizzoNonResidenteFamiglia indirizzoNonResidente

    IIndirizzo getIndirizzo() {
        return AnagrafeUtils.getIndirizzo(fascia, indirizzoResidente, indirizzoResidenteEstero, indirizzoNonResidente)
    }

    void setIndirizzo(IIndirizzo indirizzo) {
        if (indirizzo instanceof IndirizzoResidenteFamiglia) {
            this.indirizzoResidente = (IndirizzoResidenteFamiglia) indirizzo
        } else if (indirizzo instanceof IndirizzoResidenteEsteroFamiglia) {
            this.indirizzoResidenteEstero = (IndirizzoResidenteEsteroFamiglia) indirizzo
        } else if (indirizzo instanceof IndirizzoNonResidenteFamiglia) {
            this.indirizzoNonResidente = (IndirizzoNonResidenteFamiglia) indirizzo
        } else if (indirizzo != null) {
            throw new IllegalArgumentException("Tipo di indirizzo non supportato: " + indirizzo.getClass().getName())
        }
    }

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "famiglia")
    List<AnaFamigliaAllegato> allegati

    Long getNumeroAllegati() {
        return allegati.size()
    }

    @Override
    boolean canDownload() {
        return allegati.any({ it.canDownload() })
    }

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "famiglia")
    List<AnaEventoFamiglia> eventiFamiglia

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "famiglia")
    List<AnaEventoAnagrafeFamiglia> eventiAnagrafeFamiglia

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_ESISTE_CC", nullable = true, updatable = false, insertable = false)
    Boolean flagEsisteCC

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Codice_Famiglia"),
                                              Etichette.getEtichetta("Indirizzo"), Etichette.getEtichetta("CdF"), Etichette.getEtichetta("Id_Anpr_Famiglia"),
                                              Etichette.getEtichetta("Convivenza"), Etichette.getEtichetta("Denominazione"),
                                              Etichette.getEtichetta("Convivenza_di_fatto"), Etichette.getEtichetta("Data_Istituzione"), Etichette.getEtichetta("Data_Intestatario"), Etichette.getEtichetta("Intestatario"),
                                              Etichette.getEtichetta("Capo_Famiglia"), Etichette.getEtichetta("Intestatario_Convivenza"), Etichette.getEtichetta("Progressivo_Eliminazione")]

}
