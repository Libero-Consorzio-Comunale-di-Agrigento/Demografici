package it.finmatica.de4gsdzk.anagrafe.pratiche

import it.finmatica.de4gsdzk.anagrafe.AnaFamiglia
import it.finmatica.de4gsdzk.anagrafe.ETipoFamiglia
import it.finmatica.de4gsdzk.statocivile.embed.indirizzo.IndirizzoCivico

interface IDichiarazionePratica {

    AnaPratica getPratica()
    void setPratica(AnaPratica pratica)

    List<ISoggettoPratica> getSoggetti()
    void setSoggetti(List<ISoggettoPratica> soggetti)

    Boolean getFlagAggregazione()

    Long getCodFamigliaDest()
    Long getCodFamigliaProv()
    void setCodFamigliaProv(Long codFamigliaProv)

    AnaFamiglia getFamigliaDest()

    void setIndirizzo(IndirizzoCivico indirizzoCivico)
    IndirizzoCivico getIndirizzo()

    ETipoFamiglia getTipoFamiglia()
    ETipoFamiglia getTipoFamigliaOriginario()

}