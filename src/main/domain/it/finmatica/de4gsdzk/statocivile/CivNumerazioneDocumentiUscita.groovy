package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.CivNumerazioneDocumentiBaseDomain

import javax.persistence.*

@Entity
@Table(name = "CIVNDU")
class CivNumerazioneDocumentiUscita extends CivNumerazioneDocumentiBaseDomain {

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="COD_REGISTRO", nullable = false)
    CivRegistroDocumentiUscita registro

    /////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI /////////////////////////////
    /////////////////////////////////////////////////////////////////////////

}
