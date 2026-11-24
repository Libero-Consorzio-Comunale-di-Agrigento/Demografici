package it.finmatica.de4gsdzk.anpr

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.EAnprTipoGestioneCF
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "ANPCIU_AGG")
class AnprDatiAggiuntiviComunicazione extends GsdBaseDomain {

    @Id
    @Column(name = "ID_OPERAZIONE")
    Long id

    @Convert(converter = EAnprTipoGestioneCF.EnumAnprTipoGestioneCFToIntegerConverter.class)
    @Column(name = "GESTIONE_CF_ANPR")
    EAnprTipoGestioneCF gestioneCfAnpr

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_CF_RIC", nullable = true)
    Boolean flagCfRic

    @Column(name = "COD_FISCALE_RIC")
    String codFiscaleRicerca

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_CF_ANPR", nullable = true)
    Boolean flagCfAnpr

    @Column(name = "COD_FISCALE_ANPR")
    String codFiscaleAnpr

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "NO_ID_ANPR", nullable = true)
    Boolean noIdAnpr

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "NO_ID_ANPR_FAM", nullable = true)
    Boolean noIdAnprFam

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "NO_ID_ANPR_PD", nullable = true)
    Boolean noIdAnprPd

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "NO_ID_ANPR_MD", nullable = true)
    Boolean noIdAnprMd

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "NO_ID_ANPR_CN", nullable = true)
    Boolean noIdAnprCn

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "NO_ID_ANPR_UC", nullable = true)
    Boolean noIdAnprUc

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "NO_ID_ANPR_CV", nullable = true)
    Boolean noIdAnprCv

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "D_DATA_DECORRENZA_ANPR")
    Date dataDecorrenza

    static final List<Map> etichetteDomain = [
        Etichette.getEtichetta("Codice_Fiscale"),
        Etichette.getEtichetta("Gestione_Codice_Fiscale"),
        Etichette.getEtichetta("Forza_Data_Decorrenza"),
        Etichette.getEtichetta("Dati_Aggiuntivi"),
        Etichette.getEtichetta("Forza_CF_Ricerca"),
        Etichette.getEtichetta("Forza_CF_ANPR"),
        Etichette.getEtichetta("Inibizione_Id_Anpr"),
        Etichette.getEtichetta("Soggetto"),
        Etichette.getEtichetta("Famiglia"),
        Etichette.getEtichetta("Padre"),
        Etichette.getEtichetta("Madre"),
        Etichette.getEtichetta("Coniuge"),
        Etichette.getEtichetta("Contraente_UCI"),
        Etichette.getEtichetta("Convivente_CdF"),
        Etichette.getEtichetta("Modifica_Servizio")
    ]

}
