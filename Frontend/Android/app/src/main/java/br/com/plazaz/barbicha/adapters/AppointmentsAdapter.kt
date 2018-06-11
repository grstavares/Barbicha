package br.com.plazaz.barbicha.adapters

import android.support.v7.widget.RecyclerView
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import android.widget.Toast
import br.com.plazaz.barbicha.R
import br.com.plazaz.barbicha.model.Appointment
import br.com.plazaz.barbicha.model.Barbershop
import br.com.plazaz.extensions.inflate
import java.text.DateFormat
import java.time.format.DateTimeFormatter
import java.util.*

class AppointmentsAdapter(private var barbershop: Barbershop, private var appointments: ArrayList<Appointment>) : RecyclerView.Adapter<AppointmentsAdapter.AppointmentsHolder>() {

    private val numberOfItens = 4

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): AppointmentsAdapter.AppointmentsHolder {

        val inflatedView = parent.inflate(R.layout.appointment_cell, false)

        val parentHeight = parent.measuredHeight
        val parentWidth = parent.measuredWidth
        inflatedView.layoutParams = RecyclerView.LayoutParams(parentWidth, parentHeight / numberOfItens)

        return AppointmentsHolder(inflatedView)
    }

    override fun getItemCount(): Int = appointments.size

    override fun onBindViewHolder(holder: AppointmentsAdapter.AppointmentsHolder, position: Int) {
        val item = appointments[position]
        holder.bindAppointment(barbershop, item)
    }

    class AppointmentsHolder(v: View): RecyclerView.ViewHolder(v), View.OnClickListener {

        private var view: View = v
        private var mainLabel: TextView? = null
        private var detailsLabel: TextView? = null
        private var shop: Barbershop? = null
        private var appointment: Appointment? = null

        init {
            v.setOnClickListener(this)
            this.mainLabel = v.findViewById(R.id.mainLabel)
            this.detailsLabel = v.findViewById(R.id.detailLabel)
        }

        override fun onClick(v: View?) {

            val context = itemView.context
            val startDate = this.appointment?.startDate.toString()
            Toast.makeText(context, "StartDate is $startDate", Toast.LENGTH_SHORT).show()

        }

        fun bindAppointment(shop: Barbershop, appointment: Appointment) {

            this.shop = shop
            this.appointment = appointment

            val endDate = Date(appointment.startDate.time + (appointment.interval  * 60 * 1000))
            val label = DateFormat.getTimeInstance(DateFormat.SHORT).format(appointment.startDate) + " - " + DateFormat.getTimeInstance(DateFormat.SHORT).format(endDate)
            this.mainLabel?.text = label

        }

        companion object {
            val kShopId = "barbershopId"
            val kBarberId = "barberId"
        }

    }

}