package it.finmatica.de4gsdzk.utils

class Paginazione<T> {

    public static final int activePage = 0
    public static final int pageSize = 30

    private final List<T> lista
    private final long count

    Paginazione(List<T> lista, long count) {
        this.lista = lista
        this.count = count
    }

    List<T> getLista() {
        return lista
    }

    long getCount() {
        return count
    }
}
