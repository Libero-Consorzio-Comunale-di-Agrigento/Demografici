package it.finmatica.de4gsdzk.statocivile

import it.finmatica.ad4.autenticazione.Ad4Utente
import it.finmatica.ad4.hibernate.UtenteUpd
import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.IEntitaAnsc
import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.utils.*
import org.hibernate.annotations.Formula
import org.hibernate.annotations.Type

import javax.persistence.*

@Entity
@Table(name = "CIVANN_V")
class CivAnnotazioneAtto extends GsdBaseDomain implements IEntitaAnsc{

    public static final String tipo_formula_1 = "1"
    public static final String tipo_formula_5 = "5"
    public static final String tipo_formula_X = "X"

    @Id
    @Column(name = "ID")
    Long id

    @Column(name = "ID_ATTO", nullable = false)
    String idAtto

    @Column(name = "TIPO_ATTO", nullable = false)
    Integer tipoAtto

    @Column(name = "UFFICIO", nullable = false)
    Integer ufficio

    @Column(name = "ANNO", nullable = false)
    Integer anno

    @Column(name = "ATTO", nullable = false)
    Integer atto

    @Column(name = "PARTE", nullable = true)
    Integer parte

    @Column(name = "SERIE", nullable = true)
    String serie

    @Column(name = "FORMULA", nullable = false)
    String formula

