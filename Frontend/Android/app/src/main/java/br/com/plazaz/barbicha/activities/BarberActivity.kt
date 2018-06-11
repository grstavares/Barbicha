package br.com.plazaz.barbicha.activities

import android.content.*
import br.com.plazaz.barbicha.*
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.os.IBinder
import android.support.v4.content.ContextCompat
import android.util.Log
import br.com.plazaz.barbicha.adapters.AppointmentsAdapter
import br.com.plazaz.barbicha.adapters.CollectionItemAdapter
import br.com.plazaz.barbicha.helpers.Initial
import br.com.plazaz.barbicha.model.Barber
import br.com.plazaz.barbicha.model.Barbershop
import br.com.plazaz.barbicha.providers.DataProvider
import br.com.plazaz.barbicha.providers.DataProviderObservableEvent
import br.com.plazaz.barbicha.services.DataService
import kotlinx.android.synthetic.main.activity_barber.*
import kotlinx.android.synthetic.main.activity_barbershop.*
import java.util.*

class BarberActivity : AppCompatActivity() {

    private var dataProvider: DataProvider? = null
    private var barbershop: Barbershop = Initial.instance
    private var barber: Barber? = null
    private var selectedData: Date = Date()
    private var observer: BroadcastReceiver = ObservableEventReceiver()

    override fun onCreate(savedInstanceState: Bundle?) {

        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_barber)

        val intent = getIntent();
        val barberId = intent.getStringExtra(CollectionItemAdapter.BarberHolder.kBarberId);

        this.barbershop = Initial.instance
        this.barber = this.barbershop.getBarberById(barberId)

        this.refreshViews()
        this.initializeCollection()
        this.bindService()

    }

    private fun initializeCollection() {

        val appointments = this.barbershop.getAppointmentsFor(this.selectedData, this.barber?.uuid)

        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
    }

    private fun bindService() {
        val intent = Intent(this, DataService::class.java)
        bindService(intent, DataServiceConnection, Context.BIND_AUTO_CREATE)
    }

    private fun refreshViews() {

        Log.d("BROADCAST", "RefreshViews")
        barberLabel.setText(this.barber?.name)
        barberImage.setImageDrawable(ContextCompat.getDrawable(shopImage.context, R.drawable.placeholder_person))

    }

    private fun refreshAdapter() {

        Log.d("BROADCAST", "RefreshAdapter")
        val adapter = AppointmentsAdapter(this.barbershop)
        barberCollection.adapter = adapter
        barberCollection.adapter.notifyDataSetChanged()

    }

    private val DataServiceConnection = object : ServiceConnection {

        override fun onServiceConnected(className: ComponentName, service: IBinder) {

            val binder = service as DataService.DataProviderBinder
            val dataService = binder.getService()
            this@BarberActivity.dataProvider = dataService.getProvider(this@BarberActivity.barbershop)
        }

        override fun onServiceDisconnected(name: ComponentName) {
            this@BarberActivity.dataProvider = null
        }
    }

    inner class ObservableEventReceiver: BroadcastReceiver() {

        override fun onReceive(context: Context?, intent: Intent?) {
            Log.d("BROADCAST", intent?.action)
            when (intent?.action) {

                DataProviderObservableEvent.appointmensUpdated.toString() -> this@BarberActivity.refreshViews()

            }
        }

    }

}
