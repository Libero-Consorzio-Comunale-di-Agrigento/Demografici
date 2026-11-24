package it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni

import it.finmatica.de4gsdzk.utils.ETipoComunicazioneAnagrafe

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.EnumType
import javax.persistence.Enumerated
import javax.persistence.Id
import javax.persistence.Table

@Entity
@Table(name = "ANADCC")
class AnaCondizioneSql {

    @Id
    @Column(name = "COD_CC")
    Integer id

    @Column(name = "DESCRIZIONE")
    String descrizione

    @Column(name = "CONDIZIONE_SQL")
    String condizione

    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_COMUNICAZIONE")
    ETipoComunicazioneAnagrafe tipoComunicazione


}
