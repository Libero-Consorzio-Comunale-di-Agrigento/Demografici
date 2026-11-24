package it.finmatica.de4gsdzk.statocivile

import it.finmatica.ad4.autenticazione.Ad4Utente
import it.finmatica.ad4.hibernate.UtenteUpd
import it.finmatica.de4gsdzk.utils.ESesso
import it.finmatica.de4gsdzk.utils.ETipoSiNo
import it.finmatica.de4gsdzk.utils.Etichette
import org.hibernate.annotations.Formula

import javax.persistence.*

@Entity
@Table(name = "CIVDTS_V")
class CivTrasportoESeppellimento {

    @Id
    @Column(name = "ID")
    Long id

    @Column(name = "ID_ATTO", nullable = false)
    String idAtto

    @Column(name = "TIPO_ATTO", updatable = false, insertable = false)
    Integer tipoAtto

    @Column(name = "UFFICIO", nullable = false)
    Integer ufficio

    @Column(name = "ANNO", nullable = false)
    Integer anno

    @Column(name = "ATTO", nullable = false)
    Integer atto

    @Column(name = "PARTE", nullable = false)
    Integer parte

    @Column(name = "SERIE", nullable = true)
    String serie

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////// RICHIEDENTE /////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_RICHIESTA", nullable = false)
    Date dataRichiesta

    @Column(name = "COGNOME_RICHIEDENTE", nullable = true)
    String cognomeRichiedente

    @Column(name = "NOME_RICHIEDENTE", nullable = true)
    String nomeRichiedente

    @Column(name = "RICHIEDENTE", nullable = true)
    String richiedente

    @Enumerated(EnumType.STRING)
    @Column(name = "SESSO_RICHIEDENTE", nullable = true)
    ESesso sessoRichiedente

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAS_RICHIEDENTE", nullable = false)
    Date dataNascitaRichiedente

    @Column(name = "COD_COM_NAS_RICHIEDENTE", nullable = true)
    Integer codiceComuneNascitaRichiedente

    @Column(name = "DES_COM_NAS_RICHIEDENTE", nullable = true, updatable = false, insertable = false)
    String descrizioneComuneNascitaRichiedente

    @Column(name = "COD_PRO_NAS_RICHIEDENTE", nullable = true)
    Integer codiceProvinciaNascitaRichiedente

    @Column(name = "SIGLA_PRO_NAS_RICHIEDENTE", nullable = true, updatable = false, insertable = false)
    String siglaProvinciaNascitaRichiedente

    @Column(name = "COD_COM_RES_RICHIEDENTE", nullable = true)
    Integer codiceComuneResidenzaRichiedente

    @Column(name = "DES_COM_RES_RICHIEDENTE", nullable = true, updatable = false, insertable = false)
    String descrizioneComuneResidenzaRichiedente

    @Column(name = "COD_PRO_RES_RICHIEDENTE", nullable = true)
    Integer codiceProvinciaResidenzaRichiedente

    @Column(name = "SIGLA_PRO_RES_RICHIEDENTE", nullable = true, updatable = false, insertable = false)
    String siglaProvinciaResidenzaRichiedente

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////// DESTINAZIONE ////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Column(name = "INDIRIZZO_DEST", nullable = true)
    String indirizzoDestinazione

    @Column(name = "COD_COM_DEST", nullable = true)
    Integer codiceComuneDestinazione

    @Column(name = "DES_COM_DEST", nullable = true, updatable = false, insertable = false)
    String descrizioneComuneDestinazione

    @Column(name = "COD_PRO_DEST", nullable = true)
    Integer codiceProvinciaDestinazione

    @Column(name = "SIGLA_PRO_DEST", nullable = true, updatable = false, insertable = false)
    String siglaProvinciaDestinazione

    @Column(name = "CIMITERO_DEST", nullable = true)
    String cimiteroDestinazione

    ////////////////////////////////////////////////////////////////////////
    //////////////////////////////// ONORANZE //////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Column(name = "DITTA_ONORANZE", nullable = true)
    String dittaOnoranze

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_ONORANZE", nullable = false)
    Date dataOnoranze

    @Column(name = "ORE_ONORANZE", nullable = true)
    String oraOnoranze

    @Column(name = "MINUTI_ONORANZE", nullable = true)
    String minutoOnoranze

