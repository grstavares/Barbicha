package br.com.plazaz.barbicha.adapters

import android.support.v4.content.ContextCompat
import android.support.v7.widget.RecyclerView
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import br.com.plazaz.barbicha.R
import br.com.plazaz.barbicha.model.Appointment
import br.com.plazaz.barbicha.model.Barbershop
import br.com.plazaz.extensions.inflate

class AppointmentsAdapter(private var barbershop: Barbershop) : RecyclerView.Adapter<AppointmentsAdapter.AppointmentsHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): AppointmentsAdapter.AppointmentsHolder {
        val inflatedView = parent.inflate(R.layout.appointment_cell, false)
        return AppointmentsHolder(inflatedView)
    }

    override fun getItemCount(): Int = barbershop.appointments.size;

    override fun onBindViewHolder(holder: AppointmentsAdapter.AppointmentsHolder, position: Int) {
        val item = barbershop.appointments[position]
        holder.bindAppointment(barbershop, item)
    }

    class AppointmentsHolder(v: View): RecyclerView.ViewHolder(v), View.OnClickListener {

        private var view: View = v;
        private var itemDescription: TextView? = null;
        private var thumbnail: ImageView? = null;
        private var shop: Barbershop? = null;
        private var appointment: Appointment? = null

        init {
            v.setOnClickListener(this)
            this.itemDescription = v.findViewById(R.id.itemDescription)
            this.thumbnail = v.findViewById(R.id.thumbnail)
        }

        override fun onClick(v: View?) {

            val context = itemView.context;

        }

        fun bindAppointment(shop: Barbershop, appointment: Appointment) {

            this.shop = shop;
            this.appointment = appointment;
            this.itemDescription?.setText(appointment.startDate.toString());
            this.thumbnail?.setImageDrawable(ContextCompat.getDrawable(view.context, R.drawable.placeholder_person));

        }

        companion object {
            val kShopId = "barbershopId"
            val kBarberId = "barberId"
        }

    }

}