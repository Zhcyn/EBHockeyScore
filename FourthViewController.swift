import UIKit
class FourthViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var gameScoresTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var refreshButton: UIButton!
    var scoresArray:[[String:String]] = [[String:String]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gameScoresTableView.allowsSelection = false
        self.gameScoresTableView.delegate = self
        self.gameScoresTableView.dataSource = self
        self.gameScoresTableView.register(UINib(nibName: "CustomScheduleTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomSubclassCell")
        self.retrieveByGames()
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
    func retrieveByGames() {
        self.activityIndicator.startAnimating()
        let url:URL = URL(string: "http://evanwolfapps.com/retrieveByGames.php")!
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: { (data, response, Error) -> Void in
            do {
                if let foundData = data {
                    let dataArray:[AnyObject]? = try JSONSerialization.jsonObject(with: foundData, options: JSONSerialization.ReadingOptions.mutableContainers) as! [AnyObject]
                    self.scoresArray.removeAll(keepingCapacity: false)
                    for data in dataArray! {
                        let dictionary:[String:String] = data as! [String:String]
                        if dictionary["HomeScore"] != nil {
                            self.scoresArray.append(dictionary)
                        }
                    }
                    DispatchQueue.main.async {
                        self.gameScoresTableView.reloadData()
                        self.activityIndicator.stopAnimating()
                    }
                }
                else {
                    self.checkForInternetConnection()
                    self.activityIndicator.stopAnimating()
                }
            }
            catch {
            }
        }) 
        task.resume()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CustomScheduleTableViewCell = self.gameScoresTableView.dequeueReusableCell(withIdentifier: "CustomSubclassCell") as! CustomScheduleTableViewCell
        cell.setHomeTeamLabel(self.scoresArray[indexPath.row]["HomeTeam"]!)
        cell.setHomeScoreLabel(self.scoresArray[indexPath.row]["HomeScore"]!)
        cell.setAwayTeamLabel(self.scoresArray[indexPath.row]["AwayTeam"]!)
        cell.setAwayScoreLabel(self.scoresArray[indexPath.row]["AwayScore"]!)
        cell.setFieldLocationLabel(self.scoresArray[indexPath.row]["Field"]!)
        cell.setGameTimeLabel(self.scoresArray[indexPath.row]["Time"]!) 
        cell.boldWinningTeam()
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.scoresArray.count
    }
    @IBAction func refreshGameScores(_ sender: UIButton) {
        self.retrieveByGames()
    }
}
