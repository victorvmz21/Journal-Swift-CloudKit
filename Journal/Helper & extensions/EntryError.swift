//
//  EntryError.swift
//  Journal
//
//  Created by Victor Monteiro on 6/29/20.
//  Copyright © 2020 Atomuz. All rights reserved.
//

import Foundation
import CloudKit

enum EntryError: LocalizedError {
    
    case thrownError(Error)
    case noEntryFound
    case noRecordFound
}
