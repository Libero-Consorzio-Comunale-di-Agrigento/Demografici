package it.finmatica.de4gsdzk.certificazione

import it.finmatica.de4gsdzk.utils.DataUtils
import it.finmatica.de4gsdzk.utils.ETipoSoggetto
import it.finmatica.de4gsdzk.utils.Etichette

class RicercaCertificato extends BaseRicercaCertificato {

    Integer annoEmissione
    Integer progressivoEmissione
    String cognomeTipoSoggettoCertificato
    String nomeTipoSoggettoCertificato
    CerTipoCertificato tipoCertificato
    ETipoSoggetto tipoSoggettoCertificato

    RicercaCertificato() {
        this.escludiAnnullati = Boolean.TRUE
        this.tipoSoggettoCertificato = ETipoSoggetto.BENEFICIARIO_CERTIFICATO

        this.dataEmissioneDal = DataUtils.getDataCorrente()
        this.dataEmissioneAl = DataUtils.getDataCorrente()
    }

    static final List<Map> etichetteRicercaCerDesc = [Etichette.getEtichetta("Effettua_Ricerca"), Etichette.getEtichetta("Da"), Etichette.getEtichetta("A"),
                                                      Etichette.getEtichetta("Escludi_annullati"),Etichette.getEtichetta("Annullati"),Etichette.getEtichetta("Tipo_Soggetto"), Etichette.getEtichetta("Tutti")]

}
