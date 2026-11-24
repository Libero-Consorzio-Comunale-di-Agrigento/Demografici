package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.utils.ETipoPratica

import javax.persistence.*

@Entity
@Table(name = "ANAWPM_SAP4_ZK")
class AnaSoggettoModelloApr4 implements Serializable {

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

    // Sezione P1 - Dati richiedente
    @Column(name = "P1_1")
    BigDecimal p1_1

    @Column(name = "P1_2", length = 100)
    String p1_2

    @Column(name = "P1_3", length = 100)
    String p1_3

    @Column(name = "P1_4", length = 4000)
    String p1_4

    // Sezione P2
    @Column(name = "P2_0", length = 2)
    String p2_0

    @Column(name = "P2_1", length = 2)
    String p2_1

    @Column(name = "P2_2", length = 4000)
    String p2_2

    @Column(name = "P2_3", length = 30)
    String p2_3

    @Column(name = "P2_4", length = 4000)
    String p2_4

    @Column(name = "P2_5", length = 4000)
    String p2_5

    // Sezione P3
    @Column(name = "P3_1", length = 130)
    String p3_1

    @Column(name = "P3_2", length = 30)
    String p3_2

    @Column(name = "P3_3", length = 1)
    String p3_3

    @Column(name = "P3_4", length = 1)
    String p3_4

    @Column(name = "P3_5", length = 1)
    String p3_5

    @Column(name = "P3_6", length = 1)
    String p3_6

    @Column(name = "P3_7", length = 1)
    String p3_7

    @Column(name = "P3_8", length = 1)
    String p3_8

    // Sezione P4
    @Column(name = "P4_1", length = 100)
    String p4_1

    @Column(name = "P4_2", length = 30)
    String p4_2

    @Column(name = "P4_3", length = 87)
    String p4_3

    @Column(name = "P4_4", length = 4000)
    String p4_4

    // Sezione P5
    @Column(name = "P5_1", length = 30)
    String p5_1

    @Column(name = "P5_2", length = 4000)
    String p5_2

    @Column(name = "P5_3", length = 124)
    String p5_3

    // Sezione P6
    @Column(name = "P6_1", length = 1)
    String p6_1

    @Column(name = "P6_2", length = 1)
    String p6_2

    @Column(name = "P6_3", length = 30)
    String p6_3

    @Column(name = "P6_4", length = 4000)
    String p6_4

    @Column(name = "P6_5", length = 16)
    String p6_5

    @Column(name = "P6_6", length = 4000)
    String p6_6

    @Column(name = "P6_7", length = 1)
    String p6_7

    @Column(name = "P6_8", length = 1)
    String p6_8

    // Sezione P7
    @Column(name = "P7_1", length = 1)
    String p7_1

    @Column(name = "P7_2", length = 1)
    String p7_2

    @Column(name = "P7_3", length = 1)
    String p7_3

    @Column(name = "P7_4", length = 1)
    String p7_4

    @Column(name = "P7_5", length = 1)
    String p7_5

    // Sezione P8
    @Column(name = "P8_1", length = 1)
    String p8_1

    @Column(name = "P8_2", length = 1)
    String p8_2

    @Column(name = "P8_3", length = 1)
    String p8_3

    @Column(name = "P8_4", length = 1)
    String p8_4

    @Column(name = "P8_5", length = 1)
    String p8_5

    // Sezione P9
    @Column(name = "P9_1", length = 1)
    String p9_1

    @Column(name = "P9_2", length = 1)
    String p9_2

    @Column(name = "P9_3", length = 1)
    String p9_3

    @Column(name = "P9_4", length = 1)
    String p9_4

    @Column(name = "P9_5", length = 1)
    String p9_5

    @Column(name = "P9_6", length = 1)
    String p9_6

    @Column(name = "P9_7", length = 27)
    String p9_7

    @Column(name = "P9_8", length = 27)
    String p9_8

}