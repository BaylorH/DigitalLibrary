//
//  infoDictionary.swift
//  MyBookList
//
//  Created by Baylor Harrison on 2/18/24.
//

import Foundation
class infoDictionary: ObservableObject{
    @Published var infoRepository : [String:bookRecord] = [String:bookRecord]()
    init(){}
    
    func add(_ title:String, _ author:String, _ genre:String, _ price:Double){
        let bRecord = bookRecord(t: title, a: author, g: genre, p: price)
        infoRepository[bRecord.title!] = bRecord
    }
    
    func delete(t:String){
        infoRepository[t] = nil
    }
    
    func search(t:String) -> bookRecord?
    {
        for (title, _) in infoRepository{
            if title == t{                      //found book!
                return infoRepository[t]
            }
        }
        //didn't find book
        return nil
    }
    
    func getCount() -> Int
    {
        return infoRepository.count
    }
    
    //func edit(_ title:String, _ author:String, _ genre:String, _ price:Double){}
    
}
