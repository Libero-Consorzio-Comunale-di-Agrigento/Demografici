package it.finmatica.de4gsdzk.utils

import it.finmatica.de4gsdzk.*
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafeBaseDomain
import it.finmatica.de4gsdzk.archivi.ArcComune
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.statocivile.embed.SoggettoDAT
import it.finmatica.de4gsdzk.statocivile.embed.Testimone
import org.apache.commons.lang.StringUtils
import org.springframework.beans.BeanUtils

import javax.persistence.Table

class DomainUtils {

    /**
     * Restituisce il nome della tabella mappata dalla entity
     *
     * @param entity la entity, o la sua classe
     * @return il nome della tabella (in maiuscolo) senza il suffisso _V se presente
     */
    static String getTableName(Object entity) {
        Class clazz = entity instanceof Class ? entity : entity.getClass()
        Table table = (Table) clazz.getAnnotation(Table.class)
        String tableName = table.name().toUpperCase()
        if (tableName.endsWith("_V"))
            tableName = tableName.substring(0, tableName.length()-2)
        return tableName
    }

    private static Class getEntityClass(ETipoAtto tipoAtto) {
        Class entityClass
        switch (tipoAtto) {
            case ETipoAtto.NAS:
                entityClass = CivNascita.class
                break
            case ETipoAtto.MAT:
                entityClass = CivMatrimonio.class
                break
            case ETipoAtto.PUB:
                entityClass = CivPubblicazione.class
                break
            case ETipoAtto.MOR:
                entityClass = CivMorte.class
                break
            case ETipoAtto.UCI:
                entityClass = CivUnioneCivile.class
                break
            case ETipoAtto.PVU:
                entityClass = CivProcessoVerbale.class
                break
            case ETipoAtto.CIT:
                entityClass = CivCittadinanza.class
                break
            default:
                throw new IllegalArgumentException("Tipo atto ${tipoAtto} non gestito")
        }
        return entityClass
    }

    static Object copyAtto(CivAttoBaseDomain domainSource) {
        Class entityClass = getEntityClass(domainSource.getTipoAttoEnum())
        CivAttoBaseDomain copy = entityClass.newInstance()

        BeanUtils.copyProperties(domainSource, copy, 'id', 'idAtto')

        return copy
    }

    static void initFromAtto(def domainTarget, CivAttoBaseDomain domainSource){
        switch (domainSource.getTipoAttoEnum()) {
            case ETipoAtto.NAS:
            case ETipoAtto.MAT:
            case ETipoAtto.PUB:
            case ETipoAtto.MOR:
            case ETipoAtto.PVU:
            case ETipoAtto.UCI:
            case ETipoAtto.CIT:
                domainTarget.ufficio = domainSource.ufficio
                domainTarget.anno = domainSource.anno
                domainTarget.parte = domainSource.parte
                domainTarget.serie = domainSource.serie
                domainTarget.atto = domainSource.atto
                domainTarget.tipoAtto = domainSource.tipoAtto
                break
        }
    }

    static void initFromRiferimentoAtto(IRiferimentoAttoDomain domainTarget, IRiferimentoAttoDomain domainSource){
        domainTarget.ufficio = domainSource.ufficio
        domainTarget.anno = domainSource.anno
        domainTarget.parte = domainSource.parte
        domainTarget.serie = domainSource.serie
        domainTarget.atto = domainSource.atto
        domainTarget.tipoAtto = domainSource.tipoAtto
    }

    static void initEstremiAttoNascitaFromMargine(CivMargine domainTarget, CivMargine domainSource){
        // Estremi atto di nascita soggetto 1
        domainTarget.ufficioAttoNascita1 = domainSource?.ufficioAttoNascita1
        domainTarget.annoAttoNascita1 = domainSource?.annoAttoNascita1
        domainTarget.attoAttoNascita1 = domainSource?.attoAttoNascita1
        domainTarget.parteAttoNascita1String = domainSource?.parteAttoNascita1String
        domainTarget.serieAttoNascita1 = domainSource?.serieAttoNascita1

        domainTarget.idAttoAnscNascita1 = domainSource?.idAttoAnscNascita1

        domainTarget.codiceComuneAttoNascita1 = domainSource?.codiceComuneAttoNascita1
        domainTarget.codiceProvinciaAttoNascita1 = domainSource?.codiceProvinciaAttoNascita1
        domainTarget.descrizioneComuneAttoNascita1 = domainSource?.descrizioneComuneAttoNascita1
        domainTarget.siglaProvinciaAttoNascita1 = domainSource?.siglaProvinciaAttoNascita1
    }

    static void initEstremiAttoNascitaFromMargineNuovaGestioneAnnotazione(CivMargine domainTarget, CivMargine domainSource) {
        if (domainSource == null) {
            domainTarget.ufficioAttoNascita1 = null
            domainTarget.annoAttoNascita1 = null
            domainTarget.attoAttoNascita1 = null
            domainTarget.parteAttoNascita1String = null
            domainTarget.serieAttoNascita1 = null
            domainTarget.idAttoAnscNascita1 = null
            domainTarget.codiceComuneAttoNascita1 = null
            domainTarget.codiceProvinciaAttoNascita1 = null
            domainTarget.descrizioneComuneAttoNascita1 = null
            domainTarget.siglaProvinciaAttoNascita1 = null
            return
        }

        // Estremi atto di nascita soggetto 1
        if (!TestoUtils.isVuoto(domainSource.idAttoAnscNascita1)) {
            domainTarget.idAttoAnscNascita1 = domainSource.idAttoAnscNascita1
        } else {
            domainTarget.ufficioAttoNascita1 = domainSource.ufficioAttoNascita1
            domainTarget.annoAttoNascita1 = domainSource.annoAttoNascita1
            domainTarget.attoAttoNascita1 = domainSource.attoAttoNascita1
            domainTarget.parteAttoNascita1String = domainSource.parteAttoNascita1String
            domainTarget.serieAttoNascita1 = domainSource.serieAttoNascita1
        }

        domainTarget.codiceComuneAttoNascita1 = domainSource.codiceComuneAttoNascita1
        domainTarget.codiceProvinciaAttoNascita1 = domainSource.codiceProvinciaAttoNascita1
        domainTarget.descrizioneComuneAttoNascita1 = domainSource.descrizioneComuneAttoNascita1
        domainTarget.siglaProvinciaAttoNascita1 = domainSource.siglaProvinciaAttoNascita1
    }

