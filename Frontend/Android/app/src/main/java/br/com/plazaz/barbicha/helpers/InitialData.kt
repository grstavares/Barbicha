package br.com.plazaz.barbicha.helpers

import br.com.plazaz.barbicha.model.Barber
import br.com.plazaz.barbicha.model.Barbershop
import java.util.*

object Initial {

    val instance: Barbershop

    init {
        val shop = Barbershop(uuid = "0BC576BD-D174-4F40-8E21-5962A403BCA1", name = "Brotherhood")
        val jonas = Barber(uuid = "wsXpZZkBJlQniVbIjLe4UPsEDUA2", name = "Jonas Rex")
        val douglas = Barber(uuid = "7A802D59-1098-4AD6-8E9E-7DC48092ED33", name = "Douglas")
        shop.updateBarbersFromCloud(setOf(jonas, douglas));
        this.instance = shop
    }

}