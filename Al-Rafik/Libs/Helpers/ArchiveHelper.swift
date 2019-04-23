//
//  ArchiveHelper.swift
//  Al-Rafik
//
//  Created by Nour  on 4/5/19.
//  Copyright © 2019 Nour . All rights reserved.
//

import Foundation
import Zip

struct ArchiveHelper{
    
    static func unZip(filePath:URL) -> String?{
        do {
            let unzipDirectory = try Zip.quickUnzipFile(filePath)
            return unzipDirectory.lastPathComponent
        }
        catch {
            print(error)
            return nil
        }
    }
    
}