    static void initEstremiAttoNascitaFromSposi(CivSposiAtto domainTarget, CivSposiAtto domainSource){
        // Estremi atto di nascita soggetto 1
        domainTarget.ufficioAttoNascita1 = domainSource?.ufficioAttoNascita1
        domainTarget.annoAttoNascita1 = domainSource?.annoAttoNascita1
        domainTarget.attoAttoNascita1 = domainSource?.attoAttoNascita1
        domainTarget.parteAttoNascita1String = domainSource?.parteAttoNascita1String
        domainTarget.serieAttoNascita1 = domainSource?.serieAttoNascita1

        domainTarget.idAttoAnscNascita1 = domainSource?.idAttoAnscNascita1

        domainTarget.codiceComuneAttoNascita1 = domainSource?.codiceComuneAttoNascita1
        domainTarget.codiceProvinciaAttoNascita1 = domainSource?.codiceProvinciaAttoNascita1
        domainTarget.descrizioneComuneAttoNascita1 = domainSource?.descrizioneComuneAttoNascita1
        domainTarget.siglaProvinciaAttoNascita1 = domainSource?.siglaProvinciaAttoNascita1
        // Estremi atto di nascita soggetto 2
        domainTarget.ufficioAttoNascita2 = domainSource?.ufficioAttoNascita2
        domainTarget.annoAttoNascita2 = domainSource?.annoAttoNascita2
        domainTarget.attoAttoNascita2 = domainSource?.attoAttoNascita2
        domainTarget.parteAttoNascita2String = domainSource?.parteAttoNascita2String
        domainTarget.serieAttoNascita2 = domainSource?.serieAttoNascita2

        domainTarget.idAttoAnscNascita2 = domainSource?.idAttoAnscNascita2

        domainTarget.codiceComuneAttoNascita2 = domainSource?.codiceComuneAttoNascita2
        domainTarget.codiceProvinciaAttoNascita2 = domainSource?.codiceProvinciaAttoNascita2
        domainTarget.descrizioneComuneAttoNascita2 = domainSource?.descrizioneComuneAttoNascita2
        domainTarget.siglaProvinciaAttoNascita2 = domainSource?.siglaProvinciaAttoNascita2
    }

    static void initEstremiAttoNascitaFromSposiNuovaGestioneAnnotazione(CivSposiAtto domainTarget, CivSposiAtto domainSource) {
        if (domainSource == null) {
            domainTarget.idAttoAnscNascita1 = null
            domainTarget.ufficioAttoNascita1 = null
            domainTarget.annoAttoNascita1 = null
            domainTarget.attoAttoNascita1 = null
            domainTarget.parteAttoNascita1String = null
            domainTarget.serieAttoNascita1 = null
            domainTarget.codiceComuneAttoNascita1 = null
            domainTarget.codiceProvinciaAttoNascita1 = null
            domainTarget.descrizioneComuneAttoNascita1 = null
            domainTarget.siglaProvinciaAttoNascita1 = null

            domainTarget.idAttoAnscNascita2 = null
            domainTarget.ufficioAttoNascita2 = null
            domainTarget.annoAttoNascita2 = null
            domainTarget.attoAttoNascita2 = null
            domainTarget.parteAttoNascita2String = null
            domainTarget.serieAttoNascita2 = null
            domainTarget.codiceComuneAttoNascita2 = null
            domainTarget.codiceProvinciaAttoNascita2 = null
            domainTarget.descrizioneComuneAttoNascita2 = null
            domainTarget.siglaProvinciaAttoNascita2 = null
        }

        // Estremi atto di nascita soggetto 1
        if (!TestoUtils.isVuoto(domainSource.idAttoAnscNascita1)) {
            domainTarget.idAttoAnscNascita1 = domainSource.idAttoAnscNascita1
        } else {
            domainTarget.ufficioAttoNascita1 = domainSource.ufficioAttoNascita1
            domainTarget.annoAttoNascita1 = domainSource.annoAttoNascita1
            domainTarget.attoAttoNascita1 = domainSource.attoAttoNascita1
            domainTarget.parteAttoNascita1String = domainSource.parteAttoNascita1String
            domainTarget.serieAttoNascita1 = domainSource.serieAttoNascita1
        }

        domainTarget.codiceComuneAttoNascita1 = domainSource.codiceComuneAttoNascita1
        domainTarget.codiceProvinciaAttoNascita1 = domainSource.codiceProvinciaAttoNascita1
        domainTarget.descrizioneComuneAttoNascita1 = domainSource.descrizioneComuneAttoNascita1
        domainTarget.siglaProvinciaAttoNascita1 = domainSource.siglaProvinciaAttoNascita1

        // Estremi atto di nascita soggetto 2
        if (!TestoUtils.isVuoto(domainSource.idAttoAnscNascita2)) {
            domainTarget.idAttoAnscNascita2 = domainSource.idAttoAnscNascita2
        } else {
            domainTarget.ufficioAttoNascita2 = domainSource.ufficioAttoNascita2
            domainTarget.annoAttoNascita2 = domainSource.annoAttoNascita2
            domainTarget.attoAttoNascita2 = domainSource.attoAttoNascita2
            domainTarget.parteAttoNascita2String = domainSource.parteAttoNascita2String
            domainTarget.serieAttoNascita2 = domainSource.serieAttoNascita2
        }

        domainTarget.codiceComuneAttoNascita2 = domainSource.codiceComuneAttoNascita2
        domainTarget.codiceProvinciaAttoNascita2 = domainSource.codiceProvinciaAttoNascita2
        domainTarget.descrizioneComuneAttoNascita2 = domainSource.descrizioneComuneAttoNascita2
        domainTarget.siglaProvinciaAttoNascita2 = domainSource.siglaProvinciaAttoNascita2
    }

    static initDatiMatUciFromPubblicazione(IAttoMatUci domainTarget, IAttoPubPvu domainSource){
        domainTarget.codiceComuneMatrimonio = domainSource.codiceComuneMatrimonio
        domainTarget.descrizioneComuneMatrimonio = domainSource.descrizioneComuneMatrimonio
        domainTarget.codiceProvinciaMatrimonio = domainSource.codiceProvinciaMatrimonio
        domainTarget.siglaProvinciaMatrimonio = domainSource.siglaProvinciaMatrimonio
    }

