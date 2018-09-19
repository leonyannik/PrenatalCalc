//
//  AppDelegate.swift
//  PrenatalCalc
//
//  Created by Leon Yannik Lopez Rojas on 7/7/18.
//  Copyright © 2018 Leon Yannik Lopez Rojas. All rights reserved.
//

import UIKit
import CoreData

let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        moc.persistentStoreCoordinator = CoreDataPatientManager.shared.coordinator
        logo = UIImage(named: "placeHolder")!
        if let name = defaults.string(forKey: "name") {
            nameOfDoctor = name
        }else {
            nameOfDoctor = "Medical Record"
        }
        setDefault()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    //MARK: Additional functions
    func setDefault() {
        let defaultPatientRequest: NSFetchRequest<Patient> = Patient.fetchRequest()
        defaultPatientRequest.predicate = NSPredicate(format: "%K == %@", entity.name, "prenatalDefault")
        moc.perform {
            do {
                let fetchedPatients = try defaultPatientRequest.execute()
                if fetchedPatients.count > 0 {
                    let defaultThings = try jsonDecoder.decode(Things.self, from: fetchedPatients.first!.things as! Data)
                    solutionValuesDefault = defaultThings.patientValues
                }else {
                    let defaultValues = try jsonEncoder.encode(solutionValuesDefault) // Create the default values
                    let patientValues = try jsonDecoder.decode(ProvidedSolutionValues.self, from: defaultValues) //create a provitional solution with the default values
                    let things = Things(patientValues: patientValues, solution: [])
                    let thingsToSave = try jsonEncoder.encode(things) // create json Data of the provitional solution
                    let newPatient = NSEntityDescription.insertNewObject(forEntityName: entity.patient, into: moc) as! Patient
                    newPatient.id = "0"
                    newPatient.lastWeight = 0
                    newPatient.name = "prenatalDefault"
                    newPatient.things = thingsToSave as NSData
                    try moc.save()
                }
            }catch {
                print("Error on read persistance: \(error)")
            }
        }
        
        let path = URL.urlInDocumentsDirectory(with: "defaultLogo").path
        let image = UIImage(contentsOfFile: path)
        if let defaultImage = image {
            logo = defaultImage
        }
    }


}

