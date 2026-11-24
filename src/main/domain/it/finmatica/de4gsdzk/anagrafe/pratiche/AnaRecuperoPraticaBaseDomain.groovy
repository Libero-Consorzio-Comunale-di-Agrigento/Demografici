package it.finmatica.de4gsdzk.anagrafe.pratiche

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.anagrafe.ETipoAnagrafe
import it.finmatica.de4gsdzk.utils.ETipoPratica
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@MappedSuperclass
abstract class AnaRecuperoPraticaBaseDomain extends GsdBaseDomain {

    @Id
    @Column(name = "ID")
    Long id

    @Convert(converter = ETipoAnagrafe.EnumTipoAnagrafeToStringConverter.class)
    @Column(name ="ANAGRAFE", updatable = false, insertable = false)
    ETipoAnagrafe archivioAnagrafe

    @Convert(converter = ETipoPratica.EnumTipoPraticaToStringConverter.class)
    @Column(name ="TIPO_EVENTO", updatable = false, insertable = false)
    ETipoPratica tipoPratica

    @Column(name ="MATRICOLA_DIC", nullable = true, updatable = false, insertable = false)
    Integer matricolaDichiarante

    @Column(name ="DICHIARANTE", nullable = true, updatable = false, insertable = false)
    String dichiarante

    @Temporal(TemporalType.DATE)
    @Column(name= "D_DATA_INOLTRO", nullable = true, updatable = false, insertable = false)
    Date dataInoltro

    @Column(name ="COD_FAM_PROV", nullable = true, updatable = false, insertable = false)
    Long codFamigliaProvenienza

    @Column(name ="UTENTE", nullable = true, updatable = false, insertable = false)
    String utente

    @Column(name ="INDIRIZZO_WEB", nullable = true, updatable = false, insertable = false)
    String email

    @Column(name ="TELEFONO", nullable = true, updatable = false, insertable = false)
    String telefono

    @Column(name ="NOTE", nullable = true, updatable = false, insertable = false)
    String note

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_INOLTRO", nullable = true, updatable = false, insertable = false)
    Boolean flagInoltro

    @Column(name ="PRATICA", nullable = true)
    Integer pratica

    @Column(name ="ANNO_PRATICA", nullable = true)
    Integer annoPratica

    abstract List<IAllegatoPratica> getAllegati()

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Archivio_Anagrafe"), Etichette.getEtichetta("Tipo_Pratica"), Etichette.getEtichetta("Matricola_Dichiarante"), Etichette.getEtichetta("Dichiarante"),
                                              Etichette.getEtichetta("Data_Inoltro"), Etichette.getEtichetta("Codice_Famiglia_Provenienza"),
                                              Etichette.getEtichetta("Utente"), Etichette.getEtichetta("Email"), Etichette.getEtichetta("Numero_Telefonico"), Etichette.getEtichetta("Note")]



}
