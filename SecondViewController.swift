import UIKit
class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var numberHeaderLabel: UILabel!
    @IBOutlet weak var nameHeaderLabel: UILabel!
    @IBOutlet weak var goalsHeaderLabel: UILabel!
    @IBOutlet weak var assistsHeaderLabel: UILabel!
    @IBOutlet weak var pointsHeaderLabel: UILabel!
    @IBOutlet weak var groundBallsHeaderLabel: UILabel!
    @IBOutlet weak var faceoffsHeaderLabel: UILabel!
    @IBOutlet weak var savesHeaderLabel: UILabel!
    @IBOutlet weak var refreshLeaderboardButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var playerInfoView: UIView!
    @IBOutlet weak var playerInfoViewNameLabel: UILabel!
    @IBOutlet weak var playerInfoViewNumberLabel: UILabel!
    @IBOutlet weak var playerInfoViewTeamLabel: UILabel!
    @IBOutlet weak var playerInfoViewPositionLabel: UILabel!
    @IBOutlet weak var playerInfoViewYearLabel: UILabel!
    @IBOutlet weak var playerInfoViewHometownLabel: UILabel!
    @IBOutlet weak var playerInfoViewHighSchoolLabel: UILabel!
    @IBOutlet weak var closePlayerInfoViewButton: UIButton!
    @IBOutlet weak var sortByView: UIView!
    @IBOutlet weak var sortByPickerView: UIPickerView!
    let statTypesArray:[String] = ["Points", "Goals", "Assists", "Ground Balls", "Face Offs", "Saves", "Player Number", "Player Name"]
    var playerStatsArray:[[String:String]] = [[String:String]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.sortByPickerView.delegate = self
        self.sortByPickerView.dataSource = self
        self.playerInfoView.alpha = 0
        self.tableView.register(UINib(nibName: "CustomLeaderboardTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomSubclassCell")
        self.retrieveBySpecifiedCategory("Points", order: "DESC")
        refreshLeaderboardButton.isHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
         self.retrieveBySpecifiedCategory("Points", order: "DESC")
    }
    func checkForInternetConnection() {
        let reachabilityTest:Reachability = Reachability()
        if reachabilityTest.isConnectedToNetwork() {
            print("Internet Connected OK")
        }
        else {
            print("Internet Connection Failed")
            let alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    func retrieveBySpecifiedCategory(_ category:String, order:String) {
        self.activityIndicator.startAnimating()
        self.setLeaderboardHeaderColors(category) 
        do {
            let url:URL = URL(string: "http://evanwolfapps.com/retrieveBySpecifiedCategory.php")!
            var request:URLRequest = URLRequest(url: url)
            request.httpMethod = "POST"
            let dataDictionary:[String:String] = ["category" : category, "order" : order]
            let data:Data = try JSONSerialization.data(withJSONObject: dataDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
            request.httpBody = data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: { (data, response, Error) -> Void in
                do {
                    let response:[AnyObject] = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [AnyObject]
                    self.playerStatsArray.removeAll(keepingCapacity: false)
                    for player in response {
                        let dictionary:[String:String] = player as! [String:String]
                        if dictionary["PlayerName"] != nil {
                            self.playerStatsArray.append(dictionary)
                        }
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.activityIndicator.stopAnimating()
                    }
                }
                catch {}
            }) 
            task.resume()
        }
        catch {}
    }
    func setLeaderboardHeaderColors(_ category:String) {
        self.pointsHeaderLabel.textColor = UIColor.white
        self.goalsHeaderLabel.textColor = UIColor.white
        self.assistsHeaderLabel.textColor = UIColor.white
        self.nameHeaderLabel.textColor = UIColor.white
        self.numberHeaderLabel.textColor = UIColor.white
        self.groundBallsHeaderLabel.textColor = UIColor.white
        self.faceoffsHeaderLabel.textColor = UIColor.white
        self.savesHeaderLabel.textColor = UIColor.white
        if category == "Points" {
            self.pointsHeaderLabel.textColor = UIColor.red
        }
        else if category == "Goals" {
            self.goalsHeaderLabel.textColor = UIColor.red
        }
        else if category == "Assists" {
            self.assistsHeaderLabel.textColor = UIColor.red
        }
        else if category == "groundBalls" {
            self.groundBallsHeaderLabel.textColor = UIColor.red
        }         
        else if category == "faceoffs" {
            self.faceoffsHeaderLabel.textColor = UIColor.red
        }
        else if category == "saves" {
            self.savesHeaderLabel.textColor = UIColor.red
        }
        else if category == "playerNumber" {
            self.numberHeaderLabel.textColor = UIColor.red
        }
        else {
            self.nameHeaderLabel.textColor = UIColor.red
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CustomLeaderboardTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "CustomSubclassCell") as! CustomLeaderboardTableViewCell
        cell.setPlayerNumber(self.playerStatsArray[indexPath.row]["PlayerNumber"]!)
        cell.setPlayerName(self.playerStatsArray[indexPath.row]["PlayerName"]!)
        cell.setPlayerPoints(self.playerStatsArray[indexPath.row]["Points"]!)
        cell.setPlayerGoalsLabel(self.playerStatsArray[indexPath.row]["Goals"]!)
        cell.setPlayerAssistsLabel(self.playerStatsArray[indexPath.row]["Assists"]!)
        cell.setPlayerGroundBallsLabel(self.playerStatsArray[indexPath.row]["groundBalls"]!)
        cell.setPlayerFaceoffsLabel(self.playerStatsArray[indexPath.row]["faceoffs"]!)
        cell.setPlayerSavesLabel(self.playerStatsArray[indexPath.row]["saves"]!)
        cell.setPlayerTeamLabel(self.playerStatsArray[indexPath.row]["Team"]!)
        cell.setPlayerPositionLabel(self.playerStatsArray[indexPath.row]["Position"]!)
        cell.setPlayerYearLabel(self.playerStatsArray[indexPath.row]["Year"]!)
        cell.setPlayerHometownLabel(self.playerStatsArray[indexPath.row]["Hometown"]!)
        cell.setPlayerHighSchoolLabel(self.playerStatsArray[indexPath.row]["HighSchool"]!)
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.playerStatsArray.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.playerInfoView.alpha == 1 {
            self.hidePlayerInfoView()
            return
        }
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as! CustomLeaderboardTableViewCell
        self.setPlayerInfoForPopupView(currentCell)
    }
    @IBAction func refreshLeaderboard(_ sender: UIButton) {
        if self.goalsHeaderLabel.textColor == UIColor.red {
            self.retrieveBySpecifiedCategory("Goals", order: "DESC")
        }
        else if self.assistsHeaderLabel.textColor == UIColor.red {
            self.retrieveBySpecifiedCategory("Assists", order: "DESC")
        }
        else if self.groundBallsHeaderLabel.textColor == UIColor.red {
            self.retrieveBySpecifiedCategory("groundBalls", order: "DESC")
        }
        else if self.faceoffsHeaderLabel.textColor == UIColor.red {
            self.retrieveBySpecifiedCategory("faceoffs", order: "DESC")
        }
        else if self.savesHeaderLabel.textColor == UIColor.red {
            self.retrieveBySpecifiedCategory("saves", order: "DESC")
        }
        else if self.numberHeaderLabel.textColor == UIColor.red {
            self.retrieveBySpecifiedCategory("playerNumber", order: "ASC")
        }
        else if self.nameHeaderLabel.textColor == UIColor.red {
            self.retrieveBySpecifiedCategory("playerName", order: "ASC")
        }
        else {
            self.retrieveBySpecifiedCategory("Points", order: "DESC")
        }
    }
    func setPlayerInfoForPopupView(_ cell:CustomLeaderboardTableViewCell) {
        self.playerInfoViewNameLabel.text = cell.playerNameLabel.text
        self.playerInfoViewNumberLabel.text = "#" + cell.playerNumberLabel.text!
        self.playerInfoViewTeamLabel.text = cell.playerTeam
        self.playerInfoViewPositionLabel.text = cell.playerPosition
        self.playerInfoViewYearLabel.text = cell.playerYear
        self.playerInfoViewHometownLabel.text = cell.playerHometown
        self.playerInfoViewHighSchoolLabel.text = cell.playerHighSchool
        self.showPlayerInfoView()
    }
    func showPlayerInfoView() {
        UIView.animate(withDuration: 0.5, animations: {
                self.playerInfoView.alpha = 1
                self.tableView.alpha = 0.2})
    }
    func hidePlayerInfoView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.playerInfoView.alpha = 0
            self.tableView.alpha = 1})
    }
    @IBAction func closePlayerInfoView(_ sender: UIButton) {
        self.hidePlayerInfoView()
    }
    @IBAction func closeSortByView(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {
            self.sortByView.alpha = 0
        })
    }
    @IBAction func showSortByView(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {
            self.sortByView.alpha = 1
        })
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 8 
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return statTypesArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if statTypesArray[row] == "Points" {
            self.retrieveBySpecifiedCategory("Points", order: "DESC")
        }
        else if statTypesArray[row] == "Goals" {
            self.retrieveBySpecifiedCategory("Goals", order: "DESC")
        }
        else if statTypesArray[row] == "Assists" {
            self.retrieveBySpecifiedCategory("Assists", order: "DESC")
        }
        else if statTypesArray[row] == "Ground Balls" {
            self.retrieveBySpecifiedCategory("groundBalls", order: "DESC")
        }
        else if statTypesArray[row] == "Face Offs" {
            self.retrieveBySpecifiedCategory("faceoffs", order: "DESC")
        }
        else if statTypesArray[row] == "Saves" {
            self.retrieveBySpecifiedCategory("saves", order: "DESC")
        }
        else if statTypesArray[row] == "Player Number" {
            self.retrieveBySpecifiedCategory("playerNumber", order: "ASC")
        }
        else {
            self.retrieveBySpecifiedCategory("playerName", order: "ASC")
        }
    }
}
