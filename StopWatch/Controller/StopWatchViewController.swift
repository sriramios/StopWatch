//
//  StopWatchViewController.swift
//  StopWatch
//
//  Created by Sriram on 19/10/19.
//  Copyright © 2019 Sriram. All rights reserved.
//

import UIKit
import Foundation
import CoreData

let initialStateTimerStr = String(format:  "%02d:%02d:%02d", 0,0,0)

class StopWatchViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var lapButton: CustomRoundedButton!
    @IBOutlet weak var startResetButton: CustomStateButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var lapButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lapsTableView: UITableView!
    
    
    //MARK: Properties
    var lapfetchResultController: NSFetchedResultsController<LapInfo>?
    var timerInfoModel: TimerInfo?
    var laps:[TimeInterval] = []
    var dataModelinteractor: DateModelInteractorInput?
    var timerManagerInteractor: TimerManagerInput?
    var dataSource: LapTableViewDataSource?
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataModelinteractor = DataModelInteractor(with: self)
        dataSource = LapTableViewDataSource(with: dataModelinteractor!.managedObjectContext, tableView: lapsTableView)
        dataModelinteractor?.fetchTimerInfo()
        timerManagerInteractor = TimerManager(with: self, dateModelInteractor: dataModelinteractor)
        updateUI()
        addObserser()
    }
    
    func updateUI() {
        lapButton.isEnabled = (startResetButton.buttonState == .stop)
        if startResetButton.buttonState == .start {
            timerLabel.text = initialStateTimerStr
        }
    }
    
    func addObserser() {
        _ = NotificationCenter.default.addObserver(self, selector: #selector(save), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }

    @IBAction func lapButtonAction(_ sender: Any) {
        timerManagerInteractor?.userClickedLapButton()
    }
    
    @IBAction func startResetAction(_ sender: Any) {
        //Handled Through State Machine
        timerManagerInteractor?.userAction(buttonState: startResetButton.buttonState)
        updateUI()
    }
    
    func attachFetchResultController() {
//        self.lapfetchResultController = self.fetchedResultsController
        if let timerInfo = timerInfoModel {
             dataSource?.lapFetchResultController?.fetchRequest.predicate = NSPredicate(format: Constants.DataModel.FormatString.idFormat, "id", timerInfo.id! as CVarArg)
            print(timerInfo.id ?? 0)
        }
        do {
            try  dataSource?.lapFetchResultController?.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
    }

}

//MARK: Timer Handling Methods
extension StopWatchViewController: TimerDelegate {
    func didStartFetchResultController(for info: TimerInfo?) {
        timerInfoModel = info
        attachFetchResultController()
    }
    
    func didChangeButtonState(state: ButtonState) {
        startResetButton.buttonState = state
    }

    func didChangeInterval(interval: Double) {
        timerLabel.text = interval.convertString()
    }
}

//MARK: Data Model Handling Methods
extension StopWatchViewController {
    @objc private func save() {
        dataModelinteractor!.appDelegate.saveContext()
    }
}

//MARK: StopWatchInteractorOutput Methods
extension StopWatchViewController: DataModelInteractorOutput {
    func restoreUI(model: TimerInfo?) {
        timerInfoModel = model
        timerLabel.text = initialStateTimerStr
        attachFetchResultController()
        if let timerInfo = timerInfoModel {
            let elapsedTime = timerInfo.endTime - timerInfo.startTime
            timerLabel.text = elapsedTime.convertString()
            startResetButton.buttonState = .reset
        }
    }
}
