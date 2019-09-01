//
//  Data.swift
//  Todoey
//
//  Created by juliana vargas on 8/26/19.
//  Copyright © 2019 Juliana Vargas. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object{
    @objc dynamic var name: String = ""
    @objc dynamic var age = 0
}
