import UIKit
class FifthViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource  {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var statsTableView: UITableView!
    @IBOutlet weak var statsTableVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var scoresTableView: UITableView!
    @IBOutlet weak var scoresTableVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var awayLabel: UILabel!
    @IBOutlet weak var statModeSwitch: UISwitch!
    @IBOutlet weak var statModeSwitchLabel: UILabel!
    @IBOutlet weak var selectTeamsForTeamsModeView: UIView!
    @IBOutlet weak var teamPickerView: UIPickerView!
    @IBOutlet weak var selectTeamsDropdownButton: UIButton!
    var statsArray:[[String:String]] = [[String:String]]()
    var scoresArray:[[String:String]] = [[String:String]]()
    var administratorPassword:String = ""
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var teamNamesArray:[[String:String]] = [[String:String]]()
    var teamsModeHomeTeam:String = ""
    var teamsModeAwayTeam:String = ""
    @IBOutlet weak var teamsModeSegmentedControl: UISegmentedControl!
    var selectedIndexPath:IndexPath?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scoresTableView.allowsSelection = false
        self.statsTableView.delegate = self
        self.statsTableView.dataSource = self
        self.scoresTableView.delegate = self
        self.scoresTableView.dataSource = self
        self.teamPickerView.delegate = self
        self.teamPickerView.dataSource = self
        self.statsTableView.register(UINib(nibName: "CustomStatUpdaterTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomSubclassCell")
        self.scoresTableView.register(UINib(nibName: "CustomScoreUpdaterTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomSubclassCell2")
        self.retrievePassword()
        self.retrieveTeamNames()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let myAlert:UIAlertController = UIAlertController(title: "Administrator Login", message: "Please enter your password", preferredStyle: UIAlertControllerStyle.alert)
        let firstAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alertAction:UIAlertAction!) in
            NSLog("OK button clicked")
            let firstTextField:UITextField = myAlert.textFields![0] as UITextField
            NSLog(firstTextField.text!)
            print(self.administratorPassword)
            if firstTextField.text! != self.administratorPassword {
                self.statsTableView.alpha = 0.2
                let wrongPasswordAlert:UIAlertController = UIAlertController(title: "Invalid Password", message: "", preferredStyle: UIAlertControllerStyle.alert)
                let returnToHomeAction:UIAlertAction = UIAlertAction(title: "Return to Home Page", style: UIAlertActionStyle.default, handler: { (alertAction:UIAlertAction!) in
                    NSLog("Return to home screen button clicked")
                    self.tabBarController!.selectedIndex = 0
                })
                wrongPasswordAlert.addAction(returnToHomeAction)
                self.present(wrongPasswordAlert, animated: true, completion: nil)
            }
            else {
                UIView.animate(withDuration: 0.5, animations: {
                    self.statsTableView.alpha = 1
                    if self.statModeSwitch.isOn == false {
                        self.selectTeamsForTeamsModeView.alpha = 1
                        self.retrieveIndividualRoster(self.teamsModeHomeTeam)
                    }
                    else {
                        self.retrieveByPlayerNumber()
                    }
                })
            }
        })
        myAlert.addAction(firstAction)
        let secondAction:UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (alertAction:UIAlertAction!) in
            NSLog("Cancel button clicked")
            self.tabBarController!.selectedIndex = 0
        })
        myAlert.addAction(secondAction)
        myAlert.addTextField(configurationHandler: {(textField:UITextField!) in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        })
        self.present(myAlert, animated: true, completion: nil)
    }
    func retrievePassword() {
        let url:URL = URL(string: "http://evanwolfapps.com/retrievePassword.php")!
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: { (data, response, Error) -> Void in
            do {
                let dataArray:[AnyObject] = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [AnyObject]
                self.administratorPassword.removeAll(keepingCapacity: false)
                for data in dataArray {
                    let dictionary:[String:String] = data as! [String:String]
                    if dictionary["password"] != nil {
                        self.administratorPassword = dictionary["password"]!
                    }
                }
                DispatchQueue.main.async {
                }
            }
            catch {
            }
        }) 
        task.resume()
    }
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        let segmentedControl = sender as UISegmentedControl
        switch segmentedControl.selectedSegmentIndex {
        case 0: 
            self.statsTableView.alpha = 1
            self.scoresTableView.alpha = 0
            self.homeLabel.alpha = 0
            self.awayLabel.alpha = 0
            self.statModeSwitch.alpha = 1
            self.statModeSwitchLabel.alpha = 1
            if self.statModeSwitch.isOn  == false {
                self.statsTableVerticalConstraint.constant = 140
                self.scoresTableVerticalConstraint.constant = 140
                self.selectTeamsDropdownButton.alpha = 1
                self.teamsModeSegmentedControl.alpha = 1
                self.retrieveIndividualRoster(self.teamsModeHomeTeam)
            }
            else {
                self.selectTeamsForTeamsModeView.alpha = 0
                self.selectTeamsDropdownButton.alpha = 0
                self.statsTableVerticalConstraint.constant = 100
                self.scoresTableVerticalConstraint.constant = 100
                self.teamsModeSegmentedControl.alpha = 0
            }
        case 1: 
            self.statsTableView.alpha = 0
            self.selectTeamsDropdownButton.alpha = 0
            self.scoresTableView.alpha = 1
            self.statModeSwitch.alpha = 0
            self.statModeSwitchLabel.alpha = 0
            self.selectTeamsForTeamsModeView.alpha = 0
            self.scoresTableVerticalConstraint.constant = 100
            self.statsTableVerticalConstraint.constant = 100
            self.homeLabel.alpha = 1
            self.awayLabel.alpha = 1
            self.teamsModeSegmentedControl.alpha = 0
            self.retrieveByGames()
        default:
            return
        }
    }
    @IBAction func teamsModeSegmentChanged(_ sender: UISegmentedControl) {
        let segmentedControl = sender as UISegmentedControl
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            self.retrieveIndividualRoster(self.teamsModeHomeTeam)
        case 1:
            self.retrieveIndividualRoster(self.teamsModeAwayTeam)
        default:
            return
        }
    }
    @IBAction func changeStatMode(_ sender: UISwitch) {
        if sender.isOn == false {
            self.statModeSwitchLabel.text = "Show All: Off"
            self.scoresTableVerticalConstraint.constant = 140
            self.statsTableVerticalConstraint.constant = 140
            UIView.animate(withDuration: 0.5, animations: {
                self.selectTeamsForTeamsModeView.alpha = 1
                self.selectTeamsDropdownButton.alpha = 1
                self.teamsModeSegmentedControl.alpha = 1
            })
        }
        else {
            self.retrieveByPlayerNumber()
            self.statModeSwitchLabel.text = "Show All: On"
            self.selectTeamsForTeamsModeView.alpha = 0
            self.scoresTableVerticalConstraint.constant = 100
            self.statsTableVerticalConstraint.constant = 100
            self.selectTeamsDropdownButton.alpha = 0
            self.teamsModeSegmentedControl.alpha = 0
        }
    }
    func retrieveByPlayerNumber() {
        self.activityIndicator.startAnimating()
        let url:URL = URL(string: "http://evanwolfapps.com/retrieveByPlayerNumber.php")!
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: { (data, response, Error) -> Void in
            do {
                let dataArray:[AnyObject] = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [AnyObject]
                self.statsArray.removeAll(keepingCapacity: false)
                for data in dataArray {
                    let dictionary:[String:String] = data as! [String:String]
                    if dictionary["PlayerName"] != nil {
                        self.statsArray.append(dictionary)
                    }
                }
                DispatchQueue.main.async {
                    self.statsTableView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            }
            catch {
            }
        }) 
        task.resume()
    }
    func retrieveByGames() {
        let url:URL = URL(string: "http://evanwolfapps.com/retrieveByGames.php")!
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            do {
                let dataArray:[AnyObject] = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [AnyObject]
                self.scoresArray.removeAll(keepingCapacity: false)
                for data in dataArray {
                    let dictionary:[String:String] = data as! [String:String]
                    if dictionary["HomeScore"] != nil {
                        self.scoresArray.append(dictionary)
                    }
                }
                DispatchQueue.main.async {
                    self.scoresTableView.reloadData()
                }
            }
            catch {
            }
        }) 
        task.resume()
    }
    func retrieveTeamNames() {
        let url:URL = URL(string: "http://evanwolfapps.com/retrieveTeamNamesForButtons.php")!
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: { (data, response, Error) -> Void in
            do {
                if let foundData = data {
                    let dataArray:[AnyObject]? = try JSONSerialization.jsonObject(with: foundData, options: JSONSerialization.ReadingOptions.mutableContainers) as! [AnyObject]
                    self.teamNamesArray.removeAll(keepingCapacity: false)
                    for data in dataArray! {
                        let dictionary:[String:String] = data as! [String:String]
                        if dictionary["Team"] != nil {
                            self.teamNamesArray.append(dictionary)
                        }
                    }
                    DispatchQueue.main.async {
                        self.teamPickerView.reloadAllComponents()
                        self.teamsModeHomeTeam = self.teamNamesArray[0]["Team"]!
                        self.teamsModeAwayTeam = self.teamNamesArray[0]["Team"]!
                    }
                }
                else {
                    print("no data found")
                }
            }
            catch {
            }
        }) 
        task.resume()
    }
    func retrieveIndividualRoster(_ teamName:String) {
        self.activityIndicator.startAnimating()
        do {
            let url:URL = URL(string: "http://evanwolfapps.com/retrieveTeamRosters.php")!
            var request:URLRequest = URLRequest(url: url)
            request.httpMethod = "POST"
            let dataDictionary:[String:String] = ["teamName" : teamName]
            let data:Data = try JSONSerialization.data(withJSONObject: dataDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
            request.httpBody = data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: { (data, response, Error) -> Void in
                do {
                    let response:[AnyObject] = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [AnyObject]
                    self.statsArray.removeAll(keepingCapacity: false)
                    for player in response {
                        let dictionary:[String:String] = player as! [String:String]
                        if dictionary["PlayerName"] != nil {
                            self.statsArray.append(dictionary)
                        }
                    }
                    DispatchQueue.main.async {
                        self.statsTableView.reloadData()
                        self.activityIndicator.stopAnimating()
                    }
                }
                catch {}
            }) 
            task.resume()
        }
        catch {}
    }
    @IBAction func closeSelectTeamsForTeamsModelView(_ sender: UIButton) {
        if self.teamsModeSegmentedControl.selectedSegmentIndex == 0 {
            self.retrieveIndividualRoster(self.teamsModeHomeTeam)
        }
        else {
            self.retrieveIndividualRoster(self.teamsModeAwayTeam)
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.selectTeamsForTeamsModeView.alpha = 0
        })
    }
    @IBAction func showSelectTeamsForTeamsModeView(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {self.selectTeamsForTeamsModeView.alpha = 1})
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CustomStatUpdaterTableViewCell = self.statsTableView.dequeueReusableCell(withIdentifier: "CustomSubclassCell") as! CustomStatUpdaterTableViewCell
        let cell2:CustomScoreUpdaterTableViewCell = self.scoresTableView.dequeueReusableCell(withIdentifier: "CustomSubclassCell2") as! CustomScoreUpdaterTableViewCell
        if tableView == self.statsTableView {
            cell.setPlayerNumberLabel(self.statsArray[indexPath.row]["PlayerNumber"]!)
            cell.setPlayerName(self.statsArray[indexPath.row]["PlayerName"]!)
            cell.hideUpdateButton()
            cell.setGoalsAndAssistsLabelsToZero()
        }
        else {
            cell2.setHomeTeam(self.scoresArray[indexPath.row]["HomeTeam"]!)
            cell2.setAwayTeam(self.scoresArray[indexPath.row]["AwayTeam"]!)
            cell2.setHomeScore(self.scoresArray[indexPath.row]["HomeScore"]!)
            cell2.setAwayScore(self.scoresArray[indexPath.row]["AwayScore"]!)
            cell2.setGameNum(self.scoresArray[indexPath.row]["GameNumber"]!)
        }
        if tableView == self.statsTableView {
            return cell
        }
        else {
            return cell2
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.statsTableView {
            return self.statsArray.count
        }
        else if tableView == self.scoresTableView {
            return self.scoresArray.count
        }
        return 5
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.statsTableView {
            let previousIndexPath = selectedIndexPath
            if indexPath == selectedIndexPath {
                selectedIndexPath = nil
            }
            else {
                selectedIndexPath = indexPath
            }
            var indexPaths: Array<IndexPath> = []
            if let previous = previousIndexPath {
                indexPaths += [previous]
            }
            if let current = selectedIndexPath {
                indexPaths += [current]
            }
            if indexPaths.count > 0 {
            tableView.reloadRows(at: indexPaths, with: UITableViewRowAnimation.automatic)
            }
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == self.statsTableView {
            (cell as! CustomStatUpdaterTableViewCell).watchFrameChanges()
        }
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == self.statsTableView {
            (cell as! CustomStatUpdaterTableViewCell).ignoreFrameChanges()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.statsTableView {
            if indexPath == selectedIndexPath {
                return CustomStatUpdaterTableViewCell.expandedHeight
            }
            else {
                return CustomStatUpdaterTableViewCell.defaultHeight
            }
        }
        return 44
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.teamNamesArray.count
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return teamNamesArray[row]["Team"]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            self.teamsModeHomeTeam = self.teamNamesArray[row]["Team"]!
        }
        else  if component == 1 {
            self.teamsModeAwayTeam = self.teamNamesArray[row]["Team"]!
        }
        else {
        }
    }
}
