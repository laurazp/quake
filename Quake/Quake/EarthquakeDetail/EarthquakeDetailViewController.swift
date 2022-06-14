//
//  EarthquakeDetailViewController.swift
//  Quake
//
//  Created by Guillermo Zafra on 14/6/22.
//

import UIKit

class EarthquakeDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        // Do any additional setup after loading the view.
    }
    

    func didTapButton() {
//        navigationController?.popViewController(animated: true) // Volver si se ha presentado navegacion
        dismiss(animated: true) // Si es modal
    }

}
