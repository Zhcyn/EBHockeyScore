import UIKit
class FirstViewController: UIViewController {
    @IBOutlet weak var crownImage: UIImageView!
    @IBOutlet weak var statKingTitle: UILabel!
    @IBOutlet weak var appMotto: UILabel!
    @IBOutlet weak var createByLabel: UILabel!
    var initialLoginPassword:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkForInternetConnection()
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
    func showLoginAlert() {
        let myAlert:UIAlertController = UIAlertController(title: "Login", message: "Please enter your coaching credentials", preferredStyle: UIAlertControllerStyle.alert)
        let firstAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alertAction:UIAlertAction!) in
            NSLog("OK button clicked")
            let firstTextField:UITextField = myAlert.textFields![0] as UITextField
            NSLog(firstTextField.text!)
            if (firstTextField.text != self.initialLoginPassword ) {
                myAlert.message = "Invalid Password. Try Again."
                myAlert.textFields![0].text = ""
                self.present(myAlert, animated: true, completion: nil)
            }
            else {
            }
        })
        myAlert.addTextField(configurationHandler: {(textField:UITextField!) in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        })
        myAlert.addAction(firstAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    func retrieveInitialLoginPassword() {
        let url:URL = URL(string: "http://evanwolfapps.com/retrieveInitialLoginPassword.php")!
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: { (data, response, Error) -> Void in
            do {
                let dataArray:[AnyObject] = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [AnyObject]
                for data in dataArray {
                    let dictionary:[String:String] = data as! [String:String]
                    if dictionary["password"] != nil {
                        self.initialLoginPassword = dictionary["password"]!
                        print(self.initialLoginPassword)
                    }
                }
                DispatchQueue.main.async {
                    self.showLoginAlert()
                }
            }
            catch {
            }
        }) 
        task.resume()
    }
}
