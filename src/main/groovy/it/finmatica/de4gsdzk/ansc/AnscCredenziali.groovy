package it.finmatica.de4gsdzk.ansc

class AnscCredenziali {

    private final AnscUtente anscUtente
    private final String anscOtp

    private final String utenteFirmaRemota
    private final String pwdFirmaRemota
    private final String otpFirmaRemota

    AnscCredenziali(AnscUtente anscUtente, String anscOtp){
        this.anscUtente = anscUtente
        this.anscOtp = anscOtp
        this.utenteFirmaRemota = null
        this.pwdFirmaRemota = null
        this.otpFirmaRemota = null
    }

    AnscCredenziali(AnscUtente anscUtente, String anscOtp, String utenteFirmaRemota, String pwdFirmaRemota, String otpFirmaRemota){
        this.anscUtente = anscUtente
        this.anscOtp = anscOtp
        this.utenteFirmaRemota = utenteFirmaRemota?.bytes?.encodeBase64()?.toString()
        this.pwdFirmaRemota = pwdFirmaRemota?.bytes?.encodeBase64()?.toString()
        this.otpFirmaRemota = otpFirmaRemota?.bytes?.encodeBase64()?.toString()
    }

    AnscUtente getAnscUtente() {
        return anscUtente
    }

    String getAnscOtp() {
        return anscOtp
    }

    String getUtenteFirmaRemota() {
        return utenteFirmaRemota
    }

    String getPwdFirmaRemota() {
        return pwdFirmaRemota
    }

    String getOtpFirmaRemota() {
        return otpFirmaRemota
    }

}
