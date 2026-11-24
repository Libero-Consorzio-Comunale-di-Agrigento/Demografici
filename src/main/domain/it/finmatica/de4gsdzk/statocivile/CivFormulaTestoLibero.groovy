package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.IRiferimentoAttoDomain
import it.finmatica.de4gsdzk.utils.ETipoSN
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.FormulaUtils

import javax.persistence.*

@Entity
@Table(name = "CIVTLI_FORMULE")
class CivFormulaTestoLibero implements IRiferimentoAttoDomain{

    @Id
    @Column(name = "ID")
    Long id

    @Column(name = "ID_ATTO", nullable = false)
    String idAtto

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

    @Column(name = "TIPO_ATTO", nullable = false)
    Integer tipoAtto

    @Column(name = "RICHIAMO", nullable = false)
    Integer richiamo

    @Column(name = "PROGR_DETTAGLIO", nullable = true)
    Integer progressivo

    @Column(name = "NUM_RIGHE", nullable = true)
    Integer numeroRighe

    @Column(name = "NUM_COLONNE", nullable = true)
    Integer numeroColonne

    @Enumerated(EnumType.STRING)
    @Column(name = "FLAG_AGGIUNTA_A_CAPO", nullable = true)
    private ETipoSN aCapoDb

    Boolean getACapo() {
        return (aCapoDb == ETipoSN.S)
    }
    void setACapo(Boolean val) {
        this.aCapoDb = (val?ETipoSN.S:null)
    }

    @Lob
    @Column(name = "TESTO_CLOB", nullable = true)
    String testo

    @Version
    @Column(nullable = false)
    Long version

    Boolean isFormulaTestataTrascrizione(){
        Boolean val = ( (this.richiamo?.compareTo(FormulaUtils.getRichiamoTestataTrascrizione()) == 0) && (this.progressivo?.compareTo(FormulaUtils.getProgressivoTestataTrascrizione()) == 0) )
        return val
    }

    Boolean isFormulaTestata(){
        Boolean val = ( (this.richiamo?.compareTo(FormulaUtils.getRichiamoTestata()) == 0) && (this.progressivo?.compareTo(FormulaUtils.getProgressivoTestata()) == 0) )
        return val
    }

    Boolean isFormulaDatiMatrimonio(){
        Boolean val = ( (this.richiamo?.compareTo(FormulaUtils.getRichiamoDatiMatrimonio()) == 0) && (this.progressivo?.compareTo(FormulaUtils.getProgressivoDatiMatrimonio()) == 0) )
        return val
    }

    Boolean isFormulaSposi(){
        Boolean val = ( (this.richiamo?.compareTo(FormulaUtils.getRichiamoSposi()) == 0) && (this.progressivo?.compareTo(FormulaUtils.getProgressivoSposi()) == 0) )
        return val
    }

    Boolean isFormulaContraenti(){
        Boolean val = ( (this.richiamo?.compareTo(FormulaUtils.getRichiamoContraenti()) == 0) && (this.progressivo?.compareTo(FormulaUtils.getProgressivoContraenti()) == 0) )
        return val
    }

    Boolean isFormulaRichiestaFissa(){
        Boolean val = ( (this.richiamo?.compareTo(FormulaUtils.getRichiamoRichiesta()) == 0) && (this.progressivo?.compareTo(FormulaUtils.getProgressivoRichiestaFissa()) == 0) )
        return val
    }

    Boolean isFormulaRichiesta(){
        Boolean val = ( (this.richiamo?.compareTo(FormulaUtils.getRichiamoRichiesta()) == 0) && (this.progressivo?.compareTo(FormulaUtils.getProgressivoRichiesta()) == 0) )
        return val
    }

    Boolean isFormulaTestimoni(){
        Boolean val = ( (this.richiamo?.compareTo(FormulaUtils.getRichiamoTestimoni()) == 0) && (this.progressivo?.compareTo(FormulaUtils.getProgressivoTestimoni()) == 0) )
        return val
    }

    Boolean isFormulaDatiDecesso(){
        Boolean val = ( (this.richiamo?.compareTo(FormulaUtils.getRichiamoDatiDecesso()) == 0) && (this.progressivo?.compareTo(FormulaUtils.getProgressivoDatiDecesso()) == 0) )
        return val
    }

    Boolean isFormulaDatiIntegrativi(){
        Boolean val = ( (this.richiamo?.compareTo(FormulaUtils.getRichiamoDatiIntegrativi()) == 0) && (this.progressivo?.compareTo(FormulaUtils.getProgressivoDatiIntegrativi()) == 0) )
        return val
    }

    Boolean isFormulaApostille(){
        Boolean val = ( (this.richiamo?.compareTo(FormulaUtils.getRichiamoApostille()) == 0) && (this.progressivo?.compareTo(FormulaUtils.getProgressivoGenericoApostilleGreaterThen()) > 0) )
        return val
    }

    Boolean isFormulaDocumenti(){
        Boolean val = ( (this.richiamo?.compareTo(FormulaUtils.getRichiamoDocumenti()) == 0) && (this.progressivo?.compareTo(FormulaUtils.getProgressivoDocumenti()) == 0) )
        return val
    }

