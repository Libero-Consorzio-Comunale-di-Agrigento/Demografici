package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.utils.ESesso

import javax.persistence.*

@MappedSuperclass
abstract class CivVerbaleBaseDomain implements ISoggettoRecupero1, ISoggettoRecupero2 {

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

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_PUB", nullable = true)
    Date dataPubblicazione

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_REG", nullable = false)
    Date dataRegistrazione

    ////////////////////////////////////////////////////////////////////////
    ///////////////////////////// CONTRAENTE 1 /////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Column(name="MATRICOLA_1", nullable = true)
    Integer idAnagrafe1

    @Column(name = "COGNOME_M", nullable = true)
    String cognome1

    @Column(name = "NOME_M", nullable = true)
    String nome1

    @Column(name = "COD_COM_RES_M", nullable = true)
    Integer codiceComuneResidenza1

    @Column(name = "COD_PRO_RES_M", nullable = true)
    Integer codiceProvinciaResidenza1

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAS_M", nullable = false)
    Date dataNascita1

    @Enumerated(EnumType.STRING)
    @Column(name = "SESSO_M")
    ESesso sesso1

    ////////////////////////////////////////////////////////////////////////
    ///////////////////////////// CONTRAENTE 1 /////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Column(name="MATRICOLA_2", nullable = true)
    Integer idAnagrafe2

    @Column(name = "COGNOME_F", nullable = true)
    String cognome2

    @Column(name = "NOME_f", nullable = true)
    String nome2

    @Column(name = "COD_COM_RES_F", nullable = true)
    Integer codiceComuneResidenza2

    @Column(name = "COD_PRO_RES_F", nullable = true)
    Integer codiceProvinciaResidenza2

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAS_F", nullable = false)
    Date dataNascita2

    @Enumerated(EnumType.STRING)
    @Column(name = "SESSO_F")
    ESesso sesso2

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = []

}