    static void initDatiAccordoDivScioFromDivScio(CivDatiProvenienzaAtto domainTarget, IAttoMatUci domainSource){
        domainTarget.ufficioAccordo = ((CivAttoBaseDomain)domainSource)?.ufficio
        domainTarget.annoAccordo = ((CivAttoBaseDomain)domainSource)?.anno
        domainTarget.attoAccordo = ((CivAttoBaseDomain)domainSource)?.atto
        domainTarget.parteAccordo = ((CivAttoBaseDomain)domainSource)?.parte
        domainTarget.serieAccordo = ((CivAttoBaseDomain)domainSource)?.serie
        domainTarget.dataAccordo = domainSource?.dataMatrimonio

        domainTarget.idAttoAnscAccordo = ((IAttoAnsc)domainSource)?.idAttoAnsc
    }

    static void initDatiAccordoDivScioFromDivScioNuovaGestioneAnnotazione(CivDatiProvenienzaAtto domainTarget, IAttoMatUci domainSource) {
        if (domainSource == null) {
            domainTarget.ufficioAccordo = null
            domainTarget.annoAccordo = null
            domainTarget.attoAccordo = null
            domainTarget.parteAccordo = null
            domainTarget.serieAccordo = null
            domainTarget.idAttoAnscAccordo = null
            domainTarget.dataAccordo = null

            return
        }

        CivAttoBaseDomain ds = (CivAttoBaseDomain) domainSource
        String idAttoAnsc = ((IAttoAnsc) domainSource)?.idAttoAnsc
        if (!TestoUtils.isVuoto(idAttoAnsc)) {
            domainTarget.idAttoAnscAccordo = idAttoAnsc
        } else {
            domainTarget.ufficioAccordo = ds.ufficio
            domainTarget.annoAccordo = ds.anno
            domainTarget.attoAccordo = ds.atto
            domainTarget.parteAccordo = ds.parte
            domainTarget.serieAccordo = ds.serie
        }
        domainTarget.dataAccordo = domainSource?.dataMatrimonio
    }

    static void initEstremiAttoMatrimonioFromSposi(CivSposiAtto domainTarget, CivSposiAtto domainSource){
        domainTarget.ufficioAttoMatrimonio = domainSource?.ufficioAttoMatrimonio
        domainTarget.annoAttoMatrimonio = domainSource?.annoAttoMatrimonio
        domainTarget.attoAttoMatrimonio = domainSource?.attoAttoMatrimonio
        domainTarget.parteAttoMatrimonioString = domainSource?.parteAttoMatrimonioString
        domainTarget.serieAttoMatrimonio = domainSource?.serieAttoMatrimonio

        domainTarget.idAttoAnscMatrimonio = domainSource?.idAttoAnscMatrimonio

        domainTarget.dataAttoMatrimonio = domainSource?.dataAttoMatrimonio

        domainTarget.codiceComuneAttoMatrimonio = domainSource?.codiceComuneAttoMatrimonio
        domainTarget.codiceProvinciaAttoMatrimonio = domainSource?.codiceProvinciaAttoMatrimonio
        domainTarget.descrizioneComuneAttoMatrimonio = domainSource?.descrizioneComuneAttoMatrimonio
        domainTarget.siglaProvinciaAttoMatrimonio = domainSource?.siglaProvinciaAttoMatrimonio
    }

    static void initEstremiAttoMatrimonioFromSposiNuovaGestioneAnnotazioni(CivSposiAtto domainTarget, CivSposiAtto domainSource) {
        if (domainSource == null) {
            domainTarget.ufficioAttoMatrimonio = null
            domainTarget.annoAttoMatrimonio = null
            domainTarget.attoAttoMatrimonio = null
            domainTarget.parteAttoMatrimonioString = null
            domainTarget.serieAttoMatrimonio = null
            domainTarget.idAttoAnscMatrimonio = null
            domainTarget.dataAttoMatrimonio = null
            domainTarget.codiceComuneAttoMatrimonio = null
            domainTarget.codiceProvinciaAttoMatrimonio = null
            domainTarget.descrizioneComuneAttoMatrimonio = null
            domainTarget.siglaProvinciaAttoMatrimonio = null
            return
        }

        if(domainSource.idAttoAnscMatrimonio != null){
            domainTarget.idAttoAnscMatrimonio = domainSource.idAttoAnscMatrimonio
        } else {
            domainTarget.ufficioAttoMatrimonio = domainSource.ufficioAttoMatrimonio
            domainTarget.annoAttoMatrimonio = domainSource.annoAttoMatrimonio
            domainTarget.attoAttoMatrimonio = domainSource.attoAttoMatrimonio
            domainTarget.parteAttoMatrimonioString = domainSource.parteAttoMatrimonioString
            domainTarget.serieAttoMatrimonio = domainSource.serieAttoMatrimonio
        }

        domainTarget.dataAttoMatrimonio = domainSource?.dataAttoMatrimonio

        domainTarget.codiceComuneAttoMatrimonio = domainSource?.codiceComuneAttoMatrimonio
        domainTarget.codiceProvinciaAttoMatrimonio = domainSource?.codiceProvinciaAttoMatrimonio
        domainTarget.descrizioneComuneAttoMatrimonio = domainSource?.descrizioneComuneAttoMatrimonio
        domainTarget.siglaProvinciaAttoMatrimonio = domainSource?.siglaProvinciaAttoMatrimonio
    }

