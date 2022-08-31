
import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        return table
    }()
    
    var models = [SettingsSection]()
    
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
            SettingsOption(title: "Unidades", icon: UIImage(systemName: "house"), iconBackgroundColor: .systemMint) {
                
            },
            SettingsOption(title: "Turn Location Services On", icon: UIImage(systemName: "location"), iconBackgroundColor: .systemOrange) {
                
            },
            SettingsOption(title: "Push notifications", icon: UIImage(systemName: "house"), iconBackgroundColor: .systemPurple) {
                let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                //TODO: Descomentar para actualizar
//                let center = UNUserNotificationCenter.current()
//                center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
//
//                    if let error = error {
//                        print(error)
//                        // Handle the error here.
//                    }
//                    // Enable or disable features based on the authorization.
//                }
            }
        ]))
        
        models.append(SettingsSection(title: "General", options: [
            SettingsOption(title: "API info", icon: UIImage(systemName: "house"), iconBackgroundColor: .systemPink) {
                
            },
            SettingsOption(title: "FAQ", icon: UIImage(systemName: "questionmark"), iconBackgroundColor: .link) {
                let storyboard = UIStoryboard(name: "FAQStoryboard", bundle: nil)
                if let viewController = storyboard.instantiateViewController(withIdentifier: "FAQStoryboard") as? FAQViewController {
                    
                    viewController.title = "FAQ"
                    let backItem = UIBarButtonItem()
                    backItem.title = "Back"
                    self.navigationItem.backBarButtonItem = backItem
                    
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            }
        ]))
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
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingTableViewCell.identifier,
            for: indexPath) as? SettingTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = models[indexPath.section].options[indexPath.row]
        model.handler()
    }
}
