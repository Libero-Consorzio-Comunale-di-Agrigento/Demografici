package it.finmatica.de4gsdzk.ansc

import com.auth0.jwt.HeaderParams
import com.auth0.jwt.JWT
import com.auth0.jwt.JWTCreator
import com.auth0.jwt.algorithms.Algorithm
import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.AnscRuntimeException
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.utils.IAnscPaginazione
import it.finmatica.de4gsdzk.utils.IRicercaEventoAnsc
import it.finmatica.de4gsdzk.utils.IRicercaAnsc
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

import javax.xml.bind.DatatypeConverter
import java.security.Key
import java.security.KeyPair
import java.security.KeyStore
import java.security.PrivateKey
import java.security.cert.Certificate
import java.security.interfaces.RSAPrivateKey
import java.security.interfaces.RSAPublicKey
import java.time.Instant

@Slf4j
@Transactional
@Service
class AnscJsonService {

    private final GsdService gsdService

    private final AnscSezioneService anscSezioneService

    private final AnscCampoService anscCampoService

    private final AnscParametroService anscParametroService

    AnscJsonService(AnscSezioneService anscSezioneService, AnscCampoService anscCampoService,
                    AnscParametroService anscParametroService, GsdService gsdService) {
        this.anscSezioneService = anscSezioneService
        this.anscCampoService = anscCampoService
        this.anscParametroService = anscParametroService
        this.gsdService = gsdService
    }

    LinkedHashMap<String, ?> buildJwsPayloadClaims(String servizio, Integer tipoAtto, Integer livello, AnscSezione sezionePadre,
                                                   Long idRif, Long idCdu, Long pkAtto, Long idOperazione, AnscCredenziali cre, IRicercaAnsc ricerca=null, IAnscPaginazione paginazione=null, IRicercaEventoAnsc ricercaEvento = null) {
        LinkedHashMap<String, ?> mJson = build(servizio, tipoAtto, livello, sezionePadre, idRif, idCdu, pkAtto, idOperazione, cre, ricerca, paginazione, ricercaEvento)
        return mJson
    }

    private LinkedHashMap<String, ?> build(String servizio, Integer tipoAtto, Integer livello, AnscSezione sezionePadre,
                                           Long idRif, Long idCdu, Long pkAtto, Long idOperazione, AnscCredenziali cre, IRicercaAnsc ricerca = null, IAnscPaginazione paginazione = null, IRicercaEventoAnsc ricercaEvento = null) {
        if (livello == null){
            throw new De4gsdzkRuntimeException("Errore in costruzione sezione json da inviare ad ANSC - indicare il livello di annidamento")
        }
        List<AnscSezione> lSezioni
        if (sezionePadre != null){
            lSezioni = anscSezioneService.listAllByServizioAndTipoAttoAndUseCaseAndLivelloAndSezionePadre(servizio, tipoAtto, idCdu, livello, sezionePadre)
        } else {
            lSezioni = anscSezioneService.listAllByServizioAnyAndTipoAttoAnyAndUseCaseAnyAndLivelloOrderBySequenzaAsc(servizio, tipoAtto, idCdu, livello)
        }
        LinkedHashMap<String, ?> mj = new LinkedHashMap<>()
        for (AnscSezione s: lSezioni){
            boolean skip = false
            if (s.useCasesEsclusi?.trim() && (idCdu != null) ){
                List<String> lCduEscl = s.useCasesEsclusi.tokenize(";")
                for (String c:lCduEscl){
                    try {
                        Long cLong = Long.valueOf(c?.trim())
                        if (cLong.compareTo(idCdu) == 0) {
                            skip = true
                            break
                        }
                    } catch (Exception ex){
                        log.warn ("Errore in conversione id cdu " + ex.getMessage())
                    }
                }
            }
            if (skip)
                continue
            if (s.vista != null){
                LinkedHashMap<String, String> mCampi = new LinkedHashMap<>()
                if (s.hasCampi) {
                    List<AnscCampo> lCampi = anscCampoService.listAllBySezione(s)
                    if (lCampi.size() > 0) {
                        for (AnscCampo c: lCampi){
                            mCampi.put((c.campoDb?:c.campo).toUpperCase(), c.campo)
                        }
                        List<Map<String, ?>> ll = gsdService.anscQuery(mCampi, s.vista, s.parametro, s.flagOtpFirma, idRif, pkAtto, idOperazione, cre, ricerca, paginazione, ricercaEvento)
                        if (s.isArray){
                            mj.put(s.nomeSezione, ll)
                        } else {
                            Map<String, ?> mUnique = ll[0]
                            mj.put(s.nomeSezione, mUnique)
                        }
                    }
                } else {
                    mCampi.put((s.campoDb?:s.nomeSezione).toUpperCase(), s.nomeSezione)
                    List<Map<String, ?>> ll = gsdService.anscQuery(mCampi, s.vista, s.parametro, s.flagOtpFirma, idRif, pkAtto, idOperazione, cre, ricerca, paginazione, ricercaEvento)
                    if (s.isArray){
                        ArrayList<Long> llValori = new ArrayList<Long>()
                        for (Map mVal: ll) {
                            llValori.add((Long)mVal.get(s.nomeSezione))
                        }
                        mj.put(s.nomeSezione, llValori)
                    } else {
                        mj.putAll(ll[0])
                    }
                }
            }
            Map<String, ?> mi = build(servizio, tipoAtto, livello + 1, s, idRif, idCdu, pkAtto, idOperazione, cre)
            if (mi?.size()){
                if (mj.containsKey(s.nomeSezione)){
                    if (s.isArray) {
                        List<Map<String, ?>> llInner = (List<Map<String, ?>>) mj.get(s.nomeSezione)
                        if (llInner?.size() == 1){
                            LinkedHashMap<String, ?> innerVal = (LinkedHashMap) llInner[0]
                            innerVal.putAll(mi)
                        } else {
                            throw new De4gsdzkRuntimeException("Errore in costruzione sezione ${s.nomeSezione} da inviare ad ANSC")
                        }
                    } else {
                        LinkedHashMap<String, ?> val = (LinkedHashMap) mj.get(s.nomeSezione)
                        if (val) {
                            val.putAll(mi)
                        } else {
                            throw new AnscRuntimeException("La sezione ${s.nomeSezione} non contiene dati!")
                        }
                    }
                } else {
                    mj.put(s.nomeSezione, mi)
                }
            }
        }
        return mj
    }

