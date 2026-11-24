package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.anagrafe.AnaCittadinanza
import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.utils.EArchivioSorgenteSoggetto
import it.finmatica.de4gsdzk.utils.ESesso
import it.finmatica.de4gsdzk.utils.EStatoCivile
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@MappedSuperclass
abstract class AnagrafeBaseDomain extends GsdBaseDomain {

    abstract Integer getMatricola()

    abstract EArchivioSorgenteSoggetto getArchivio()

    @Column(name = "ID_SOGGETTO_ANPR", nullable = false, updatable = false, insertable = false)
    Long idSoggettoAnpr

    @Column(name = "ID_UNICO_ANPR", nullable = true, updatable = false, insertable = false)
    String idUnicoAnpr

    @Column(name = "COGNOME", nullable = true)
    String cognome

    @Column(name = "NOME", nullable = true)
    String nome

    @Column(name = "COGNOME_RIC", nullable = true, updatable = false, insertable = false)
    String cognomeRicerca

    @Column(name = "NOME_RIC", nullable = true, updatable = false, insertable = false)
    String nomeRicerca

    @Enumerated(EnumType.STRING)
    @Column(name = "SESSO", nullable = false)
    ESesso sesso

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAS", nullable = false)
    Date dataNascita

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_NAS")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_NAS", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_NAS")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_NAS", updatable = false, insertable = false))
    ])
    private Comune comuneNascita

    Comune getComuneNascita() {
        if (comuneNascita == null) {
            comuneNascita = new Comune()
        }
        return comuneNascita
    }

    void setComuneNascita(Comune comuneNascita) {
        this.comuneNascita = comuneNascita
    }

    // TODO: rimuovi getter obsoleti
    Integer getCodiceComuneNascita() {
        return getComuneNascita().codice
    }

    String getDescrizioneComuneNascita() {
        return getComuneNascita().descrizione
    }

    Integer getCodiceProvinciaNascita() {
        return getComuneNascita().codiceProvincia
    }

    String getSiglaProvinciaNascita() {
        return getComuneNascita().siglaProvincia
    }

    abstract Comune getComuneResidenza()

    @Column(name = "COD_FISCALE")
    String codiceFiscale
    void setCodiceFiscale(String val) { codiceFiscale = val?.toUpperCase() }

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "CF_CALCOLATO", nullable = true)
    Boolean cfCalcolato

    @ManyToOne(fetch= FetchType.LAZY)
    @JoinColumn(name="NAZIONALITA", nullable = true)
    AnaCittadinanza nazionalita

    @Convert(converter = EStatoCivile.EnumStatoCivileToStringConverter.class)
    @Column(name = "STATO_CIVILE", nullable = true)
    EStatoCivile statoCivile

    @Column(name = "DES_STATO_CIVILE", nullable = true, updatable = false, insertable = false)
    String descrizioneStatoCivile

    @Column(name = "DES_STATO_ANA", nullable = true, updatable = false, insertable = false)
    String descrizioneStatoAnagrafico

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Cognome"), Etichette.getEtichetta("Nome"), Etichette.getEtichetta("Sesso"),
                                              Etichette.getEtichetta("Data_Nascita"), Etichette.getEtichetta("Comune_Nascita"),
                                              Etichette.getEtichetta("Data_Decesso"), Etichette.getEtichetta("Comune_Decesso"),
                                              Etichette.getEtichetta("Stato_Civile"), Etichette.getEtichetta("Stato_Anagrafico"), Etichette.getEtichetta("Posizione"),
                                              Etichette.getEtichetta("Id_scheda_ANPR"), Etichette.getEtichetta("Id_unico_nazionale"),
                                              Etichette.getEtichetta("Codice_Fiscale"), Etichette.getEtichetta("Non_Validato"),
                                              Etichette.getEtichetta("Matricola"),
                                              Etichette.getEtichetta("Indirizzo"), Etichette.getEtichetta("Dal"),
                                              Etichette.getEtichetta("Residenza"), Etichette.getEtichetta("Comune_Residenza"),
                                              Etichette.getEtichetta("Nazionalita")]


}
