package it.finmatica.de4gsdzk.anagrafe.pratiche

import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafe
import it.finmatica.de4gsdzk.istat.IstatDizionarioDettagliSoggetto
import it.finmatica.de4gsdzk.utils.ESesso

interface ISoggettoPraticaIscrizione {

    AnaAnagrafe getAnagrafe()
    void setAnagrafe(AnaAnagrafe anagrafe)

    ESesso getSesso()
    void setSesso(ESesso sesso)

    AnaRapportoParentelaIstat getRapportoParentela()
    void setRapportoParentela(AnaRapportoParentelaIstat rapportoParentela)

    IstatDizionarioDettagliSoggetto getTitoloStudioIstat()
    void setTitoloStudioIstat(IstatDizionarioDettagliSoggetto titoloStudioIstat)

    IstatDizionarioDettagliSoggetto getProfessioneIstat()
    void setProfessioneIstat(IstatDizionarioDettagliSoggetto professioneIstat)

    Integer getCodiceTitoloStudioIstat()
    void setCodiceTitoloStudioIstat(Integer codiceTitoloStudioIstat)

    Integer getCodiceProfessioneIstat()
    void setCodiceProfessioneIstat(Integer codiceProfessioneIstat)

    void setIstRp(String istRp)

}