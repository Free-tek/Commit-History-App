//
//  HomeViewController.swift
//  Commit History
//
//  Created by Botosoft Technologies on 10/09/2020.
//  Copyright © 2020 mePlaylist. All rights reserved.
//

import UIKit
import Network
import Foundation
import SystemConfiguration

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {



    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var commitTableView: UITableView!

    let commitViewModelController: CommitViewModelController = CommitViewModelController()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
        fecthDataforTableView()

    }

    func fecthDataforTableView() {
        if !isInternetAvailable(){
            showToast(message: "Please check you internet connection and try again", seconds: 1.5)
        }else{
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
        

    }


    func setUpElements() {
        //hide keyboard when  tapped around
        hideKeyboardWhenTappedAround()
        
        //remove empty table view cells
        commitTableView.tableFooterView = UIView()
        
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

extension UIViewController {

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func showToast(message: String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15

        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }

    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()

        if searchText == "" {

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


        } else {

            commitViewModelController.fetchCommitsSearched(searchText, completion: { (success) in

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





    }


    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        commitViewModelController.fetchCommits(completion: { (success) in
            if !success {
                print("error encountered")
            } else {
                DispatchQueue.main.async {
                    self.commitTableView.alpha = 1
                    self.commitTableView.reloadData()
                }
            }
        })


    }
}



