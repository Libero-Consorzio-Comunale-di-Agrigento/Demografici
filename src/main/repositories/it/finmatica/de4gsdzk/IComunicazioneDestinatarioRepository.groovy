package it.finmatica.de4gsdzk

interface IComunicazioneDestinatarioRepository {

    IComunicazioneDestinatario findById(Long id)

    List<IComunicazioneDestinatario> findAllByArchivioComunicazione(Long idArcCom)

    IComunicazioneDestinatario save(IComunicazioneDestinatario obj)

    IComunicazioneDestinatario delete(IComunicazioneDestinatario obj)

}