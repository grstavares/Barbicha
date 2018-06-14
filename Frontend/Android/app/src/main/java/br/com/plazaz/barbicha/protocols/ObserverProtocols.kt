package br.com.plazaz.barbicha.protocols

class Event(val name: String, val uuids: ArrayList<String>)

interface EventObserver {

    fun receiveEvent(event: Event)

}

interface EventEmitter {

    fun registerObserver(observer: EventObserver)
    fun unregister(observer: EventObserver)
    fun informEvent(event: Event)

}