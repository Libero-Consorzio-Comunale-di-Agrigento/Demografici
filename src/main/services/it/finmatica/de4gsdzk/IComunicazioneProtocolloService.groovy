package it.finmatica.de4gsdzk

interface IComunicazioneProtocolloService {

    IComunicazioneProtocollo get(Long id)

    IComunicazioneProtocollo save(IComunicazioneProtocollo protocollo, IArchivioComunicazione archivioComunicazione)

}