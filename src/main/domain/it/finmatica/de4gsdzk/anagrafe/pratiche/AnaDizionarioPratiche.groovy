package it.finmatica.de4gsdzk.anagrafe.pratiche

import it.finmatica.de4gsdzk.anagrafe.ETipoAnagrafe
import it.finmatica.de4gsdzk.utils.ETipoPratica

import javax.persistence.Column
import javax.persistence.Convert
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Table

@Entity
@Table(name = "ANATPR_V_DIZ")
class AnaDizionarioPratiche {

    @Id
    @Column(name = "ID")
    String id

    @Convert(converter = ETipoAnagrafe.EnumTipoAnagrafeToStringConverter.class)
    @Column(name ="ANAGRAFE")
    ETipoAnagrafe archivioAnagrafe

    @Convert(converter = ETipoPratica.EnumTipoPraticaToStringConverter.class)
    @Column(name ="TIPO_EVENTO")
    ETipoPratica tipoPratica

    @Convert(converter = ETipoArchivioDizionario.EnumTipoArchivioDizionarioToStringConverter.class)
    @Column(name ="COD_ARCHIVIO")
    ETipoArchivioDizionario codiceArchivio

    @Column(name ="DES_ARCHIVIO")
    String descrizioneArchivio

    @Column(name = "CODICE")
    String codice

    @Column(name ="DESCRIZIONE")
    String descrizione

    @Column(name = "SEQUENZA")
    Integer sequenza

}
