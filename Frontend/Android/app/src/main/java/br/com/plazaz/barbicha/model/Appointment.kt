package br.com.plazaz.barbicha.model

import java.util.*

data class Appointment(val uuid:String = UUID.randomUUID().toString(), val startDate: Date, var interval: Int,
                       var serviceType: Int, var status: Status,
                       var barberUUID:String?, var customerUUID: String?, var customerName: String?) {

    var isEmpty = {this.status == Status.empty}
    var isUnavailable = {this.status = Status.unavailable}

    fun updateValues(with: Appointment) {return}

    enum class Status {requested, cancelled, confirmed, executed, evaluated, empty, unavailable}

    companion object {

        const val kUUID = "UUID"
        const val kDate = "startDate"
        const val kInterval = "interval"
        const val kType = "serviceType"
        const val kStatus = "status"
        const val kBarber = "barberUUID"
        const val kCustId = "customerUUID"
        const val kCustName = "customerName"

        fun empty(date: Date, interval: Int): Appointment {return Appointment(startDate = date, interval = interval, serviceType = AppointmentType.empty().index, status = Status.empty, barberUUID = null, customerUUID = null, customerName = null)}
        fun unavailable(date: Date, interval: Int): Appointment {return Appointment(startDate = date, interval = interval, serviceType = AppointmentType.empty().index, status = Status.unavailable, barberUUID = null, customerUUID = null, customerName = null)}

        fun fromMap(map: Map<String, Any>) : Appointment {

            val uuid = map.get(kUUID) as String
            val date = map.get(kDate) as Date
            val interval = map.get(kInterval) as Long
            val type = map.get(kType) as Long
            val statusKey = map.get(kStatus) as String
            val status = Status.valueOf(statusKey)
            val barber = map.get(kBarber) as String
            val custId = map.get(kCustId) as String?
            val custoName = map.get(kCustName) as String?

            return Appointment(uuid, date, interval.toInt(), type.toInt(), status, barber, custId, custoName)

        }

    }

}