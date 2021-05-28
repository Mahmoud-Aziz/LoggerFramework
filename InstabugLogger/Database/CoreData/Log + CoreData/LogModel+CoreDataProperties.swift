//
//  LogModel+CoreDataProperties.swift
//  InstabugInternshipTask
//
//  Created by Mahmoud Aziz on 28/05/2021.
//
//

import Foundation
import CoreData


extension LogModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LogModel> {
        return NSFetchRequest<LogModel>(entityName: "LogModel")
    }

    @NSManaged public var message: String? 
    @NSManaged public var level: LogType
    @NSManaged public var date: Date?

}

extension LogModel : Identifiable {

}
