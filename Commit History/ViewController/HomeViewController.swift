//
//  HomeViewController.swift
//  Commit History
//
//  Created by Botosoft Technologies on 10/09/2020.
//  Copyright © 2020 mePlaylist. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {



    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var commitTableView: UITableView!

    let commitViewModelController: CommitViewModelController = CommitViewModelController()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()

        commitViewModelController.fetchCommits(completion: { (success) in
            if !success {
                print("error encountered")
            } else {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.commitTableView.alpha = 1
                    self.commitTableView.reloadData()
                }
            }
        })

    }
    func setUpElements() {
        //allow the tabke view scroll to the buttom
        commitTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 300, right: 0);

        commitTableView.alpha = 0

        //show activity indicator during loading
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()

        commitTableView.delegate = self
        commitTableView.dataSource = self
        commitTableView.register(CommitTableViewCell.nib(), forCellReuseIdentifier: CommitTableViewCell.cellIdentifier)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commitViewModelController.viewModelsCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commitTableView.dequeueReusableCell(withIdentifier: CommitTableViewCell.cellIdentifier, for: indexPath) as! CommitTableViewCell

        if let viewModel = commitViewModelController.viewModel(at: indexPath.row) {
            cell.configure(with: viewModel)
        }


        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
        
    }

    //get clicked item
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }


    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    }


}
