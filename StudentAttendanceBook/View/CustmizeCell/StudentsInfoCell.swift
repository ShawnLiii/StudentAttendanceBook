//
//  StudentsInfoCell.swift
//  StudentAttendanceBook
//
//  Created by Shawn Li on 6/6/20.
//  Copyright © 2020 ShawnLi. All rights reserved.
//

import UIKit

class StudentsInfoCell: UITableViewCell
{
    
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var lastNameLbl: UILabel!
    @IBOutlet weak var majorLbl: UILabel!
    @IBOutlet weak var checkMarkLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(students: [Students] ,indexPath: IndexPath)
    {
        let student = students[indexPath.row]
        checkMarkLbl.text = student.checked ? "✓" : "x"
        firstNameLbl.text = student.firstName
        lastNameLbl.text = student.lastName
        majorLbl.text = student.major
    }
}
