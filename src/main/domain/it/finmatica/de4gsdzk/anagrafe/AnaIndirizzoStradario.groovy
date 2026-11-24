package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.statocivile.embed.indirizzo.famiglia.IndirizzoResidenteFamiglia
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "ARCINT_V_DEST")
class AnaIndirizzoStradario {

    @Id
    @Column(name = "ID", nullable = false)
    String id

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "COD_FAM_UNIQUE", nullable = false)
    AnaFamiglia famiglia

    @Column(name = "COD_FAM", nullable = false)
    Long codice

    @Embedded
    private IndirizzoResidenteFamiglia indirizzo

    IndirizzoResidenteFamiglia getIndirizzo() {
        return indirizzo
    }

    void setIndirizzo(IndirizzoResidenteFamiglia indirizzo) {
        this.indirizzo = indirizzo
    }

    @Column(name = "INTESTATARIO", nullable = false)
    String intestatario

    @Column(name = "COGNOME_INTESTATARIO", nullable = false)
    String cognomeIntestatario

    @Column(name = "NOME_INTESTATARIO", nullable = false)
    String nomeIntestatario

    @Convert(converter = ETipoFamiglia.EnumTipoFamigliaToStringConverter.class)
    @Column(name = "FAMIGLIA_CONVIVENZA", nullable = true)
    ETipoFamiglia tipoFamiglia

    @Convert(converter = EStatoIndirizzo.EnumStatoIndirizzoToStringConverter.class)
    @Column(name = "STATO_INTERNO", nullable = true)
    EStatoIndirizzo stato

    @Column(name = "INTESTATARIO_INTERNO", nullable = false)
    String intestatarioInterno

    @Column(name = "CONVIVENZA", nullable = false)
    String convivenza

    @Column(name ="SEZIONE_CATASTO", nullable = true)
    String sezioneCatasto

    @Column(name ="FOGLIO_CATASTO", nullable = true)
    String foglioCatasto

    @Column(name ="NUMERO_CATASTO", nullable = true)
    String numeroCatasto

    @Column(name ="SUBALTERNO_CATASTO", nullable = true)
    String subalternoCatasto

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Stato"), Etichette.getEtichetta("Ricerca_Famiglie_Interni")]
}
