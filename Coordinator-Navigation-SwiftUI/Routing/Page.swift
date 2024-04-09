//
//  Routes.swift
//  VxH-Cam
//
//  Created by XD on 09/04/2024.
//

import Foundation
enum Page {
    case home
    case popUpModal
    case popUpBottom
    case detailView
    case moreDetail
}
extension Page: Identifiable {
    var id: Self { self }
}
extension Page: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.hashValue)
    }
}