    static void initEstremiAttoMatrimonioFromMatUci(CivSposiAtto domainTarget, IAttoMatUci domainSource, ArcComune comune, CivDatiProvenienzaAtto dpaMat, Boolean anscOn=Boolean.FALSE){
        if (domainSource instanceof CivAttoBaseDomain) {
            CivAttoBaseDomain ds = (CivAttoBaseDomain) domainSource
            domainTarget.ufficioAttoMatrimonio = ds?.ufficio
            domainTarget.annoAttoMatrimonio = ds?.anno
            domainTarget.attoAttoMatrimonio = ds?.atto
            domainTarget.parteAttoMatrimonioString = ds?.parte?.toString()
            domainTarget.serieAttoMatrimonio = ds?.serie

            domainTarget.idAttoAnscMatrimonio = ds?.idAttoAnsc

            // ANSC richiede come dato obbligatorio la 'Data atto'; con i servizi
            // abbiamo convenuto di valorizzare in automatico tale campo con la data di matrimonio/unione civile
            // nonostante i tracciati ANSC richiedano quel dato nel campo 'Data formazione atto'
            // refs #70216
            domainTarget.dataAttoMatrimonio = dpaMat?.dataAtto
            if (anscOn){
                domainTarget.dataMatrimonio = domainSource?.getDataMatrimonio()
                domainTarget.comuneMatrimonio.codice = domainSource?.getCodiceComuneMatrimonio()
                domainTarget.comuneMatrimonio.descrizione = domainSource?.getDescrizioneComuneMatrimonio()
                domainTarget.comuneMatrimonio.codiceProvincia = domainSource?.getCodiceProvinciaMatrimonio()
                domainTarget.comuneMatrimonio.siglaProvincia = domainSource?.getSiglaProvinciaMatrimonio()
            }

            domainTarget.codiceComuneAttoMatrimonio = comune?.codiceComune
            domainTarget.codiceProvinciaAttoMatrimonio = comune?.codiceProvincia
            domainTarget.descrizioneComuneAttoMatrimonio = comune?.descrizioneComune
            domainTarget.siglaProvinciaAttoMatrimonio = comune?.siglaProvincia
        }
    }

    static void initEstremiAttoMatrimonioFromMatUciNuovaGestioneAnnotazioni(CivSposiAtto domainTarget, IAttoMatUci domainSource, ArcComune comune, CivDatiProvenienzaAtto dpaMat, Boolean anscOn = Boolean.FALSE) {
        if (domainSource instanceof CivAttoBaseDomain) {
            CivAttoBaseDomain ds = (CivAttoBaseDomain) domainSource
            String idAttoAnsc = ((IAttoAnsc) domainSource)?.idAttoAnsc
            if (!TestoUtils.isVuoto(idAttoAnsc)) {
                domainTarget.idAttoAnscMatrimonio = idAttoAnsc
            } else {
                domainTarget.ufficioAttoMatrimonio = ds?.ufficio
                domainTarget.annoAttoMatrimonio = ds?.anno
                domainTarget.attoAttoMatrimonio = ds?.atto
                domainTarget.parteAttoMatrimonioString = ds?.parte?.toString()
                domainTarget.serieAttoMatrimonio = ds?.serie
            }

            // ANSC richiede come dato obbligatorio la 'Data atto'; con i servizi
            // abbiamo convenuto di valorizzare in automatico tale campo con la data di matrimonio/unione civile
            // nonostante i tracciati ANSC richiedano quel dato nel campo 'Data formazione atto'
            // refs #70216
            domainTarget.dataAttoMatrimonio = dpaMat?.dataAtto
            if (anscOn) {
                domainTarget.dataMatrimonio = domainSource?.getDataMatrimonio()
                domainTarget.comuneMatrimonio.codice = domainSource?.getCodiceComuneMatrimonio()
                domainTarget.comuneMatrimonio.descrizione = domainSource?.getDescrizioneComuneMatrimonio()
                domainTarget.comuneMatrimonio.codiceProvincia = domainSource?.getCodiceProvinciaMatrimonio()
                domainTarget.comuneMatrimonio.siglaProvincia = domainSource?.getSiglaProvinciaMatrimonio()
            }

            domainTarget.codiceComuneAttoMatrimonio = comune?.codiceComune
            domainTarget.codiceProvinciaAttoMatrimonio = comune?.codiceProvincia
            domainTarget.descrizioneComuneAttoMatrimonio = comune?.descrizioneComune
            domainTarget.siglaProvinciaAttoMatrimonio = comune?.siglaProvincia
        }
    }

    static void initEstremiAttoNascita1FromAttoNascita(IEstremiAttoNascitaSoggetto1Domain domainTarget, CivNascita domainSource, ArcComune comune){
        domainTarget.ufficioAttoNascita1 = domainSource.ufficio
        domainTarget.annoAttoNascita1 = domainSource.anno
        domainTarget.attoAttoNascita1 = domainSource.atto
        domainTarget.parteAttoNascita1String = domainSource.parte?.toString()
        domainTarget.serieAttoNascita1 = domainSource.serie

        domainTarget.idAttoAnscNascita1 = domainSource.idAttoAnsc

        domainTarget.codiceComuneAttoNascita1 = comune?.codiceComune
        domainTarget.codiceProvinciaAttoNascita1 = comune?.codiceProvincia
        domainTarget.descrizioneComuneAttoNascita1 = comune?.descrizioneComune
        domainTarget.siglaProvinciaAttoNascita1 = comune?.siglaProvincia
    }

    static void initEstremiAttoNascita1FromAttoNascitaNuovaGestioneAnnotazioni(IEstremiAttoNascitaSoggetto1Domain domainTarget, CivNascita domainSource, ArcComune comune) {
        String idAttoAnsc = ((IAttoAnsc) domainSource)?.idAttoAnsc
        if (!TestoUtils.isVuoto(idAttoAnsc)) {
            domainTarget.idAttoAnscNascita1 = idAttoAnsc
        } else {
            domainTarget.ufficioAttoNascita1 = domainSource.ufficio
            domainTarget.annoAttoNascita1 = domainSource.anno
            domainTarget.attoAttoNascita1 = domainSource.atto
            domainTarget.parteAttoNascita1String = domainSource.parte?.toString()
            domainTarget.serieAttoNascita1 = domainSource.serie
        }

        domainTarget.codiceComuneAttoNascita1 = comune?.codiceComune
        domainTarget.codiceProvinciaAttoNascita1 = comune?.codiceProvincia
        domainTarget.descrizioneComuneAttoNascita1 = comune?.descrizioneComune
        domainTarget.siglaProvinciaAttoNascita1 = comune?.siglaProvincia
    }

