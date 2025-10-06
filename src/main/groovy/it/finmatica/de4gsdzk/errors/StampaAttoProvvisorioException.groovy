package it.finmatica.de4gsdzk.errors

class StampaAttoProvvisorioException extends De4gsdzkRuntimeException {

    StampaAttoProvvisorioException(Map<String, String> etichetta) {
        super(etichetta, (String) etichetta?.defaultValue)
    }

}
