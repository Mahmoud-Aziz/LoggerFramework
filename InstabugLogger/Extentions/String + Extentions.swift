//
//  String + Extentions.swift
//  InstabugInternshipTask
//
//  Created by Mahmoud Aziz on 26/05/2021.
//

import Foundation

extension String {
    func truncate(length: Int = 1000, trailing: String = "…") -> String {
      return (self.count > length) ? self.prefix(length) + trailing : self
    }
}