    static void initEstremiAttoNascita2FromAttoNascita(IEstremiAttoNascitaSoggetto2Domain domainTarget, CivNascita domainSource, ArcComune comune){
        domainTarget.ufficioAttoNascita2 = domainSource.ufficio
        domainTarget.annoAttoNascita2 = domainSource.anno
        domainTarget.attoAttoNascita2 = domainSource.atto
        domainTarget.parteAttoNascita2String = domainSource.parte?.toString()
        domainTarget.serieAttoNascita2 = domainSource.serie

        domainTarget.idAttoAnscNascita2 = domainSource.idAttoAnsc

        domainTarget.codiceComuneAttoNascita2 = comune?.codiceComune
        domainTarget.codiceProvinciaAttoNascita2 = comune?.codiceProvincia
        domainTarget.descrizioneComuneAttoNascita2 = comune?.descrizioneComune
        domainTarget.siglaProvinciaAttoNascita2 = comune?.siglaProvincia
    }

    static void initEstremiAttoNascita2FromAttoNascitaNuovaGestioneAnnotazioni(IEstremiAttoNascitaSoggetto2Domain domainTarget, CivNascita domainSource, ArcComune comune) {
        String idAttoAnsc = ((IAttoAnsc) domainSource)?.idAttoAnsc
        if (!TestoUtils.isVuoto(idAttoAnsc)) {
            domainTarget.idAttoAnscNascita2 = idAttoAnsc
        } else {
            domainTarget.ufficioAttoNascita2 = domainSource.ufficio
            domainTarget.annoAttoNascita2 = domainSource.anno
            domainTarget.attoAttoNascita2 = domainSource.atto
            domainTarget.parteAttoNascita2String = domainSource.parte?.toString()
            domainTarget.serieAttoNascita2 = domainSource.serie
        }

        domainTarget.codiceComuneAttoNascita2 = comune?.codiceComune
        domainTarget.codiceProvinciaAttoNascita2 = comune?.codiceProvincia
        domainTarget.descrizioneComuneAttoNascita2 = comune?.descrizioneComune
        domainTarget.siglaProvinciaAttoNascita2 = comune?.siglaProvincia
    }

    static void initEstremiAttoNascita1FromAnagrafe(IEstremiAttoNascitaSoggetto1Domain domainTarget, AnaAnagrafeBaseDomain domainSource){
        domainTarget.ufficioAttoNascita1 = domainSource?.attoNascita?.ufficio
        domainTarget.annoAttoNascita1 = domainSource?.attoNascita?.anno
        domainTarget.attoAttoNascita1 = domainSource?.attoNascita?.atto
        domainTarget.parteAttoNascita1String = domainSource?.attoNascita?.parte?.toString()
        domainTarget.serieAttoNascita1 = domainSource?.attoNascita?.serie

        domainTarget.idAttoAnscNascita1 = domainSource?.attoNascita?.idAttoAnsc

        domainTarget.codiceComuneAttoNascita1 = domainSource?.comuneAttoNascita?.codice
        domainTarget.codiceProvinciaAttoNascita1 = domainSource?.comuneAttoNascita?.codiceProvincia
        domainTarget.descrizioneComuneAttoNascita1 = domainSource?.comuneAttoNascita?.descrizione
        domainTarget.siglaProvinciaAttoNascita1 = domainSource?.comuneAttoNascita?.siglaProvincia
    }

    static void initEstremiAttoNascita1FromAnagrafeNuovaGestioneAnnotazioni(IEstremiAttoNascitaSoggetto1Domain domainTarget, AnaAnagrafeBaseDomain domainSource) {
        if (domainSource == null) {
            domainTarget.ufficioAttoNascita1 = null
            domainTarget.annoAttoNascita1 = null
            domainTarget.attoAttoNascita1 = null
            domainTarget.parteAttoNascita1String = null
            domainTarget.serieAttoNascita1 = null
            domainTarget.idAttoAnscNascita1 = null
            domainTarget.codiceComuneAttoNascita1 = null
            domainTarget.codiceProvinciaAttoNascita1 = null
            domainTarget.descrizioneComuneAttoNascita1 = null
            domainTarget.siglaProvinciaAttoNascita1 = null
            return
        }

        if (!TestoUtils.isVuoto(domainSource?.attoNascita?.idAttoAnsc)) {
            domainTarget.idAttoAnscNascita1 = domainSource?.attoNascita?.idAttoAnsc
        } else {
            domainTarget.ufficioAttoNascita1 = domainSource?.attoNascita?.ufficio
            domainTarget.annoAttoNascita1 = domainSource?.attoNascita?.anno
            domainTarget.attoAttoNascita1 = domainSource?.attoNascita?.atto
            domainTarget.parteAttoNascita1String = domainSource?.attoNascita?.parte?.toString()
            domainTarget.serieAttoNascita1 = domainSource?.attoNascita?.serie
        }

        domainTarget.codiceComuneAttoNascita1 = domainSource?.comuneAttoNascita?.codice
        domainTarget.codiceProvinciaAttoNascita1 = domainSource?.comuneAttoNascita?.codiceProvincia
        domainTarget.descrizioneComuneAttoNascita1 = domainSource?.comuneAttoNascita?.descrizione
        domainTarget.siglaProvinciaAttoNascita1 = domainSource?.comuneAttoNascita?.siglaProvincia
    }

    static void initEstremiAttoNascita2FromAnagrafe(IEstremiAttoNascitaSoggetto2Domain domainTarget, AnaAnagrafeBaseDomain domainSource){
        domainTarget.ufficioAttoNascita2 = domainSource?.attoNascita?.ufficio
        domainTarget.annoAttoNascita2 = domainSource?.attoNascita?.anno
        domainTarget.attoAttoNascita2 = domainSource?.attoNascita?.atto
        domainTarget.parteAttoNascita2String = domainSource?.attoNascita?.parte?.toString()
        domainTarget.serieAttoNascita2 = domainSource?.attoNascita?.serie

        domainTarget.idAttoAnscNascita2 = domainSource?.attoNascita?.idAttoAnsc

        domainTarget.codiceComuneAttoNascita2 = domainSource?.comuneAttoNascita?.codice
        domainTarget.codiceProvinciaAttoNascita2 = domainSource?.comuneAttoNascita?.codiceProvincia
        domainTarget.descrizioneComuneAttoNascita2 = domainSource?.comuneAttoNascita?.descrizione
        domainTarget.siglaProvinciaAttoNascita2 = domainSource?.comuneAttoNascita?.siglaProvincia
    }

