//
//  EntryController.swift
//  Journal
//
//  Created by Victor Monteiro on 6/29/20.
//  Copyright © 2020 Atomuz. All rights reserved.
//

import Foundation
import CloudKit

class EntryController {
    
    //MARK: - Singleton
    static let shared = EntryController()
    
    //MARK: S.O.T
    var entries: [Entry] = []
    
    //MARK: Private CloudKit Database
    let privateDB = CKContainer.default().privateCloudDatabase
    
    //MARK: - Crud Methods
    
    func createEntryWith(title: String, body: String, completion: @escaping (Result<Entry?, EntryError>) -> Void) {
        let newEntry = Entry(title: title, body: body)
        save(entry: newEntry, completion: completion)
    }
    
    func updateEntry(entry: Entry, title: String, body: String) {
        entry.title = title
        entry.body = body
    }
    
    func save(entry: Entry, completion: @escaping (Result<Entry?, EntryError>) -> Void) {
        
        let record = CKRecord(entry: entry)
        privateDB.save(record) { (record, error) in
            if let error = error {
               return completion(.failure(.thrownError(error)))
            }
            
            guard let record = record else { return completion(.failure(.noRecordFound))}
            guard let newEntry = Entry(ckRecord: record) else { return completion(.failure(.noEntryFound))}
            self.entries.append(newEntry)
            
            return completion(.success(newEntry))
        }
    }
    
    func fetchEntries(completion: @escaping (Result<[Entry]?, EntryError>) -> Void) {
        
        let predicate = NSPredicate(value: true)
        let ckQuery = CKQuery(recordType: EntryContants.recordTypeKey, predicate: predicate)
        privateDB.perform(ckQuery, inZoneWith: nil) { (records, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let records = records else { return completion(.failure(.noRecordFound)) }
            let entries = records.compactMap{ Entry(ckRecord: $0)}
            self.entries = entries
            completion(.success(entries))
            
        }
    }
}
