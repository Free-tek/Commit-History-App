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

class CommitViewModelController {

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

                        for i in 0...25 {

                            print(json[i])
                            var itemCommitDate = json[i]["commit"]["author"]["date"].string

                            let inputDateFormatter = DateFormatter()
                            inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                            let date = inputDateFormatter.date(from: itemCommitDate!)

                            let outputDateFormatter = DateFormatter()
                            outputDateFormatter.dateFormat = "yyyy-dd-mm HH:mm"
                            itemCommitDate = outputDateFormatter.string(from: date!)

                            let itemCommitAuthor = json[i]["commit"]["author"]["name"].string

                            let itemCommitMessage = json[i]["commit"]["message"].string

                            let itemGotten = CommitModel(itemCommitMessage: itemCommitMessage!, itemCommitDate: itemCommitDate!, itemCommitAuthor: itemCommitAuthor!)

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
    
    func fetchCommitsSearched(_ searchedText: String, completion: @escaping (_ success: Bool) -> ()) {
            
        fetchCommits(completion: { (success) in
            if !success {
                completion(false)
                print("error encountered")
            } else {
                
                self.viewModels = self.viewModels.filter({ ($0?.itemCommitAuthor!.lowercased())!.contains(searchedText.lowercased()) })
                
    
                completion(true)
            }
        })
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

