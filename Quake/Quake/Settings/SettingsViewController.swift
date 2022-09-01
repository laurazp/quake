
import UIKit
import MapKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        table.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.identifier)
        return table
    }()
    
    var models = [SettingsSection]()
    
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        configure()
    }
    
    func configure() {
        models.append(SettingsSection(title: "Configuration", options: [
            .staticCell(model: SettingsOption(title: "Units ", icon: UIImage(systemName: "option"), iconBackgroundColor: .systemMint) {
                
            }),
            .switchCell(model: SettingsSwitchOption(title: "Push notifications", icon: UIImage(systemName: "message"), iconBackgroundColor: .systemPurple, handler: {
                
            }, isOn: false)),
            .staticCell(model: SettingsOption(title: "Turn Location Services On", icon: UIImage(systemName: "location"), iconBackgroundColor: .systemOrange) {
                
                self.checkLocationServices()
                
//                let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertController.Style.alert)
//                alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
            })
        ]))
        
        models.append(SettingsSection(title: "General", options: [
            .staticCell(model: SettingsOption(title: "API info", icon: UIImage(systemName: "house"), iconBackgroundColor: .systemPink) {
                let storyboard = UIStoryboard(name: "ApiInfoStoryboard", bundle: nil)
                if let viewController = storyboard.instantiateViewController(withIdentifier: "ApiInfoStoryboard") as? ApiInfoViewController {
                    
                    viewController.title = "API Info"
                    let backItem = UIBarButtonItem()
                    backItem.title = "Back"
                    self.navigationItem.backBarButtonItem = backItem
                    
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
                
                //<a href="https://www.flaticon.com/free-icons/earthquake" title="earthquake icons">Earthquake icons created by fjstudio - Flaticon</a>
                
            }),
            .staticCell(model: SettingsOption(title: "FAQ", icon: UIImage(systemName: "questionmark"), iconBackgroundColor: .link) {
                let storyboard = UIStoryboard(name: "FAQStoryboard", bundle: nil)
                if let viewController = storyboard.instantiateViewController(withIdentifier: "FAQStoryboard") as? FAQViewController {
                    
                    viewController.title = "FAQ"
                    let backItem = UIBarButtonItem()
                    backItem.title = "Back"
                    self.navigationItem.backBarButtonItem = backItem
                    
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            })
        ]))
    }
    
    private func checkLocationServices() {
        guard CLLocationManager.locationServicesEnabled() else {
            // TODO: Revisar mensaje !!!
            let alert = UIAlertController(title: "Location Services not enabled", message: "Go to your phone Settings and turn location services on in order to have the whole app working properly.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        let alert = UIAlertController(title: "Location Services enabled", message: "Location Services enabled for Quake.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Accept", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        checkAuthorizationForLocation()
    }

    private func checkAuthorizationForLocation() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            //mapView.showsUserLocation = true
            //centerViewOnUser()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            let alert = UIAlertController(title: "Location Services not enabled", message: "Go to your phone Settings and turn location services on in order to have the app working properly.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
                // TODO: Revisar mensaje !!!
            let alert = UIAlertController(title: "Alert", message: "Quake is not authorize to use location services. Go to your phone Settings to change it.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            break
        @unknown default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = models[section]
        return section.title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section].options[indexPath.row]
        
        switch model.self {
        case .staticCell(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingTableViewCell.identifier,
                for: indexPath) as? SettingTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
        case .switchCell(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SwitchTableViewCell.identifier,
                for: indexPath) as? SwitchTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let type = models[indexPath.section].options[indexPath.row]
        
        switch type.self {
        case .staticCell(let model):
            model.handler()
        case .switchCell(let model):
            model.handler()
        }
    }
}
