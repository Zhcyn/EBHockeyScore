import UIKit
class CustomStatUpdaterTableViewCell: UITableViewCell {
    @IBOutlet weak var playerNumber: UILabel!
    @IBOutlet weak var goalsLabel: UILabel!
    @IBOutlet weak var incrementGoalsButton: UIButton!
    @IBOutlet weak var decrementGoalsButton: UIButton!
    @IBOutlet weak var assistsLabel: UILabel!
    @IBOutlet weak var incrementAssistsLabel: UIButton!
    @IBOutlet weak var decrementAssistsButton: UIButton!
    @IBOutlet weak var groundBallsLabel: UILabel!
    @IBOutlet weak var incrementGoundBallsButton: UIButton!
    @IBOutlet weak var decrementGroundBallsButton: UIButton!
    @IBOutlet weak var faceoffsLabel: UILabel!
    @IBOutlet weak var incrementFaceoffsButton: UIButton!
    @IBOutlet weak var decrementFaceoffsButton: UIButton!
    @IBOutlet weak var savesLabel: UILabel!
    @IBOutlet weak var incrementSavesButton: UIButton!
    @IBOutlet weak var decrementSavesButton: UIButton!
    @IBOutlet weak var goalsHeader: UILabel!
    @IBOutlet weak var assistsHeader: UILabel!
    @IBOutlet weak var groundBallsHeader: UILabel!
    @IBOutlet weak var faceoffsHeader: UILabel!
    @IBOutlet weak var savesHeader: UILabel!
    var playerNameLabel:String!
    @IBOutlet weak var updatePointsButton: UIButton!
    @IBOutlet weak var updatedStatsCompleteCheck: UIImageView!
    var goalsToAdd:Int = 0
    var assistsToAdd:Int = 0
    var groundBallsToAdd:Int = 0
    var faceoffsToAdd:Int = 0
    var savesToAdd:Int = 0
    class var expandedHeight: CGFloat { get { return 175} }
    class var defaultHeight: CGFloat { get { return 44} }
    var frameAdded:Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func checkHeight() {
        self.incrementGoalsButton.isHidden = (frame.size.height < CustomStatUpdaterTableViewCell.defaultHeight)
        if frame.size.height < CustomStatUpdaterTableViewCell.expandedHeight {
            self.goalsLabel.alpha = 0
            self.incrementGoalsButton.alpha = 0
            self.decrementGoalsButton.alpha = 0
            self.assistsLabel.alpha = 0
            self.incrementAssistsLabel.alpha = 0
            self.decrementAssistsButton.alpha = 0
            self.groundBallsLabel.alpha = 0
            self.incrementGoundBallsButton.alpha = 0
            self.decrementGroundBallsButton.alpha = 0
            self.faceoffsLabel.alpha = 0
            self.incrementFaceoffsButton.alpha = 0
            self.decrementFaceoffsButton.alpha = 0
            self.savesLabel.alpha = 0
            self.incrementSavesButton.alpha = 0
            self.decrementSavesButton.alpha = 0
            self.goalsHeader.alpha = 0
            self.assistsHeader.alpha = 0
            self.groundBallsHeader.alpha = 0
            self.faceoffsHeader.alpha = 0
            self.savesHeader.alpha = 0
            self.updatePointsButton.alpha = 0
        }
        else {
            self.playerNumber.alpha = 1
            self.goalsLabel.alpha = 1
            self.incrementGoalsButton.alpha = 1
            self.decrementGoalsButton.alpha = 1
            self.assistsLabel.alpha = 1
            self.incrementAssistsLabel.alpha = 1
            self.decrementAssistsButton.alpha = 1
            self.groundBallsLabel.alpha = 1
            self.incrementGoundBallsButton.alpha = 1
            self.decrementGroundBallsButton.alpha = 1
            self.faceoffsLabel.alpha = 1
            self.incrementFaceoffsButton.alpha = 1
            self.decrementFaceoffsButton.alpha = 1
            self.savesLabel.alpha = 1
            self.incrementSavesButton.alpha = 1
            self.decrementSavesButton.alpha = 1
            self.goalsHeader.alpha = 1
            self.assistsHeader.alpha = 1
            self.groundBallsHeader.alpha = 1
            self.faceoffsHeader.alpha = 1
            self.savesHeader.alpha = 1
            self.updatePointsButton.alpha = 1
        }
    }
    func watchFrameChanges() {
        if (!frameAdded) {
            addObserver(self, forKeyPath: "frame", options: .new, context: nil)
            frameAdded = true
            checkHeight()
        }
    }
    func ignoreFrameChanges() {
        if (frameAdded) {
            removeObserver(self, forKeyPath: "frame")
            frameAdded = false
        }
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "frame" {
            checkHeight()
        }
    }
    func hideUpdateButton() {
        self.updatePointsButton.isHidden = true
    }
    func unhideUpdateButton() {
        self.updatePointsButton.isHidden = false
    }
    func setPlayerNumberLabel(_ number:String) {
        self.playerNumber.text = number
    }
    func setPlayerName(_ name:String) {
        self.playerNameLabel = name
    }
    func checkToHideUpdateButton() {
        if self.goalsLabel.text == "0" && self.assistsLabel.text == "0" && self.groundBallsLabel.text == "0" && self.faceoffsLabel.text == "0" && self.savesLabel.text == "0" {
            self.hideUpdateButton()
        }
        else {
            self.unhideUpdateButton()
        }
    }
    func checkToMakeLabelRed() {
        if self.goalsLabel.text != "0" {
            self.goalsLabel.textColor = UIColor.red
        }
        else {
            self.goalsLabel.textColor = UIColor.black
        }
        if self.assistsLabel.text != "0" {
            self.assistsLabel.textColor = UIColor.red
        }
        else {
            self.assistsLabel.textColor = UIColor.black
        }
        if self.groundBallsLabel.text != "0" {
            self.groundBallsLabel.textColor = UIColor.red
        }
        else {
            self.groundBallsLabel.textColor = UIColor.black
        }
        if self.faceoffsLabel.text != "0" {
            self.faceoffsLabel.textColor = UIColor.red
        }
        else {
            self.faceoffsLabel.textColor = UIColor.black
        }
        if self.savesLabel.text != "0" {
            self.savesLabel.textColor = UIColor.red
        }
        else {
            self.savesLabel.textColor = UIColor.black
        }
    }
    @IBAction func incrementGoals(_ sender: AnyObject) {
        self.goalsToAdd += 1
        self.goalsLabel.text = String(goalsToAdd)
        self.checkToMakeLabelRed()
        self.checkToHideUpdateButton()
    }
    @IBAction func decrementGoals(_ sender: UIButton) {
        self.goalsToAdd -= 1
        self.goalsLabel.text = String(goalsToAdd)
        self.checkToMakeLabelRed()
        self.checkToHideUpdateButton()
    }
    @IBAction func incrementAssists(_ sender: UIButton) {
        self.assistsToAdd += 1
        self.assistsLabel.text = String(assistsToAdd)
        self.checkToMakeLabelRed()
        self.checkToHideUpdateButton()
    }
    @IBAction func decrementAssists(_ sender: UIButton) {
        self.assistsToAdd -= 1
        self.assistsLabel.text = String(assistsToAdd)
        self.checkToMakeLabelRed()
        self.checkToHideUpdateButton()
    }
    @IBAction func incrementGroundBalls(_ sender: UIButton) {
        self.groundBallsToAdd += 1
        self.groundBallsLabel.text = String(groundBallsToAdd)
        self.checkToMakeLabelRed()
        self.checkToHideUpdateButton()
    }
    @IBAction func decrementGroundBalls(_ sender: UIButton) {
        self.groundBallsToAdd -= 1
        self.groundBallsLabel.text = String(groundBallsToAdd)
        self.checkToMakeLabelRed()
        self.checkToHideUpdateButton()
    }
    @IBAction func incrementFaceoffs(_ sender: UIButton) {
        self.faceoffsToAdd += 1
        self.faceoffsLabel.text = String(faceoffsToAdd)
        self.checkToMakeLabelRed()
        self.checkToHideUpdateButton()
    }
    @IBAction func decrementFaceoffs(_ sender: UIButton) {
        self.faceoffsToAdd -= 1
        self.faceoffsLabel.text = String(faceoffsToAdd)
        self.checkToMakeLabelRed()
        self.checkToHideUpdateButton()
    }
    @IBAction func incrementSaves(_ sender: UIButton) {
        self.savesToAdd += 1
        self.savesLabel.text = String(savesToAdd)
        self.checkToMakeLabelRed()
        self.checkToHideUpdateButton()
    }
    @IBAction func decrementSaves(_ sender: UIButton) {
        self.savesToAdd -= 1
        self.savesLabel.text = String(savesToAdd)
        self.checkToMakeLabelRed()
        self.checkToHideUpdateButton()
    }
    func setGoalsAndAssistsLabelsToZero() {
        self.goalsLabel.text = "0"
        self.assistsLabel.text = "0"
        self.groundBallsLabel.text = "0"
        self.faceoffsLabel.text = "0"
        self.savesLabel.text = "0"
        self.goalsToAdd = 0
        self.assistsToAdd = 0
        self.groundBallsToAdd = 0
        self.faceoffsToAdd = 0
        self.savesToAdd = 0
        self.goalsLabel.textColor = UIColor.black
        self.assistsLabel.textColor = UIColor.black
        self.groundBallsLabel.textColor = UIColor.black
        self.faceoffsLabel.textColor = UIColor.black
        self.savesLabel.textColor = UIColor.black
    }
    func saveMessage(_ textToSave:String) {
        do {
            let url:URL = URL(string: "http://evanwolfapps.com/updateStatistics.php")!
            var request:URLRequest = URLRequest(url: url)
            request.httpMethod = "POST"
            let dataDictionary:[String:String] = ["playerName" : self.playerNameLabel! , "goals" : self.goalsLabel.text!, "assists" : self.assistsLabel.text!, "groundBalls" : self.groundBallsLabel.text!, "faceoffs" : self.faceoffsLabel.text!, "saves" : self.savesLabel.text!]
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
        self.goalsLabel.text = "0"
        self.goalsToAdd = 0
        self.assistsLabel.text = "0"
        self.assistsToAdd = 0
        self.groundBallsLabel.text = "0"
        self.groundBallsToAdd = 0
        self.faceoffsLabel.text = "0"
        self.faceoffsToAdd = 0
        self.savesLabel.text = "0"
        self.savesToAdd = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.updatedStatsCompleteCheck.alpha = 1
        })
        let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(CustomStatUpdaterTableViewCell.hideGreenCheck), userInfo: nil, repeats: false)
        self.checkToMakeLabelRed()
        self.hideUpdateButton()
    }
    @IBAction func updatePoints(_ sender: UIButton) {
        self.saveMessage(self.goalsLabel.text!)
    }
    @objc func hideGreenCheck() {
        UIView.animate(withDuration: 0.5, animations: {
            self.updatedStatsCompleteCheck.alpha = 0
        })
    }
}
