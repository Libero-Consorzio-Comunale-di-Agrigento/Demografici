package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.utils.ETipoPratica

import javax.persistence.*

/**
 * Entity che rappresenta la tabella ANAWP4_SAP4_ZK
 * Contiene i dati dei moduli APR4 con mappatura a T1, T2, T3, T4, C1, C2, C3
 */
@Entity
@Table(name = "ANAWP4_SAP4_ZK")
class AnaTestataModelloApr4 implements Serializable {

    private static final long serialVersionUID = 1L

    @Id
    @Column(name = "ID")
    String id

    @Convert(converter = ETipoAnagrafe.EnumTipoAnagrafeToStringConverter.class)
    @Column(name ="ANAGRAFE")
    ETipoAnagrafe archivioAnagrafe

    @Convert(converter = ETipoPratica.EnumTipoPraticaToStringConverter.class)
    @Column(name ="TIPO_EVENTO")
    ETipoPratica tipoEvento

    @Column(name = "NUMERO_DIC")
    Integer numeroDic

    @Column(name = "ANNO_DIC")
    Integer annoDic

    @Column(name = "DES_COMUNE_UTENTE", length = 100)
    String desComune

    @Column(name = "SIGLA_PRO_UTENTE", length = 2)
    String siglaProvincia

    @Column(name = "RICHIESTA")
    BigDecimal richiesta

    @Column(name = "PROVVEDIMENTO")
    BigDecimal provvedimento

    @Column(name = "T1_I_1", length = 4000)
    String t1i1

    @Column(name = "T1_I_2", length = 4000)
    String t1i2

    @Column(name = "T1_I_3", length = 4000)
    String t1i3

    @Column(name = "T1_I_4", length = 4000)
    String t1i4

    @Column(name = "T1_I_5", length = 4000)
    String t1i5

    @Column(name = "T1_I_6", length = 4000)
    String t1i6

    @Column(name = "T1_I_7", length = 4000)
    String t1i7

    @Column(name = "T1_I_8", length = 4000)
    String t1i8

    @Column(name = "T1_I_9", length = 4000)
    String t1i9

    @Column(name = "T1_I_9_0", length = 4000)
    String t1i9_0

    @Column(name = "T1_I_10", length = 4000)
    String t1i10

    @Column(name = "T1_I_11", length = 4000)
    String t1i11

    // Sezione T1 - Contenuto
    @Column(name = "T1_C_1", length = 4000)
    String t1c1

    @Column(name = "T1_C_2", length = 4000)
    String t1c2

    @Column(name = "T1_C_3", length = 4000)
    String t1c3

    @Column(name = "T1_C_4", length = 4000)
    String t1c4

    @Column(name = "T1_C_5", length = 4000)
    String t1c5

    @Column(name = "T1_C_6", length = 4000)
    String t1c6

    @Column(name = "T1_C_7", length = 4000)
    String t1c7

    @Column(name = "T1_C_8", length = 4000)
    String t1c8

    @Column(name = "T1_C_9", length = 4000)
    String t1c9

    @Column(name = "T1_C_9_0", length = 4000)
    String t1c9_0

    @Column(name = "T1_C_10", length = 4000)
    String t1c10

    @Column(name = "T1_C_11", length = 4000)
    String t1c11

    // Sezione T2 - Intestazione
    @Column(name = "T2_I_1", length = 4000)
    String t2i1

    @Column(name = "T2_I_2", length = 4000)
    String t2i2

    @Column(name = "T2_I_3", length = 4000)
    String t2i3

    @Column(name = "T2_I_4", length = 4000)
    String t2i4

    @Column(name = "T2_I_5", length = 4000)
    String t2i5

    @Column(name = "T2_I_6", length = 4000)
    String t2i6

    @Column(name = "T2_I_7", length = 4000)
    String t2i7

    // Sezione T2 - Contenuto
    @Column(name = "T2_C_1", length = 4000)
    String t2c1

    @Column(name = "T2_C_2", length = 4000)
    String t2c2

    @Column(name = "T2_C_3", length = 4000)
    String t2c3

    @Column(name = "T2_C_4", length = 4000)
    String t2c4

    @Column(name = "T2_C_5", length = 4000)
    String t2c5

    @Column(name = "T2_C_6", length = 4000)
    String t2c6

    @Column(name = "T2_C_7", length = 4000)
    String t2c7

    @Column(name = "T2_C_8", length = 4000)
    String t2c8

    @Column(name = "T2_C_9", length = 4000)
    String t2c9

    // Sezione T3 - Intestazione
    @Column(name = "T3_I_1", length = 4000)
    String t3i1

    @Column(name = "T3_I_2", length = 4000)
    String t3i2

    @Column(name = "T3_I_3", length = 4000)
    String t3i3

    @Column(name = "T3_I_4", length = 4000)
    String t3i4

    @Column(name = "T3_I_5", length = 4000)
    String t3i5

    @Column(name = "T3_I_6", length = 4000)
    String t3i6

    @Column(name = "T3_I_7", length = 4000)
    String t3i7

    @Column(name = "T3_I_8", length = 4000)
    String t3i8

    // Sezione T3 - Contenuto
    @Column(name = "T3_C_1", length = 4000)
    String t3c1

    @Column(name = "T3_C_2", length = 4000)
    String t3c2

    @Column(name = "T3_C_3", length = 4000)
    String t3c3

    @Column(name = "T3_C_4", length = 4000)
    String t3c4

    @Column(name = "T3_C_5", length = 4000)
    String t3c5

    @Column(name = "T3_C_6", length = 4000)
    String t3c6

    @Column(name = "T3_C_7", length = 4000)
    String t3c7

    @Column(name = "T3_C_8", length = 4000)
    String t3c8

    // Sezione T4
    @Column(name = "T4_1", length = 4000)
    String t4_1

    // Sezione C1, C2, C3
    @Column(name = "C1_1", length = 4000)
    String c1_1

    @Column(name = "C2_1", length = 4000)
    String c2_1

    @Column(name = "C3_1", length = 4000)
    String c3_1

    @Column(name = "C3_2", length = 4000)
    String c3_2

    @Column(name = "C3_3", length = 4000)
    String c3_3
}


