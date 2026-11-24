package it.finmatica.de4gsdzk.anagrafe.pratiche

import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafe
import it.finmatica.de4gsdzk.anagrafe.ETipoAnagrafe
import it.finmatica.de4gsdzk.utils.ETipoPratica

interface ISoggettoPratica {

    AnaPratica getPratica()
    void setPratica(AnaPratica pratica)

    String getIdPratica()
    void setIdPratica(String idPratica)

    ETipoAnagrafe getArchivioAnagrafe()
    void setArchivioAnagrafe(ETipoAnagrafe archivioAnagrafe)

    ETipoPratica getTipoPratica()
    void setTipoPratica(ETipoPratica tipoPratica)

    AnaAnagrafe getAnagrafe()
    void setAnagrafe(AnaAnagrafe anagrafe)

    IDichiarazionePratica getDichiarazione()
    void setDichiarazione(IDichiarazionePratica dichiarazione)

    Boolean getFlagAnnullamento()
    void setFlagAnnullamento(Boolean flag)

    Integer getNumeroOrdine()
    void setNumeroOrdine(Integer numeroOrdine)

    Boolean getFlagSoggetto()
    void setFlagSoggetto(Boolean flag)

    AnaRapportoParentela getRapportoParentelaPrecedente()
    void setRapportoParentelaPrecedente(AnaRapportoParentela rapportoParentela)
    void setCodRpPrecedente(String codRpPrecedente)
    void setSequenzaRpPrecedente(Integer sequenzaRpPrecedente)

    AnaRapportoParentela getRapportoParentelaNuovo()
    void setRapportoParentelaNuovo(AnaRapportoParentela rapportoParentela)
    void setNuovoCodRp(String NuovocodRp)
    void setNuovaSequenzaRp(Integer NuovasequenzaRp)
}