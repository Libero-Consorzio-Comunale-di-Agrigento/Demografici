package it.finmatica.de4gsdzk.utils.requestforwarding

import org.springframework.stereotype.Component

import java.util.concurrent.ConcurrentHashMap

@Component
class RequestForwardingStore {
    private final ConcurrentHashMap<String, Object> requestMap = new ConcurrentHashMap<>()

    String storeRequestForwardingParams(RequestForwardingParams params) {
        return storeObject(params)
    }

    RequestForwardingParams retrieveRequestForwardingParams(String requestId) {
        Object object = retrieveObject(requestId)
        if (object == null) {
            return new RequestForwardingParams()
        }
        return (RequestForwardingParams) object
    }

    String storeObject(Object value) {
        String requestId = UUID.randomUUID().toString()
        requestMap.put(requestId, value)
        return requestId
    }

    Object retrieveObject(String requestId) {
        if (!requestMap.containsKey(requestId)) {
            return null
        }
        return requestMap.remove(requestId)
    }
}
