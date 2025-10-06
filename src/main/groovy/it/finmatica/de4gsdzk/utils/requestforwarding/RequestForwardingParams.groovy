package it.finmatica.de4gsdzk.utils.requestforwarding

class RequestForwardingParams {
    private Map<String, Object> map

    RequestForwardingParams() {
        this([:] as Map<String, Object>)
    }

    RequestForwardingParams(Map<String, Object> source) {
        map = new HashMap<>()
        source.each { k, v ->
            map.put(k, v)
        }
    }

    Object get(String key) {
        if (!map.containsKey(key)) {
            return null
        }
        return map.get(key)
    }
}