    LinkedHashMap<String, String> generateTokens(LinkedHashMap<String, String> jwtPayloadClaims, Boolean jwsEnabled, LinkedHashMap<String, ?> jwsPayloadClaims) throws Exception {
        LinkedHashMap<String, String> tokenMap = new LinkedHashMap<>()

        // Certificato
        byte[] certByteArray = anscParametroService.get(AnscParametro.CERTIFICATO)?.blobAllegato
        String certPwd = anscParametroService.get(AnscParametro.PASSWORD)?.valore
        if ( (certByteArray == null) || (certPwd == null)){
            throw new De4gsdzkRuntimeException("Configurazione ANSC incompleta")
        }

        Key key = null
        Certificate cert = null
        KeyStore ks = KeyStore.getInstance(AnscUtils.KEYSTORE_TYPE)
        ks.load(new ByteArrayInputStream(certByteArray), certPwd.toCharArray())
        Enumeration aliasEnum = ks.aliases()
        while (aliasEnum.hasMoreElements()) {
            String keyName = (String) aliasEnum.nextElement()
            key = ks.getKey(keyName, certPwd.toCharArray())
            cert = ks.getCertificate(keyName)
        }
        KeyPair keyPair = new KeyPair(cert.getPublicKey(), (PrivateKey) key)

        // Header
        Map<String, Object> headerClaims = new HashMap<>()
        headerClaims.put(HeaderParams.TYPE, AnscUtils.HEADER_JWT_TYPE)
        headerClaims.put(HeaderParams.ALGORITHM, AnscUtils.ALGORITHM_TYPE)

        // JWT
        Map<String, Object> jwtHeaderClaims = new HashMap<>()
        jwtHeaderClaims.putAll(headerClaims)
        // Versione per java 7
        String[] strArray = [DatatypeConverter.printBase64Binary(cert.getEncoded())]
        //String[] strArray = [Base64.getEncoder().encodeToString(cert.getEncoded())]
        jwtHeaderClaims.put(AnscUtils.X5C_PROPERTY, strArray)
        JWTCreator.Builder tokenJwtBuilder = JWT.create()
                .withHeader(jwtHeaderClaims)
                .withJWTId(UUID.randomUUID().toString())
                .withExpiresAt(Date.from(Instant.now().plusSeconds(AnscUtils.TOKEN_DURATION)))
                .withIssuedAt(Date.from(Instant.now().minusSeconds(AnscUtils.SCARTO_IAT)))
        tokenJwtBuilder.withPayload(jwtPayloadClaims)

        String tokenJwt = tokenJwtBuilder.sign(Algorithm.RSA256(((RSAPublicKey) keyPair.getPublic()), ((RSAPrivateKey) keyPair.getPrivate())))
        tokenMap.put(AnscUtils.HEADER_JWT_TYPE, tokenJwt)

        // JWS
        if (jwsEnabled) {
            Map<String, Object> jwsHeaderClaims = new HashMap<>()
            jwsHeaderClaims.putAll(headerClaims)
            JWTCreator.Builder tokenJwsBuilder = JWT.create()
                    .withHeader(jwsHeaderClaims)
            tokenJwsBuilder.withPayload(jwsPayloadClaims)

            String tokenJwsFull = tokenJwsBuilder.sign(Algorithm.RSA256(((RSAPublicKey) keyPair.getPublic()), ((RSAPrivateKey) keyPair.getPrivate())))
            String tokenJws = tokenJwsFull.substring(0, (tokenJwsFull.indexOf(".") + 1)) + tokenJwsFull.substring(tokenJwsFull.lastIndexOf("."))
            tokenMap.put(AnscUtils.HEADER_JWS_TYPE, tokenJws)
            tokenMap.put(AnscUtils.HEADER_JWS_FULL_TYPE, tokenJwsFull)
        } else {
            tokenMap.put(AnscUtils.HEADER_JWS_TYPE, null)
            tokenMap.put(AnscUtils.HEADER_JWS_FULL_TYPE, null)
        }

        return tokenMap
    }
}
