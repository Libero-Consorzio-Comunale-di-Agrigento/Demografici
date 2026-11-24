package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.anagrafe.pratiche.AnaPratica
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaEnte
import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.statocivile.embed.EstremiAtto
import it.finmatica.de4gsdzk.utils.ETipoPratica
import it.finmatica.de4gsdzk.utils.Etichette
import javax.persistence.*

@Entity
@Table(name = "ANASEN_V")
class AnaDettaglioProvvedimento extends GsdBaseDomain{

    @Id
    @Column(name = "ID")
    Integer id

    @ManyToOne(fetch= FetchType.LAZY)
    @JoinColumn(name="TIPO_PROVVEDIMENTO", nullable = true)
    AnaTipoProvvedimento tipo

    @Column(name = "DES_TIPO_PROVVEDIMENTO", nullable = true, updatable = false, insertable = false)
    String tipoProvvedimento

    @Column(name = "NUMERO_DECRETO")
    String numeroDecreto

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_DECRETO")
    Date dataDecreto

    @ManyToOne(fetch= FetchType.LAZY)
    @JoinColumn(name="ENTE_PROVVEDIMENTO", nullable = true)
    AnaEnte ente

    @Column(name = "DES_ENTE_PROVVEDIMENTO", nullable = true, updatable = false, insertable = false)
    String enteProvvedimento

    @Column(name = "ANAGRAFE_TPR")
    String archivioAnagrafe

    @Convert(converter = ETipoPratica.EnumTipoPraticaToStringConverter.class)
    @Column(name ="TIPO_EVENTO_TPR")
    ETipoPratica tipoPratica

    @Column(name ="ANNO_PRATICA_TPR", nullable = true)
    Integer annoPratica

    @Column(name ="PRATICA_TPR", nullable = true)
    Integer numeroPratica

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "COD_COM_TRIB")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_TRIB", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "COD_PRO_TRIB")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_TRIB", updatable = false, insertable = false))
    ])
    private Comune comuneEnte

    Comune getComuneEnte() {
        if (comuneEnte == null){
            comuneEnte = new Comune()
        }
        return comuneEnte
    }

    void setComuneEnte(Comune comuneEnte) {
        this.comuneEnte = comuneEnte
    }

    @Column(name = "AUTORE_PROVVEDIMENTO")
    String autoreProvvedimento

    @ManyToOne(fetch= FetchType.LAZY)
    @JoinColumn(name="TIPO_SENTENZA", nullable = true)
    AnaMotivoProvvedimento motivo

    @Column(name = "DES_TIPO_SENTENZA", nullable = true, updatable = false, insertable = false)
    String tipoSentenza

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "PRIVACY", nullable = true)
    Boolean privacy

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "ufficio", column = @Column(name = "UFFICIO_ATTO_TR")),
            @AttributeOverride(name = "anno", column = @Column(name = "ANNO_ATTO_TR")),
            @AttributeOverride(name = "atto", column = @Column(name = "ATTO_TR")),
            @AttributeOverride(name = "parte", column = @Column(name = "PARTE_ATTO_TR")),
            @AttributeOverride(name = "serie", column = @Column(name = "SERIE_ATTO_TR")),
            @AttributeOverride(name = "idAttoAnsc", column = @Column(name = "ATTO_TR_DIGITALE"))
    ])
    EstremiAtto attoTrascritto

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "COD_COM_ATTO_TR")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_ATTO_TR", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "COD_PRO_ATTO_TR")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_ATTO_TR", updatable = false, insertable = false))
    ])
    private Comune comuneAttoTrascritto

    Comune getComuneAttoTrascritto() {
        if (comuneAttoTrascritto == null){
            comuneAttoTrascritto = new Comune()
        }
        return comuneAttoTrascritto
    }

    void setComuneAttoTrascritto(Comune comuneAttoTrascritto) {
        this.comuneAttoTrascritto = comuneAttoTrascritto
    }

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_ATTO_TR")
    Date dataAttoTrascritto

    @ManyToOne(fetch= FetchType.LAZY)
    @JoinColumn(name="MATRICOLA", nullable = true)
    AnaAnagrafe soggetto

    @ManyToOne(fetch= FetchType.LAZY)
    @JoinColumn(name="ID_ANATPR", nullable = true)
    AnaPratica pratica

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Tipo"), Etichette.getEtichetta("Numero"), Etichette.getEtichetta("Data"), Etichette.getEtichetta("Ente"), Etichette.getEtichetta("Comune"), Etichette.getEtichetta("Nome"),
                                              Etichette.getEtichetta("Atto_Trascritto"), Etichette.getEtichetta("Data_Nascita"), Etichette.getEtichetta("Stato_Civile"), Etichette.getEtichetta("Da"), Etichette.getEtichetta("A"), Etichette.getEtichetta("Autore"),
                                              Etichette.getEtichetta("Motivazione"), Etichette.getEtichetta("Privacy"), Etichette.getEtichetta("Dettaglio_Provvedimento"), Etichette.getEtichetta("Dettaglio_Trascrizione"), Etichette.getEtichetta("Provvedimento_Divorzio") ]


}
