package it.finmatica.de4gsdzk.anagrafe.visualizzazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.utils.requestforwarding.RequestForwardingParams
import it.finmatica.de4gsdzk.utils.requestforwarding.RequestForwardingStore
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestParam

@Slf4j
@Controller
class VisualizzazioneController {

    RequestForwardingStore requestForwardingStore

    VisualizzazioneController(RequestForwardingStore requestForwardingStore) {
        this.requestForwardingStore = requestForwardingStore
    }

    @GetMapping("/anagrafe/visualizzazione")
    String redirect(@RequestParam Map<String, String> params) {
        RequestForwardingParams rfp = new RequestForwardingParams(params)
        String requestId = requestForwardingStore.storeRequestForwardingParams(rfp)
        return "redirect:/restrict/anagrafe/index.zul?requestId=$requestId"
    }
}
