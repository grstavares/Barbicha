package br.com.plazaz.barbicha.activities

import br.com.plazaz.barbicha.*
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.support.v4.content.ContextCompat
import android.support.v7.widget.GridLayoutManager
import android.util.Log
import br.com.plazaz.barbicha.adapters.CollectionItemAdapter
import br.com.plazaz.barbicha.helpers.Initial
import br.com.plazaz.barbicha.model.Barbershop
import br.com.plazaz.barbicha.protocols.Event
import br.com.plazaz.barbicha.protocols.EventObserver
import br.com.plazaz.barbicha.providers.AppProvider
import kotlinx.android.synthetic.main.activity_barbershop.*

class BarbershopActivity : AppCompatActivity(), EventObserver {

    private var barbershop: Barbershop = Initial.instance

    override fun onCreate(savedInstanceState: Bundle?) {

        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_barbershop)

        AppProvider.initializeWith(this.barbershop)
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


    private fun registerObservers() {

        this.barbershop.registerObserver(this)

    }

    private fun initializeCollection() {

        val adapter = CollectionItemAdapter(this.barbershop)
        barberCollection.adapter = adapter
        barberCollection.layoutManager = GridLayoutManager(this, 2);

    }

    private fun refreshViews() {

        Log.d(logTag, "BarbershopActivity:refreshViews")
        shopLabel.setText(this.barbershop.name);
        shopImage.setImageDrawable(ContextCompat.getDrawable(shopImage.context, R.drawable.placeholder_person))

    }

    private fun refreshAdapter() {

        Log.d(logTag, "BarbershopActivity:refreshAdapter")
        val adapter = CollectionItemAdapter(this.barbershop)
        barberCollection.adapter = adapter
        barberCollection.adapter.notifyDataSetChanged()

    }

    override fun receiveEvent(event: Event) {

        if (event.name == Barbershop.kEventBarbershopUpdated) {this.refreshViews()}
        if (event.name == Barbershop.kEventBarberListUpdated) {this.refreshAdapter()}

    }

//    private val DataServiceConnection = object : ServiceConnection {
//
//        override fun onServiceConnected(className: ComponentName, service: IBinder) {
//
//            val binder = service as DataService.DataProviderBinder
//            val dataService = binder.getService()
//            this@BarbershopActivity.dataProvider = dataService.getProvider(this@BarbershopActivity.barbershop)
//        }
//
//        override fun onServiceDisconnected(name: ComponentName) {
//            this@BarbershopActivity.dataProvider = null
//        }
//    }
//
//    inner class ObservableEventReceiver: BroadcastReceiver() {
//
//        override fun onReceive(context: Context?, intent: Intent?) {
//            Log.d(logTag, "BarbershopActivity:Observer:${intent?.action}")
//            when (intent?.action) {
//
//                DataProviderObservableEvent.barbershopUpdated.toString() -> this@BarbershopActivity.refreshViews()
//                DataProviderObservableEvent.barberListUpdated.toString() -> this@BarbershopActivity.refreshAdapter()
//
//            }
//        }
//
//    }

}
