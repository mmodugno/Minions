//MINIONS


class Empleado{
	var rol 
	var tareasCompletadas
	var estamina = 10
	
	method cambiarRol(nuevoRol){ 
		rol = nuevoRol
		rol.perderAtributos()
	}
	
	method rol() = rol
	
	method realizarTarea(tarea){
		if(not tarea.validar(self)){self.error("no se puede realizar")}
		tarea.producirEfecto(tarea)
	 	self.tareaRealizada(tarea)
	 	
	}
	
	method tareaRealizada(tarea) {tareasCompletadas.add(tarea)}
	
	method ganarEstamina(numero)
	
	method herramientas() = rol.herramientas()
	
	method fuerza() = estamina / 2  + rol.calcularFuerza()
	
	method dividirEstamina(){estamina/=2}
	
	
	//PUNTO 1
	method comerFruta(fruta){
		self.ganarEstamina(fruta.recuperaEnergia())
	}
	//PUNTO 2
	method experiencia(){
		return tareasCompletadas.size() * tareasCompletadas.sum({t=>t.dificultad()})
	}
	
	
}



class Biclope inherits Empleado{
	
	method perderEstamina(numero){estamina = 0.max(estamina-numero) }
	method ganarEstamina(numero) {estamina = 10.min(estamina+numero)}
	
	method dificultadDeTarea(tarea) = tarea.dificultad()
}


class Ciclope inherits Empleado{
	
	method perderEstamina(numero){}
	method ganarEstamina(numero) {estamina+=numero}
	
	override method fuerza() = super()/2
	
	method dificultadDeTarea(tarea){
		if (tarea.esDefender()) return tarea.dificultad()/2
		else return tarea.dificultad()
		
		}
}





class Rol{
	method perderAtributos()
	
	method defenderSector(){}
	
	method herramientas() {
		self.error("no tiene herramientas")
		return 0
	}
	method calcularFuerza() = 0
	method puedeDefender() = true
	method reducirEfectoPorDefender(empleado){ empleado.dividirEstamina()}
	
	method perderEstaminaPorLimpiar(empleado,numero){empleado.perderEstamina(numero)}
}

object soldado inherits Rol{
	var practica = 0
	
	override method defenderSector() { practica+=2 }
	override method perderAtributos() { practica = 0}
	override method calcularFuerza() = practica
	override method reducirEfectoPorDefender(empleado){}
}

class Obrero inherits Rol{
	var herramientas = []
	
	override method herramientas() = herramientas
}

class Mucama inherits Rol{
	override method puedeDefender() = false
	override method perderEstaminaPorLimpiar(empleado,numero){}
}


//TODAS TIENEN QUE TENER EL METODO PUEDEREALIZARLA(EMPLEADO) y tarea.producirEfectosDeRealizacion(self)



class ArreglarUnaMaquina {
	const complejidad
	const herramientasRequeridas
	
	 method validar(empleado){
		return self.tieneLasHerramientasNecesarias(empleado) and
		self.tieneSuficienteEstamina(empleado)
	}
	
	method tieneLasHerramientasNecesarias(empleado){
		if(herramientasRequeridas.isEmpty()) return true
		else{return empleado.herramientas().intersect(herramientasRequeridas).size() == herramientasRequeridas.size()
		}
	}
		
	method tieneSuficienteEstamina(empleado) = empleado.estamina() >= complejidad
	
	
	 method producirEfecto(empleado){
		empleado.perderEstamina(complejidad)
	}
	
	method dificultad() = 2*complejidad
}


class DefenderSector{
	var gradoAmenaza
	
	method esDefender() = true
	
	method validar(empleado){ return 
		empleado.rol().puedeDefender() and
		self.tieneFuerzaSuficiente(empleado)
	}
	
	method tieneFuerzaSuficiente(empleado){
		return empleado.fuerza()>=gradoAmenaza
	}
	
	method producirEfecto(empleado){
		empleado.rol().reducirEfectoPorDefender(empleado)
	}
	method dificultad() = gradoAmenaza
}



class LimpiarUnSector{
	var dificultad = 10
	var sector
	
	method dificultad() = dificultad
	
	method cambiarDificultad(nueva) = {dificultad = nueva}
	
	method validar(empleado) = empleado.estamina() > sector.seNecesitaEstamina()
	
	method producirEfecto(empleado){
		empleado.rol().perderEstaminaPorLimpiar(empleado,sector.seNecesitaEstamina())
	}
}




class Sector{
	var tamanio
	
	method esGrande() = tamanio > 10
	
	method seNecesitaEstamina() = if(self.esGrande()) 4 else 1
}



object banana{
	method recuperaEnergia() = 10
}

object manzana{
	method recuperaEnergia() = 5
}

object uva{
	method recuperaEnergia() = 1
}