    Boolean isFormulaDocumentiFissa(){
        Boolean val = ( (this.richiamo?.compareTo(FormulaUtils.getRichiamoDocumentiFisso()) == 0) && (this.progressivo?.compareTo(FormulaUtils.getProgressivoDocumentiFisso()) == 0) )
        return val
    }

    Boolean isFormulaDocumentiAltro(){
        Boolean val = ( (this.richiamo?.compareTo(FormulaUtils.getRichiamoDocumentiAltro()) == 0) && (this.progressivo?.compareTo(FormulaUtils.getProgressivoDocumentiAltro()) == 0) )
        return val
    }

    Boolean isFormulaCongiunti(){
        Boolean val = ( (this.richiamo?.compareTo(FormulaUtils.getRichiamoCongiunti()) == 0) && (this.progressivo?.compareTo(FormulaUtils.getProgressivoCongiunti()) == 0) )
        return val
    }

    Boolean isFormulaDichiaranteFissa(){
        Boolean val = ( (this.richiamo?.compareTo(FormulaUtils.getRichiamoDichiaranteFisso()) == 0) && (this.progressivo?.compareTo(FormulaUtils.getProgressivoDichiaranteFisso()) == 0) )
        return val
    }

    Boolean isFormulaDichiarante(){
        Boolean val = ( (this.richiamo?.compareTo(FormulaUtils.getRichiamoDichiarante()) == 0) && (this.progressivo?.compareTo(FormulaUtils.getProgressivoGenericoDichiaranteGreaterThen()) > 0) )
        return val
    }

    Boolean isFormulaFiliazioneFissa(){
        Boolean val = ( (this.richiamo?.compareTo(FormulaUtils.getRichiamoFiliazioneFisso()) == 0) && (this.progressivo?.compareTo(FormulaUtils.getProgressivoFiliazioneFisso()) == 0) )
        return val
    }

    Boolean isFormulaFiliazione(){
        Boolean val = ( (this.richiamo?.compareTo(FormulaUtils.getRichiamoFiliazione()) == 0) && (this.progressivo?.compareTo(FormulaUtils.getProgressivoGenericoFiliazioneGreaterThen()) > 0) )
        return val
    }

    Boolean isFormulaPresentazione(){
        Boolean val = ( this.richiamo?.compareTo(FormulaUtils.getRichiamoPresentazione()) == 0 )
        return val
    }

    Boolean isFormulaPartoPlurimo(){
        Boolean val = ( (this.richiamo?.compareTo(FormulaUtils.getRichiamoPartoPlurimo()) == 0) && (this.progressivo?.compareTo(FormulaUtils.getProgressivoPartoPlurimo()) == 0) )
        return val
    }

    Boolean isFormulaStatoNascita(){
        Boolean val = ( (this.richiamo?.compareTo(FormulaUtils.getRichiamoStatoNascita()) == 0) && (this.progressivo?.compareTo(FormulaUtils.getProgressivoStatoNascita()) == 0) )
        return val
    }

    Boolean isFormulaCircostanzeParticolari(){
        Boolean val = ( (this.richiamo?.compareTo(FormulaUtils.getRichiamoCircostanzeParticolari()) == 0) && (this.progressivo?.compareTo(FormulaUtils.getProgressivoGenericoCircostanzeParticolariGreaterThen()) > 0) )
        return val
    }

    Boolean isFormulaMatrimonioConcordatario(){
        Boolean val = ( (this.richiamo?.compareTo(FormulaUtils.getRichiamoMatrimonioConcordatario()) == 0) && (this.progressivo?.compareTo(FormulaUtils.getProgressivoMatrimonioConcordatario()) == 0) )
        return val
    }

    Boolean isFormulaAmmissioneOltreImpedimenti(){
        Boolean val = ( (this.richiamo?.compareTo(FormulaUtils.getRichiamoAmmissioneOltreImpedimenti()) == 0) && (this.progressivo?.compareTo(FormulaUtils.getProgressivoAmmissioneOltreImpedimenti()) == 0) )
        return val
    }

    Boolean isFormulaRiconoscimentoFigli(){
        Boolean val = ( (this.richiamo?.compareTo(FormulaUtils.getRichiamoRiconoscimentoFigli()) == 0) && (this.progressivo?.compareTo(FormulaUtils.getProgressivoRiconoscimentoFigli()) == 0) )
        return val
    }

    Boolean isFormulaSceltaCognome(){
        Boolean val = ( (this.richiamo?.compareTo(FormulaUtils.getRichiamoSceltaCognome()) == 0) && (this.progressivo?.compareTo(FormulaUtils.getProgressivoSceltaCognome()) == 0) )
        return val
    }

    Boolean isFormulaRegimePatrimoniale(){
        Boolean val = ( (this.richiamo?.compareTo(FormulaUtils.getRichiamoRegimePatrimoniale()) == 0) && (this.progressivo?.compareTo(FormulaUtils.getProgressivoRegimePatrimoniale()) == 0) )
        return val
    }

