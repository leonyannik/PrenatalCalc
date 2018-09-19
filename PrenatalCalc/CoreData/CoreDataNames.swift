//
//  CoreDataNames.swift
//  PrenatalCalc
//
//  Created by Developer on 8/20/18.
//  Copyright © 2018 Leon Yannik Lopez Rojas. All rights reserved.
//

import Foundation

struct Entity {
    let id = "id"
    let name = "name"
    let patient = "Patient"
    let values = PacientValues()
    let solution = PacientSolution()
}


struct PacientValues {
    
}

struct PacientSolution {
    
}

let entity = Entity()
let jsonDecoder = JSONDecoder()
let jsonEncoder = JSONEncoder()
