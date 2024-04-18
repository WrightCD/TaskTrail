//
//  TableViewTaskCell.swift
//  TaskTrail
//
//  Created by Carl Wright on 2024-04-16.
//

import UIKit

protocol TableViewTaskCellDelegate: AnyObject {
    func deleteButtonTapped(cell: TableViewTaskCell)
    func checkmarkButtonTapped(cell: TableViewTaskCell)
}

class TableViewTaskCell: UITableViewCell {
    weak var delegate: TableViewTaskCellDelegate?
    
    @IBOutlet weak var taskName: UITextView!
    @IBOutlet weak var dueDate: UITextView!
    @IBOutlet weak var priority: UITextView!
    @IBOutlet weak var category: UITextView!
    @IBOutlet weak var checkmark: UIButton!
    @IBOutlet weak var deleteTask: UIButton!
    @IBOutlet weak var difficulty: UIImageView!
    @IBOutlet weak var colorDisplay: UIImageView!
    
    @IBAction func deleteTaskButtonTapped(_ sender: UIButton) {
        delegate?.deleteButtonTapped(cell: self)
    }
    
    @IBAction func checkmarkButtonTapped(_ sender: UIButton) {
        delegate?.checkmarkButtonTapped(cell: self)
    }
    
}
