package br.com.plazaz.barbicha.helpers

import br.com.plazaz.barbicha.model.Barber
import br.com.plazaz.barbicha.model.Barbershop
import java.util.*

class MockData {

    companion object Mock {

        fun create(): Barbershop {

            val shop = Barbershop(uuid = UUID.randomUUID().toString(), name = "Brotherhood")
            val jonas = Barber(uuid = UUID.randomUUID().toString(), name = "Jonas Rex")
            val douglas = Barber(uuid = UUID.randomUUID().toString(), name = "Douglas")
            shop.updateBarbersFromCloud(setOf(jonas, douglas));
            return shop

        }

    }

}