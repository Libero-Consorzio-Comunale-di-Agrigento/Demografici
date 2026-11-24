package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaComunicazioneDestinatario

interface IComunicazioneDestinatarioService {

    List<AnaComunicazioneDestinatario> listAllByArchivioComunicazione(Long idArcCom)

    IComunicazioneDestinatario get (Long id)

    void delete(IComunicazioneDestinatario obj)

    IComunicazioneDestinatario save (IComunicazioneDestinatario obj)

    String inviaPec(IComunicazioneDestinatario obj)

}