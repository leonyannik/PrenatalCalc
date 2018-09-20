//
//  Structure.swift
//  PrenatalCalc
//
//  Created by Developer on 8/20/18.
//  Copyright © 2018 Leon Yannik Lopez Rojas. All rights reserved.
//

import Foundation

struct Things: Codable {
    ///Valores con los cuáles se calculará la solución
    var patientValues:ProvidedSolutionValues
    ///Solución
    var solution:[SolutionToUse]
}

class ProvidedSolutionValues: Codable {
    
    var líquidos:Double = 150
    var sol_fisiológica_:Double = 0
    var prot_10:Double = 3.5
    var prot_8:Double = 0
    var chs_50:Double = 8.5
    var chs_10:Double = 0
    var kcl_amp_10_:Double = 3
    var kcl_amp_5_:Double = 0
    var naclhip_:Double = 0
    var lípidos:Double = 3.5
    var fosfato_k_:Double = 0
    var calcio_:Double = 100
    var magnesio_:Double = 40
    var mvi_:Double = 3
    var oligoelementos_:Double = 1.5
    var carnitina_: Double = 1.5
    var heparina_:Double = 0.5
    var _108:Bool = false
    var _5010:Bool = false
    var _105:Bool = false
    var _nacSol:Bool = false
    
    func changeProperty(name:String, value: Double) {
        switch name {
        case "líquidos": self.líquidos = value
        case "sol_fisiológica_": self.sol_fisiológica_ = value
        case "prot_10": self.prot_10 = value
        case "prot_8": self.prot_8 = value
        case "chs_50": self.chs_50 = value
        case "chs_10": self.chs_10 = value
        case "kcl_amp_10_": self.kcl_amp_10_ = value
        case "kcl_amp_5_": self.kcl_amp_5_ = value
        case "naclhip_": self.naclhip_ = value
        case "lípidos": self.lípidos = value
        case "fosfato_k_": self.fosfato_k_ = value
        case "calcio_": self.calcio_ = value
        case "magnesio_": self.magnesio_ = value
        case "mvi_": self.mvi_ = value
        case "oligoelementos_": self.oligoelementos_ = value
        case "carnitina_": self.carnitina_ = value
        case "heparina_": self.heparina_ = value
        case "_108": self._108 = Bool(truncating: NSNumber(floatLiteral: value))
        case "_5010": self._5010 = Bool(truncating: NSNumber(floatLiteral: value))
        case "_105": self._105 = Bool(truncating: NSNumber(floatLiteral: value))
        case "_nacSol": self._nacSol = Bool(truncating: NSNumber(floatLiteral: value))
        default: fatalError("Wrong property name")
        }
    }
}




var solutionValuesDefault = ProvidedSolutionValues()




struct Solution: Codable {
    
    var fecha:Double = 0
    var weight: Double = 0
    
    var líquidos:Double = 0
    var sol_fisiológica_:Double = 0
    var prot_10:Double = 0
    var prot_8:Double = 0
    var chs_50:Double = 0
    var chs_10:Double = 0
    var kcl_amp_10_:Double = 0
    var kcl_amp_5_:Double = 0
    var naclhip_:Double = 0
    var lípidos:Double = 0
    var fosfato_k_:Double = 0
    var calcio_:Double = 0
    var magnesio_:Double = 0
    var mvi_:Double = 0
    var oligoelementos_:Double = 0
    var carnitina_: Double = 0
    var heparina_:Double = 0
    
    //Tipo de valores
    var _108:Bool = false
    var _5010:Bool = false
    var _105:Bool = false
    var _nacSol:Bool = false
    
    
    //Valores a calcular
    var líquidos_iv_tot:Double = 0
    var sol_fisiológica:Double = 0
    var trophamine_10:Double = 0
    var trophamine_8:Double = 0
    var sg_50:Double = 0
    var sg_10:Double = 0
    var kcl_amp_10:Double = 0
    var kcl_amp_5:Double = 0
    var intralipid_20:Double = 0
    var naclhip:Double = 0
    var fosfato_k:Double = 0
    var glucca:Double = 0
    var magnesio:Double = 0
    var mvi:Double = 0
    var oligoelementos:Double = 0
    var l_cisteína:Double = 0
    var carnitina:Double = 0
    var heparina:Double = 0
    var abd:Double = 0
    
    //Otros valores
    var líquidos_tot:Double = 0
    var calorías_tot:Double = 0
    var caljjml:Double = 0
    var caljjkgjjdia:Double = 0
    var infusión:Double = 0
    var nitrógeno:Double = 0
    var relcnpjntg:Double = 0
    var concentración:Double = 0
    var gkm:Double = 0
    var calprot:Double = 0
    var calgrasa:Double = 0
    var calchs50:Double = 0
    var calchs10:Double = 0
    