    static void initEstremiAttoNascita2FromAnagrafeNuovaGestioneAnnotazione(IEstremiAttoNascitaSoggetto2Domain domainTarget, AnaAnagrafeBaseDomain domainSource) {
        if (domainSource == null) {
            domainTarget.ufficioAttoNascita2 = null
            domainTarget.annoAttoNascita2 = null
            domainTarget.attoAttoNascita2 = null
            domainTarget.parteAttoNascita2String = null
            domainTarget.serieAttoNascita2 = null
            domainTarget.idAttoAnscNascita2 = null
            domainTarget.codiceComuneAttoNascita2 = null
            domainTarget.codiceProvinciaAttoNascita2 = null
            domainTarget.descrizioneComuneAttoNascita2 = null
            domainTarget.siglaProvinciaAttoNascita2 = null
            return
        }

        if (!TestoUtils.isVuoto(domainSource?.attoNascita?.idAttoAnsc)) {
            domainTarget.idAttoAnscNascita2 = domainSource?.attoNascita?.idAttoAnsc
        } else {
            domainTarget.ufficioAttoNascita2 = domainSource?.attoNascita?.ufficio
            domainTarget.annoAttoNascita2 = domainSource?.attoNascita?.anno
            domainTarget.attoAttoNascita2 = domainSource?.attoNascita?.atto
            domainTarget.parteAttoNascita2String = domainSource?.attoNascita?.parte?.toString()
            domainTarget.serieAttoNascita2 = domainSource?.attoNascita?.serie
        }

        domainTarget.codiceComuneAttoNascita2 = domainSource?.comuneAttoNascita?.codice
        domainTarget.codiceProvinciaAttoNascita2 = domainSource?.comuneAttoNascita?.codiceProvincia
        domainTarget.descrizioneComuneAttoNascita2 = domainSource?.comuneAttoNascita?.descrizione
        domainTarget.siglaProvinciaAttoNascita2 = domainSource?.comuneAttoNascita?.siglaProvincia
    }

    static void initEstremiGiuramentoFromCittadinanza(CivDatiProvenienzaAtto domainTarget, CivCittadinanza domainSource){
        domainTarget.ufficioGiuramento = domainSource.ufficio
        domainTarget.annoGiuramento = domainSource.anno
        domainTarget.attoGiuramento = domainSource.atto
        domainTarget.idAttoAnscGiuramento = domainSource.idAttoAnsc
    }

    static void initEstremiGiuramentoFromCittadinanzaNuovaGestioneAnnotazione(CivDatiProvenienzaAtto domainTarget, CivCittadinanza domainSource) {
        if (domainSource == null) {
            domainTarget.ufficioGiuramento = null
            domainTarget.annoGiuramento = null
            domainTarget.attoGiuramento = null
            domainTarget.idAttoAnscGiuramento = null
            return
        }

        if(!TestoUtils.isVuoto(domainSource.idAttoAnsc)){
            domainTarget.idAttoAnscGiuramento = domainSource.idAttoAnsc
        } else {
            domainTarget.ufficioGiuramento = domainSource.ufficio
            domainTarget.annoGiuramento = domainSource.anno
            domainTarget.attoGiuramento = domainSource.atto
        }
    }

    static void initTestimoneFromAnagrafe(Testimone domainTarget, AnaAnagrafeBaseDomain domainSource){
        initSoggettoEsternoFromAnagrafe(domainTarget, domainSource)

        domainTarget.nazionalita = domainSource?.nazionalita
    }

    static void initSoggettoCollegatoFromAnagrafe(CivSoggettoCollegato domainTarget, AnaAnagrafeBaseDomain domainSource){
        initSoggettoEsternoFromAnagrafe(domainTarget, domainSource)

        //domainTarget.codiceFiscale = domainSource?.codiceFiscale
        domainTarget.nazionalita = domainSource?.nazionalita
    }

    static void initDichiaranteFromAnagrafe(CivDatiProvenienzaAtto domainTarget, AnaAnagrafeBaseDomain domainSource){
        initSoggettoEsternoFromAnagrafe(domainTarget, domainSource)

        domainTarget.nazionalita = domainSource?.nazionalita
    }

    static void initSoggettoDatFromAnagrafe(SoggettoDAT domainTarget, AnaAnagrafeBaseDomain domainSource){
        domainTarget.matricola = domainSource.matricola

        initSoggettoEsternoFromAnagrafe(domainTarget, domainSource)

        domainTarget.codiceFiscale = domainSource.codiceFiscale

        domainTarget.indirizzo = domainSource.indirizzo?.via
        domainTarget.cap = domainSource.indirizzo?.cap

        domainTarget.telefono = null
        domainTarget.indirizzoMail = null
    }

    static void initSoggettoEsternoFromAnagrafe(ISoggettoCollegato domainTarget, AnaAnagrafeBaseDomain domainSource){
        domainTarget.cognome = domainSource?.cognome
        domainTarget.nome = domainSource?.nome
        domainTarget.sesso = domainSource?.sesso
        domainTarget.dataNascita = domainSource?.dataNascita

        domainTarget.comuneNascita.codice = domainSource?.codiceComuneNascita
        domainTarget.comuneNascita.descrizione = domainSource?.descrizioneComuneNascita
        domainTarget.comuneNascita.codiceProvincia = domainSource?.codiceProvinciaNascita
        domainTarget.comuneNascita.siglaProvincia = domainSource?.siglaProvinciaNascita

        domainTarget.comuneResidenza.codice = domainSource?.comuneResidenza?.codice
        domainTarget.comuneResidenza.descrizione = domainSource?.comuneResidenza?.descrizione
        domainTarget.comuneResidenza.codiceProvincia = domainSource?.comuneResidenza?.codiceProvincia
        domainTarget.comuneResidenza.siglaProvincia = domainSource?.comuneResidenza?.siglaProvincia
    }

