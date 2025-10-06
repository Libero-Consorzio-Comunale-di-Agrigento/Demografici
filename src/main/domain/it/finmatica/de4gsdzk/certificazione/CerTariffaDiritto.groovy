package it.finmatica.de4gsdzk.certificazione

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "CERDTD")
class CerTariffaDiritto extends GsdBaseDomain {

    @Id
    @Column(name = "ID")
    Long id

    @Convert(converter = EDirittoConverter.class)
    @Column(name = "COD_DIRITTO", nullable = false)
    EDiritto diritto

    @Column(name = "FASCIA_TARIFFARIA", nullable = false)
    Integer fasciaTariffaria

    @Column(name = "DESCRIZIONE", nullable = false)
    String descrizione

    @Column(name = "IMPORTO_1", nullable = false)
    BigDecimal	importo1

    @Column(name = "IMPORTO_2", nullable = true)
    BigDecimal	importo2

    @Column(name = "IMPORTO_1_ON_LINE", nullable = true)
    BigDecimal importo1OnLine

    @Column(name = "IMPORTO_2_ON_LINE", nullable = true)
    BigDecimal importo2OnLine

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "CERDDC_CTC",
            joinColumns = @JoinColumn(name = "ID_CERDTD"),
            inverseJoinColumns = @JoinColumn(name = "ID_CERCTC"))
    @OrderBy("sequenza ASC")
    List<CerCategoriaTipoCertificato> categoriaTipiCertificatoList

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Codice, Etichette.Descrizione,
                                              Etichette.Codice_diritto, Etichette.Fascia_tariffaria,
                                              Etichette.Importo_1, Etichette.Importo_2,
                                              Etichette.Importo_1_on_line, Etichette.Importo_2_on_line,
                                              Etichette.Categoria_Tipo_Certificato,Etichette.Categorie_Tipo_Certificato]
}
