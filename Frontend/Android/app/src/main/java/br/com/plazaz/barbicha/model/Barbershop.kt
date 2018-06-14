package br.com.plazaz.barbicha.model

import android.util.Log
import br.com.plazaz.barbicha.logTag
import br.com.plazaz.barbicha.protocols.*
import java.net.URL
import java.util.*
import kotlin.collections.ArrayList

class Barbershop(uuid: String, name: String, imageURL: URL? = null, latitude: Double? = null, longitude: Double? = null,
                 serviceTypes: ArrayList<AppointmentType> = arrayListOf(), barbers: ArrayList<Barber> = arrayListOf(), appointments: ArrayList<Appointment> = arrayListOf()) : EventEmitter {

    val uuid: String = uuid;
    var name: String = name;
    var latitude: Double? = latitude;
    var longitude: Double? = longitude;
    var imageURL: URL? = imageURL;
    var imageData: ByteArray? = null;

    var serviceTypes: ArrayList<AppointmentType> = serviceTypes
        private set;

    var barbers: ArrayList<Barber> = barbers
        private set;

    var appointments: List<Appointment> = appointments
        private set;

    var observers: ArrayList<EventObserver> = arrayListOf()

    fun location(): Pair<Double?, Double?> = Pair(this.latitude, this.longitude)

    fun updateFromCloud(map: Map<String, Any>) {

        val name = map.get(kName) as String
        val lat = map.get(kLatitude) as Double?
        val lon = map.get(kLongitude) as Double?
        val image = map.get(kImageUrl) as? String
        val imageUrl = if (image != null) URL(image) else null

        var changed: Boolean = false

        if (this.name == name) {this.name = name; changed = true}
        if (this.latitude == lat) {this.latitude = lat; changed = true}
        if (this.longitude == lon) {this.longitude = lon; changed = true}
        if (this.imageURL == imageUrl) {this.imageURL = imageUrl; changed = true}

        if (changed) {this.informEvent(Event(Barbershop.kEventBarbershopUpdated, arrayListOf(this.uuid)))}

    }

    fun updateBarbersFromCloud(fromWeb: Set<Barber>) {

        var changed: Boolean = false

        val oldUUIDs:Set<String> = this.barbers.map { it.uuid }.toSet()
        val newUUIDs:Set<String> = fromWeb.map { it.uuid }.toSet()

        val toBeRemoved = oldUUIDs.minus(newUUIDs)
        if (toBeRemoved.isNotEmpty()) {changed = true}

        val toBeAdded = newUUIDs.minus(oldUUIDs);
        if (toBeAdded.isNotEmpty()) {changed = true}

        val toBeUpdated = oldUUIDs.intersect(newUUIDs);

        var updatedSet: Array<Barber> = emptyArray();
        for (id in toBeUpdated) {

            val old: Barber? = this.barbers.filter({ id == it.uuid }).first()
            val new: Barber? = fromWeb.filter({ id == it.uuid }).first()

            if (old != null) {

                if (new != null) {
                    if (old != new) {
                        changed = true
                        old.updateValues(new)}}

                updatedSet = updatedSet.plus(old);

            }

        }

        var newSet = fromWeb.toSet().filter { toBeAdded.contains(it.uuid) }

        if (changed) {
            this.barbers = ArrayList(newSet.plus(updatedSet));
            this.informEvent(Event(Barbershop.kEventBarberListUpdated, arrayListOf(this.uuid)))
        }

    }

    fun updateServicesFromCloud(services: ArrayList<AppointmentType>) {

        this.serviceTypes = services
        this.informEvent(Event(Barbershop.kEventBarbershopUpdated, arrayListOf(this.uuid)))

    }

    fun updateAppointmentsFromCloud(fromWeb: ArrayList<Appointment>) {

        var changed: Boolean = false

        val oldUUIDs:Set<String> = this.appointments.map { it.uuid }.toSet();
        val newUUIDs:Set<String> = fromWeb.map { it.uuid }.toSet();

//        val toBeRemoved = oldUUIDs.minus(newUUIDs)
//        if (toBeRemoved.isNotEmpty()) {changed = true}

        val toBeAdded = newUUIDs.minus(oldUUIDs)
        if (toBeAdded.isNotEmpty()) {changed = true}

        val toBeUpdated = oldUUIDs.intersect(newUUIDs)

        for (id in toBeUpdated) {

            val old: Appointment? = this.appointments.filter({ id == it.uuid }).first()
            val new: Appointment? = fromWeb.filter({ id == it.uuid }).first()

            if (old != null) {

                if (new != null) {
                    if (old != new) {
                        changed = true
                        old.updateValues(new)}}

            }

        }

        val newList = fromWeb.filter { toBeAdded.contains(it.uuid) }

        if (changed) {
            Log.d(logTag, "Barbershop:updateAppointmentsFromCloud:Old List (${this.appointments.map { it.uuid }})")
            this.appointments = this.appointments.plus(newList)
            Log.d(logTag, "Barbershop:updateAppointmentsFromCloud:New List (${this.appointments.map { it.uuid }})")
            this.informEvent(Event(Barbershop.kEventAppointmentListUpdated, arrayListOf(this.uuid)))

        }

    }

    fun dayStart(date: Date): Date {

        var startTime = Calendar.getInstance(TimeZone.getDefault(), Locale.getDefault())
        startTime.time = date
        startTime.set(Calendar.HOUR_OF_DAY, 9)
        startTime.set(Calendar.MINUTE, 0)
        startTime.set(Calendar.SECOND, 0)
        return startTime.time

    }

    fun dayEnd(date: Date): Date {

        var endTime = Calendar.getInstance(TimeZone.getDefault(), Locale.getDefault())
        endTime.time = date
        endTime.set(Calendar.HOUR_OF_DAY, 21)
        endTime.set(Calendar.MINUTE, 0)
        endTime.set(Calendar.SECOND, 0)
        return endTime.time

    }

    fun startTime(date: Date): Date {

        var startTime = Calendar.getInstance(TimeZone.getDefault(), Locale.getDefault())
        startTime.time = date
        startTime.set(Calendar.HOUR_OF_DAY, 9)
        startTime.set(Calendar.MINUTE, 0)
        startTime.set(Calendar.SECOND, 0)
        return startTime.time

    }

    fun endTime(date: Date): Date {

        var endTime = Calendar.getInstance(TimeZone.getDefault(), Locale.getDefault())
        endTime.time = date
        endTime.set(Calendar.HOUR_OF_DAY, 21)
        endTime.set(Calendar.MINUTE, 0)
        endTime.set(Calendar.SECOND, 0)
        return endTime.time

    }

    fun slotTime(date: Date): Int {
        return 30
    }

    fun getBarberById(barberId: String?): Barber? {

        return this.barbers.filter { it.uuid == barberId }.first()

    }

    fun getAppointmentsFor(date: Date, barberUUID: String?): ArrayList<Appointment> {

        var appointmentList: ArrayList<Appointment> = arrayListOf()

        val startTime:Date = this.startTime(date)
        val endTime:Date = this.endTime(date)
        val slot:Int = this.slotTime(date)

        Log.d(logTag, "Barbershop:getAppointmentsFor:$startTime and $endTime")

        var dateWalkInMillis = startTime
        while (dateWalkInMillis <  endTime) {

            var found = this.appointments.filter<Appointment> { it: Appointment ->

                val fromBarber = if (barberUUID == null) {true} else {barberUUID == it.barberUUID}
                this.compareDatesWithoutMilliseconds(it.startDate, dateWalkInMillis) && fromBarber

            }

            val value:Appointment = if (found.isEmpty()) {Appointment.empty(dateWalkInMillis, slot)} else {found.first()}

            appointmentList.add(value)
            dateWalkInMillis = Date(dateWalkInMillis.time + (1000 * 60 * value.interval).toLong())

        }

        return appointmentList

    }

    override fun registerObserver(observer: EventObserver) {this.observers.add(observer)}

    override fun unregister(observer: EventObserver) {this.observers.remove(observer)}

    override fun informEvent(event: Event) {

        for (observer in this.observers) {observer.receiveEvent(event)}

    }

    private fun compareDatesWithoutMilliseconds(lh: Date, rh: Date): Boolean {return lh.time / 1000 == rh.time / 1000}

    companion object {

        val kUUID: String = "uuid";
        val kName: String = "name"
        val kLatitude: String = "latitude"
        val kLongitude: String = "longitude"
        val kImageUrl: String = "imageUrl"

        val kEventBarbershopUpdated: String = "barbershopUpdated"
        val kEventBarberListUpdated: String = "barberListUpdated"
        val kEventAppointmentUpdated: String = "appointmentUpdated"
        val kEventAppointmentListUpdated: String = "appointmentListUpdated"

        fun fromMap(map: Map<String, Any>): Barbershop {

            val uuid = map.get(kUUID) as String
            val name = map.get(kName) as String
            val lat = map.get(kLatitude) as Double?
            val lon = map.get(kLongitude) as Double?
            val image = map.get(kImageUrl) as? String
            val imageUrl = if (image != null) URL(image) else null

            return Barbershop(uuid, name, imageUrl, lat, lon)
        }

    }

}