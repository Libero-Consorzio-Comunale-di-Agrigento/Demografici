package it.finmatica.de4gsdzk.anpr

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.ETipoSN
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.Column
import javax.persistence.Convert
import javax.persistence.Entity
import javax.persistence.EnumType
import javax.persistence.Enumerated
import javax.persistence.Id
import javax.persistence.Table
import javax.persistence.Temporal
import javax.persistence.TemporalType

@Entity
@Table(name = "ANPELE_V")
class AnpElettorale {

    @Id
    @Column(name = "ID")
    String id

    @Column(name = "ID_OPERAZIONE", nullable = true)
    Long idOperazione

    @Column(name = "ORD_LISTA", nullable = true)
    Long ordLista

    @Column(name = "DES_LISTA", nullable = true)
    String descrizioneLista

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "ELE_ELETTORE", nullable = true)
    Boolean elettore

    @Column(name = "ELE_NOMECOMUNE", nullable = true)
    String nomeComune

    @Column(name = "ELE_CODICEISTAT", nullable = true)
    String codiceIstat

    @Column(name = "ELE_SIGLAPROVINCIAISTAT", nullable = true)
    String siglaProvinciaIstat

    @Column(name = "ELE_SEZIONEELETTORALENUM", nullable = true)
    String sezioneElettorale

    @Enumerated(EnumType.STRING)
    @Column(name = "ELE_REFERENDUMNAZIONALI", nullable = true)
    ETipoSN referendum

    @Enumerated(EnumType.STRING)
    @Column(name = "ELE_ELEZIONIMEMBRIUE", nullable = true)
    ETipoSN elezioniMembriUe

    @Enumerated(EnumType.STRING)
    @Column(name = "ELE_SENATOREPUBBLICA", nullable = true)
    ETipoSN senato

    @Column(name = "ELE_CIRCOSCRSENATOREPUBBLICA", nullable = true)
    String circoscrizioneSenato

    @Enumerated(EnumType.STRING)
    @Column(name = "ELE_CAMERADEPUTATI", nullable = true)
    ETipoSN camera

    @Column(name = "ELE_CIRCOSCRCAMERADEPUTATI", nullable = true)
    String circoscrizioneCamera

    @Enumerated(EnumType.STRING)
    @Column(name = "ELE_REGIONALI", nullable = true)
    ETipoSN regionali

    @Enumerated(EnumType.STRING)
    @Column(name = "ELE_COMUNALI", nullable = true)
    ETipoSN comunali

    @Enumerated(EnumType.STRING)
    @Column(name = "ELE_CIRCOSCRIZIONALI", nullable = true)
    ETipoSN circoscrizionali

    @Column(name = "SEZ_NOMECOMUNE", nullable = true)
    String comune

    @Column(name = "SEZ_SIGLAPROVINCIAISTAT", nullable = true)
    String provinciaIstat

    @Column(name = "SEZ_SEZIONEELETTORALEDENOM", nullable = true)
    String denominazioneSezioneElettorale

    @Column(name = "SEZIND_SPECIE", nullable = true)
    String sezIndSpecie

    @Column(name = "SEZIND_DENOMINAZIONETOPONIMO", nullable = true)
    String toponimo

    @Column(name = "SEZIND_NUMERO", nullable = true)
    String sezIndNumero

    @Column(name = "SEZIND_LETTERA", nullable = true)
    String sezIndLettera

    @Column(name = "ELE_CIRCOSCRELEZIONIMEMBRIUE", nullable = true)
    String circoscrizioneElezioniMembriUe

    @Column(name = "ELE_COLLEGIOCAMERADEPUTATI", nullable = true)
    String collegioCamera

    @Column(name = "ELE_CIRCOSCRREGIONALI", nullable = true)
    String circoscrizioneRegionali

    @Column(name = "ELE_CIRCOSRIZIONEELEZCIRCOSC", nullable = true)
    String circoscrizioneElezCircosc

    @Column(name = "ELE_COLLEGIOSENATOREPUBBLICA", nullable = true)
    String collegioSenato

    @Column(name = "ELE_TIPOCONSULTAZIONE", nullable = true)
    String tipoConsultazione

    @Temporal(TemporalType.DATE)
    @Column(name = "D_ELE_DATACANCELLAZIONELISTA", nullable = true)
    Date dataCancellazioneLista

    @Column(name = "DES_ELE_TIPOCONSULTAZIONE", nullable = true)
    String descrizioneTipoConsultazione

    static final List<Map> etichetteDomain = [
            Etichette.getEtichetta("Dati_Liste"),
            Etichette.getEtichetta("Lista"),
            Etichette.getEtichetta("Elettore"),
            Etichette.getEtichetta("Sezione"),
            Etichette.getEtichetta("Comune"),
            Etichette.getEtichetta("Provincia"),
            Etichette.getEtichetta("Vota_Per"),
            Etichette.getEtichetta("Referendum"),
            Etichette.getEtichetta("Comunali"),
            Etichette.getEtichetta("Parlamento_UE"),
            Etichette.getEtichetta("Senato"),
            Etichette.getEtichetta("Camera"),
            Etichette.getEtichetta("Regionali"),
            Etichette.getEtichetta("Circoscrizionali"),
            Etichette.getEtichetta("Dati_Sezione"),
            Etichette.getEtichetta("Sede"),
            Etichette.getEtichetta("Indirizzo"),
            Etichette.getEtichetta("Dati_Circorscrizioni"),
            Etichette.getEtichetta("Collegio"),
            Etichette.getEtichetta("Circoscrizione"),
            Etichette.getEtichetta("Dati_Cancellazione"),
            Etichette.getEtichetta("Data"),
            Etichette.getEtichetta("Data_Cancellazione"),
            Etichette.getEtichetta("Consultazione")
    ]

    String getIndirizzoFormattato() {
        [sezIndSpecie, toponimo, sezIndNumero, sezIndLettera].findAll { it }.join(' ')
    }

    @Override
    boolean equals(Object o) {
        if (this.is(o)) return true
        if (getClass() != o?.class) return false
        AnpElettorale that = (AnpElettorale) o
        return id == that.id
    }

    @Override
    int hashCode() {
        return Objects.hash(id)
    }

}