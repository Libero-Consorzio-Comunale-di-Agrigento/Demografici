package it.finmatica.de4gsdzk.anagrafe

import org.hibernate.annotations.Immutable

import javax.persistence.*

@Entity
@Immutable
@Table(name = "ANAWP4_SDDR_ZK")
class AnaDichiarazioneResidenza implements Serializable {

    private static final long serialVersionUID = 1L

    @Id
    @Column(name = "ID")
    String id

    @Column(name = "ANAGRAFE")
    String anagrafe

    @Column(name = "TIPO_EVENTO")
    String tipoEvento

    @Column(name = "ANNO_DIC")
    Integer annoDic

    @Column(name = "NUMERO_DIC")
    Integer numeroDic

    @Column(name = "ANNO_PRATICA")
    Integer annoPratica

    @Column(name = "PRATICA")
    Integer pratica

    @Column(name = "DES_PRATICA_TPR")
    String desPraticaTpr

    @Column(name = "DATA_PRATICA_TPR")
    String dataPraticaTpr

    @Column(name = "NOME_TERMINALISTA_TPR")
    String nomeTerminalistaTpr

    @Column(name = "B_DIC_1")
    String bDic1

    @Column(name = "F_DIC_1")
    String fDic1

    @Column(name = "B_DIC_2")
    String bDic2

    @Column(name = "F_DIC_2")
    String fDic2

    @Column(name = "B_DIC_3")
    String bDic3

    @Column(name = "F_DIC_3")
    String fDic3

    @Column(name = "B_DIC_4")
    String bDic4

    @Column(name = "B_DIC_5")
    String bDic5

    @Column(name = "DATA_PRATICA")
    String dataPratica

    @Column(name = "DATA_DECORRENZA")
    String dataDecorrenza

    @Column(name = "TIPO_RICHIESTA")
    String tipoRichiesta

    @Column(name = "COD_PRO_EVE")
    Integer codProEve

    @Column(name = "COD_STATO")
    Integer codStato

    @Column(name = "COD_PRO_ISCR_AIRE")
    Integer codProIscrAire

    @Column(name = "DES_COM_EVE")
    String desComEve

    @Column(name = "COMUNE_EVE")
    String comuneEve

    @Column(name = "SIGLA_EVE")
    String siglaEve

    @Column(name = "DES_STATO_ESTERO")
    String desStatoEstero

    @Column(name = "COMUNE_ESTERO")
    String comuneEstero

    @Column(name = "SIGLA_ESTERO")
    String siglaEstero

    @Column(name = "DES_COM_ISCR_AIRE")
    String desComIscrAire

    @Column(name = "COMUNE_AIRE")
    String comuneAire

    @Column(name = "SIGLA_PRO_AIRE")
    String siglaProAire

    @Column(name = "SOTTOSCRITTO")
    String sottoscritto

    @Column(name = "B_TRASFERITO")
    String bTrasferito

    @Column(name = "F_COMUNE")
    String fComune

    @Column(name = "F_PROVINCIA")
    String fProvincia

    @Column(name = "F_INDIRIZZO")
    String fIndirizzo

    @Column(name = "F_NUM_CIV")
    String fNumCiv

    @Column(name = "F_INTERNO")
    String fInterno

    @Column(name = "F_SCALA")
    String fScala

    @Column(name = "F_PIANO")
    String fPiano

    @Column(name = "B_FAMILIARI")
    String bFamiliari

    @Column(name = "FAMIGLIA_CONVIVENZA")
    String famigliaConvivenza

    @Column(name = "PRESSO")
    String presso

    @Column(name = "INDIRIZZO_A")
    String indirizzoA

    @Column(name = "FLAG_AGGR")
    String flagAggr

    @Column(name = "COD_FAM_DEST")
    Integer codFamDest

    @Column(name = "COD_FAM_PROV")
    Integer codFamProv

    @Column(name = "B_AGGREGAZIONE")
    String bAggregazione

