package br.com.plazaz.barbicha.providers

import android.util.Log
import br.com.plazaz.barbicha.helpers.Utils
import br.com.plazaz.barbicha.model.Appointment
import br.com.plazaz.barbicha.model.AppointmentType
import br.com.plazaz.barbicha.model.Barber
import br.com.plazaz.barbicha.model.Barbershop
import com.google.android.gms.tasks.OnCompleteListener
import com.google.firebase.firestore.DocumentSnapshot
import com.google.firebase.firestore.FirebaseFirestore
import java.util.*

class FirebaseProvider(val barbershopUUID: String): DataProvider {

    val firestore = FirebaseFirestore.getInstance();
    var barbershop: Barbershop

    fun basePath(): String = "barbershops/${barbershopUUID}"
    fun barbersPath(): String = basePath() + "/barbers";
    fun servicesPath(): String = basePath() + "/serviceTypes";
    fun appointmentsPath(): String = basePath() + "/appointments";

    init {
        this.barbershop = Barbershop(barbershopUUID, "")
        this.refresh()
    }

    override fun loadData(uuid: String) {
        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
    }


    private fun refresh() {

        val reference = this.firestore.document(this.basePath())
        reference.get().addOnCompleteListener(OnCompleteListener {

            if (it.isSuccessful) {

                val doc: DocumentSnapshot = it.getResult();
                val data = doc.data
                barbershop.updateFromCloud(data)

                val barbersReference = this.firestore.collection(this.barbersPath())
                barbersReference.get().addOnCompleteListener {

                    if (it.isSuccessful) {

                        val barbers = it.result.documents.map {

                            var map = it.data
                            map.put(Barber.kUUID, it.id)
                            Barber.fromMap(map)

                        }.toSet()

                        barbershop.updateBarbersFromCloud(barbers)

                    }

                }

                val servicesReference = this.firestore.collection(this.servicesPath())
                servicesReference.get().addOnCompleteListener {

                    if (it.isSuccessful) {

                        val types = ArrayList(it.result.documents.map { AppointmentType.fromMap(it.data) })
                        barbershop.updateServicesFromCloud(types)

                    }

                }

                val date = Utils.zeroedDate(Date());
                val appointmentsReference = this.firestore.collection(this.appointmentsPath()).whereGreaterThan("startDate", date)
                appointmentsReference.addSnapshotListener { querySnapshot, firebaseFirestoreException ->

                    if (!querySnapshot.isEmpty) {

                        val appointments = ArrayList(querySnapshot.documents.map {
                            
                            var map = it.data
                            map.put(Appointment.kUUID, it.id)
                            Appointment.fromMap(map)
                        })

                        barbershop.updateAppointmentsFromCloud(appointments)

                    }

                }

            }

        })

    }

}