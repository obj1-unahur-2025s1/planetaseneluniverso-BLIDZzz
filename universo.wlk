class Persona {
    var edad
    var monedas = 20
    method recursos() = monedas
    method esDestacada() = edad.between(18, 65) or 30 < self.recursos()

    method cumplirAños() {edad += 1}
    method ganarMonedas(unasMonedas) {monedas = monedas + unasMonedas}
    method gastarMonedas(unasMonedas) {monedas = (monedas - unasMonedas).max(0)} 
    method laburarEnPlaneta(unPlaneta, unTiempo) {}
}

class Productor inherits Persona {
    const tecnicas = #{"cultivo"}
    override method recursos() = monedas * self.cantTecnicas()
    method cantTecnicas() = tecnicas.size()
    override method esDestacada() = super() or 5 < self.cantTecnicas()

    method laburar(unaTecnia, unTiempo) {
        if(tecnicas.contains(unaTecnia)) {
            self.ganarMonedas(unTiempo * 3)
        } else {
            self.gastarMonedas(1)
        }
    }
    method aprenderTecnica(unaTecnica) {tecnicas.add(unaTecnica)}
    override method laburarEnPlaneta(unPlaneta, unTiempo) {
        if(unPlaneta.habitantes().contains(self)) {
            self.laburar(tecnicas.asList().last(), unTiempo)
        }
    }
}

class Constructor inherits Persona {
    var cantConstrucciones = 0
    const region
    override method recursos() = monedas + (cantConstrucciones * 10)
    override method esDestacada() = 5 < cantConstrucciones or 30 < self.recursos()

    override method laburarEnPlaneta(unPlaneta, unTiempo) {
        unPlaneta.construir(self.construccion(unTiempo))
        self.gastarMonedas(5)
    }
    method construccion(unTiempo) {
        return
        if(region == "montaña") {new Muralla(longitud = unTiempo.div(2))}
        else if(region == "costa") {new Museo(superficie = unTiempo, importancia = 1)}
        else if(region == "llanura"){
            self.laburoDeLlanura(unTiempo)    
        }
    }
    method laburoDeLlanura(unTiempo) {
        return
        if(!self.esDestacada()) {new Muralla(longitud = unTiempo.div(2))}
        else {new Museo(superficie = unTiempo, importancia = self.importanciaSegunRecursos())}
    }
    method importanciaSegunRecursos() {
        return
        if(self.recursos() < 10) {1}
        else if(self.recursos().between(10, 20)) {2}
        else if(self.recursos().between(20, 30)) {3}
        else if(self.recursos().between(30, 40)) {4}
        else {5}
    }
}

class Construccion {
    method valor()
}

class Muralla inherits Construccion {
    const longitud
    override method valor() = longitud * 10
}

class Museo inherits Construccion {
    const importancia
    const superficie
    override method valor() = superficie * importancia
}

class Planeta {
    const property habitantes = #{}
    const construcciones = #{}

    method delegacionDiplomatica() {
        const delegacion = self.destacados()
        return
        if(delegacion.contains(self.elMasRecursoso())){
            delegacion
        } else {
            delegacion.add(self.elMasRecursoso())
            delegacion
        }
    } 
    method destacados() = habitantes.filter{x=>x.esDestacada()}
    method elMasRecursoso() = habitantes.max{x=>x.recursos()}
    method esValioso() = 100 < self.valorTotal()
    method valorTotal() = construcciones.sum{x=>x.valor()}
    method construir(unaConstruccion) {construcciones.add(unaConstruccion)}
}