    private enum CodingKeys: String, CodingKey {
        case fecha, weight, líquidos, sol_fisiológica_, prot_10, prot_8, chs_50, chs_10, kcl_amp_10_, kcl_amp_5_, naclhip_, lípidos, fosfato_k_, calcio_, magnesio_, mvi_, oligoelementos_, carnitina_, heparina_, _108, _5010, _105, _nacSol
        case líquidos_iv_tot, sol_fisiológica, trophamine_10, trophamine_8, sg_50, sg_10, kcl_amp_10, kcl_amp_5, intralipid_20, naclhip, fosfato_k, glucca, magnesio, mvi, oligoelementos, l_cisteína, carnitina, heparina, abd, líquidos_tot, calorías_tot, caljjml, caljjkgjjdia, infusión, nitrógeno, relcnpjntg, concentración, gkm, calprot,  calgrasa, calchs50, calchs10
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        líquidos = try container.decode(Double.self, forKey: .líquidos)
        sol_fisiológica_ = try container.decode(Double.self, forKey: .sol_fisiológica_)
        prot_10 = try container.decode(Double.self, forKey: .prot_10)
        prot_8 = try container.decode(Double.self, forKey: .prot_8)
        chs_50 = try container.decode(Double.self, forKey: .chs_50)
        chs_10 = try container.decode(Double.self, forKey: .chs_10)
        kcl_amp_10_ = try container.decode(Double.self, forKey: .kcl_amp_10_)
        kcl_amp_5_ = try container.decode(Double.self, forKey: .kcl_amp_5_)
        naclhip_ = try container.decode(Double.self, forKey: .naclhip_)
        lípidos = try container.decode(Double.self, forKey: .lípidos)
        fosfato_k_ = try container.decode(Double.self, forKey: .fosfato_k_)
        calcio_ = try container.decode(Double.self, forKey: .calcio_)
        magnesio_ = try container.decode(Double.self, forKey: .magnesio_)
        mvi_ = try container.decode(Double.self, forKey: .mvi_)
        oligoelementos_ = try container.decode(Double.self, forKey: .oligoelementos_)
        carnitina_ = try container.decode(Double.self, forKey: .carnitina_)
        heparina_ = try container.decode(Double.self, forKey: .heparina_)
        _108 = try container.decode(Bool.self, forKey: ._108)
        _5010 = try container.decode(Bool.self, forKey: ._5010)
        _105 = try container.decode(Bool.self, forKey: ._105)
        _nacSol = try container.decode(Bool.self, forKey: ._nacSol)
        
    }
}

struct SolutionToUse: Codable {

    var fecha:Double
    var weight: Double
    
    var líquidos:Double
    var sol_fisiológica_:Double
    var prot_10:Double
    var prot_8:Double
    var chs_50:Double
    var chs_10:Double
    var kcl_amp_10_:Double
    var kcl_amp_5_:Double
    var naclhip_:Double
    var lípidos:Double
    var fosfato_k_:Double
    var calcio_:Double
    var magnesio_:Double
    var mvi_:Double
    var oligoelementos_:Double
    var carnitina_: Double
    var heparina_:Double = 0
    
    //Tipo de valores
    var _108:Bool
    var _5010:Bool
    var _105:Bool
    var _nacSol:Bool = false
    
    //Valores a calcular
    var líquidos_iv_tot:Double
    var sol_fisiológica:Double
    var trophamine_10:Double
    var trophamine_8:Double
    var sg_50:Double
    var sg_10:Double
    var kcl_amp_10:Double
    var kcl_amp_5:Double
    var intralipid_20:Double
    var naclhip:Double
    var fosfato_k:Double
    var glucca:Double
    var magnesio:Double
    var mvi:Double
    var oligoelementos:Double
    var l_cisteína:Double
    var carnitina:Double
    var heparina:Double
    var abd:Double
    
    //Otros valores
    var líquidos_tot:Double = 0
    var calorías_tot:Double = 0
    var caljjml:Double = 0
    var caljjkgjjdia:Double = 0
    var infusión:Double = 0
    var nitrógeno:Double = 0
    var relcnpjntg:Double = 0
    var concentración:Double = 0
    var gkm:Double = 0
    var calprot:Double = 0
    var calgrasa:Double = 0
    var calchs50:Double = 0
    var calchs10:Double = 0

}
let asteriscInformation = "*RNTE = Recién nacido de término \n  RNPT = Recién nacido de pretérmino"
let aditionalInformation = "Si hay insuficiencia renal o hepática, no administrar Oligoelementos\nEn caso de que la gestación sea de 32 semanas o más, no se administra Heparina"

let aditionalInformationTable = ["", "INICIO", "INCREMENTO", "MÁXIMO", "AMINOÁCIDOS(aa)", "2-2.5 gr/Kg", "0.5 gr/Kg/día", "RNTE 3 gr/Kg/día\nRNPT 3.5 gr/Kg/día", "LÍPIDOS", "1-2 gr/Kg/día", "0.5-1 gr/Kg/día", "", "CARBOHIDRATOS", "RNTE 3-5 gr/Kg/día\nRNPT 4-6 gr/Kg/día", "2 gr/Kg/día", "18 gr/Kg/día"]

