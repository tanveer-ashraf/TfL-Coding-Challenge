//
//  TubeLineStatus.swift
//  TFLCodeApp
//
//  Created by Tanveer Ashraf on 12/11/2023.
//

import Foundation

struct TubeLineStatus: Codable, Equatable {
    static func == (lhs: TubeLineStatus, rhs: TubeLineStatus) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: String
    let name: String
    let lineStatuses: [LineStatus]

    struct LineStatus: Codable {
        let statusSeverityDescription: String
    }
}
