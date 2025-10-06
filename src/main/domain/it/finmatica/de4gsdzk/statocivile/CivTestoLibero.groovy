package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.IRiferimentoAttoDomain
import it.finmatica.de4gsdzk.utils.ETipoSN
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "CIVTLI_V")
class CivTestoLibero implements IRiferimentoAttoDomain{

    @Id
    @Column(name = "ID")
    Long id

    @Column(name = "ID_ATTO", nullable = false)
    String idAtto

    @Column(name = "UFFICIO", nullable = true)
    Integer ufficio

    @Column(name = "ANNO", nullable = true)
    Integer anno

    @Column(name = "ATTO", nullable = false)
    Integer atto

    @Column(name = "PARTE", nullable = true)
    Integer parte

    @Column(name = "SERIE", nullable = true)
    String serie

    @Column(name = "TIPO_ATTO")
    Integer tipoAtto

    @Lob
    @Column(name = "RIGA_CLOB", nullable = true)
    String testo

    @Enumerated(EnumType.STRING)
    @Column(name = "FLAG_TRATTEGGIO", nullable = true)
    private ETipoSN tratteggioDb

    Boolean getTratteggio() {
        return (tratteggioDb == ETipoSN.S)
    }
    void setTratteggio(Boolean val) {
        this.tratteggioDb = (val?ETipoSN.S:null)
    }

    @Version
    @Column(nullable = false)
    Long version

    /////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI /////////////////////////////
    /////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Ufficio, Etichette.Anno, Etichette.Parte, Etichette.Serie, Etichette.Numero_Atto]

}
