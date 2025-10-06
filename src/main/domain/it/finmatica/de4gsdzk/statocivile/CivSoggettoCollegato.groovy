package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.ISoggettoCollegato
import it.finmatica.de4gsdzk.anagrafe.AnaNazionalita
import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.utils.*

import javax.persistence.*

@Entity
@Table(name = "CIVSOG_V")
class CivSoggettoCollegato extends GsdBaseDomain implements ISoggettoCollegato{

    @Id
    @Column(name = "ID")
    Long id

    @Column(name = "ID_ATTO", nullable = false)
    String idAtto

    @Column(name = "TIPO_ATTO", nullable = false)
    Integer tipoAtto

    @Column(name = "UFFICIO", nullable = true)
    Integer ufficio

    @Column(name = "ANNO", nullable = false)
    Integer anno

    @Column(name = "ATTO", nullable = false)
    Integer atto

    @Column(name = "PARTE", nullable = true)
    Integer parte

    @Column(name = "SERIE", nullable = true)
    String serie

    @Column(name = "COGNOME")
    String cognome

    @Column(name = "NOME")
    String nome

    @Enumerated(EnumType.STRING)
    @Column(name = "SESSO")
    ESesso sesso

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAS")
    Date dataNascita

    @Column(name = "COD_FISCALE", nullable = true)
    private String codiceFiscale

    String getCodiceFiscale() {
        return codiceFiscale
    }

    void setCodiceFiscale(String val) {
        this.codiceFiscale = (val?.toUpperCase())
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "COD_COM_NAS")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_NAS", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "COD_PRO_NAS")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_NAS", updatable = false, insertable = false))
    ])
    private Comune comuneNascita

    Comune getComuneNascita() {
        if (comuneNascita == null){
            comuneNascita = new Comune()
        }
        return comuneNascita
    }

    void setComuneNascita(Comune c) {
        this.comuneNascita = c
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "COD_COM_RES")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_RES", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "COD_PRO_RES")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_RES", updatable = false, insertable = false))
    ])
    private Comune comuneResidenza

    Comune getComuneResidenza() {
        if (comuneResidenza == null){
            comuneResidenza = new Comune()
        }
        return comuneResidenza
    }

    void setComuneResidenza(Comune c) {
        this.comuneResidenza = c
    }

    @Column(name = "INDIRIZZO_RES")
    String indirizzo

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="NAZIONALITA", nullable = true)
    AnaNazionalita nazionalita

    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_SOGGETTO", nullable = false)
    ETipoSoggettoCollegato tipoSoggettoCollegato

    Map<String, String> getMinuscoleProperties(){
        switch (this.tipoSoggettoCollegato) {
            case ETipoSoggettoCollegato.AS:
                return ["cognomeAscendente": "cognome", "nomeAscendente": "nome"]
            case ETipoSoggettoCollegato.IT:
                return ["cognomeInterprete": "cognome", "nomeInterprete": "nome"]
            case ETipoSoggettoCollegato.OS:
                return ["cognomeSanitario":  "cognome", "nomeSanitario": "nome"]
            case ETipoSoggettoCollegato.PD:
                return ["cognomeSoggettoCollegatoPadre":  "cognome", "nomeSoggettoCollegatoPadre":  "nome"]
            case ETipoSoggettoCollegato.MD:
                return ["cognomeSoggettoCollegatoMadre":  "cognome", "nomeSoggettoCollegatoMadre":  "nome"]
            case ETipoSoggettoCollegato.PP:
                return ["cognomeProcuratorePadre":  "cognome", "nomeProcuratorePadre": "nome"]
            case ETipoSoggettoCollegato.PM:
                return ["cognomeProcuratoreMadre":  "cognome", "nomeProcuratoreMadre": "nome"]
            case ETipoSoggettoCollegato.CG:
                return ["cognomeIntestatarioVecchio":  "cognome", "nomeIntestatarioVecchio": "nome"]
            default:
                return [:]
        }
    }

    @Enumerated(EnumType.STRING)
    @Column(name = "GRADO_PARENTELA", nullable = true)
    EGradoParentela gradoParentela

    @Enumerated(EnumType.STRING)
    @Column(name = "QUALIFICA", nullable = true)
    EQualifica qualifica

    @Enumerated(EnumType.STRING)
    @Column(name = "CAMBIO_GENERALITA", nullable = true, updatable = false, insertable = false)
    ETipoSiNo cambioGeneralita

    /*
    @Column(name = "ID_SOGGETTO_ANSC", nullable = true)
    Long idSoggettoAnsc
    */

    @Version
    Long version

    ////////////////////////////////////////////////////////////////////////
    ///////////////////////////////// GENERALI /////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Cognome, Etichette.Nome, Etichette.Sesso,
                                              Etichette.Data_Nascita, Etichette.Ruolo, Etichette.Qualifica]


}