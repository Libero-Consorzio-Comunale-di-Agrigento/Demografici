package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.errors.AnscClientUnmanagedStatusException
import org.apache.http.HttpStatus
import org.json.JSONException
import org.json.JSONObject
import org.json.XML
import org.springframework.web.bind.annotation.RequestMethod

import java.nio.charset.StandardCharsets

class AnscClient {

    private final String json

    AnscClient(String jwsPayloadClaimsString) {
        //this.json = JsonOutput.toJson(jwsPayloadClaims)
        this.json = jwsPayloadClaimsString
    }

    AnscResponse getResponse(String wsdl, String responseXML, String tokenJwt, String tokenJws) throws Exception {
        URL url = new URL(wsdl)
        HttpURLConnection conn = (HttpURLConnection) url.openConnection()
        conn.setRequestMethod(RequestMethod.POST.name())
        conn.setRequestProperty("Content-Type", "application/json")
        conn.setRequestProperty("Authorization", "Bearer " + tokenJwt)
        if (tokenJws){
            conn.setRequestProperty(AnscUtils.HEADER_JWS_TYPE, tokenJws)
        }
        conn.setDoOutput(true)

        //try {
        OutputStream os = conn.getOutputStream()
        byte[] input = json.getBytes(StandardCharsets.UTF_8.name())
        //byte[] input = json.getBytes("WINDOWS-1252")
        os.write(input, 0, input.length)
        //} catch (IOException){

        //}

        BufferedReader br
        String responseLine
        StringBuilder response = new StringBuilder()

        if (!isManagedStatusCode(conn.getResponseCode())) {
            throw new AnscClientUnmanagedStatusException(conn.getResponseCode())
        }

        if (conn.getResponseCode() == 200) {
            br = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8.name()))
        } else {
            br = new BufferedReader(new InputStreamReader(conn.getErrorStream(), StandardCharsets.UTF_8.name()))
        }
        while ((responseLine = br.readLine()) != null) {
            response.append(responseLine.trim())
        }
        String stringResponse = response.toString()
        conn.disconnect()

        String xmlResponse = null
        if (Boolean.parseBoolean(responseXML) && !stringResponse.startsWith("<")){
            if (stringResponse.startsWith("{")){
                xmlResponse = convertToXML(stringResponse, "root")
            }
        }
        return new AnscResponse(stringResponse, xmlResponse)
    }

    private isManagedStatusCode(int status) {
        status in [HttpStatus.SC_OK, HttpStatus.SC_BAD_REQUEST, HttpStatus.SC_UNAUTHORIZED, HttpStatus.SC_FORBIDDEN, HttpStatus.SC_NOT_FOUND, HttpStatus.SC_NOT_ACCEPTABLE, HttpStatus.SC_PRECONDITION_FAILED, HttpStatus.SC_INTERNAL_SERVER_ERROR]
    }

    // https://www.javatpoint.com/convert-json-to-xml-in-java
    private String convertToXML(String jsonString, String root) throws JSONException {    // handle JSONException

        // create instance of JSONObject by passing jsonString to the constructor
        JSONObject jsonObject = new JSONObject(jsonString)

        // use XML.toString() method to convert JSON into XML and store the result into a string
        String xml = "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n<"+root+">" + XML.toString(jsonObject) + "</"+root+">"

        // pass the XML data to the main() method
        return xml
    }

}