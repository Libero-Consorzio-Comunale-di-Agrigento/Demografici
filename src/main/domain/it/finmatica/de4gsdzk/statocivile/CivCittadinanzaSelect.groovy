package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.ISoggettoRecupero1
import it.finmatica.de4gsdzk.utils.ESesso
import it.finmatica.de4gsdzk.utils.ETipoRecupero

import javax.persistence.*

@Entity
@Table(name = "CIVCIT_V_GIU")
class CivCittadinanzaSelect implements ISoggettoRecupero1 {

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

    @Column(name = "ID_ATTO_ANSC", nullable = true)
    String idAttoAnsc

    @Column(name = "SIGLA_CATEGORIA", nullable = false)
    String codiceCategoria

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_REG", nullable = false)
    Date dataRegistrazione

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_CIT", nullable = true)
    Date dataCittadinanza

    ////////////////////////////////////////////////////////////////////////
    ///////////////////////////// RICHIEDENTE //////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Column(name="MATRICOLA_1", nullable = true)
    Integer idAnagrafe1

    @Column(name = "COGNOME", nullable = true)
    String cognome1

    @Column(name = "NOME", nullable = true)
    String nome1

    @Column(name = "COD_COM_RES", nullable = true)
    Integer codiceComuneResidenza1

    @Column(name = "COD_PRO_RES", nullable = true)
    Integer codiceProvinciaResidenza1

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAS", nullable = false)
    Date dataNascita1

    @Enumerated(EnumType.STRING)
    @Column(name = "SESSO")
    ESesso sesso1

    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_RECUPERO", nullable = false)
    ETipoRecupero tipoRecupero

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

}
