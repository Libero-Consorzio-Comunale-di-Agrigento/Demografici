package it.finmatica.de4gsdzk.anagrafe

import org.hibernate.annotations.Immutable

import javax.persistence.*

@Entity
@Immutable
@Table(name = "ANAWPM_SDDR_ZK")
class AnaSoggettoDichiarazioneResidenza implements Serializable {

    private static final long serialVersionUID = 1L

    @Id
    @Column(name = "ID")
    String id

    @Column(name = "ANAGRAFE")
    String anagrafe

    @Column(name = "TIPO_EVENTO")
    String tipoEvento

    @Column(name = "ANNO_PRATICA")
    Integer annoPratica

    @Column(name = "PRATICA")
    Integer pratica

    @Column(name = "NUMERO_ORDINE")
    Integer numeroOrdine

    @Column(name = "MATRICOLA")
    Integer matricola

    @Column(name = "F_COGNOME_S")
    String fCognomeS

    @Column(name = "F_NOME_S")
    String fNomeS

    @Column(name = "F_COD_FISCALE_S")
    String fCodFiscaleS

    @Column(name = "F_DATA_NAS_S")
    String fDataNasS

    @Column(name = "F_LUOGO_NAS_S")
    String fLuogoNasS

    @Column(name = "F_SESSO_S")
    String fSessoS

    @Column(name = "F_STATO_CIVILE_S")
    String fStatoCivileS

    @Column(name = "F_CITT_S")
    String fCittS

    @Column(name = "IST_RP")
    String istRp

    @Column(name = "DES_RAPPORTO_PAR")
    String desRapportoPar

    @Column(name = "F_PROFESSIONE_S")
    String fProfessioneS

    @Column(name = "POSIZIONE_PROF")
    Integer posizioneProf

    @Column(name = "B_PROF_1")
    String bProf1

    @Column(name = "B_PROF_2")
    String bProf2

    @Column(name = "B_PROF_3")
    String bProf3

    @Column(name = "B_PROF_4")
    String bProf4

    @Column(name = "B_PROF_5")
    String bProf5

    @Column(name = "IST_NP")
    Integer istNp

    @Column(name = "B_NPROF_1")
    String bNprof1

    @Column(name = "B_NPROF_2")
    String bNprof2

    @Column(name = "B_NPROF_3")
    String bNprof3

    @Column(name = "B_NPROF_4")
    String bNprof4

    @Column(name = "B_NPROF_5")
    String bNprof5

    @Column(name = "IST_TS")
    Integer istTs

    @Column(name = "B_TS_1")
    String bTs1

    @Column(name = "B_TS_2")
    String bTs2

    @Column(name = "B_TS_3")
    String bTs3

    @Column(name = "B_TS_4")
    String bTs4

    @Column(name = "B_TS_5")
    String bTs5

    @Column(name = "B_TS_6")
    String bTs6

    @Column(name = "W_ORD_1")
    Integer word1

    @Column(name = "W_ORD_2")
    Integer word2

    @Column(name = "F_TIPO_PT")
    String fTipoPt

    @Column(name = "F_NUMERO_PT")
    String fNumeroPt

    @Column(name = "F_DATA_EMISSIONE_PT")
    String fDataEmissionePt

    @Column(name = "F_ENTE_EMISSIONE_PT")
    String fEnteEmissionePt

    @Column(name = "F_SIGLA_PROVINCIA_PT")
    String fSiglaProvinciaPt

    @Column(name = "F_NUMERO_CC_A")
    String fNumeroCcA

    @Column(name = "F_NUMERO_CC_R")
    String fNumeroCcR

    @Column(name = "F_NUMERO_CC_M")
    String fNumeroCcM

    @Column(name = "F_NUMERO_CC_C")
    String fNumeroCcC

}
