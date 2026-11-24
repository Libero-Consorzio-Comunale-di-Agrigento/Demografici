package it.finmatica.de4gsdzk.elettorale

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.ESesso
import it.finmatica.de4gsdzk.utils.EStatoElettore
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "ELEARC_V")
class EleArchivio extends GsdBaseDomain {

    @Id
    @Column(name = "ID")
    String id

    @Column(name = "MATRICOLA")
    Long matricola

    @Column(name = "COGNOME", nullable = true)
    String cognome

    @Column(name = "NOME", nullable = true)
    String nome

    @Enumerated(EnumType.STRING)
    @Column(name = "SESSO", nullable = false)
    ESesso sesso

    @Enumerated(EnumType.STRING)
    @Column(name = "STATO", nullable = false)
    EStatoElettore stato

    @Column(name = "FASCICOLO", nullable = true, updatable = false, insertable = false)
    Long fascicolo

    @Column(name = "ANNO", nullable = true, updatable = false, insertable = false)
    Integer anno

    @Column(name = "SEZIONE", nullable = true, updatable = false, insertable = false)
    Integer sezione

    @Column(name = "PROGR_LISTA_SEZ", nullable = true, updatable = false, insertable = false)
    Long progressivoSezionale

    @Column(name = "PROGR_LISTA_GEN", nullable = true, updatable = false, insertable = false)
    Long progressivoGenerale

    @Column(name = "TESSERA_ELE", nullable = true, updatable = false, insertable = false)
    Long tessera

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_TESSERA_ELE", nullable = false)
    Date dataTessera

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TIPO_LISTA", nullable = true)
    EleTipoLista tipoLista

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_GIACENZA_TESSERA_ELE", nullable = true, updatable = false, insertable = false)
    Boolean flagGiacenza

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Matricola"), Etichette.getEtichetta("Cognome"), Etichette.getEtichetta("Nome"), Etichette.getEtichetta("Sesso"),
                                              Etichette.getEtichetta("Stato"), Etichette.getEtichetta("Fascicolo"),
                                              Etichette.getEtichetta("Anno"), Etichette.getEtichetta("Sezione"),
                                              Etichette.getEtichetta("Progressivo_Sezionale"), Etichette.getEtichetta("Progressivo_Generale"),
                                              Etichette.getEtichetta("Tessera"), Etichette.getEtichetta("Data_Tessera"),
                                              Etichette.getEtichetta("Tipo_Lista"), Etichette.getEtichetta("Tutte"), Etichette.getEtichetta("Giacenza")
                                        ]
}