    ////////////////////////////////////////////////////////////////////////
    ///////////////////////////// SEPPELLIMENTO ////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_PROTOCOLLO_S", nullable = false)
    Date dataProtocolloSeppellimento

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="COD_REGISTRO_S", nullable = false)
    CivRegistroDocumentiUscita registroSeppellimento

    @Column(name = "ANNO_PROTOCOLLO_S", nullable = false)
    Integer annoProtocolloSeppellimento

    @Column(name = "PROTOCOLLO_S", nullable = false)
    Integer numeroProtocolloSeppellimento

    ////////////////////////////////////////////////////////////////////////
    /////////////////////////////// TRASPORTO //////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_TRASPORTO", nullable = false)
    Date dataTrasporto

    @Column(name = "ORE_TRASPORTO", nullable = true)
    String oraTrasporto

    @Column(name = "MINUTI_TRASPORTO", nullable = true)
    String minutoTrasporto

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_PROTOCOLLO_T", nullable = false)
    Date dataProtocolloTrasporto

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="COD_REGISTRO_T", nullable = false)
    CivRegistroDocumentiUscita registroTrasporto

    @Column(name = "ANNO_PROTOCOLLO_T", nullable = false)
    Integer annoProtocolloTrasporto

    @Column(name = "PROTOCOLLO_T", nullable = false)
    Integer numeroProtocolloTrasporto

    @Column(name = "NOTE", nullable = true)
    String noteTrasporto

    @Column(name = "COGNOME_INCARICATO_TR", nullable = true)
    String cognomeIncaricatoTrasporto

    @Column(name = "NOME_INCARICATO_TR", nullable = true)
    String nomeIncaricatoTrasporto

    @Column(name = "INCARICATO_TRASPORTO", nullable = true)
    String incaricatoTrasporto

    @Enumerated(EnumType.STRING)
    @Column(name = "SESSO_INCARICATO_TR", nullable = true)
    ESesso sessoIncaricatoTrasporto

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAS_INCARICATO_TR", nullable = false)
    Date dataNascitaIncaricatoTrasporto

    @Column(name = "COD_COM_NAS_INCARICATO_TR", nullable = true)
    Integer codiceComuneNascitaIncaricatoTrasporto

    @Column(name = "DES_COM_NAS_INCARICATO_TR", nullable = true, updatable = false, insertable = false)
    String descrizioneComuneNascitaIncaricatoTrasporto

    @Column(name = "COD_PRO_NAS_INCARICATO_TR", nullable = true)
    Integer codiceProvinciaNascitaIncaricatoTrasporto

    @Column(name = "SIGLA_PRO_NAS_INCARICATO_TR", nullable = true, updatable = false, insertable = false)
    String siglaProvinciaNascitaIncaricatoTrasporto

    @Column(name = "COD_COM_RES_INCARICATO_TR", nullable = true)
    Integer codiceComuneResidenzaIncaricatoTrasporto

    @Column(name = "DES_COM_RES_INCARICATO_TR", nullable = true, updatable = false, insertable = false)
    String descrizioneComuneResidenzaIncaricatoTrasporto

    @Column(name = "COD_PRO_RES_INCARICATO_TR", nullable = true)
    Integer codiceProvinciaResidenzaIncaricatoTrasporto

    @Column(name = "SIGLA_PRO_RES_INCARICATO_TR", nullable = true, updatable = false, insertable = false)
    String siglaProvinciaResidenzaIncaricatoTrasporto

    ////////////////////////////////////////////////////////////////////////
    /////////////////////////////// CREMAZIONE /////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_CREMAZIONE", nullable = false)
    Date dataCremazione

    @Column(name = "ORE_CREMAZIONE", nullable = true)
    String oraCremazione

    @Column(name = "MINUTI_CREMAZIONE", nullable = true)
    String minutoCremazione

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_PROTOCOLLO_C", nullable = false)
    Date dataProtocolloCremazione

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="COD_REGISTRO_C", nullable = false)
    CivRegistroDocumentiUscita registroCremazione

    @Column(name = "ANNO_PROTOCOLLO_C", nullable = false)
    Integer annoProtocolloCremazione

    @Column(name = "PROTOCOLLO_C", nullable = false)
    Integer numeroProtocolloCremazione

    @Column(name = "COD_COM_CREMAZIONE", nullable = true)
    Integer codiceComuneCremazione

    @Column(name = "DES_COM_CREMAZIONE", nullable = true, updatable = false, insertable = false)
    String descrizioneComuneCremazione

    @Column(name = "COD_PRO_CREMAZIONE", nullable = true)
    Integer codiceProvinciaCremazione

    @Column(name = "SIGLA_PRO_CREMAZIONE", nullable = true, updatable = false, insertable = false)
    String siglaProvinciaCremazione

    @Column(name = "DESTINAZIONE_CENERI", nullable = true)
    String destinazioneCeneri

    @Column(name = "NOTE_CREMAZIONE", nullable = true)
    String noteCremazione

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TERMINALISTA", nullable = false)
    @UtenteUpd
    Ad4Utente utenteUpd

    @Version
    @Column(nullable = false)
    Long version

    @Enumerated(EnumType.STRING)
    @Formula("""CASE WHEN D_DATA_RICHIESTA IS NOT NULL OR D_DATA_TRASPORTO IS NOT NULL OR ORE_TRASPORTO IS NOT NULL OR MINUTI_TRASPORTO IS NOT NULL 
            OR COD_COM_DEST IS NOT NULL OR INDIRIZZO_DEST IS NOT NULL OR CIMITERO_DEST IS NOT NULL OR NOTE IS NOT NULL
            OR DITTA_ONORANZE IS NOT NULL OR D_DATA_ONORANZE IS NOT NULL OR ORE_ONORANZE IS NOT NULL OR MINUTI_ONORANZE IS NOT NULL 
            OR D_DATA_PROTOCOLLO_T IS NOT NULL OR COD_REGISTRO_T IS NOT NULL OR ANNO_PROTOCOLLO_T IS NOT NULL OR PROTOCOLLO_T IS NOT NULL
            OR D_DATA_PROTOCOLLO_S IS NOT NULL OR COD_REGISTRO_S IS NOT NULL OR ANNO_PROTOCOLLO_S IS NOT NULL OR PROTOCOLLO_S IS NOT NULL
            OR COGNOME_RICHIEDENTE IS NOT NULL OR NOME_RICHIEDENTE IS NOT NULL OR D_DATA_NAS_RICHIEDENTE IS NOT NULL OR COD_COM_NAS_RICHIEDENTE IS NOT NULL OR COD_COM_RES_RICHIEDENTE IS NOT NULL 
            OR COGNOME_INCARICATO_TR IS NOT NULL OR NOME_INCARICATO_TR IS NOT NULL OR D_DATA_NAS_INCARICATO_TR IS NOT NULL OR COD_COM_NAS_INCARICATO_TR IS NOT NULL OR COD_COM_RES_INCARICATO_TR IS NOT NULL
                THEN 'SI' ELSE 'NO' END""")
    private ETipoSiNo trasporto

    ETipoSiNo getTrasporto() {
        return trasporto
    }

    void setTrasporto(ETipoSiNo trasporto) {
        this.trasporto = trasporto
        if ( trasporto == ETipoSiNo.NO ) {
            dataRichiesta = null
            cognomeRichiedente = null
            nomeRichiedente = null
            sessoRichiedente = null
            dataNascitaRichiedente = null
            codiceComuneNascitaRichiedente = null
            codiceProvinciaNascitaRichiedente = null
            descrizioneComuneNascitaRichiedente = null
            siglaProvinciaNascitaRichiedente = null
            codiceComuneResidenzaRichiedente = null
            codiceProvinciaResidenzaRichiedente = null
            descrizioneComuneResidenzaRichiedente = null
            siglaProvinciaResidenzaRichiedente = null
            codiceComuneDestinazione = null
            codiceProvinciaDestinazione = null
            descrizioneComuneDestinazione = null
            siglaProvinciaDestinazione = null
            indirizzoDestinazione = null
            cimiteroDestinazione = null

            dittaOnoranze = null
            dataOnoranze = null
            oraOnoranze = null
            minutoOnoranze = null

            dataProtocolloSeppellimento = null
            registroSeppellimento = null
            annoProtocolloSeppellimento = null
            numeroProtocolloSeppellimento = null

            dataTrasporto = null
            oraTrasporto = null
            minutoTrasporto = null
            noteTrasporto = null
            cognomeIncaricatoTrasporto = null
            nomeIncaricatoTrasporto = null
            sessoIncaricatoTrasporto = null
            dataNascitaIncaricatoTrasporto = null
            codiceComuneNascitaIncaricatoTrasporto = null
            codiceProvinciaNascitaIncaricatoTrasporto = null
            descrizioneComuneNascitaIncaricatoTrasporto = null
            siglaProvinciaNascitaIncaricatoTrasporto = null
            codiceComuneResidenzaIncaricatoTrasporto = null
            codiceProvinciaResidenzaIncaricatoTrasporto = null
            descrizioneComuneResidenzaIncaricatoTrasporto = null
            siglaProvinciaResidenzaIncaricatoTrasporto = null
            dataProtocolloTrasporto = null
            registroTrasporto = null
            annoProtocolloTrasporto = null
            numeroProtocolloTrasporto = null
        }
    }

    @Enumerated(EnumType.STRING)
    @Formula("""CASE WHEN D_DATA_CREMAZIONE IS NOT NULL OR ORE_CREMAZIONE IS NOT NULL OR MINUTI_CREMAZIONE IS NOT NULL
                OR COD_COM_CREMAZIONE IS NOT NULL OR DESTINAZIONE_CENERI IS NOT NULL OR NOTE_CREMAZIONE IS NOT NULL
                OR D_DATA_PROTOCOLLO_C IS NOT NULL OR COD_REGISTRO_C IS NOT NULL OR ANNO_PROTOCOLLO_C IS NOT NULL OR PROTOCOLLO_C IS NOT NULL
                THEN 'SI' ELSE 'NO' END""")
    private ETipoSiNo cremazione

    ETipoSiNo getCremazione() {
        return cremazione
    }

    void setCremazione(ETipoSiNo cremazione) {
        this.cremazione = cremazione
        if ( cremazione == ETipoSiNo.NO ){
            dataCremazione = null
            oraCremazione = null
            minutoCremazione = null
            codiceComuneCremazione = null
            descrizioneComuneCremazione = null
            codiceProvinciaCremazione = null
            siglaProvinciaCremazione = null
            destinazioneCeneri = null
            noteCremazione = null

            dataProtocolloCremazione = null
            registroCremazione = null
            annoProtocolloCremazione = null
            numeroProtocolloCremazione = null
        }
    }

    /*
    @PrePersist
    void beforeInsert() {
        if ( (this.richiedente?:"") == ""){
            this.richiedente = (cognomeRichiedente?:"") + ((cognomeRichiedente && nomeRichiedente)?" ":"") + (nomeRichiedente?:"")
        }
        if ( (this.incaricatoTrasporto?:"") == ""){
            this.incaricatoTrasporto = (cognomeIncaricatoTrasporto ?: "") + ((cognomeIncaricatoTrasporto && nomeIncaricatoTrasporto) ? " " : "") + (nomeIncaricatoTrasporto ?: "")
        }
    }

    @PreUpdate
    void beforeUpdate() {
        if ( (this.richiedente?:"") == ""){
            this.richiedente = (cognomeRichiedente?:"") + ((cognomeRichiedente && nomeRichiedente)?" ":"") + (nomeRichiedente?:"")
        }
        if ( (this.incaricatoTrasporto?:"") == ""){
            this.incaricatoTrasporto = (cognomeIncaricatoTrasporto ?: "") + ((cognomeIncaricatoTrasporto && nomeIncaricatoTrasporto) ? " " : "") + (nomeIncaricatoTrasporto ?: "")
        }
    }
    */

    Boolean hasParte(){
        return Boolean.TRUE
    }

    Boolean hasSerie(){
        return Boolean.TRUE
    }

    ////////////////////////////////////////////////////////////////////////
    /////////////////////////////// GENERALI ///////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    @Override
    String toString() {
        return String.format("CIVDTS(id=%d)", id)
    }

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Cimitero"), Etichette.getEtichetta("Data_Richiesta"), Etichette.getEtichetta("Data_Trasporto"), Etichette.getEtichetta("Ore"), Etichette.getEtichetta("Minuti"), Etichette.getEtichetta("Ditta"),
                                              Etichette.getEtichetta("Comune_destinazione"), Etichette.getEtichetta("Indirizzo_destinazione"), Etichette.getEtichetta("Registro_Aut_Trasporto"),
                                              Etichette.getEtichetta("Registro_Aut_Seppellimento"), Etichette.getEtichetta("Registro_Aut_Cremazione"), Etichette.getEtichetta("Comune_cremazione"),
                                              Etichette.getEtichetta("Indirizzo_destinazione_ceneri"), Etichette.getEtichetta("Numero_Protocollo_Anno"), Etichette.getEtichetta("In_data"), Etichette.getEtichetta("Cognome_Richiedente"),
                                              Etichette.getEtichetta("Nome_Richiedente"), Etichette.getEtichetta("Cognome_Incaricato"), Etichette.getEtichetta("Nome_Incaricato")]

}