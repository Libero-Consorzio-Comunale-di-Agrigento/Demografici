package it.finmatica.de4gsdzk.elettorale

import javax.persistence.Column
import javax.persistence.Convert
import javax.persistence.MappedSuperclass

@MappedSuperclass
class EleElettoreListaSezionaleBaseDomain extends EleElettoreListaBaseDomain {

    @Column(name = "PROGR_LISTA_SEZ", nullable = true, updatable = false, insertable = false)
    Long progressivoSezionale

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_DEPENNATO_ART_33", nullable = true)
    Boolean flagDepennatoArt33

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_VOTO_ESTERO", nullable = true)
    Boolean flagVotoEstero

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_OPZIONE_VOTO_ITALIA", nullable = true)
    Boolean flagOpzioneVotoItalia

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_FUORI_SEDE", nullable = true)
    Boolean flagFuoriSede

    @Column(name = "COGNOME_ORD", nullable = true, updatable = false, insertable = false)
    String cognomeOrdinamento

    @Column(name = "NOME_ORD", nullable = true, updatable = false, insertable = false)
    String nomeOrdinamento

}
