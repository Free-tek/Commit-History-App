//
//  CommitModel.swift
//  Commit History
//
//  Created by Botosoft Technologies on 10/09/2020.
//  Copyright © 2020 mePlaylist. All rights reserved.
//

import Foundation
struct CommitModel {
    let itemCommitMessage: String?
    let itemCommitDate: String?


    init(itemCommitMessage: String?, itemCommitDate: String?) {
        self.itemCommitMessage = itemCommitMessage
        self.itemCommitDate = itemCommitDate
    }

}