    static void initSoggetto1FromAnagrafe(ISoggettoAtto1 domainTarget, AnaAnagrafeBaseDomain domainSource){
        domainTarget.cognome1 = domainSource.cognome
        domainTarget.nome1 = domainSource.nome
        domainTarget.sesso1 = domainSource.sesso
        domainTarget.dataNascita1 = domainSource.dataNascita

        domainTarget.statoCivile1 = domainSource.statoCivile

        domainTarget.codiceComuneNascita1 = domainSource.codiceComuneNascita
        domainTarget.descrizioneComuneNascita1 = domainSource.descrizioneComuneNascita
        domainTarget.codiceProvinciaNascita1 = domainSource.codiceProvinciaNascita
        domainTarget.siglaProvinciaNascita1 = domainSource.siglaProvinciaNascita

        domainTarget.nazionalita1 = domainSource.nazionalita

        domainTarget.codiceComuneResidenza1 = domainSource.comuneResidenza.codice
        domainTarget.descrizioneComuneResidenza1 = domainSource.comuneResidenza.descrizione
        domainTarget.codiceProvinciaResidenza1 = domainSource.comuneResidenza.codiceProvincia
        domainTarget.siglaProvinciaResidenza1 = domainSource.comuneResidenza.siglaProvincia

        domainTarget.codiceFiscale1 = domainSource.codiceFiscale
        domainTarget.cfCalcolato1 = domainSource.cfCalcolato
    }

    static void initSoggetto2FromAnagrafe(ISoggettoAtto2 domainTarget, AnaAnagrafeBaseDomain domainSource){
        domainTarget.cognome2 = domainSource.cognome
        domainTarget.nome2 = domainSource.nome
        domainTarget.sesso2 = domainSource.sesso
        domainTarget.dataNascita2 = domainSource.dataNascita

        domainTarget.codiceComuneNascita2 = domainSource.codiceComuneNascita
        domainTarget.descrizioneComuneNascita2 = domainSource.descrizioneComuneNascita
        domainTarget.codiceProvinciaNascita2 = domainSource.codiceProvinciaNascita
        domainTarget.siglaProvinciaNascita2 = domainSource.siglaProvinciaNascita

        domainTarget.nazionalita2 = domainSource.nazionalita

        domainTarget.codiceComuneResidenza2 = domainSource.comuneResidenza.codice
        domainTarget.descrizioneComuneResidenza2 = domainSource.comuneResidenza.descrizione
        domainTarget.codiceProvinciaResidenza2 = domainSource.comuneResidenza.codiceProvincia
        domainTarget.siglaProvinciaResidenza2 = domainSource.comuneResidenza.siglaProvincia

        domainTarget.codiceFiscale2 = domainSource.codiceFiscale
        domainTarget.cfCalcolato2 = domainSource.cfCalcolato
    }

    static void initSoggetto1FromSoggetto1(ISoggettoAtto1 domainTarget, ISoggettoAtto1 domainSource){
        domainTarget.cognome1 = domainSource.cognome1
        domainTarget.senzaCognome1 = domainSource.senzaCognome1
        domainTarget.nome1 = domainSource.nome1
        domainTarget.senzaNome1 = domainSource.senzaNome1
        domainTarget.sesso1 = domainSource.sesso1
        domainTarget.dataNascita1 = domainSource.dataNascita1
        domainTarget.codiceComuneNascita1 = domainSource.codiceComuneNascita1
        domainTarget.descrizioneComuneNascita1 = domainSource.descrizioneComuneNascita1
        domainTarget.codiceProvinciaNascita1 = domainSource.codiceProvinciaNascita1
        domainTarget.siglaProvinciaNascita1 = domainSource.siglaProvinciaNascita1
        domainTarget.codiceComuneResidenza1 = domainSource.codiceComuneResidenza1
        domainTarget.descrizioneComuneResidenza1 = domainSource.descrizioneComuneResidenza1
        domainTarget.codiceProvinciaResidenza1 = domainSource.codiceProvinciaResidenza1
        domainTarget.siglaProvinciaResidenza1 = domainSource.siglaProvinciaResidenza1
        domainTarget.codiceFiscale1 = domainSource.codiceFiscale1
        domainTarget.cfCalcolato1 = domainSource.cfCalcolato1
        domainTarget.nazionalita1 = domainSource.nazionalita1
    }

    static void initSoggetto2FromSoggetto2(ISoggettoAtto2 domainTarget, ISoggettoAtto2 domainSource){
        domainTarget.cognome2 = domainSource.cognome2
        domainTarget.senzaCognome2 = domainSource.senzaCognome2
        domainTarget.nome2 = domainSource.nome2
        domainTarget.senzaNome2 = domainSource.senzaNome2
        domainTarget.sesso2 = domainSource.sesso2
        domainTarget.dataNascita2 = domainSource.dataNascita2
        domainTarget.codiceComuneNascita2 = domainSource.codiceComuneNascita2
        domainTarget.descrizioneComuneNascita2 = domainSource.descrizioneComuneNascita2
        domainTarget.codiceProvinciaNascita2 = domainSource.codiceProvinciaNascita2
        domainTarget.siglaProvinciaNascita2 = domainSource.siglaProvinciaNascita2
        domainTarget.codiceComuneResidenza2 = domainSource.codiceComuneResidenza2
        domainTarget.descrizioneComuneResidenza2 = domainSource.descrizioneComuneResidenza2
        domainTarget.codiceProvinciaResidenza2 = domainSource.codiceProvinciaResidenza2
        domainTarget.siglaProvinciaResidenza2 = domainSource.siglaProvinciaResidenza2
        domainTarget.cfCalcolato2 = domainSource.cfCalcolato2
        domainTarget.codiceFiscale2 = domainSource.codiceFiscale2
        domainTarget.nazionalita2 = domainSource.nazionalita2
    }

    static void initAttoOriginaleAnagrafeFromDatiProvenienzaAtto(CivAnagrafe domainTarget, CivDatiProvenienzaAtto domainSource){
        domainTarget.ufficioAttoOriginale = domainSource.ufficioAttoOriginale
        domainTarget.annoAttoOriginale = domainSource.annoAttoOriginale
        domainTarget.attoAttoOriginale = domainSource.attoAttoOriginale
        domainTarget.parteAttoOriginale = domainSource.parteAttoOriginale
        domainTarget.serieAttoOriginale = domainSource.serieAttoOriginale
        domainTarget.codiceComuneAttoOriginale = domainSource.comuneAttoOriginale.codice
        domainTarget.codiceProvinciaAttoOriginale = domainSource.comuneAttoOriginale.codiceProvincia

        domainTarget.idAttoAnscAttoOriginale = domainSource?.idAttoAnscAttoOriginale
    }

