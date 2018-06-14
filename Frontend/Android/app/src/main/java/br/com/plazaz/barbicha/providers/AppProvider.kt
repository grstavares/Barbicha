package br.com.plazaz.barbicha.providers

import br.com.plazaz.barbicha.model.Barbershop

object AppProvider {

    var barbershop: Barbershop? = null
        private set

    var dataProvider: DataProvider? = null
        private set

    fun initializeWith(shop: Barbershop) {

        this@AppProvider.barbershop = shop
        this@AppProvider.dataProvider = FirebaseProvider(shop)

    }

}