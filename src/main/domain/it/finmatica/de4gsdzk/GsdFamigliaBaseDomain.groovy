package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.anagrafe.*
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
    @Column(name = "ANAGRAFE", nullable = false)
    ETipoAnagrafe tipoAnagrafe

    @Convert(converter = EFascia.EnumFasciaToIntConverter.class)
    @Column(name = "FASCIA", nullable = false)
    EFascia fascia

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MATRICOLA_CF", nullable = false)
    AnaAnagrafe capoFamiglia

    // Convivenza

    @Column(name = "TIPO_FAM", nullable = false)
    Boolean convivenza

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

    static final List<Map> etichetteDomain = [Etichette.Codice_Famiglia,
                                              Etichette.Indirizzo,
                                              Etichette.Convivenza, Etichette.Denominazione,
                                              Etichette.Convivenza_di_fatto, Etichette.CdF, Etichette.Data_Istituzione, Etichette.Data_Intestatario, Etichette.Intestatario,
                                              Etichette.Capo_Famiglia, Etichette.Intestatario_Convivenza, Etichette.Progressivo_Eliminazione]

}
