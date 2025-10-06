package it.finmatica.de4gsdzk.utils

import groovy.util.logging.Slf4j
import it.finmatica.jsign.api.SignedObjectReaderFactory
import it.finmatica.jsign.api.SignedObjectReaderI
import it.finmatica.jsign.utils.Utils
import it.finmatica.jsign.verify.api.SimpleVerifier
import it.finmatica.jsign.verify.result.CriticityLevel
import it.finmatica.jsign.verify.result.VerifyResult

@Slf4j
class FirmaUtils {

    /** Verifica se il file passato è firmato
     *
     * @param fileIS inputStream contenente il file da verificare
     * @return false	=> non firmato
     * 		   true		=> firmato
     */
    static boolean isSigned(InputStream fileIS) throws Exception{
        boolean signed = false
        SimpleVerifier v
        try {
            v = new SimpleVerifier ()
            VerifyResult res = v.isSigned(fileIS)
            //MODIFICHE PER BIGDIMENSION
            //VerifyResult res= v.isSignedLarge(fileIS, getTypeFromName(nomeFile));

            signed = (res.isValid(CriticityLevel.HIGH) && !"".equals(res.toStringTXT()))
        } catch (Exception e) {
            log.error(e.getMessage())
            //throw e;
            signed = false
        }
        return signed
    }

    static Boolean verify(InputStream fileIS, boolean verificaCRL, CriticityLevel criticityLevel=CriticityLevel.HIGH) throws Exception{
        // bisogna utilizzare un'altra variabile perchè altrimenti l'inputStream è vuoto.

        byte[] bfile = Utils.readBytesFromInputStream(fileIS)
        InputStream fileFirmato = new ByteArrayInputStream(bfile)

        if (!isSigned(fileFirmato)) {
            return false
        }

        fileIS = new ByteArrayInputStream(bfile)
        SignedObjectReaderI reader = SignedObjectReaderFactory.getSignedObjectReader(fileIS)
        VerifyResult verifyResult = reader.verify(verificaCRL) // "false" indica di NON verificare anche le CRL.
        return verifyResult.isValid(criticityLevel)
    }

}