var fileDataKeys = ["paciente", "fecha", "gestación", "expediente", "cama", "dx"]
var providedValuesKeys = ["líquidos", "sol_fisiológica_", "naclhip_", "prot_10", "prot_8", "chs_50", "chs_10", "fosfato_k_", "kcl_amp_10_", "kcl_amp_5_", "lípidos", "calcio_", "magnesio_", "mvi_", "oligoelementos_", "carnitina_", "heparina_"]
var solutionValuesKeys = ["líquidos_iv_tot", "sol_fisiológica", "trophamine_10", "trophamine_8", "intralipid_20", "sg_50", "sg_10", "kcl_amp_10", "kcl_amp_5", "naclhip", "fosfato_k", "glucca", "magnesio", "mvi", "oligoelementos", "l_cisteína", "carnitina", "heparina", "abd"]
var otherSolutionValuesKeys = ["líquidos_tot", "calorías_tot", "caljjml", "caljjkgjjdia", "infusión", "nitrógeno", "relcnpjntg", "concentración", "gkm", "calprot", "calgrasa", "calchs50", "calchs10"]

let displayNames = ["líquidos": "líquidos", "sol_fisiológica_": "sol. fisiológica al 0.9%", "prot_10": "prot. 10%", "prot_8": "prot. 8%", "chs_50": "chs 50%", "chs_10": "chs 10%", "kcl_amp_10_": "cloruro de Potasio ámpula de 10 ml", "kcl_amp_5_": "cloruro de Potasio ámpula de 5 ml", "naclhip_": "concentrado de sódio", "lípidos": "lípidos", "fosfato_k_": "fosfato de potasio", "calcio_": "calcio", "magnesio_": "magnesio", "mvi_": "multivitamínico intravenoso", "oligoelementos_": "oligoelementos", "carnitina_": "carnitina", "heparina_": "heparina", "líquidos_tot": "líquidos totales", "calorías_tot": "calorías totales", "caljjml": "calorías/ml", "caljjkgjjdia": "calorías/Kg/día", "infusión": "infusión", "nitrógeno": "nitrógeno", "relcnpjntg": "relcnp-ntg", "concentración": "concentración", "gkm": "gramos/Kg/minuto", "calprot": "% calorías protéicas", "calgrasa": "% calorías grasa", "calchs50": "% calorías chs 50%", "calchs10": "% calorías chs 10%", "líquidos_iv_tot": "intravenosos totales", "sol_fisiológica": "sol. fisiológica 0.9%", "trophamine_10": "trophamine 10%", "trophamine_8": "trophamine 8%", "intralipid_20": "intralípidos 20%", "sg_50": "sol. glucosada 50%", "sg_10": "sol. glucosada 10%", "kcl_amp_10": "cloruro de Potasio ámpula de 10 ml", "kcl_amp_5": "cloruro de Potasio ámpula de 5 ml", "naclhip": "concentrado de sódio", "fosfato_k": "fosfáto de potasio", "glucca": "gluconato de calcio", "magnesio": "magnesio", "mvi": "multivitamínico intravenoso", "oligoelementos": "oligoelementos", "l_cisteína": "l-cisteína", "carnitina": "carnitina", "heparina": "heparina", "abd": "agua bidestilada"]

let units = ["peso": "Kg", "líquidos": "ml/Kg/día", "sol_fisiológica_": "meq/Kg/día", "prot_10": "gr/Kg/día", "prot_8": "gr/Kg/día", "chs_50": "gr/Kg/día", "chs_10": "gr/Kg/día", "kcl_amp_10_": "meq/Kg/día", "kcl_amp_5_": "meq/Kg/día", "naclhip_": "meq/Kg/día", "lípidos": "gr/Kg/día", "fosfato_k_": "meq/Kg/día", "calcio_": "mg/Kg/día", "magnesio_": "mg/Kg/día", "mvi_": "ml/día", "oligoelementos_": "ml/Kg/día", "carnitina_": "mg/Kg/día", "heparina_": "Unidades", "líquidos_tot": "ml/día", "calorías_tot": "Kcal/día", "caljjml": "kcal/ml", "caljjkgjjdia": "Kcal/Kg/día", "infusión": "ml/hr", "nitrógeno": "", "relcnpjntg": "", "concentración": "%", "gkm": "mg/Kg/min", "calprot": "%", "calgrasa": "%", "calchs50": "%", "calchs10": "%", "líquidos_iv_tot": "ml/día", "sol_fisiológica": "ml/día", "trophamine_10": "ml/día", "trophamine_8": "ml/día", "intralipid_20": "ml/día", "sg_50": "ml/día", "sg_10": "ml/día", "kcl_amp_10": "ml/día", "kcl_amp_5": "ml/día", "naclhip": "ml/día", "fosfato_k": "ml/día", "glucca": "ml/día", "magnesio": "ml/día", "mvi": "ml/día", "oligoelementos": "ml/día", "l_cisteína": "mg", "carnitina": "mg", "heparina": "Unidades", "abd": "ml"]
