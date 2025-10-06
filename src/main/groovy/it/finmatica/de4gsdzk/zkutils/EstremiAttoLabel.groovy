package it.finmatica.de4gsdzk.zkutils

import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.statocivile.embed.EstremiAtto
import it.finmatica.de4gsdzk.config.Holders
import it.finmatica.de4gsdzk.utils.Etichette

class EstremiAttoLabel extends CustomLabel {

    Map<String, String> etichette = [:]

    EstremiAtto estremiAtto

    EstremiAttoLabel() {
        super()
        super.setMultiline(false)

        List<Map> eList = [Etichette.Provvisorio, Etichette.Parte, Etichette.Serie, Etichette.Anno, Etichette.Ufficio]

        etichette = Holders.getApplicationContext().getBean(GsdEtichettaService.class).listAndInsertWhereIdIn(eList)
    }

    @Override
    void setValue(def value) {
        estremiAtto = value as EstremiAtto

        if (value == null) {
            super.setValue(null)
            return
        }

        if (estremiAtto.idAttoAnsc) {
            super.setValue(estremiAtto.idAttoAnsc)
            return
        }

        if (estremiAtto.atto != null) {
            super.setValue("${estremiAtto.atto > 0 ? estremiAtto.atto : etichette['Provvisorio']}${estremiAtto.parte ? ' - ' + etichette['Parte'] + ' ' + estremiAtto.parte : ''}${estremiAtto.serie ? ' - ' + etichette['Serie'] + ' ' + estremiAtto.serie : ''}${estremiAtto.anno ? ' - ' + etichette['Anno'] + ' ' + estremiAtto.anno : ''}${estremiAtto.ufficio ? ' - ' + etichette['Ufficio'] + ' ' + estremiAtto.ufficio : ''}")
            return
        }

        super.setValue(null)
    }

    void setAtto(Integer atto) {
        if (estremiAtto == null) {
            estremiAtto = new EstremiAtto()
        }

        estremiAtto.atto = atto
        setValue(estremiAtto)
    }

    void setParte(Integer parte) {
        if (estremiAtto == null) {
            estremiAtto = new EstremiAtto()
        }

        estremiAtto.parte = parte
        setValue(estremiAtto)
    }

    void setSerie(String serie) {
        if (estremiAtto == null) {
            estremiAtto = new EstremiAtto()
        }

        estremiAtto.serie = serie
        setValue(estremiAtto)
    }

    void setAnno(Integer anno) {
        if (estremiAtto == null) {
            estremiAtto = new EstremiAtto()
        }

        estremiAtto.anno = anno
        setValue(estremiAtto)
    }

    void setUfficio(Integer ufficio) {
        if (estremiAtto == null) {
            estremiAtto = new EstremiAtto()
        }

        estremiAtto.ufficio = ufficio
        setValue(estremiAtto)
    }

    void setIdAttoAnsc(String idAttoAnsc) {
        if (estremiAtto == null) {
            estremiAtto = new EstremiAtto()
        }

        estremiAtto.idAttoAnsc = idAttoAnsc
        setValue(estremiAtto)
    }

}