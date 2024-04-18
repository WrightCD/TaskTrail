//
//  CompletedCell.swift
//  TaskTrail
//
//  Created by Carl Wright on 2024-04-16.
//

import UIKit

protocol CompletedCellDelegate: AnyObject {
    func deleteButtonTapped(cell: CompletedCell)
}

class CompletedCell: UITableViewCell {
    weak var delegate: CompletedCellDelegate?
    
    @IBOutlet weak var taskName: UITextView!
    @IBOutlet weak var compDate: UITextView!
    @IBOutlet weak var category: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        delegate?.deleteButtonTapped(cell: self)
    }

}
