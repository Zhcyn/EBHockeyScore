import UIKit
class CustomRostersTableViewCell: UITableViewCell {
    @IBOutlet weak var playerNumberLabel: UILabel!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerPositionLabel: UILabel!
    @IBOutlet weak var playerYearLabel: UILabel!
    @IBOutlet weak var playerHometownLabel: UILabel!
    var playerHighSchoolLabel:String = ""
    var playerTeam:String!
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
    func setPlayerHometown(_ hometown:String) {
        self.playerHometownLabel.text = hometown
    }
    func setPlayerPosition(_ position:String) {
        self.playerPositionLabel.text = position
    }
    func setPlayerYear(_ year:String) {
        self.playerYearLabel.text = "" 
    }
    func setPlayerTeamLabel(_ team:String) {
        self.playerTeam = team
    }
    func setPlayerHighSchool(_ highschool:String) {
        self.playerHighSchoolLabel = highschool
    }
}
