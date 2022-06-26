//
//  EarthquakeDetailViewController.swift
//  Quake
//
//  Created by Guillermo Zafra on 14/6/22.
//

import UIKit

class EarthquakeDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
//    let resultLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Title"
//        label.font = UIFont.systemFont(ofSize: 12)
//        return label
//    }()
    
    var titleFromCell: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.addSubview(titleLabel)
        view.backgroundColor = .yellow
        
        /*titleLabel = UILabel()
        titleLabel.text = "Mierda"
        view.addSubview(titleLabel)*/
        
        //view.addSubview(resultLabel)
        
        // Assign labels text
        guard let resultTitle = titleFromCell else {
            return
        }
        print("TitleFromCell después = " + (titleFromCell ?? "error"))
        titleLabel.text = resultTitle
    }

    func didTapButton() {
        navigationController?.popViewController(animated: true) // Volver si se ha presentado navegacion
  //      dismiss(animated: true) // Si es modal
    }

}



/*
 struct Feature: Codable {
     let properties: Property
     let geometry: Geometry
 }
         
 struct Property: Codable {
     let mag: Double
     let place: String
     //let time: Date
     let tsunami: Int
     let title: String
 }
         
 struct Geometry: Codable {
     let coordinates: [Float]
 }
 */
