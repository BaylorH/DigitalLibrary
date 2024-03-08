//
//  bookRecord.swift
//  MyBookList
//
//  Created by Baylor Harrison on 2/18/24.
//

import Foundation
class bookRecord{
    var title: String? = nil
    var author: String? = nil
    var genre: String? = nil
    var price: Double? = nil
    
    init(t: String, a: String, g: String, p: Double) {
        self.title = t
        self.author = a
        self.genre = g
        self.price = p
    }
    
}
