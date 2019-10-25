//
//  TimerManager.swift
//  StopWatch
//
//  Created by Sriram on 24/10/19.
//  Copyright © 2019 Sriram. All rights reserved.
//

import Foundation

protocol TimerDelegate: NSObjectProtocol {
    func didChangeInterval(interval: Double)
    func didChangeButtonState(state : ButtonState)
    func didStartFetchResultController(for info: TimerInfo?)
}

protocol TimerManagerInput: NSObjectProtocol {
    func userAction(buttonState: ButtonState)
    func userClickedLapButton()
}

class TimerManager: NSObject {
    private weak var delegate: TimerDelegate?
    private weak var dateModelInteractor: DateModelInteractorInput?

    private var stopWatchTimer: Timer?
    private var startTime: TimeInterval = 0.0
    private var currentLapStartTime: TimeInterval = 0.0
    private var timerInfoModel: TimerInfo?
    private var currentLapNo: Int = 0
    private var currentLapModel: LapInfo?
    
    init(with delegte: TimerDelegate, dateModelInteractor: DateModelInteractorInput?) {
        super.init()
        self.delegate = delegte
        self.dateModelInteractor = dateModelInteractor
    }
    
    private func stopTimer() {
        stopWatchTimer?.invalidate()
        currentLapStartTime = 0.0
        currentLapNo = 0
        dateModelInteractor?.appDelegate.saveContext()
        delegate?.didChangeButtonState(state: .reset)
    }
    
    private func resetTimer() {
        stopWatchTimer?.invalidate()
        dateModelInteractor?.removeAllData()
        currentLapStartTime = 0.0
        currentLapNo = 0
        delegate?.didChangeButtonState(state: .start)
    }
    
    private func addLap()  {
        if stopWatchTimer?.isValid ?? false {
            guard let timerInfo = timerInfoModel  else { return }
            let lap: LapInfo = dateModelInteractor!.createLapEnity()
            let elapsedTime =  Date.timeIntervalSinceReferenceDate - currentLapStartTime
            currentLapStartTime = Date.timeIntervalSinceReferenceDate
            currentLapNo = currentLapNo + 1
            lap.lap = Int16(currentLapNo)
            lap.id = timerInfo.id
            lap.timeInterval = elapsedTime
            lap.createdAt = Date()
            currentLapModel = lap
        }
    }
    
    private func startTimer()  {
        dateModelInteractor!.removeAllData()
        stopWatchTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        startTime = Date.timeIntervalSinceReferenceDate
        currentLapStartTime = startTime
        let timerModel: TimerInfo = dateModelInteractor!.createTimerInfoEnity()
        timerModel.id = UUID()
        timerModel.startTime = startTime
        timerInfoModel = timerModel
        delegate?.didStartFetchResultController(for: timerInfoModel)
        addLap()
        delegate?.didChangeButtonState(state: .stop)
    }
    
    @objc func updateTime()  {
        self.timerInfoModel?.endTime = Date.timeIntervalSinceReferenceDate
        let elapsedTime = self.timerInfoModel!.endTime - startTime
        if currentLapNo == 1 {
            currentLapStartTime = startTime
        }
        self.currentLapModel?.timeInterval = Date.timeIntervalSinceReferenceDate - currentLapStartTime
        delegate?.didChangeInterval(interval: elapsedTime)
    }
}

extension TimerManager: TimerManagerInput {
    func userClickedLapButton() {
        addLap()
    }
    
    func userAction(buttonState: ButtonState) {
        switch buttonState {
        case .start:
            startTimer()
        case .stop:
            stopTimer()
        case .reset:
            resetTimer()
        }
    }
}
