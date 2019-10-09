//
//  Post.swift
//  IOS Social Network
//
//  Created by  SENAT on 31/07/2019.
//  Copyright © 2019 <ASi. All rights reserved.
//

import Foundation

struct Post: Decodable {
    var id: Int
    var title, body: String
}
