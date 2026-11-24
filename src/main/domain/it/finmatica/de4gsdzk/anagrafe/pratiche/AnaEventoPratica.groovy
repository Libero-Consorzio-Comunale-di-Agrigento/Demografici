package it.finmatica.de4gsdzk.anagrafe.pratiche

import it.finmatica.de4gsdzk.GsdBaseDomain

import javax.persistence.*

@Entity
@Table(name = "ANADEP")
class AnaEventoPratica {

    @Id
    @Column(name = "COD_EP")
    Integer codEp

    @Column(name = "DESCRIZIONE")
    String descrizione

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_ON_LINE", nullable = true)
    Boolean flagOnline

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_ESITO", nullable = true)
    Boolean flagEsito

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_PERFEZIONAMENTO", nullable = true)
    Boolean flagPerfezionamento

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_ANNULLAMENTO", nullable = true)
    Boolean flagAnnullamento

    //Per oggetto dummy
    AnaEventoPratica() {}

    AnaEventoPratica(Integer codEp, String descrizone){
        this.codEp = codEp
        this.descrizione = descrizone
    }
}
