package it.finmatica.de4gsdzk.zkutils

import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafe
import it.finmatica.de4gsdzk.config.Holders
import it.finmatica.de4gsdzk.utils.Etichette

class EstremiAnagrafeLabel extends CustomLabel {

    Map<String, String> etichette = [:]

    AnaAnagrafe anagrafe

    EstremiAnagrafeLabel() {
        super()
        super.setMultiline(true)

        List<Map> eList = [Etichette.Matricola, Etichette.Id_scheda_ANPR, Etichette.Id_unico_nazionale]

        etichette = Holders.getApplicationContext().getBean(GsdEtichettaService.class).listAndInsertWhereIdIn(eList)
    }

    @Override
    void setValue(def value) {
        anagrafe = value as AnaAnagrafe

        if (value == null) {
            super.setValue(null)
            return
        }

        super.setValue("${anagrafe.cognome} ${anagrafe.nome} - " +
                "${etichette['Matricola']} ${anagrafe.matricola}" +
                "${anagrafe.idSoggettoAnpr ? '\n' + etichette['Id_scheda_ANPR'] + ' ' + anagrafe.idSoggettoAnpr : ''}" +
                "${anagrafe.idUnicoAnpr ? ' - ' + etichette['Id_unico_nazionale'] + ' ' + anagrafe.idUnicoAnpr : ''}")

    }

}