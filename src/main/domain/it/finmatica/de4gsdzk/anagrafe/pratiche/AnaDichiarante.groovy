package it.finmatica.de4gsdzk.anagrafe.pratiche

import it.finmatica.de4gsdzk.anagrafe.ETipoAnagrafe
import it.finmatica.de4gsdzk.utils.ETipoPratica

import javax.persistence.*

@Entity
@Table(name = "ANATPR_V_ZK_SOGGETTI")
class AnaDichiarante {

    @Id
    @Column(name = "ID")
    String id

    @Convert(converter = ETipoAnagrafe.EnumTipoAnagrafeToStringConverter.class)
    @Column(name ="ANAGRAFE")
    ETipoAnagrafe archivioAnagrafe

    @Convert(converter = ETipoPratica.EnumTipoPraticaToStringConverter.class)
    @Column(name ="TIPO_EVENTO")
    ETipoPratica tipoPratica

    @Column(name ="ANNO_PRATICA", nullable = true)
    Integer annoPratica

    @Column(name ="PRATICA", nullable = true)
    Integer numeroPratica

    @Column(name = "COGNOME_DICHIARANTE", nullable = true)
    String cognome

    @Column(name = "NOME_DICHIARANTE", nullable = true)
    String nome

    @Column(name = "COD_FISCALE_DICHIARANTE", nullable = true)
    String codiceFiscale

    @Column(name = "MATRICOLA_DICHIARANTE", nullable = true)
    String matricola

    @Column(name = "ID_UNICO_ANPR_DICHIARANTE", nullable = true)
    String idAnpr

    @Column(name = "ID_ANPR_DICHIARANTE", nullable = true)
    String idScheda


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_ANATPR")
    AnaPratica pratica

    @Column(name = "ID_PRATICA")
    String idPratica
}
