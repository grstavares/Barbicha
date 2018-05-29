package br.com.plazaz.barbicha.model

import java.net.URL

class Barbershop(uuid: String, name: String, imageURL: URL? = null, latitude: Double? = null, longitude: Double? = null,
                 serviceTypes: ArrayList<AppointmentType> = arrayListOf(), barbers: ArrayList<Barber> = arrayListOf(), appointments: ArrayList<Appointment> = arrayListOf()) {

    val uuid: String = uuid;
    val name: String = name;
    var latitude: Double? = latitude;
    var longitude: Double? = longitude;
    var imageURL: URL? = imageURL;
    var imageData: ByteArray? = null;

    var serviceTypes: ArrayList<AppointmentType> = serviceTypes
        private set;

    var barbers: ArrayList<Barber> = barbers
        private set;

    var appointments: ArrayList<Appointment> = appointments
        private set;

    fun location(): Pair<Double?, Double?> = Pair(this.latitude, this.longitude)

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

            val old = this.barbers.filter({ id == it.uuid }).first()
            val new = fromWeb.filter({ id == it.uuid }).first()

            if (old != null) {

                if (new != null) {
                    if (old != new) {
                        changed = true
                        old?.updateValues(new)}}

                updatedSet = updatedSet.plus(old);

            }

        }

        var newSet = fromWeb.toSet().filter { toBeAdded.contains(it.uuid) }

        if (changed) {
            this.barbers = ArrayList(newSet.plus(updatedSet));
//            this.signalChange(event: .barberListUpdated)
        }

    }

    fun updateServicesFromCloud(services: ArrayList<AppointmentType>) {

        this.serviceTypes = services

    }

    fun updateAppointmentsFromCloud(fromWeb: ArrayList<Appointment>) {

        var changed: Boolean = false

        val oldUUIDs:Set<String> = this.appointments.map { it.uuid }.toSet();
        val newUUIDs:Set<String> = fromWeb.map { it.uuid }.toSet();

        val toBeRemoved = oldUUIDs.minus(newUUIDs)
        if (toBeRemoved.isNotEmpty()) {changed = true}

        val toBeAdded = newUUIDs.minus(oldUUIDs)
        if (toBeAdded.isNotEmpty()) {changed = true}

        val toBeUpdated = oldUUIDs.intersect(newUUIDs)

        var updatedArray: Array<Appointment> = emptyArray()
        for (id in toBeUpdated) {

            val old = this.appointments.filter({ id == it.uuid }).first()
            val new = fromWeb.filter({ id == it.uuid }).first()

            if (old != null) {

                if (new != null) {
                    if (old != new) {
                        changed = true
                        old?.updateValues(new)}}

                updatedArray.plus(old)

            }

        }

        val newArray = fromWeb.filter { toBeAdded.contains(it.uuid) }

        if (changed) {
            this.appointments = ArrayList(newArray.plus(updatedArray))
//            self.signalChange(event: .appointmentListUpdated)
        }

    }

}