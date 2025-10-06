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

        this.dataEmissioneDal = DataUtils.getDataCorrente()
        this.dataEmissioneAl = DataUtils.getDataCorrente()
    }

    Boolean findRichiedenti(){
        return tipoSoggettoCertificato == ETipoSoggetto.RICHIEDENTE_CERTIFICATO || tipoSoggettoCertificato == null
    }

    Boolean findBeneficiari(){
        return tipoSoggettoCertificato == ETipoSoggetto.BENEFICIARIO_CERTIFICATO || tipoSoggettoCertificato == null
    }

    static final List<Map> etichetteRicercaCerDesc = [Etichette.Effettua_Ricerca, Etichette.Da, Etichette.A,
                                                      Etichette.Escludi_annullati, Etichette.Annullati, Etichette.Tipo_Soggetto, Etichette.Tutti]

}
