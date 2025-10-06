package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.anagrafe.AnaNazionalita
import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.utils.EArchivioSorgenteSoggetto
import it.finmatica.de4gsdzk.utils.ESesso
import it.finmatica.de4gsdzk.utils.EStatoCivile
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@MappedSuperclass
abstract class GsdAnagrafeBaseDomain extends GsdBaseDomain {

    abstract Integer getMatricola()

    abstract EArchivioSorgenteSoggetto getArchivio()

    @Column(name = "ID_SOGGETTO_ANPR", nullable = false)
    Long idSoggettoAnpr

    @Column(name = "ID_UNICO_ANPR", nullable = true)
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
    AnaNazionalita nazionalita

    @Convert(converter = EStatoCivile.EnumStatoCivileToStringConverter.class)
    @Column(name = "STATO_CIVILE", nullable = true)
    EStatoCivile statoCivile

    @Column(name = "DES_STATO_CIVILE", nullable = true, updatable = false)
    String descrizioneStatoCivile

    @Column(name = "DES_STATO_ANA", nullable = true, updatable = false)
    String descrizioneStatoAnagrafico

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Cognome, Etichette.Nome, Etichette.Sesso,
                                              Etichette.Data_Nascita, Etichette.Comune_Nascita,
                                              Etichette.Data_Decesso, Etichette.Comune_Decesso,
                                              Etichette.Stato_Civile, Etichette.Stato_Anagrafico, Etichette.Id_scheda_ANPR, Etichette.Id_unico_nazionale,
                                              Etichette.Codice_Fiscale,
                                              Etichette.Matricola,
                                              Etichette.Indirizzo, Etichette.Dal,
                                              Etichette.Residenza, Etichette.Comune_Residenza,
                                              Etichette.Nazionalita]


}
