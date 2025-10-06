package it.finmatica.de4gsdzk

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Table

@Entity
@Table(name="PARAMETRI_PROTOCOLLO_V_DIZ")
class ParametroProtocolloDiz{

    public static final String FASE_SCPW = "SCPW"
    public static final String CODICE_FASE_A = "A"
    public static final String CODICE_FASE_W = "W"
    public static final String CODICE_TIPO_ATTO_UCI = "U"

    @Id
    @Column(name = "ID")
    Long id

    @Column(name="MODULO") String modulo

    @Column(name="COD_FASE") String codiceFase

    @Column(name="DES_FASE") String descrizioneFase

    @Column(name="COD_TIPO_ATTO_CIV") String codiceTipoAtto

    @Column(name="DES_TIPO_ATTO_CIV") String descrizioneTipoAtto

}
