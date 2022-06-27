//
//  EarthquakeEventCell.swift
//  Quake
//
//  Created by Guillermo Zafra on 14/6/22.
//

import UIKit

protocol EarthquakeEventCellDelegate: AnyObject {
    func didExpandCell(isExpanded: Bool, indexPath: IndexPath)
}

class EarthquakeEventCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var magnitudeLabel: UILabel!
    @IBOutlet weak var expandableImage: UIImageView!
    @IBOutlet weak var expandableView: UIView!
    
    var indexPath: IndexPath = IndexPath()
    weak var delegate: EarthquakeEventCellDelegate?
    
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
    
    @objc private func tappedMe() {
        print("Tapped on ExpandableImage")
        
        //Expand the cell
        expandableView.isHidden = !expandableView.isHidden
        delegate?.didExpandCell(isExpanded: !expandableView.isHidden, indexPath: indexPath)
    }
    
}
