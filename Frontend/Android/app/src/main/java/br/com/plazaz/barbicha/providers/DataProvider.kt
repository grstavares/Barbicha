package br.com.plazaz.barbicha.providers

interface DataProvider {

    fun addListener(listener: ProviderListener): String
    fun removeListener(token: String)

}

interface ProviderListener {

    fun receiveMessage(message: String)

}

enum class DataProviderObservableEvent {

    barbershopUpdated, barberListUpdated, serviceTypesUpdated, appointmensUpdated

}