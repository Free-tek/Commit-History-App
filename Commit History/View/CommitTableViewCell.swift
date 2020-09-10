//
//  CommitTableViewCell.swift
//  Commit History
//
//  Created by Botosoft Technologies on 10/09/2020.
//  Copyright © 2020 mePlaylist. All rights reserved.
//

import UIKit

class CommitTableViewCell: UITableViewCell {

    @IBOutlet weak var commitMessage: UILabel!
    @IBOutlet weak var commitDate: UILabel!
    
    static let cellIdentifier = "CommitTableViewCell"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setOpaqueBackground()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
                
    }

    static func nib() -> UINib {
        return UINib(nibName: "CommitTableViewCell", bundle: nil)
    }
    
    public func configure(with viewModel: CommitViewModel) {

        commitMessage.text = viewModel.itemCommitMessage
        commitDate.text = viewModel.itemCommitDate
    }
}

private extension CommitTableViewCell {
    static let defaultBackgroundColor = UIColor.groupTableViewBackground
    
    //to achieve a smooth scroll
    func setOpaqueBackground() {
        alpha = 1.0
        backgroundColor = CommitTableViewCell.defaultBackgroundColor
        
    }
}

