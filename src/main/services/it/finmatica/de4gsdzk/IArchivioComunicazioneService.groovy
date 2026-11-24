package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.utils.EStatoProtocollazione

interface IArchivioComunicazioneService {

    Boolean checkAllegatoPrincipale(Long idArcCom)

    String firmaComunicazione(List<IArchivioComunicazione> listaArcCom, String idsArcCom, Long idAlle, String codUte, String otp)

    String protocolla(IArchivioComunicazione obj)

    String inviaAlbo(IArchivioComunicazione obj)

    void bloccaSeProtocollata(IArchivioComunicazione obj)

    void bloccaSeInviataAlbo(IArchivioComunicazione obj)

    void bloccaSeStampaEseguita(IArchivioComunicazione obj)

    void deleteComunicazione(IArchivioComunicazione obj)

    EStatoProtocollazione getStatoProtocollazione(Long id)


}