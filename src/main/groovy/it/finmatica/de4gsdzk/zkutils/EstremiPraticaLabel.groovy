package it.finmatica.de4gsdzk.zkutils

import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.anagrafe.ETipoAnagrafe
import it.finmatica.de4gsdzk.anagrafe.pratiche.AnaPratica
import it.finmatica.de4gsdzk.config.Holders
import it.finmatica.de4gsdzk.utils.ETipoPratica
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.EtichetteUtils

class EstremiPraticaLabel extends CustomLabel {

    Map<String, String> etichette = [:]

    AnaPratica pratica

    EstremiPraticaLabel() {
        super()
        super.setMultiline(true)

        List<Map> eList = [Etichette.getEtichetta("Provvisorio"), Etichette.getEtichetta("Dichiarante"),
                           Etichette.getEtichetta("Non_Assegnato"), Etichette.getEtichetta("Pratica_di")]
        eList.addAll(ETipoAnagrafe.values()*.etichettaDesc)
        eList.addAll(ETipoPratica.values()*.etichettaDesc)

        etichette = Holders.getApplicationContext().getBean(GsdEtichettaService.class).listAndInsertWhereIdIn(eList)
    }

    @Override
    void setValue(def value) {
        pratica = value as AnaPratica

        if (value == null) {
            super.setValue(null)
            return
        }

        String nomeCognomeDichiarante = [pratica.cognomeDichiarante, pratica.nomeDichiarante].findAll { it != null }.join(" ")

        super.setValue("${etichette['Pratica_di']} ${EtichetteUtils.getEtichettaEnum(etichette, pratica.tipoPratica)} ${EtichetteUtils.getEtichettaEnum(etichette, pratica.archivioAnagrafe)}\t: " +
                "${pratica.numero == null ? etichette['Non_Assegnato'] : pratica.numero < 0 ? etichette['Provvisorio'] : pratica.numero} " +
                "/ ${pratica.anno}" +
                "${nomeCognomeDichiarante ? "\n" + etichette['Dichiarante'] + ' : ' + nomeCognomeDichiarante.toUpperCase() : ''}")

    }

}