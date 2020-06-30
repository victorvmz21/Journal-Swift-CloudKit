//
//  Entry.swift
//  Journal
//
//  Created by Victor Monteiro on 6/29/20.
//  Copyright © 2020 Atomuz. All rights reserved.
//

import Foundation
import CloudKit

struct EntryContants {
    static let titleKey = "title"
    static let bodyKey = "body"
    static let timeStampKey = "timeStamp"
    static let recordTypeKey = "Entry"
}

class Entry {
    
    var title: String
    var body: String
    var timeStamp: Date
    var ckRecordID: CKRecord.ID
    
    init(title: String, body: String, timeStamp: Date = Date(),
         ckRecordId: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString) ) {
        self.title = title
        self.body = body
        self.timeStamp = timeStamp
        self.ckRecordID = ckRecordId
    }
}

extension Entry {
    
    convenience init?(ckRecord: CKRecord) {
        
       guard let title = ckRecord[EntryContants.titleKey]     as? String,
         let body      = ckRecord[EntryContants.bodyKey]      as? String,
         let timeStamp = ckRecord[EntryContants.timeStampKey] as? Date
       else { return nil }
        
        self.init(title: title, body: body, timeStamp: timeStamp, ckRecordId: ckRecord.recordID)
    }
}

extension CKRecord {
    convenience init(entry: Entry) {
        self.init(recordType: EntryContants.recordTypeKey, recordID: entry.ckRecordID)
        self.setValuesForKeys([
            EntryContants.titleKey: entry.title,
            EntryContants.bodyKey: entry.body,
            EntryContants.timeStampKey: entry.timeStamp
        ])
    }
}
