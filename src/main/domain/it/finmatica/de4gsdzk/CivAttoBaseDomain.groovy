package it.finmatica.de4gsdzk

import it.finmatica.ad4.autenticazione.Ad4Utente
import it.finmatica.ad4.hibernate.UtenteUpd
import it.finmatica.de4gsdzk.statocivile.CivAnnotazioneAtto
import it.finmatica.de4gsdzk.statocivile.CivTipoAtto
import it.finmatica.de4gsdzk.statocivile.embed.EstremiAtto
import it.finmatica.de4gsdzk.utils.*
import org.hibernate.annotations.Formula
import org.hibernate.annotations.Type

import javax.persistence.*

@MappedSuperclass
abstract class CivAttoBaseDomain extends GsdBaseDomain{

    @Id
    @Column(name = "ID")
    Long id

    @Column(name = "ID_ATTO", nullable = false)
    String idAtto

    @Column(name = "UFFICIO", nullable = true)
    Integer ufficio

    @Column(name = "ANNO", nullable = true)
    Integer anno

    @Column(name = "ATTO", nullable = false)
    Integer atto


    @AttributeOverrides([
            @AttributeOverride(name = "ufficio", column = @Column(name = "UFFICIO_LISTA", updatable = false, insertable = false)),
            @AttributeOverride(name = "anno", column = @Column(name = "ANNO_LISTA", updatable = false, insertable = false)),
            @AttributeOverride(name = "atto", column = @Column(name = "ATTO_LISTA", updatable = false, insertable = false)),
            @AttributeOverride(name = "parte", column = @Column(name = "PARTE_LISTA", updatable = false, insertable = false)),
            @AttributeOverride(name = "serie", column = @Column(name = "SERIE_LISTA", updatable = false, insertable = false)),
            @AttributeOverride(name = "idAttoAnsc", column = @Column(name = "ID_ATTO_ANSC_LISTA", updatable = false, insertable = false))
    ])
    EstremiAtto attoLista

    abstract Integer getParte()

    abstract void setParte(Integer parte)

    abstract String getSerie()

    abstract void setSerie(String serie)

    @Enumerated(EnumType.STRING)
    @Column(name = "NATURA", nullable = false)
    ENaturaAtto natura

    @Enumerated(EnumType.STRING)
    @Column(name = "FLAG_BLOCCATO", nullable = true)
    ETipoSN bloccatoDb

    @Formula("CASE WHEN COALESCE(FLAG_BLOCCATO, 'N') = 'N' THEN 0 ELSE 1 END")
    @Type(type="numeric_boolean")
    private Boolean bloccato

    Boolean getBloccato() {
        return this.bloccato
    }

    void setBloccato(Boolean val) {
        this.bloccato = val
        this.bloccatoDb = (val?ETipoSN.S:null)
    }

    @Enumerated(EnumType.STRING)
    @Column(name = "FLAG_COM_IN_SOSPESO", nullable = false, updatable = false, insertable = false)
    ETipoSiNo comunicazioniPendenti

    @Enumerated(EnumType.STRING)
    @Column(name = "FLAG_EVENTO_NEL_COMUNE", nullable = true, updatable = false, insertable = false)
    ETipoSN eventoNelComune

    ETipoLuogoEvento getEventoNelComuneLista(){
        if ( this.eventoNelComune == ETipoSN.S ){
            return ETipoLuogoEvento.NEL_COMUNE
        } else {
            return ETipoLuogoEvento.FUORI_COMUNE
        }
    }

    @Enumerated(EnumType.STRING)
    @Column(name = "FLAG_RESIDENTE", nullable = true, updatable = false, insertable = false)
    ETipoSN soggettoResidente

    abstract Integer getTipoAtto()

    abstract ETipoAtto getTipoAttoEnum()

