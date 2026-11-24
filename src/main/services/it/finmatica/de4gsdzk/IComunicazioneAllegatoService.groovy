package it.finmatica.de4gsdzk

interface IComunicazioneAllegatoService {

    List<IComunicazioneAllegato> listAllMetadatiByArchivioComunicazione(Long idArcCom)

    IComunicazioneAllegato get(Long id)

    void deleteAllegato(IComunicazioneAllegato obj)

    void deleteComunicazioneEAllegati(IArchivioComunicazione arcCom)

    Boolean checkAllegatiDaFirmare(List<Long> idsArcCom)

}