    @Column(name = "F_COGNOME_CF")
    String fCognomeCf

    @Column(name = "F_NOME_CF")
    String fNomeCf

    @Column(name = "F_DATA_NAS_CF")
    String fDataNasCf

    @Column(name = "F_LUOGO_NASCITA_CF")
    String fLuogoNascitaCf

    @Column(name = "FLAG_LEGITTIMA")
    String flagLegittima

    @Column(name = "FLAG_PROPRIETARIO")
    String flagProprietario

    @Column(name = "SEZIONE_CATASTO")
    String sezioneCatasto

    @Column(name = "FOGLIO_CATASTO")
    String foglioCatasto

    @Column(name = "NUMERO_CATASTO")
    String numeroCatasto

    @Column(name = "SUBALTERNO_CATASTO")
    String subalternoCatasto

    @Column(name = "FLAG_LOCAZIONE")
    String flagLocazione

    @Column(name = "SEDE_CONTRATTO_LOCAZIONE")
    String sedeContrattoLocazione

    @Column(name = "DATA_CONTRATTO_LOCAZIONE")
    String dataContrattoLocazione

    @Column(name = "NUM_CONTRATTO_LOCAZIONE")
    String numContrattoLocazione

    @Column(name = "NOME_PROPRIETA_LOCAZIONE")
    String nomeProprietaLocazione

    @Column(name = "CF_PROPRIETA_LOCAZIONE")
    String cfProprietaLocazione

    @Column(name = "COMUNE_PROPRIETA_LOCAZIONE")
    String comuneProprietaLocazione

    @Column(name = "VIA_PROPRIETA_LOCAZIONE")
    String viaProprietaLocazione

    @Column(name = "FLAG_LOCAZIONE_ERP")
    String flagLocazioneErp

    @Column(name = "NOTE_LOCAZIONE_ERP")
    String noteLocazioneErp

    @Column(name = "FLAG_COMODATO")
    String flagComodato

    @Column(name = "SEDE_CONTRATTO_COMODATO")
    String sedeContrattoComodato

    @Column(name = "DATA_CONTRATTO_COMODATO")
    String dataContrattoComodato

    @Column(name = "NUM_CONTRATTO_COMODATO")
    String numContrattoComodato

    @Column(name = "NOME_PROPRIETA_COMODATO")
    String nomeProprietaComodato

    @Column(name = "CF_PROPRIETA_COMODATO")
    String cfProprietaComodato

    @Column(name = "COMUNE_PROPRIETA_COMODATO")
    String comuneProprietaComodato

    @Column(name = "VIA_PROPRIETA_COMODATO")
    String viaProprietaComodato

    @Column(name = "FLAG_USUFRUTTO")
    String flagUsufrutto

    @Column(name = "NOTE_USUFRUTTO")
    String noteUsufrutto

    @Column(name = "FLAG_TITOLO")
    String flagTitolo

    @Column(name = "NOTE_TITOLO")
    String noteTitolo

    @Column(name = "RIF_PRATICA")
    String rifPratica

    @Column(name = "B_FLAG_FAM_NO_PAR")
    String flagFamNoPar

    @Column(name = "B_FLAG_FAM_SI_PAR")
    String flagFamSiPar

    @Column(name = "F_CELLULARE_COM")
    String fCellulareCom

    @Column(name = "F_FAX_COM")
    String fFaxCom

    @Column(name = "F_EMAIL_COM")
    String fEmailCom

    @Column(name = "F_DIC_5")
    String fDic5

    @Column(name = "F_ESTREMI_DOC_CF")
    String fEstremiDocCf

    @Column(name = "F_ALLEGATO_1")
    String fAllegato1

    @Column(name = "F_ALLEGATO_2")
    String fAllegato2

    @Column(name = "F_ALLEGATO_3")
    String fAllegato3

    @Column(name = "F_ALLEGATO_4")
    String fAllegato4
}