    // Introdotta nella nuova versione del prodotto per recuperare la descrizione per esteso del tipo di atto
    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="ID_CIVDTA", nullable = true)
    CivTipoAtto tipoAttoDomain

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TERMINALISTA", nullable = false)
    @UtenteUpd
    Ad4Utente utenteUpd

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "D_DATA_REG", nullable = true)
    Date dataRegistrazione

    @Version
    @Column(nullable = false)
    Long version

    @Column(name = "COD_REC", nullable = false)
    Integer codiceRecord

    @Column(name = "VERSIONE", nullable = true)
    Integer versioneRettifica

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "D_DATA_VERSIONE", nullable = true)
    Date dataVersioneRettifica

    Boolean isProvvisorio(){
        return  ( (this.atto != null) && (this.atto.compareTo(new Integer(0)) < 1) )
    }

    Boolean isCodRec3(){
        return  ( this.codiceRecord.compareTo(new Integer(3)) == 0 )
    }

    Boolean isCodRec0(){
        return  ( this.codiceRecord.compareTo(new Integer(0)) == 0 )
    }

    void setCodRec0(){
        codiceRecord = new Integer(0)
    }

    void setCodRec1() {
        codiceRecord = new Integer(1)
    }

    Boolean isPartePrima(){
        Boolean val = ( (this.parte?.intValue()?:0) == 1 )
        return val
    }

    Boolean isParteSeconda(){
        Boolean val = ( (this.parte?.intValue()?:1) == 2 )
        return val
    }

    Boolean hasParte(){
        return getTipoAttoEnum().hasParte()
    }

    Boolean hasSerie(){
        return getTipoAttoEnum().hasSerie()
    }

    Boolean hasMargine(){
        return Boolean.TRUE
    }

    Boolean isAttoAnsc(){
        return (this instanceof IAttoAnsc)
    }

    String getCognome1EstremiAtto(String tipoFormula){
        if (tipoFormula == CivAnnotazioneAtto.tipo_formula_1){
            return ( ((ISoggettoAtto1)this).cognome1?:"")
        }
        if (tipoFormula == CivAnnotazioneAtto.tipo_formula_5){
            return ( ((ISoggettoAtto2)this).cognome2?:"")
        }
        if (tipoFormula == CivAnnotazioneAtto.tipo_formula_X){
            return "ALTRO SOGGETTO"
        }
        return ( ((ISoggettoAtto1)this).cognome1?:"")
    }

    String getCognome2EstremiAtto(){
        if (this instanceof ISoggettoAtto2){
            return ( ((ISoggettoAtto2)this).cognome2?:"")
        }
        return null
    }

    String getNome1EstremiAtto(String tipoFormula){
        if (tipoFormula == CivAnnotazioneAtto.tipo_formula_1){
            return ( ((ISoggettoAtto1)this).nome1?:"")
        }
        if (tipoFormula == CivAnnotazioneAtto.tipo_formula_5){
            return ( ((ISoggettoAtto2)this).nome2?:"")
        }
        if (tipoFormula == CivAnnotazioneAtto.tipo_formula_X){
            return ""
        }
        return ( ((ISoggettoAtto1)this).nome1?:"")
    }

    String getNome2EstremiAtto(){
        if (this instanceof ISoggettoAtto2){
            return ( ((ISoggettoAtto2)this).nome2?:"")
        }
        return null
    }

    String getNominativoEstremiAtto(String tipoFormula, Integer tipoAttoDest){
        String s = getCognome1EstremiAtto(tipoFormula) + " " + getNome1EstremiAtto(tipoFormula)
        if ( [ETipoAtto.MAT.valore, ETipoAtto.UCI.valore, ETipoAtto.PUB.valore].contains(tipoAttoDest.intValue()) ){
            String s2 = ( getCognome2EstremiAtto() + ( getNome2EstremiAtto()?" ":"") + getNome2EstremiAtto() )
            s = s + ( ( getCognome1EstremiAtto(tipoFormula) || getNome1EstremiAtto(tipoFormula) )?" / ":"") + s2
        }
        return s
    }

    String getEstremiAttoLista(){
        String parteSerie = ((parte != null)? "-" + String.valueOf(parte)+(serie?:"") : "")
        return (atto + parteSerie + (ufficio ? "-$ufficio" : "") + (anno?"/" + String.valueOf(anno):""))
    }

    abstract String getIdAttoAnsc()

    abstract Long getNumeroUnico()

    String getEstremiAttoListaNotAnsc() {
        String parteSerie = ((parte != null)? "-" + String.valueOf(parte)+(serie?:"") : "")
        return (atto + parteSerie + (ufficio ? "-$ufficio" : "") + (anno?"/" + String.valueOf(anno):""))
    }

    String getEstremiAttoListaPdf() {
        String result
        if(idAttoAnsc != null) {
            result = idAttoAnsc
        } else if (numeroUnico != null) {
            result = numeroUnico + (anno?"/" + String.valueOf(anno):"")
        } else {
            result = estremiAttoListaNotAnsc
        }
        return result
    }

    abstract Boolean isUfficialeStatoCivileMandatory()

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Numero"), Etichette.getEtichetta("Numero_comunale"), Etichette.getEtichetta("Id_Atto_Ansc"), Etichette.getEtichetta("Caso_Uso_Ansc"), Etichette.getEtichetta("Motivo_recupero")]

}
