//
//  CommitViewModel.swift
//  Commit History
//
//  Created by Botosoft Technologies on 10/09/2020.
//  Copyright © 2020 mePlaylist. All rights reserved.
//

import Foundation
struct CommitViewModel {
    let itemCommitMessage: String?
    let itemCommitDate: String?
    let itemCommitAuthor: String?


    init(commitItem: CommitModel) {
        self.itemCommitMessage = commitItem.itemCommitMessage
        self.itemCommitDate = commitItem.itemCommitDate
        self.itemCommitAuthor = commitItem.itemCommitAuthor
    }

}
