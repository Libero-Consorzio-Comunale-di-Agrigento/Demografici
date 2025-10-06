package it.finmatica.de4gsdzk.utils

class Funzioni<T> {
    Map<T, FunzioneState> funzioni = [:]

    void set(T funzione, Boolean visible, Boolean enabled) {
        funzioni.put(funzione, new FunzioneState(visible: visible, enabled: enabled))
    }

    Boolean isVisible(T funzione) {
        return funzioni.get(funzione)?.visible ?: false
    }

    Boolean isEnabled(T funzione) {
        return funzioni.get(funzione)?.enabled ?: false
    }

    private static class FunzioneState {
        Boolean visible
        Boolean enabled
    }
}
