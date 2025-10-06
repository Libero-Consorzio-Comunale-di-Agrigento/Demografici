package it.finmatica.de4gsdzk.ansc

class AnscResponse {

    private final String stringResponse
    private final String xmlResponse

    AnscResponse(String stringResponse, String xmlResponse){
        this.stringResponse = stringResponse
        this.xmlResponse = xmlResponse
    }

    String getStringResponse() {
        return stringResponse
    }

    String getXmlResponse() {
        return xmlResponse
    }
}
