package restrict.anagrafe.pratiche

import it.finmatica.de4gsdzk.anagrafe.DatiCivico
import it.finmatica.de4gsdzk.anagrafe.pratiche.IDichiarazionePratica
import it.finmatica.de4gsdzk.archivi.ArcDatiNumerazioneCivico
import it.finmatica.de4gsdzk.archivi.ArcDatiNumerazioneCivicoService
import it.finmatica.de4gsdzk.statocivile.embed.indirizzo.IndirizzoCivico
import it.finmatica.de4gsdzk.utils.Etichette
import org.zkoss.bind.BindUtils
import org.zkoss.bind.annotation.BindingParam
import org.zkoss.bind.annotation.Command

trait TraitGestioneCivico {

    List<ArcDatiNumerazioneCivico> elementiCivicoEsterno = []
    List<ArcDatiNumerazioneCivico> elementiCivicoInterno = []
    Set<String> elementiPresenti = new HashSet<>()
    Map<String, Integer> widthElementi = [:]
    DatiCivico civico = new DatiCivico()

    private static final Set<String> ELEMENTI_INLINE = (['SUB_INTERNO', 'SUB_INTERNO2', 'FLAG_METRICO', 'FLAG_LETTERA', 'FLAG_ESPONENTE', 'FLAG_NUI'] as Set)
    private static final Map<String, String> MAPPING_SUB = [
            'INTERNO' : 'SUB_INTERNO',
            'INTERNO2': 'SUB_INTERNO2'
    ]
    private static final Map<String, List<String>> ELEMENTI_CORRELATI = [
            'NUM_CIV' : ['NUM_CIV', 'FLAG_METRICO'],
            'SUFFISSO': ['SUFFISSO', 'FLAG_LETTERA', 'FLAG_ESPONENTE'],
            'INTERNO' : ['INTERNO', 'SUB_INTERNO', 'FLAG_NUI'],
            'INTERNO2': ['INTERNO2', 'SUB_INTERNO2']
    ]

    abstract ArcDatiNumerazioneCivicoService getArcDatiNumerazioneCivicoService()

    abstract IDichiarazionePratica getDichiarazione()

    List<Map<String, String>> getEtichetteGestioneCivico() {
        List<Map<String, String>> eList = [Etichette.getEtichetta("Seleziona")]
        eList.addAll([Etichette.getEtichetta("Specie_Area"), Etichette.getEtichetta("Toponimo"),
                      Etichette.getEtichetta("Civico_Esterno"), Etichette.getEtichetta("Civico_Interno")])
        eList.addAll([Etichette.getEtichetta("NUM_CIV"), Etichette.getEtichetta("SUFFISSO"),
                      Etichette.getEtichetta("INTERNO"), Etichette.getEtichetta("SUB_INTERNO"),
                      Etichette.getEtichetta("SCALA"), Etichette.getEtichetta("SCALA_ESTERNA"), Etichette.getEtichetta("PIANO"),
                      Etichette.getEtichetta("FLAG_METRICO"), Etichette.getEtichetta("FLAG_LETTERA"),
                      Etichette.getEtichetta("FLAG_ESPONENTE"), Etichette.getEtichetta("FLAG_NUI"),
                      Etichette.getEtichetta("PROGR_SNC"), Etichette.getEtichetta("COLORE"),
                      Etichette.getEtichetta("CORTE"), Etichette.getEtichetta("INTERNO2"),
                      Etichette.getEtichetta("SUB_INTERNO2"), Etichette.getEtichetta("SECONDARIO"),
                      Etichette.getEtichetta("NUI")])

        return eList

    }

    void caricaElementiCivico(Long codVia = null, boolean applicaDefaults = false) {
        Map<String, List<ArcDatiNumerazioneCivico>> partizioni = getArcDatiNumerazioneCivicoService().getElementiVisibiliPartizionati(codVia)
        elementiPresenti.clear()
        elementiCivicoEsterno.clear()
        elementiCivicoInterno.clear()
        widthElementi.clear()
        civico = DatiCivico.fromEntity(getDichiarazione().indirizzo)
        partizioni.esterno.each { processaElemento(it, elementiCivicoEsterno, applicaDefaults) }
        partizioni.interno.each { processaElemento(it, elementiCivicoInterno, applicaDefaults) }
    }

    private void processaElemento(ArcDatiNumerazioneCivico el, List<ArcDatiNumerazioneCivico> dest, boolean applicaDefaults) {
        elementiPresenti.add(el.elemento)
        widthElementi[el.elemento] = el.widthElemento
        if (applicaDefaults && el.flag && el.flagDefault && el.proprieta && civico."${el.proprieta}" == null) {
            civico."${el.proprieta}" = true
        }
        if (!(el.elemento in ELEMENTI_INLINE)) dest.add(el)
    }

    @Command
    boolean hasSubElemento(String elemento) {
        String sub = MAPPING_SUB[elemento]
        return sub && sub in elementiPresenti
    }

    @Command
    String getSubProprieta(String elemento) {
        String sub = MAPPING_SUB[elemento]
        return sub ? ArcDatiNumerazioneCivico.snakeToCamel(sub) : null
    }

    @Command
    Integer getSubWidth(String elemento) {
        String sub = MAPPING_SUB[elemento]
        return sub ? widthElementi[sub] : null
    }

    @Command
    boolean isElementoPresente(String elemento) {
        return elemento in elementiPresenti
    }

    @Command
    void onCheckFlagLettera() {
        if (civico.flagLettera) {
            civico.flagEsponente = false
        }
        BindUtils.postNotifyChange(null, null, this, "civico")
    }

    @Command
    void onCheckFlagEsponente() {
        if (civico.flagEsponente) {
            civico.flagLettera = false
        }
        BindUtils.postNotifyChange(null, null, this, "civico")
    }

    @Command
    void onCancellaCampoCivico(@BindingParam("elemento") String elemento) {
        List<String> daCancellare = ELEMENTI_CORRELATI[elemento] ?: [elemento]
        daCancellare.each { el ->
            civico.reset(ArcDatiNumerazioneCivico.snakeToCamel(el))
        }
        getDichiarazione().codFamigliaDest = null
        getDichiarazione().famigliaDest = null
        BindUtils.postNotifyChange(null, null, this, "civico")
        BindUtils.postNotifyChange(null, null, this, "dichiarazione")
    }
    
    void copiaDatiIndirizzo(IndirizzoCivico to, IndirizzoCivico from) {
        to.via = from?.via
        to.numeroCivico = from?.numeroCivico
        to.suffisso = from?.suffisso
        to.interno = from?.interno
        to.subInterno = from?.subInterno
        to.scala = from?.scala
        to.scalaEsterna = from?.scalaEsterna
        to.piano = from?.piano

        to.flagMetrico = from?.flagMetrico
        to.progrSnc = from?.progrSnc
        to.flagLettera = from?.flagLettera
        to.flagEsponente = from?.flagEsponente
        to.colore = from?.colore
        to.corte = from?.corte
        to.interno2 = from?.interno2
        to.subInterno2 = from?.subInterno2
        to.secondario = from?.secondario
        to.flagNui = from?.flagNui
        to.nui = from?.nui
    }
}