    static void cancellaEstremiAttoRiconoscimento1(CivDatiProvenienzaAtto domainTarget){
        domainTarget.numeroAttoRiconoscimento1 = null
        domainTarget.parteAttoRiconoscimento1 = null
        domainTarget.serieAttoRiconoscimento1 = null
        domainTarget.ufficioAttoRiconoscimento1 = null
        domainTarget.annoAttoRiconoscimento1 = null
        domainTarget.idAttoAnscRiconoscimento1 = null

        domainTarget.comuneAttoRiconoscimento1.codice = null
        domainTarget.comuneAttoRiconoscimento1.descrizione = null
        domainTarget.comuneAttoRiconoscimento1.codiceProvincia = null
        domainTarget.comuneAttoRiconoscimento1.siglaProvincia = null

        domainTarget.dataAttoRiconoscimento1 = null
    }

    static void cancellaEstremiAttoRiconoscimento2(CivDatiProvenienzaAtto domainTarget){
        domainTarget.numeroAttoRiconoscimento2 = null
        domainTarget.parteAttoRiconoscimento2 = null
        domainTarget.serieAttoRiconoscimento2 = null
        domainTarget.ufficioAttoRiconoscimento2 = null
        domainTarget.annoAttoRiconoscimento2 = null
        domainTarget.idAttoAnscRiconoscimento2 = null

        domainTarget.comuneAttoRiconoscimento2.codice = null
        domainTarget.comuneAttoRiconoscimento2.descrizione = null
        domainTarget.comuneAttoRiconoscimento2.codiceProvincia = null
        domainTarget.comuneAttoRiconoscimento2.siglaProvincia = null

        domainTarget.dataAttoRiconoscimento2 = null
    }

    static void cancellaEstremiProvvedimentoSeparazione(CivDatiProvenienzaAtto domainTarget){
        domainTarget.enteSeparazione = null
        domainTarget.comuneAttoSeparazione = null
        domainTarget.estremiSeparazione = null
        domainTarget.dataAttoSeparazione = null
    }

    static void cambiaTipoAttoAnnotazioneSuAttoNascita(CivAnnotazioneAtto annotazione, CivAttoBaseDomain attoSource){
        annotazione.tipoAtto = null
        switch (attoSource.getTipoAttoEnum()) {
            case ETipoAtto.MAT:
                annotazione.tipoAtto = new Integer(CivMatrimonio.tipoAttoAnnotazioneSuAttoNascitaAltroComune)
                break
            case ETipoAtto.MOR:
                annotazione.tipoAtto = new Integer(CivMorte.tipoAttoAnnotazioneSuAttoNascitaAltroComune)
                break
            case ETipoAtto.UCI:
                annotazione.tipoAtto = new Integer(CivUnioneCivile.tipoAttoAnnotazioneSuAttoNascitaAltroComune)
                break
            case ETipoAtto.CIT:
                annotazione.tipoAtto = new Integer(CivCittadinanza.tipoAttoAnnotazioneSuAttoNascitaAltroComune)
                break
        }
    }

    static void cambiaTipoAttoAnnotazioneSuAttoMatrimonio(CivAnnotazioneAtto annotazione, CivAttoBaseDomain attoSource){
        annotazione.tipoAtto = null
        switch (attoSource.getTipoAttoEnum()) {
            case ETipoAtto.MAT:
                annotazione.tipoAtto = new Integer(CivMatrimonio.tipoAttoAnnotazioneSuAttoMatrimonioAltroComune)
                break
            case ETipoAtto.UCI:
                //FIXME: verificare caso UCN: chiedere a Chris se possibile
                annotazione.tipoAtto = new Integer(CivUnioneCivile.tipoAttoAnnotazioneSuAttoUnioneCivileAltroComune)
                break
        }
    }

    static void cambiaFormulaAnnotazione(CivAnnotazioneAtto annotazione, String idFormulaDfa, String tipoFormula){
        annotazione.formula = null
        if (idFormulaDfa){
            annotazione.formula = tipoFormula + idFormulaDfa.substring(1)
        }
    }

    static ETipoSN convertStampaSuEstrattoToStampaSuEstrattoDb(Boolean val) {
        return val ? ETipoSN.S : null
    }

    static void allineaTestoMinuscole(Object entity, Map<String,Boolean> minuscole){
        // Se ho salvato un testo con lettere minuscole, devo allineare il flag al testo
        for (Map.Entry<String, Boolean> m in minuscole) {
            String valore = null
            if (entity.hasProperty("minuscoleProperties")){
                Map<String, String> mp = entity.minuscoleProperties
                String mpProp = mp.get(m.key)
                if (mpProp){
                    valore = entity."$mpProp"
                }
            } else {
                valore = entity.hasProperty("$m.key")?entity."$m.key":null
            }
            if ( valore && (!(minuscole[m.key]) ) ) {
                for (int i=0;i<valore.length();i++){
                    if (Character.isLowerCase(valore.charAt(i))){
                        minuscole[m.key] = Boolean.TRUE
                    }
                }
            }
        }
    }

    static void cancellaEstremiCertificazione(CivDatiProvenienzaAtto domainTarget) {
        domainTarget.autoritaEnteStraniero = null
        domainTarget.dataAttoEnteStraniero = null
        domainTarget.comuneEnteStraniero = null
        domainTarget.estremiAttoEnteStraniero = null
        domainTarget.tipoAttoEnteStraniero = null
    }

    static void cancellaDatiPubblicazioni(CivMargine domainTarget) {
        domainTarget.documentoPresentatoMatrimonio = null
        domainTarget.comuneAffissione1 = null
        domainTarget.dataAffissioneDa1 = null
        domainTarget.dataAffissioneA1 = null
        domainTarget.consolatoAffisione1 = null
        domainTarget.comuneAffissione2 = null
        domainTarget.dataAffissioneDa2 = null
        domainTarget.dataAffissioneA2 = null
        domainTarget.consolatoAffisione2 = null
    }

    static String calculateIdEmissione(Integer annoEmissione, Integer progressivoEmissione) {
        if (annoEmissione && progressivoEmissione) {
            return (annoEmissione.toString() + StringUtils.leftPad(progressivoEmissione.toString(), 6, "0"))
        }
        return null
    }

}
