package it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.anagrafe.ETipoAnagrafe
import it.finmatica.de4gsdzk.anagrafe.pratiche.AnaEventoPratica
import it.finmatica.de4gsdzk.utils.ETipoPratica
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "ANADCT_V")
class AnaComunicazionePratica extends GsdBaseDomain {

    @Id
    @Column(name = "ID")
    String id

    @Column(name = "NUMERO_COPIE", nullable = true)
    Integer numeroCopie

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="CODICE_CO", nullable = false)
    AnaComunicazione comunicazione

    @Convert(converter = ETipoAnagrafe.EnumTipoAnagrafeToStringConverter.class)
    @Column(name ="ANAGRAFE")
    ETipoAnagrafe archivioAnagrafe

    @Convert(converter = ETipoPratica.EnumTipoPraticaToStringConverter.class)
    @Column(name ="TIPO_EVENTO")
    ETipoPratica tipoPratica

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="ID_ANADEP", nullable = false)
    AnaEventoPratica eventoPratica


    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Archivio_Anagrafe"), Etichette.getEtichetta("Tipo_Pratica"),
                                              Etichette.getEtichetta("Numero_copie"), Etichette.getEtichetta("Evento_Pratica_Automatico")]
}
