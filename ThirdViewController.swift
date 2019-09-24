import UIKit
import Foundation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}
class ThirdViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource  {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var rostersTableView: UITableView!
    @IBOutlet weak var downArrowButton: UIButton!
    @IBOutlet weak var selectTeamPickerView: UIPickerView!
    @IBOutlet weak var selectTeamView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var playerInfoView: UIView!
    @IBOutlet weak var playerInfoViewNameLabel: UILabel!
    @IBOutlet weak var playerInfoViewNumberLabel: UILabel!
    @IBOutlet weak var playerInfoViewHometownLabel: UILabel!
    @IBOutlet weak var playerInfoViewTeamLabel: UILabel!
    @IBOutlet weak var playerInfoViewPositionLabel: UILabel!
    @IBOutlet weak var playerInfoViewYearLabel: UILabel!
    @IBOutlet weak var playerInfoViewHighSchoolLabel: UILabel!
    @IBOutlet weak var closePlayerInfoViewButton: UIButton!
    @IBOutlet weak var currentTeamView: UIView!
    @IBOutlet weak var currentTeamLabel: UILabel!
    var teamNamesArray:[[String:String]] = [[String:String]]()
    var rostersArray:[[String:String]] = [[String:String]]()
    var playersToFollow:[[String:String]] = [[String:String]]()
    var followedPlayersCurrentStatsForComparison:[String:String] = ["goals" : "", "assists" : "", "saves" : "", "groundballs" : "", "faceoffs" : ""]
    var playerUpdateMessages:String = ""
    @IBOutlet weak var followPlayerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rostersTableView.delegate = self
        self.rostersTableView.dataSource = self
        self.selectTeamPickerView.delegate = self
        self.selectTeamPickerView.dataSource = self
        self.rostersTableView.register(UINib(nibName: "CustomRostersTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomSubclassCell")
        self.playerInfoView.alpha = 0
        self.retrieveTeamNames()
        var checkFollowedPlayersInterval = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(ThirdViewController.checkFollowedPlayers), userInfo: nil, repeats: true)
        self.followPlayerButton.layer.cornerRadius = 6
        self.followPlayerButton.layer.borderWidth = 1
        self.followPlayerButton.layer.borderColor = UIColor.darkGray.cgColor
        self.followPlayerButton.backgroundColor = UIColor.clear
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    func retrieveTeamNames() {
        self.activityIndicator.startAnimating()
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
                        self.selectTeamPickerView.reloadAllComponents()
                        self.currentTeamLabel.text = self.teamNamesArray[0]["Team"]
                        self.retrieveIndividualRoster(self.currentTeamLabel.text!) 
                        self.activityIndicator.stopAnimating()
                    }
                }
                else {
                    print("no data found")
                    self.checkForInternetConnection()
                    self.activityIndicator.stopAnimating()
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
                    self.rostersArray.removeAll(keepingCapacity: false)
                    for player in response {
                        let dictionary:[String:String] = player as! [String:String]
                        if dictionary["PlayerName"] != nil {
                            self.rostersArray.append(dictionary)
                        }
                    }
                    DispatchQueue.main.async {
                        self.rostersTableView.reloadData()
                        self.activityIndicator.stopAnimating()
                        self.currentTeamLabel.text = teamName 
                    }
                }
                catch {}
            }) 
            task.resume()
        }
        catch {}
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CustomRostersTableViewCell = self.rostersTableView.dequeueReusableCell(withIdentifier: "CustomSubclassCell") as! CustomRostersTableViewCell
        cell.setPlayerNumber(self.rostersArray[indexPath.row]["PlayerNumber"]!)
        cell.setPlayerName(self.rostersArray[indexPath.row]["PlayerName"]!)
        cell.setPlayerHometown(self.rostersArray[indexPath.row]["Hometown"]!)
        cell.setPlayerPosition(self.rostersArray[indexPath.row]["Position"]!)
        cell.setPlayerYear(self.rostersArray[indexPath.row]["Year"]!)
        cell.setPlayerTeamLabel(self.rostersArray[indexPath.row]["Team"]!)
        cell.setPlayerHighSchool(self.rostersArray[indexPath.row]["HighSchool"]!)
        return cell
    }
    @IBAction func revealSelectTeamsView(_ sender: UIButton) {
            UIView.animate(withDuration: 0.5, animations: {
                self.selectTeamView.alpha = 1
            })
    }
    func setPlayerInfoForPopupView(_ cell:CustomRostersTableViewCell) {
        self.playerInfoViewNameLabel.text = cell.playerNameLabel.text
        self.playerInfoViewNumberLabel.text = "#" + cell.playerNumberLabel.text!
        self.playerInfoViewTeamLabel.text = cell.playerTeam
        self.playerInfoViewPositionLabel.text = cell.playerPositionLabel.text
        self.playerInfoViewYearLabel.text = cell.playerYearLabel.text
        self.playerInfoViewHometownLabel.text = cell.playerHometownLabel.text
        self.playerInfoViewHighSchoolLabel.text = cell.playerHighSchoolLabel 
        self.showPlayerInfoView()
    }
    func showPlayerInfoView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.playerInfoView.alpha = 1
            self.rostersTableView.alpha = 0.2
            self.currentTeamView.alpha = 0.2})
    }
    func hidePlayerInfoView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.playerInfoView.alpha = 0
            self.rostersTableView.alpha = 1
            self.currentTeamView.alpha = 1})
    }
    @IBAction func closePlayerInfoView(_ sender: UIButton) {
        self.hidePlayerInfoView()
    }
    @IBAction func closeSelectTeamsView(_ sender: UIButton) {
        self.retrieveIndividualRoster(self.currentTeamLabel.text!)
        UIView.animate(withDuration: 0.5, animations: {
         self.selectTeamView.alpha = 0
        self.rostersTableView.alpha = 1
        self.currentTeamView.alpha = 1})
    }
    func showFollowingPlayerConfirmationAlert(_ playerName:String) {
        let message:String = "You will receive an alert each time this player records a new statistic! (followed players will reset each time you quit out of the app)"
        let myAlert:UIAlertController = UIAlertController(title: "You are now following " + self.playerInfoViewNameLabel.text! + "!", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let firstAction:UIAlertAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: { (alertAction:UIAlertAction!) in
            NSLog("OK button clicked")
        })
        myAlert.addAction(firstAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    @IBAction func followPlayer(_ sender: UIButton) {
        if (self.followPlayerButton.titleLabel!.text == "Follow Player") {
            self.followPlayerButton.setTitle("Unfollow Player", for: UIControlState())
            self.followPlayerButton.backgroundColor = UIColor.green
            self.followPlayerButton.setTitleColor(UIColor.black, for: UIControlState())
            self.showFollowingPlayerConfirmationAlert(self.playerInfoViewNameLabel.text!)
            var followedPlayerIdNumber:Int!
            var isFollowing:Bool = false
            if self.playersToFollow.isEmpty { 
                followedPlayerIdNumber = 0
                self.playersToFollow.append(["playerName" : self.playerInfoViewNameLabel.text!, "goals" : "0", "assists" : "0", "saves" : "0", "faceoffs" : "0", "groundballs" : "0"])
                self.retrieveFollowedPlayersStats(self.playerInfoViewNameLabel.text!, playerID: followedPlayerIdNumber)
            }
            else { 
                for player in self.playersToFollow {
                    if player["playerName"] == self.playerInfoViewNameLabel.text { 
                        isFollowing = true
                        break
                }
            }
            if (isFollowing == false) { 
                followedPlayerIdNumber = self.playersToFollow.count
                self.playersToFollow.append(["playerName" : self.playerInfoViewNameLabel.text!, "goals" : "0", "assists" : "0", "saves" : "0", "faceoffs" : "0", "groundballs" : "0"])
                self.retrieveFollowedPlayersStats(self.playerInfoViewNameLabel.text!, playerID: followedPlayerIdNumber)
                }
            }
        }
        else {
            for i in 0 ..< self.playersToFollow.count {
                if (self.playersToFollow[i]["playerName"] == self.playerInfoViewNameLabel.text) {
                    self.playersToFollow.remove(at: i)
                    break
                }
            }
            self.followPlayerButton.setTitle("Follow Player", for: UIControlState())
            self.followPlayerButton.layer.borderColor = UIColor.darkGray.cgColor
            self.followPlayerButton.backgroundColor = UIColor.clear
        }
    }
    func retrieveFollowedPlayersStats(_ playerName:String, playerID:Int) {
        do {
            let url:URL = URL(string: "http://evanwolfapps.com/retrieveFollowedPlayersStats.php")!
            var request:URLRequest = URLRequest(url: url)
            request.httpMethod = "POST"
            let dataDictionary:[String:String] = ["playerName" : playerName]
            let data:Data = try JSONSerialization.data(withJSONObject: dataDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
            request.httpBody = data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: { (data, response, Error) -> Void in
                do {
                    let response:[AnyObject] = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [AnyObject]
                    for player in response {
                        let dictionary:[String:String] = player as! [String:String]
                        if dictionary["PlayerName"] != nil {
                            self.playersToFollow[playerID]["goals"] = dictionary["Goals"]
                            self.playersToFollow[playerID]["assists"] = dictionary["Assists"]
                            self.playersToFollow[playerID]["groundballs"] = dictionary["groundBalls"]
                            self.playersToFollow[playerID]["saves"] = dictionary["saves"]
                            self.playersToFollow[playerID]["faceoffs"] = dictionary["faceoffs"]
                        }
                    }
                    DispatchQueue.main.async {
                    }
                }
                catch {}
            }) 
            task.resume()
        }
        catch {}
    }
    func retrieveFollowedPlayersCurrentStatsForComparison(_ playerName:String, playerID:Int) {
        do {
            let url:URL = URL(string: "http://evanwolfapps.com/retrieveFollowedPlayersStats.php")!
            var request:URLRequest = URLRequest(url: url)
            request.httpMethod = "POST"
            let dataDictionary:[String:String] = ["playerName" : playerName]
            let data:Data = try JSONSerialization.data(withJSONObject: dataDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
            request.httpBody = data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: { (data, response, Error) -> Void in
                do {
                    let response:[AnyObject] = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [AnyObject]
                    for player in response {
                        let dictionary:[String:String] = player as! [String:String]
                        if dictionary["PlayerName"] != nil {
                            self.followedPlayersCurrentStatsForComparison["goals"] = dictionary["Goals"]
                            self.followedPlayersCurrentStatsForComparison["assists"] = dictionary["Assists"]
                            self.followedPlayersCurrentStatsForComparison["saves"] = dictionary["saves"]
                            self.followedPlayersCurrentStatsForComparison["groundballs"] = dictionary["groundBalls"]
                            self.followedPlayersCurrentStatsForComparison["faceoffs"] = dictionary["faceoffs"]
                            self.compareCurrentAndUpdatedPlayerStats(playerName, playerID: playerID)
                        }
                    }
                    DispatchQueue.main.async {
                    }
                }
                catch {}
            }) 
            task.resume()
        }
        catch {}
    }
    @objc func checkFollowedPlayers() {
        self.playerUpdateMessages = ""
        for i in 0 ..< self.playersToFollow.count {
            self.retrieveFollowedPlayersCurrentStatsForComparison(playersToFollow[i]["playerName"]!, playerID: i)
        }
    }
    func compareCurrentAndUpdatedPlayerStats(_ playerName:String, playerID:Int) {
        if self.playersToFollow[playerID]["goals"] < self.followedPlayersCurrentStatsForComparison["goals"] {
            self.playersToFollow[playerID]["goals"] = self.followedPlayersCurrentStatsForComparison["goals"]
            self.playerUpdateMessages += playerName + " recorded a goal\n"
        }
        if self.playersToFollow[playerID]["assists"] < self.followedPlayersCurrentStatsForComparison["assists"] {
            self.playersToFollow[playerID]["assists"] = self.followedPlayersCurrentStatsForComparison["assists"]
            self.playerUpdateMessages += playerName + " recorded an assist\n"
        }
        if self.playersToFollow[playerID]["saves"] < self.followedPlayersCurrentStatsForComparison["saves"] {
            self.playersToFollow[playerID]["saves"] = self.followedPlayersCurrentStatsForComparison["saves"]
            self.playerUpdateMessages += playerName + " recorded a save\n"
        }
        if self.playersToFollow[playerID]["groundballs"] < self.followedPlayersCurrentStatsForComparison["groundballs"] {
            self.playersToFollow[playerID]["groundballs"] = self.followedPlayersCurrentStatsForComparison["groundballs"]
            self.playerUpdateMessages += playerName + " recorded a groundball\n"
        }
        if self.playersToFollow[playerID]["faceoffs"] < self.followedPlayersCurrentStatsForComparison["faceoffs"] {
            self.playersToFollow[playerID]["faceoffs"] = self.followedPlayersCurrentStatsForComparison["faceoffs"]
            self.playerUpdateMessages += playerName + " recorded a faceoff\n"
        }
        print(self.playerUpdateMessages)
        if self.playerUpdateMessages != "" {
            self.displayFollowedPlayerUpdateAlert()
        }
    }
    func displayFollowedPlayerUpdateAlert() {
        let myAlert:UIAlertController = UIAlertController(title: "Player Update", message: self.playerUpdateMessages, preferredStyle: UIAlertControllerStyle.alert)
        let firstAction:UIAlertAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: { (alertAction:UIAlertAction!) in
            NSLog("OK button clicked")
        })
        myAlert.addAction(firstAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rostersArray.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.playerInfoView.alpha == 1 {
            self.hidePlayerInfoView()
            return
        }
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as! CustomRostersTableViewCell
        self.setPlayerInfoForPopupView(currentCell)
        for player in self.playersToFollow {
            if (player["playerName"] == self.playerInfoViewNameLabel.text) {
                self.followPlayerButton.setTitle("Unfollow Player", for: UIControlState())
                self.followPlayerButton.backgroundColor = UIColor.green
                break
            }
            self.followPlayerButton.setTitle("Follow Player", for: UIControlState())
            self.followPlayerButton.backgroundColor = UIColor.clear
        }
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.teamNamesArray.count
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return teamNamesArray[row]["Team"]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.currentTeamLabel.text = self.teamNamesArray[row]["Team"]!
    }
}
