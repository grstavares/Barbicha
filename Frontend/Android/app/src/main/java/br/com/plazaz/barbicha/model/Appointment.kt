package br.com.plazaz.barbicha.model

import java.util.*

data class Appointment(val uuid:String = UUID.randomUUID().toString(), val startDate: Date, var interval: Int,
                       var serviceType: Int, var status: Status,
                       var barberUUID:String?, var customerUUID: String?, var customerName: String?) {

    fun updateValues(with: Appointment) {return}

    enum class Status {requested, cancelled, confirmed, executed, evaluated, empty, unavailable}

}