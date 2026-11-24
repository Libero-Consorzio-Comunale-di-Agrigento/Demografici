package it.finmatica.de4gsdzk

interface IComunicazioneAllegatoRepository {

    IComunicazioneAllegato findById(Long id)

    IComunicazioneAllegato findPrincipale(Long idArcCom)

    List<IComunicazioneAllegato> findAllMetadatiByArchivioComunicazione(Long idArcCom)

    Integer checkAllegatiDaFirmare(List<Long> listaIdArcCom)

    Integer getNumAllegatiComunicazioneByNome(Long idArcCom, Long id, String nomeAllegato)

}