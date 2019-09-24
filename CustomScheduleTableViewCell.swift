import UIKit
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
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}
class CustomScheduleTableViewCell: UITableViewCell {
    @IBOutlet weak var homeTeam: UILabel!
    @IBOutlet weak var homeScore: UILabel!
    @IBOutlet weak var awayTeam: UILabel!
    @IBOutlet weak var awayScore: UILabel!
    @IBOutlet weak var fieldLocation: UILabel!
    @IBOutlet weak var gameTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setHomeTeamLabel(_ home:String) {
        self.homeTeam.text = home
    }
    func setHomeScoreLabel(_ homeScore: String) {
        self.homeScore.text = homeScore
    }
    func setAwayTeamLabel(_ away:String) {
        self.awayTeam.text = away
    }
    func setAwayScoreLabel(_ awayScore:String) {
        self.awayScore.text = awayScore
    }
    func setFieldLocationLabel(_ field:String) {
        self.fieldLocation.text = field
    }
    func setGameTimeLabel(_ time:String) {
        self.gameTime.text = time
    }
    func boldWinningTeam() {
        let a:Int? = Int(self.homeScore.text!)
        let b:Int? = Int(self.awayScore.text!)
        if a > b {
            self.homeTeam.font = UIFont.boldSystemFont(ofSize: 15)
            self.homeScore.font = UIFont.boldSystemFont(ofSize: 15)
        }
        else  if b > a {
            self.awayTeam.font = UIFont.boldSystemFont(ofSize: 15)
            self.awayScore.font = UIFont.boldSystemFont(ofSize: 15)
        }
    }
}
