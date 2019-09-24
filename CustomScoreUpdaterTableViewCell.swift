import UIKit
class CustomScoreUpdaterTableViewCell: UITableViewCell {
    @IBOutlet weak var homeTeamLabel: UILabel!
    @IBOutlet weak var awayTeamLabel: UILabel!
    @IBOutlet weak var homeScoreLabel: UILabel!
    @IBOutlet weak var awayScoreLabel: UILabel!
    @IBOutlet weak var incrementHomeGoalsButton: UIButton!
    @IBOutlet weak var decrementHomeGoalsButton: UIButton!
    @IBOutlet weak var incrementAwayGoalsButton: UIButton!
    @IBOutlet weak var decrementAwayGoalsButton: UIButton!
    @IBOutlet weak var updateScoreButton: UIButton!
    @IBOutlet weak var updateConfirmationGreenCheck: UIImageView!
    var homeGoalsToAdd:Int = 0
    var awayGoalsToAdd:Int = 0
    var gameNumberString:String!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if self.homeScoreLabel.text != "0" || self.awayScoreLabel.text != "0" {
            self.incrementHomeGoalsButton.isHidden = true
            self.decrementHomeGoalsButton.isHidden = true
            self.incrementAwayGoalsButton.isHidden = true
            self.decrementAwayGoalsButton.isHidden = true
        }
        self.updateScoreButton.isHidden = true
    }
    func shouldUpdateButtonBeHidden() {
        if self.homeGoalsToAdd > 0 || self.awayGoalsToAdd > 0 {
            self.updateScoreButton.isHidden = false
        }
        else {
            self.updateScoreButton.isHidden = true
        }
    }
    @IBAction func incrementHomeGoals(_ sender: UIButton) {
        self.homeGoalsToAdd += 1
        self.homeScoreLabel.text = String(homeGoalsToAdd)
        if homeGoalsToAdd > 0 || self.awayGoalsToAdd > 0 {
            self.homeScoreLabel.textColor = UIColor.red
            self.awayScoreLabel.textColor = UIColor.red
        }
        else {
            self.homeScoreLabel.textColor = UIColor.black
            self.awayScoreLabel.textColor = UIColor.black
        }
        self.shouldUpdateButtonBeHidden()
    }
    @IBAction func decrementHomeGoals(_ sender: UIButton) {
        self.homeGoalsToAdd -= 1
        if self.homeGoalsToAdd < 0 {
            self.homeGoalsToAdd = 0
        }
        self.homeScoreLabel.text = String(homeGoalsToAdd)
        if self.homeGoalsToAdd > 0 || self.awayGoalsToAdd > 0 {
            self.homeScoreLabel.textColor = UIColor.red
            self.awayScoreLabel.textColor = UIColor.red
        }
        else {
            self.homeScoreLabel.textColor = UIColor.black
            self.awayScoreLabel.textColor = UIColor.black
        }
        self.shouldUpdateButtonBeHidden()
    }
    @IBAction func incrementAwayGoals(_ sender: UIButton) {
        self.awayGoalsToAdd += 1
        self.awayScoreLabel.text = String(awayGoalsToAdd)
        if self.awayGoalsToAdd > 0 || self.homeGoalsToAdd > 0 {
            self.awayScoreLabel.textColor = UIColor.red
            self.homeScoreLabel.textColor = UIColor.red
        }
        else {
            self.awayScoreLabel.textColor = UIColor.black
            self.homeScoreLabel.textColor = UIColor.black
        }
        self.shouldUpdateButtonBeHidden()
    }
    @IBAction func decrementAwayGoals(_ sender: UIButton) {
        self.awayGoalsToAdd -= 1
        if self.awayGoalsToAdd < 0 {
            self.awayGoalsToAdd = 0
        }
        self.awayScoreLabel.text = String(awayGoalsToAdd)
        if self.awayGoalsToAdd > 0 || self.homeGoalsToAdd > 0 {
            self.awayScoreLabel.textColor = UIColor.red
            self.homeScoreLabel.textColor = UIColor.red
        }
        else {
            self.awayScoreLabel.textColor = UIColor.black
            self.homeScoreLabel.textColor = UIColor.black
        }
        self.shouldUpdateButtonBeHidden()
    }
    func setHomeTeam(_ home:String) {
        self.homeTeamLabel.text = home
    }
    func setAwayTeam(_ away:String) {
        self.awayTeamLabel.text = away
    }
    func setHomeScore(_ homeScore:String) {
        self.homeScoreLabel.text = homeScore
    }
    func setAwayScore(_ awayScore:String) {
        self.awayScoreLabel.text = awayScore
    }
    func setGameNum(_ GameNum:String) {
        self.gameNumberString = GameNum
    }
    func saveMessage() {
        do {
            let url:URL = URL(string: "http://evanwolfapps.com/updateGameScores.php")!
            var request:URLRequest = URLRequest(url: url)
            request.httpMethod = "POST"
            let dataDictionary:[String:String] = ["gameNumber" : self.gameNumberString, "homeScore" : self.homeScoreLabel.text!, "awayScore" : self.awayScoreLabel.text!]
            let data:Data = try JSONSerialization.data(withJSONObject: dataDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
            request.httpBody = data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: { (data, response, Error) -> Void in
                do {
                    let response:[String:String] = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:String]
                    if let result = response["result"] {
                        if result == "success" {
                            NSLog("Inserted")
                        }
                        else {
                            NSLog("Failed to insert")
                        }
                    }
                }
                catch {}
            }) 
            task.resume()
        }
        catch {}
        self.updateScoreButton.isHidden = true
        self.homeScoreLabel.textColor = UIColor.black
        self.awayScoreLabel.textColor = UIColor.black
        self.incrementHomeGoalsButton.isHidden = true
        self.decrementHomeGoalsButton.isHidden = true
        self.incrementAwayGoalsButton.isHidden = true
        self.decrementAwayGoalsButton.isHidden = true
    }
    @IBAction func updateScores(_ sender: UIButton) {
        self.saveMessage()
        UIView.animate(withDuration: 0.5, animations: {
            self.updateConfirmationGreenCheck.alpha = 1
        })
        let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(CustomScoreUpdaterTableViewCell.hideGreenCheck), userInfo: nil, repeats: false)
    }
    @objc func hideGreenCheck() {
        UIView.animate(withDuration: 0.5, animations: {
            self.updateConfirmationGreenCheck.alpha = 0
        })
    }
}
