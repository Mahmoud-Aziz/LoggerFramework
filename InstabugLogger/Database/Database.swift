//
//  Database.swift
//  InstabugInternshipTask
//
//  Created by Mahmoud Aziz on 26/05/2021.
//

import Foundation

protocol Database {
    
    func save(log: LogModel)
    func fetch() -> [LogModel]
    func remove(log: LogModel)
    func removeAll()
}
