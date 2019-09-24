import UIKit
class CustomLeaderboardTableViewCell: UITableViewCell {
    @IBOutlet weak var playerNumberLabel: UILabel!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var goalsLabel: UILabel!
    @IBOutlet weak var assistsLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var groundBallsLabel: UILabel!
    @IBOutlet weak var faceoffsLabel: UILabel!
    @IBOutlet weak var savesLabel: UILabel!
    var playerTeam:String = ""
    var playerPosition:String = ""
    var playerYear:String = ""
    var playerHometown:String = ""
    var playerHighSchool:String = ""
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setPlayerNumber(_ number:String) {
        self.playerNumberLabel.text = number
    }
    func setPlayerName(_ name:String) {
        self.playerNameLabel.text = name
    }
    func setPlayerPoints(_ points:String) {
        self.pointsLabel.text = points
    }
    func setPlayerGoalsLabel(_ goals:String) {
        self.goalsLabel.text = goals
    }
    func setPlayerAssistsLabel(_ assists:String) {
        self.assistsLabel.text = assists
    }
    func setPlayerTeamLabel(_ team:String) {
        self.playerTeam = team
    }
    func setPlayerPositionLabel(_ position:String) {
        self.playerPosition = position
    }
    func setPlayerYearLabel(_ year:String) {
        self.playerYear = year
    }
    func setPlayerHometownLabel(_ hometown:String) {
        self.playerHometown = hometown 
    }
    func setPlayerHighSchoolLabel(_ highschool:String) {
        self.playerHighSchool = highschool 
    }
    func setPlayerGroundBallsLabel(_ groundBalls:String) {
        self.groundBallsLabel.text = groundBalls
    }
    func setPlayerFaceoffsLabel(_ faceoffs:String) {
        self.faceoffsLabel.text = faceoffs
    }
    func setPlayerSavesLabel(_ saves:String) {
        self.savesLabel.text = saves 
    }
}
