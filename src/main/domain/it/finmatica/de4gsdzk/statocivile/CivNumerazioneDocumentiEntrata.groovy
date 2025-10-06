package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.CivNumerazioneDocumentiBaseDomain

import javax.persistence.*

@Entity
@Table(name = "CIVNDE")
class CivNumerazioneDocumentiEntrata extends CivNumerazioneDocumentiBaseDomain{

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="COD_REGISTRO", nullable = true)
    CivRegistroDocumentiEntrata registro

    /////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI /////////////////////////////
    /////////////////////////////////////////////////////////////////////////

}
