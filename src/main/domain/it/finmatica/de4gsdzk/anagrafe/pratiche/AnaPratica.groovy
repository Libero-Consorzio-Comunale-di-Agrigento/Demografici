package it.finmatica.de4gsdzk.anagrafe.pratiche

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.anagrafe.AnaFamiglia
import it.finmatica.de4gsdzk.anagrafe.ETipoAnagrafe
import it.finmatica.de4gsdzk.certificazione.CerTerminalista
import it.finmatica.de4gsdzk.integrazioni.documentale.IDocumentoEsterno
import it.finmatica.de4gsdzk.utils.ETipoPratica
import it.finmatica.de4gsdzk.utils.Etichette

import org.hibernate.annotations.NotFound
import org.hibernate.annotations.NotFoundAction

import javax.persistence.*

@Entity
@Table(name = "ANATPR_V_ZK")
class AnaPratica extends GsdBaseDomain implements IDocumentoEsterno {

    @Id
    @Column(name = "ID")
    Long id

    @Version
    @Column(nullable = false)
    Long version

    @Column(name = "ID_PRATICA")
    String idPratica

    @Convert(converter = ETipoAnagrafe.EnumTipoAnagrafeToStringConverter.class)
    @Column(name ="ANAGRAFE")
    ETipoAnagrafe archivioAnagrafe

    @Convert(converter = ETipoPratica.EnumTipoPraticaToStringConverter.class)
    @Column(name ="TIPO_EVENTO")
    ETipoPratica tipoPratica

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MAX_EVENTO_PRATICA", nullable = true, updatable = false, insertable = false)
    AnaEventoPratica statoPratica

    @Temporal(TemporalType.DATE)
    @Column(name= "D_DATA_PRATICA", nullable = true)
    Date data

    @Column(name ="ANNO_PRATICA", nullable = true)
    Integer anno

    @Column(name ="PRATICA", nullable = true)
    Integer numero

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_INIZIATIVA", nullable = true, updatable = false, insertable = false)
    @NotFound(action = NotFoundAction.IGNORE)
    AnaDizionarioPratiche iniziativa

    @Column(name="INIZIATIVA", nullable = false)
    String codiceIniziativa

    @Column(name ="GG_MONITORAGGIO", nullable = true, updatable = false, insertable = false)
    Integer giorniMonitoraggio

    @Column(name ="COD_VARIAZIONE", nullable = true)
    String codiceVariazione

    @Column(name ="DES_VARIAZIONE", nullable = true, updatable = false, insertable = false)
    String descrizioneVariazione

    @Column(name ="COGNOME_DIC", nullable = true)
    String cognomeDichiarante

    @Column(name ="NOME_DIC", nullable = true)
    String nomeDichiarante

    @Column(name ="COGNOME_NOME_DIC", nullable = true)
    String cognomeNomeDichiarante

    @Column(name ="MATRICOLA_DIC", nullable = true)
    Integer matricolaDichiarante

    @Column(name ="COD_FAM_DIC", nullable = true)
    Long codFamigliaDichiarante

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "COD_FAM_UNIQUE_DIC", nullable = true)
    AnaFamiglia famigliaDichiarante

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TERMINALISTA", nullable = true)
    @NotFound(action = NotFoundAction.IGNORE)
    CerTerminalista terminalista

    @Temporal(TemporalType.DATE)
    @Column(name= "D_DATA_DECORRENZA", nullable = true)
    Date dataDecorrenza

    @OneToOne(mappedBy = "pratica", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    AnaOccupazioneImmobile occupazioneImmobile

    AnaOccupazioneImmobile getOccupazioneImmobile() {
        if (occupazioneImmobile == null){
            occupazioneImmobile = new AnaOccupazioneImmobile()
            occupazioneImmobile.pratica = this
            occupazioneImmobile.idPratica = this.idPratica
            occupazioneImmobile.flagLocazione = false
            occupazioneImmobile.flagProprietario = false
            occupazioneImmobile.flagLocazioneErp = false
            occupazioneImmobile.flagComodato = false
            occupazioneImmobile.flagUsufrutto = false
            occupazioneImmobile.flagTitolo = false
        }
        return occupazioneImmobile
    }

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_PERFEZIONAMENTO", nullable = true)
    Boolean flagPerfezionamento

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_PERFEZIONAMENTO_P", nullable = true, updatable = false, insertable = false)
    Boolean flagPerfezionamentoPreliminare

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_ANNULLAMENTO", nullable = true)
    Boolean flagAnnullamento

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "pratica", cascade = CascadeType.ALL, orphanRemoval = true)
    List<AnaAvanzamentoPratica> avanzamentiPratica = new ArrayList<>()

    @Column(name = "ID_DOCUMENTO_GDM", nullable = true)
    Long idDocumentoEsterno

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "pratica")
    List<AnaPraticaAllegato> allegati

    //Questa relazione è valida solo per determinate ISCRIZIONI RES
    @OneToOne(mappedBy = "pratica", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    AnaDichiarazioneCancellazioneAir dichiarazioneCancellazioneAir

   /* @OneToMany(fetch = FetchType.LAZY, mappedBy = "pratica")
    List<AnaDichiarante> dichiaranti*/

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Anagrafe"), Etichette.getEtichetta("Tipo_Pratica"), Etichette.getEtichetta("Data_Pratica"),
                                              Etichette.getEtichetta("Anno_Pratica"), Etichette.getEtichetta("Numero_Pratica"),
                                              Etichette.getEtichetta("Dichiarante"), Etichette.getEtichetta("Data_Decorrenza"),  Etichette.getEtichetta("Codice_Variazione"),
                                              Etichette.getEtichetta("Numera"), Etichette.getEtichetta("Provvisorio"),
                                              Etichette.getEtichetta("Variazione_Pratica"), Etichette.getEtichetta("Iniziativa")]


}