    @Column(name = "SEQUENZA")
    Integer sequenza

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="FORMULA_DFA", updatable = false, insertable = false)
    CivFormulaAnnotazione formulaDfa

    @Column(columnDefinition = "char", name = "TIPO_FORMULA", updatable = false, insertable = false)
    String tipoFormula

    @Enumerated(EnumType.STRING)
    @Column(name = "STATO")
    EStatoAnnotazione stato

    @Column(name = "TESTO_ANNOTAZIONE")
    String testo

    @Column(name = "TESTO_ANNOTAZIONE_PER_ATTO", nullable = true, updatable = false, insertable = false)
    String testoAtto

    @Column(name = "NUM_RIGHE", nullable = true, updatable = false, insertable = false)
    Integer numeroRighe

    @Column(name = "NUM_COLONNE", nullable = true, updatable = false, insertable = false)
    Integer numeroColonne

    @Enumerated(EnumType.STRING)
    @Column(name = "STAMPA", nullable = true)
    private ETipoSN stampaSuEstrattoDb

    Boolean getStampaSuEstratto() {
        return (stampaSuEstrattoDb == ETipoSN.S)
    }

    void setStampaSuEstratto(Boolean val) {
        this.stampaSuEstrattoDb = DomainUtils.convertStampaSuEstrattoToStampaSuEstrattoDb(val)
    }

    @Enumerated(EnumType.STRING)
    @Column(name = "STAMPA_SU_ATTO", nullable = true)
    private ETipoSN stampaSuAttoDb

    @Formula("CASE WHEN COALESCE(STAMPA_SU_ATTO, 'NO') = 'NO' THEN 0 ELSE 1 END")
    @Type(type="numeric_boolean")
    private Boolean stampaSuAtto

    Boolean getStampaSuAtto() {
        return this.stampaSuAtto
    }

    void setStampaSuAtto(Boolean val) {
        this.stampaSuAtto = val
        this.stampaSuAttoDb = (val? ETipoSN.S : null)
    }

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_BLOCCATO", nullable = true)
    Boolean bloccato

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_REG", nullable = false)
    Date dataRegistrazione

    @Column(name = "C1", nullable = true)
    String c1

    @Column(name = "C2", nullable = true)
    String c2

    @Column(name = "C3", nullable = true)
    String c3

    @Column(name = "C4", nullable = true)
    String c4

    @Column(name = "C5", nullable = true)
    String c5

    @Column(name = "C6", nullable = true)
    String c6

    @Column(name = "C7", nullable = true)
    String c7

    @Column(name = "C8", nullable = true)
    String c8

    @Column(name = "C9", nullable = true)
    String c9

    @Column(name = "C10", nullable = true)
    String c10

    @Column(name = "C11", nullable = true)
    String c11

    @Column(name = "C12", nullable = true)
    String c12

    @Column(name = "C13", nullable = true)
    String c13

    @Column(name = "C14", nullable = true)
    String c14

    @Column(name = "C15", nullable = true)
    String c15

    @Column(name = "C16", nullable = true)
    String c16

    @Column(name = "C17", nullable = true)
    String c17

    @Column(name = "C18", nullable = true)
    String c18

    @Column(name = "C19", nullable = true)
    String c19

    @Column(name = "C20", nullable = true)
    String c20

    @Column(name = "C21", nullable = true)
    String c21

    @Column(name = "C22", nullable = true)
    String c22

    @Column(name = "C23", nullable = true)
    String c23

    @Column(name = "C24", nullable = true)
    String c24

    @Column(name = "C25", nullable = true)
    String c25

    @Column(name = "C26", nullable = true)
    String c26

    @Column(name = "C27", nullable = true)
    String c27

    @Column(name = "C28", nullable = true)
    String c28

    @Column(name = "C29", nullable = true)
    String c29

    @Column(name = "C30", nullable = true)
    String c30

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_ISTAT", nullable = true)
    Boolean flagIstat

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_MODELLO_PROVV", nullable = true, updatable = false, insertable = false)
    Boolean hasModelloProvvSDSU

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "COD_COM_PROV")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_PROV", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "COD_PRO_PROV")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_PROV", updatable = false, insertable = false))
    ])
    private Comune comuneProvenienza

    Comune getComuneProvenienza() {
        if (comuneProvenienza == null){
            comuneProvenienza = new Comune()
        }
        return comuneProvenienza
    }

    void setComuneProvenienza(Comune comuneProvenienza) {
        this.comuneProvenienza = comuneProvenienza
    }

    @Column(name = "ESTREMI_DOC_PROV", nullable = true)
    String estremiDocumentoProvenienza

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_PROV", nullable = false)
    Date dataProvenienza

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_SECRETATO", nullable = true)
    Boolean flagSecretato

    @Enumerated(EnumType.STRING)
    @Column(name = "GENERE", nullable = true)
    EGenereAnnotazione genere

    @Column(name = "ANNO_ANNOTAZIONE", nullable = true)
    Integer annoAnnotazione

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_FIRMATO_USC_ANSC", nullable = true, updatable = false, insertable = false)
    Boolean flagFirmatoUscAnsc

    @Column(name = "ID_USECASE_ANSC", nullable = true)
    Long idAnscUseCase

    @Column(name = "NUMERO_UNICO", nullable = true)
    Long numeroUnico

    @Column(name = "ID_ATTO_ANSC", nullable = true)
    String idAttoAnsc

    ETipoArchivioAnsc getTipoArchivioAnsc(){
        return ETipoArchivioAnsc.ANN
    }

    ETipoAttoAnsc getTipoAttoAnsc(){
        return ETipoAttoAnsc.Annotazione
    }

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TERMINALISTA", nullable = false)
    @UtenteUpd
    Ad4Utente utenteUpd

    @Column(name = "ID_ATTO_RIF", nullable = true)
    String idAttoRif

    @Column(name = "TIPO_ATTO_RIF", nullable = false, updatable = false, insertable = false)
    Integer tipoAttoRif

    @Column(name = "TIPO_ATTO_ANN", nullable = false, updatable = false, insertable = false)
    Integer tipoAttoAnnotazione

    ETipoAtto getTipoAttoEnum(){
        return TipoAttoUtils.fromValoreDefault(this.tipoAttoAnnotazione.intValue())
    }

    ETipoAtto getTipoAttoRifEnum(){
        return TipoAttoUtils.fromValoreDefault(this.tipoAttoRif.intValue())
    }

    Boolean isAttoDiAltroComune(){
        return TipoAttoUtils.isAttoDiAltroComune(tipoAtto)
    }

    // Per le annotazioni di rettifica e da altre amministrazioni
    // occorre inserire anche i dati di provenienza
    Boolean isProvenienzaEnte(){
        return ( (genere != null) &&
               (genere?.equals(EGenereAnnotazione.RET) ||
                genere?.equals(EGenereAnnotazione.AMM) ||
                genere?.equals(EGenereAnnotazione.AMD) ||
                genere?.equals(EGenereAnnotazione.AMX) ||
                genere?.equals(EGenereAnnotazione.AMS) ||
                genere?.equals(EGenereAnnotazione.AMA) ) )
    }

    Boolean isModificativa(){
        return ( (genere != null) && (genere?.equals(EGenereAnnotazione.RET) || genere?.equals(EGenereAnnotazione.EMA)) )
    }

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Formula, Etichette.Stato, Etichette.Testo, Etichette.Data_Registrazione,
                                              Etichette.Sequenza, Etichette.Numero_comunale, Etichette.Istat, Etichette.Secretato,
                                              Etichette.Comune_Ente, Etichette.In_data, Etichette.Estremi_documento,
                                              Etichette.Stampa_Su_Estratto, Etichette.Stampa_Su_Atto, Etichette.Genere, Etichette.Caso_Uso_Ansc]

}