    Boolean isFormulaMargineMinistro(){
        Boolean val = ( (this.richiamo?.compareTo(FormulaUtils.getRichiamoMargine()) == 0) && (this.progressivo?.compareTo(FormulaUtils.getProgressivoMargineMinistro()) == 0) )
        return val
    }

    Boolean isFormulaChiusura(){
        Boolean val = ( this.richiamo?.compareTo(FormulaUtils.getRichiamoChiusura()) == 0 )
        return val
    }

    Boolean isFormulaPubblicazioni(){
        Boolean val = ( (this.richiamo?.compareTo(FormulaUtils.getRichiamoPubblicazioni()) == 0) && (this.progressivo?.compareTo(FormulaUtils.getProgressivoPubblicazioni()) == 0) )
        return val
    }

    Boolean isFormulaPubblicazioniFissa(){
        Boolean val = ( (this.richiamo?.compareTo(FormulaUtils.getRichiamoPubblicazioniFisso()) == 0) && (this.progressivo?.compareTo(FormulaUtils.getProgressivoPubblicazioniFisso()) == 0) )
        return val
    }

    Boolean isFormulaTestoLibero(){
        Boolean val = ( this.richiamo?.compareTo(FormulaUtils.getRichiamoTestoLibero()) == 0 )
        return val
    }

    Boolean isFormulaFirma(){
        Boolean val = ( (this.richiamo?.compareTo(FormulaUtils.getRichiamoFirma()) == 0) && (this.progressivo?.compareTo(FormulaUtils.getProgressivoFirma()) == 0) )
        return val
    }

    Boolean isFormulaMinistro(){
        Boolean val = ( (this.richiamo?.compareTo(FormulaUtils.getRichiamoMargine()) == 0) && (this.progressivo?.compareTo(FormulaUtils.getProgressivoMargineMinistro()) == 0) )
        return val
    }

    Boolean isFormulaMargineTr1(){
        Boolean val = ( (this.richiamo?.compareTo(FormulaUtils.getRichiamoMargine()) == 0) && (this.progressivo?.compareTo(FormulaUtils.getProgressivoMargineTr1()) == 0) )
        return val
    }

    Boolean isFormulaMargineTr2(){
        Boolean val = ( (this.richiamo?.compareTo(FormulaUtils.getRichiamoMargine()) == 0) && (this.progressivo?.compareTo(FormulaUtils.getProgressivoMargineTr2()) == 0) )
        return val
    }

    Boolean isFormulaMargineConvenzioni(){
        Boolean val = ( (this.richiamo?.compareTo(FormulaUtils.getRichiamoMargine()) == 0) && (this.progressivo?.compareTo(FormulaUtils.getProgressivoMargineConvenzioni()) == 0) )
        return val
    }

    Boolean isFormulaMargineLibretto(){
        Boolean val = ( (this.richiamo?.compareTo(FormulaUtils.getRichiamoMargine()) == 0) && (this.progressivo?.compareTo(FormulaUtils.getProgressivoMargineLibretto()) == 0) )
        return val
    }

    Boolean isFormulaMargineSentenza(){
        Boolean val = ( (this.richiamo?.compareTo(FormulaUtils.getRichiamoMargine()) == 0) && (this.progressivo?.compareTo(FormulaUtils.getProgressivoMargineSentenza()) == 0) )
        return val
    }

    Boolean isFormulaMargineNascita(){
        Boolean val = ( (this.richiamo?.compareTo(FormulaUtils.getRichiamoMargine()) == 0) && (this.progressivo?.compareTo(FormulaUtils.getProgressivoMargineNascita()) == 0) )
        return val
    }

    Boolean isFormulaMargineCognome1(){
        Boolean val = ( (this.richiamo?.compareTo(FormulaUtils.getRichiamoMargine()) == 0) && (this.progressivo?.compareTo(FormulaUtils.getProgressivoMargineCognome1()) == 0) )
        return val
    }

    Boolean isFormulaMargineCognome2(){
        Boolean val = ( (this.richiamo?.compareTo(FormulaUtils.getRichiamoMargine()) == 0) && (this.progressivo?.compareTo(FormulaUtils.getProgressivoMargineCognome2()) == 0) )
        return val
    }

    Boolean isFormulaRichiedenti(){
        Boolean val = ( (this.richiamo?.compareTo(FormulaUtils.getRichiamoRichiedenti()) == 0) && (this.progressivo?.compareTo(FormulaUtils.getProgressivoRichiedenti()) == 0) )
        return val
    }

    Boolean isFormulaRichiedentiFissa(){
        Boolean val = ( (this.richiamo?.compareTo(FormulaUtils.getRichiamoRichiedentiFisso()) == 0) && (this.progressivo?.compareTo(FormulaUtils.getProgressivoRichiedentiFisso()) == 0) )
        return val
    }

    /////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI /////////////////////////////
    /////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [ Etichette.getEtichetta("Ufficio"), Etichette.getEtichetta("Anno"), Etichette.getEtichetta("Parte"), Etichette.getEtichetta("Serie"), Etichette.getEtichetta("Numero_Atto")]


}
