//
//  EarthquakeEventCell.swift
//  Quake
//
//  Created by Guillermo Zafra on 14/6/22.
//

import UIKit

class EarthquakeEventCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var magnitudeLabel: UILabel!
    @IBOutlet weak var expandableImage: UIImageView!
    
    var isOpened: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tap = UITapGestureRecognizer(target: self, action: #selector(EarthquakeEventCell.tappedMe))
        expandableImage.addGestureRecognizer(tap)
        expandableImage.isUserInteractionEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func tap() {
        
    }
    
    @objc func tappedMe() {
        print("Tapped on ExpandableImage")
        
        // TODO: Expand the cell
        let viewController = EarthquakeViewController()
        viewController.expandCells()
        
        /*let viewController = EarthquakeViewController()
        viewController.tableView.deselectRow(at: (viewController.inde, animated: true)
        
        if isOpened == true {
            isOpened = false
        }
        else {
            isOpened = true
        }
        
        viewController.tableView.reloadSections([indexPath.section], with: .none)*/
        
    }
    
}
