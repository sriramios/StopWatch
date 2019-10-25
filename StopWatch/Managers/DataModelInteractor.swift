//
//  StopWatchInteractor.swift
//  StopWatch
//
//  Created by Sriram on 19/10/19.
//  Copyright © 2019 Sriram. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol DateModelInteractorInput: NSObjectProtocol {
    //MARK: Computed Properties
    var appDelegate: AppDelegate { get }
    var managedObjectContext: NSManagedObjectContext { get }
    func createTimerInfoEnity() -> TimerInfo
    func fetchTimerInfo()
    func createLapEnity() -> LapInfo
    func removeAllData()
}

protocol DataModelInteractorOutput: NSObjectProtocol {
    func restoreUI(model: TimerInfo?)
}

class DataModelInteractor:NSObject {
    weak var output: DataModelInteractorOutput?
    
    init(with output: DataModelInteractorOutput) {
        super.init()
        self.output = output
    }
    
    func deleteEntityData<T: NSManagedObject>(request: NSFetchRequest<T>) -> Bool {
        do {
            let result = try managedObjectContext.fetch(request)
            let _ = result.map { managedObject in
                managedObjectContext.delete(managedObject)
            }
            return true
        } catch {
            return false
        }
    }
}

extension DataModelInteractor: DateModelInteractorInput{
        var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var managedObjectContext: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }

    func fetchTimerInfo() {
        let timerInfoRequest: NSFetchRequest = TimerInfo.fetchRequest()
        let result = try! managedObjectContext.fetch(timerInfoRequest)
        output?.restoreUI(model: result.first)
    }
    
    func createTimerInfoEnity() -> TimerInfo {
        let entity = NSEntityDescription.entity(forEntityName: Constants.DataModel.EntityName.timerInfoName, in: managedObjectContext)
        let timer: TimerInfo = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! TimerInfo
        return timer
    }
    
    func createLapEnity() -> LapInfo {
        let entity = NSEntityDescription.entity(forEntityName: Constants.DataModel.EntityName.lapInfoName, in: managedObjectContext)
        let lap: LapInfo = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! LapInfo
        return lap
    }
    
    func removeAllData() {
        let lapDetailsRequest: NSFetchRequest = LapInfo.fetchRequest()
        let timerInfoRequest: NSFetchRequest = TimerInfo.fetchRequest()
        let _ = deleteEntityData(request: timerInfoRequest)
        let _ = deleteEntityData(request: lapDetailsRequest)
    }
}
