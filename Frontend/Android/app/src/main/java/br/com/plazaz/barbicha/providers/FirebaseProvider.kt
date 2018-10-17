package br.com.plazaz.barbicha.providers

import android.util.Log
import br.com.plazaz.barbicha.helpers.Utils
import br.com.plazaz.barbicha.logTag
import br.com.plazaz.barbicha.model.Appointment
import br.com.plazaz.barbicha.model.AppointmentType
import br.com.plazaz.barbicha.model.Barber
import br.com.plazaz.barbicha.model.Barbershop
import com.google.android.gms.tasks.OnCompleteListener
import com.google.firebase.Timestamp
import com.google.firebase.firestore.DocumentSnapshot
import com.google.firebase.firestore.FirebaseFirestore
import java.util.*
import kotlin.collections.HashMap
import com.google.firebase.firestore.FirebaseFirestoreSettings

class FirebaseProvider(private val barbershop: Barbershop): DataProvider {

    val firestore = FirebaseFirestore.getInstance();
    var listeners: HashMap<String, ProviderListener>

    fun basePath(): String = "barbershops/${barbershop.uuid}"
    fun barbersPath(): String = basePath() + "/barbers";
    fun servicesPath(): String = basePath() + "/serviceTypes";
    fun appointmentsPath(): String = basePath() + "/appointments";

    init {
        this.configFirestore()
        this.listeners = HashMap()
        this.refresh()
    }

    override fun addListener(listener: ProviderListener): String {

        val listenerUUID = UUID.randomUUID().toString()
        this.listeners.put(listenerUUID, listener)
        return listenerUUID

    }

    override fun removeListener(token: String) {

        this.listeners.remove(token)

    }

    private fun configFirestore() {

        val settings = FirebaseFirestoreSettings.Builder().setTimestampsInSnapshotsEnabled(true).build()
        this.firestore.firestoreSettings = settings
    }

    private fun refresh() {

        Log.d(logTag, "FirebaseProvider:Refreshing Data")
        val reference = this.firestore.document(this.basePath())
        reference.get().addOnCompleteListener {

            if (it.isSuccessful) {

                val doc = it.getResult();
                val data = HashMap(doc.data)
                barbershop.updateFromCloud(data)
                this.informListeners(DataProviderObservableEvent.barbershopUpdated)

                val barbersReference = this.firestore.collection(this.barbersPath())
                barbersReference.get().addOnCompleteListener {

                    if (it.isSuccessful) {

                        val barbers = it.result.documents.map {

                            var map = HashMap(it.data)
                            map.set(Barber.kUUID, it.id)
                            val parsed = this.parseFirebaseMap(map)
                            Barber.fromMap(parsed)

                        }.toSet()

                        barbershop.updateBarbersFromCloud(barbers)
                        this.informListeners(DataProviderObservableEvent.barberListUpdated)

                    }

                }

                val servicesReference = this.firestore.collection(this.servicesPath())
                servicesReference.get().addOnCompleteListener {

                    if (it.isSuccessful) {

                        val types = ArrayList(it.result.documents.map { AppointmentType.fromMap(this.parseFirebaseMap(HashMap(it.data))) })
                        barbershop.updateServicesFromCloud(types)
                        this.informListeners(DataProviderObservableEvent.serviceTypesUpdated)

                    }

                }

                val date = Utils.zeroedDate(Date());
                val appointmentsReference = this.firestore.collection(this.appointmentsPath()).whereGreaterThan("startDate", date)
                appointmentsReference.addSnapshotListener { querySnapshot, firebaseFirestoreException ->

                    if (!querySnapshot!!.isEmpty) {

                        val appointments = ArrayList(querySnapshot.documents.map {

                            Log.d(logTag, "FirebaseProvider:Appointment Found -> ${it.id}")
                            var map = HashMap(it.data)
                            map.set(Appointment.kUUID, it.id)
                            val parsed = this.parseFirebaseMap(map)
                            Appointment.fromMap(parsed)
                        })

                        barbershop.updateAppointmentsFromCloud(appointments)
                        this.informListeners(DataProviderObservableEvent.appointmensUpdated)

                    }

                }

            }

        }

    }

    private fun informListeners(event: DataProviderObservableEvent) {

        for (listener in this.listeners.values) {
            listener.receiveMessage(event.toString())
        }

    }

    private fun parseFirebaseMap(map: Map<String, Any>): Map<String, Any> {

        var newMap: MutableMap<String, Any> = mutableMapOf()
        for (key in map.keys) {

            val any = map.get(key) as Any
            if (any is Timestamp) {newMap.set(key, any.toDate())} else {newMap.set(key, any)}

        }

        return newMap

    }

}