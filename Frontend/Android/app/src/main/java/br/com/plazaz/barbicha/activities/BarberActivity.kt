package br.com.plazaz.barbicha.activities

import android.app.DatePickerDialog
import android.content.*
import br.com.plazaz.barbicha.*
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.os.IBinder
import android.support.v4.content.ContextCompat
import android.support.v4.content.LocalBroadcastManager
import android.support.v7.widget.DividerItemDecoration
import android.support.v7.widget.LinearLayoutManager
import android.util.Log
import android.view.View
import android.widget.LinearLayout
import br.com.plazaz.barbicha.adapters.AppointmentsAdapter
import br.com.plazaz.barbicha.adapters.CollectionItemAdapter
import br.com.plazaz.barbicha.helpers.Initial
import br.com.plazaz.barbicha.model.Appointment
import br.com.plazaz.barbicha.model.Barber
import br.com.plazaz.barbicha.model.Barbershop
import br.com.plazaz.barbicha.protocols.Event
import br.com.plazaz.barbicha.protocols.EventObserver
import br.com.plazaz.barbicha.providers.DataProvider
import br.com.plazaz.barbicha.providers.DataProviderObservableEvent
import br.com.plazaz.barbicha.services.DataService
import kotlinx.android.synthetic.main.activity_barber.*
import kotlinx.android.synthetic.main.activity_barbershop.*
import java.util.*
import br.com.plazaz.barbicha.fragments.DatePickerFragment
import java.text.SimpleDateFormat


class BarberActivity : AppCompatActivity(), EventObserver {

    private var barbershop: Barbershop = Initial.instance
    private var barber: Barber? = null
    private var selectedData: Date = Date()

    override fun onCreate(savedInstanceState: Bundle?) {

        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_barber)

        val intent = intent
        val barberId = intent.getStringExtra(CollectionItemAdapter.BarberHolder.kBarberId)

        this.barbershop = Initial.instance
        this.barber = this.barbershop.getBarberById(barberId)

        this.refreshViews()
        this.initializeCollection()

    }

    override fun onResume() {
        super.onResume()
        this.registerObservers()
    }

    override fun onPause() {
        super.onPause()
        this.barbershop.unregister(this)

    }

    fun showDatePickerDialog(v: View) {

        var calendar = Calendar.getInstance()
        calendar.time = this.selectedData
        DatePickerDialog(this, this.dateSelectedListener, calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH), calendar.get((Calendar.DAY_OF_MONTH))).show()

    }

    val dateSelectedListener = DatePickerDialog.OnDateSetListener {view, year, month, day ->

        var calendar = Calendar.getInstance()
        calendar.set(Calendar.YEAR, year)
        calendar.set(Calendar.MONTH, month)
        calendar.set(Calendar.DAY_OF_MONTH, day)
        this.setActivityDate(calendar.time)

    }

    private fun registerObservers() {

        this.barbershop.registerObserver(this)

    }

    private fun initializeCollection() {

        val appointments = this.barbershop.getAppointmentsFor(this.selectedData, this.barber?.uuid)
        val adapter = AppointmentsAdapter(this.barbershop, appointments)
        appointmentList.adapter = adapter
        appointmentList.layoutManager = LinearLayoutManager(this)
        appointmentList.addItemDecoration(DividerItemDecoration(this, DividerItemDecoration.VERTICAL))

    }

    private fun refreshViews() {

        Log.d(logTag, "BarberActivity:refreshViews")
        barberLabel.text = this.barber?.name
        barberImage.setImageDrawable(ContextCompat.getDrawable(barberImage.context, R.drawable.placeholder_person))
        this.setActivityDate(this.selectedData)

    }

    private fun refreshAdapter() {

        Log.d(logTag, "BarberActivity:refreshAdapter:Get Appointments for ${this.selectedData}")
        val appointments = this.barbershop.getAppointmentsFor(this.selectedData, this.barber?.uuid)
        val adapter = AppointmentsAdapter(this.barbershop, appointments)
        appointmentList.adapter = adapter
        appointmentList.adapter.notifyDataSetChanged()

    }

    private fun setActivityDate(date: Date) {

        val formatter = SimpleDateFormat("dd MMM", Locale.getDefault())
        dateButton.text = formatter.format(date)

        if (date != this.selectedData) {
            this.selectedData = date
            this.refreshAdapter()
        }

    }

    override fun receiveEvent(event: Event) {

        if (event.name == Barbershop.kEventBarbershopUpdated) {this.refreshViews()}
        if (event.name == Barbershop.kEventAppointmentListUpdated) {this.refreshAdapter()}

    }

//    private val DataServiceConnection = object : ServiceConnection {
//
//        override fun onServiceConnected(className: ComponentName, service: IBinder) {
//
//            val binder = service as DataService.DataProviderBinder
//            val dataService = binder.getService()
//            this@BarberActivity.dataProvider = dataService.getProvider(this@BarberActivity.barbershop)
//        }
//
//        override fun onServiceDisconnected(name: ComponentName) {
//            this@BarberActivity.dataProvider = null
//        }
//    }
//
//    inner class ObservableEventReceiver: BroadcastReceiver() {
//
//        override fun onReceive(context: Context?, intent: Intent?) {
//            Log.d(logTag, "BarberActivity:Observer:${intent?.action}")
//            when (intent?.action) {
//
//                DataProviderObservableEvent.appointmensUpdated.toString() -> this@BarberActivity.refreshAdapter()
//
//            }
//        }
//
//    }

}
