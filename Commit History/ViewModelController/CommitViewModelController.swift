//
//  CommitViewModelController.swift
//  Commit History
//
//  Created by Botosoft Technologies on 10/09/2020.
//  Copyright © 2020 mePlaylist. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class TrendsViewModelController {

    var viewModels: [CommitViewModel?] = []

    func fetchCommits(completion: @escaping (_ success: Bool) -> ()) {

        var commitModel = [CommitModel?]()
        let Url = String(format: "https://api.github.com/repos/rails/rails/commits")

        AF.request(Url)
            .responseJSON { response in
                print(response)

                do {
                    if response.data != nil {
                        let json = try JSON(data: response.data!)

                        for _ in 0...25 {

                            let itemCommitDate = json["author"]["date"].string
                            
                            let itemCommitAuthor = json["author"]["name"].string
                            
                            let itemCommitMessage = json["message"].string

                            let itemGotten = CommitModel(itemCommitMessage: itemCommitMessage!, itemCommitDate: itemCommitDate!)

                            commitModel.append(itemGotten)
                        }

                        self.viewModels = self.initViewModels(commitModel)
                        completion(true)


                    } else {
                        //TODO: No network
                        completion(false)
                    }



                } catch let error as NSError {
                    completion(false)
                    print("Failed to load: \(error.localizedDescription)")
                }

        }

    }

    var viewModelsCount: Int {
        return viewModels.count
    }

    func viewModel(at index: Int) -> CommitViewModel? {
        guard index >= 0 && index < viewModelsCount else { return nil }
        return viewModels[index]
    }


    func initViewModels(_ commitModel: [CommitModel?]) -> [CommitViewModel?] {
        return commitModel.map { commit in
            if let commit = commit {
                return CommitViewModel(commitItem: commit)
            } else {
                return nil
            }
        }
    }


}
