//
//  InstabugLogger.swift
//  InstabugLogger
//
//  Created by Yosef Hamza on 19/04/2021.
//

import Foundation

public class InstabugLogger {
    private var savedLogs: [LogModel]?
    public static var shared = InstabugLogger()
    private let databaseManager: Database = CoreDataManager()
    
    // MARK: Logging
    public func log(_ level: LogType, message: String) {
        let log = LogModel()
        log.level = level
        log.message = message
        saveLog(log: log)
    }

    // MARK: Fetch logs
    public func fetchAllLogs() -> [LogModel] {
        databaseManager.fetch()
    }
    
    public func fetchAllLogs(completionHandler: ([LogModel])->Void) {
        let logs = databaseManager.fetch()
        completionHandler(logs)
    }
}

//MARK:- Private Functions

private extension InstabugLogger {
    func didMessagesExcededLimit() -> Bool {
        //fetch all logs
        let logs = fetchAllLogs()
        //check count
        return logs.count > 1000 
    }
    
    func saveLog(log: LogModel) {
        if didMessagesExcededLimit() {
            //remove old messages
            removeOldLog(logs: &savedLogs!)
        } else {
            databaseManager.save(log: log)
        }
    }
    
    func removeOldLog(logs: inout [LogModel]) {
        let backgroundContext = CoreDataManager.shared.backgroundContext
        backgroundContext.performAndWait {
            logs.sort {
                $0.date! > $1.date!
            }
            backgroundContext.delete((savedLogs?.last!)!)
            savedLogs!.removeLast()
        }
    }
}


