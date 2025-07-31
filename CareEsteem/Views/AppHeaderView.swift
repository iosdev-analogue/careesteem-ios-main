
import UIKit

class AppHeaderView: UIView {
    let kCONTENT_XIB_NAME = "AppHeaderView"
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var btnNotification: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var imgProfile: AGImageView!
    lazy var badgeLabel: UILabel = {
      let label = UILabel(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
      label.translatesAutoresizingMaskIntoConstraints = false
      label.layer.cornerRadius = label.bounds.size.height / 2
      label.textAlignment = .center
      label.layer.masksToBounds = true
      label.textColor = .white
      label.font = label.font.withSize(12)
      label.backgroundColor = .systemRed
      return label
    }()
    @IBInspectable var hideBackButton: Bool = true {
            didSet {
                self.btnBack.isHidden = hideBackButton
            }
        }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
  
    func showBadge(count: Int) {
      badgeLabel.text = "\(count)"
      btnNotification.addSubview(badgeLabel)
      let constraints = [
        badgeLabel.leftAnchor.constraint(equalTo: btnNotification.centerXAnchor, constant: -6),
        badgeLabel.topAnchor.constraint(equalTo: btnNotification.topAnchor, constant: 5),
        badgeLabel.widthAnchor.constraint(equalToConstant: 20),
        badgeLabel.heightAnchor.constraint(equalToConstant: 20)
      ]
      NSLayoutConstraint.activate(constraints)
    }
    @objc func onDidReceiveNotification(_ notification:Notification) {
        if let count: Int = notification.userInfo?["count"] as? Int, count > 0 {
            showBadge(count: count)
        }
    }
    
    func commonInit() {
        NotificationCenter.default.addObserver(self,
                                                   selector: #selector(onDidReceiveNotification(_:)),
                                                   name: .customNotification,
                                                   object: nil)

        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        contentView.fixInView(self)
        if notificationCount != 0 {
            showBadge(count: notificationCount)
        }
        print("photo :- ",UserDetails.shared.profileModel?.profilePhotoName ?? "")
        
        if let photo = UserDetails.shared.profileModel?.profilePhotoName {
            if photo == "" {
                // Get initials
                self.imgProfile.isHidden = true
                     let fullName = UserDetails.shared.profileModel?.name ?? ""
                     let initials = getInitials(from: fullName)
                     btnProfile.setTitle(initials, for: .normal)
                print(" Button title set to initials: \(initials)")
                     imgProfile.image = Photo().imageWith(name: fullName)
                      btnProfile.setTitleColor(.white, for: .normal)
                       btnProfile.backgroundColor =  UIColor(named: "appGreen")
                       btnProfile.layer.cornerRadius = 20
                       btnProfile.clipsToBounds = true
            } else {
                // Photo exists: Show image
                btnProfile.setTitle("", for: .normal)
                self.imgProfile.isHidden = false
                self.imgProfile.sd_setImage(with: URL(string: photo), placeholderImage: UIImage(named: "logo1"))
            }
        } else {
            // No photo key: fallback to initials
            let fullName = UserDetails.shared.profileModel?.name ?? ""
            let initials = getInitials(from: fullName)

            btnProfile.setTitle(initials, for: .normal)
            print("🟡 Button title set to initials (fallback): \(initials)")

            btnProfile.setTitleColor(.white, for: .normal)
            btnProfile.backgroundColor = UIColor(named: "appGreen")
            btnProfile.layer.cornerRadius = 20
            btnProfile.clipsToBounds = true
            imgProfile.image = Photo().imageWith(name: fullName)
        }
    }
    // first letter of first name and first letter of last name function

    func getInitials(from fullName: String) -> String {
        let nameComponents = fullName.components(separatedBy: " ").filter { !$0.isEmpty }

        guard let first = nameComponents.first?.first else { return "" }
        let last = nameComponents.count > 1 ? nameComponents.last?.first : nil

        let initials = "\(first)\(last ?? Character(""))"
        return initials.uppercased()
    }

    @IBAction func btnProfileAction(_ sender:UIButton){
        if AppDelegate.shared.topViewController() is ProfileViewController {
            return
        }
        let vc = Storyboard.Main.instantiateViewController(withViewClass: ProfileViewController.self)
        AppDelegate.shared.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnNotificationAction(_ sender:UIButton){
        if !(AppDelegate.shared.topViewController() is NotificationViewController) {
            let vc = Storyboard.Main.instantiateViewController(withViewClass: NotificationViewController.self)
            AppDelegate.shared.topViewController()?.navigationController?.pushViewController(vc,
                                                                                             animated: true)
        }
    }
    @IBAction func btnBackAction(_ sender:UIButton){
        AppDelegate.shared.topViewController()?.navigationController?.popViewController(animated: true)
    }
}
extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}

extension Notification.Name {
    static let customNotification = Notification.Name("com.example.customNotification")
}

class Photo {
    func imageWith(name: String?) -> UIImage? {
         let frame = CGRect(x: 0, y: 0, width: 50, height: 50)
         let nameLabel = UILabel(frame: frame)
         nameLabel.textAlignment = .center
         nameLabel.backgroundColor = UIColor(named: "appGreen")
         nameLabel.textColor = .white
         nameLabel.font = UIFont.RobotoSlabFont(size: 20, weight: .Bold)
         var initials = ""
         if let initialsArray = name?.components(separatedBy: " ") {
             if let firstWord = initialsArray.first {
                 if let firstLetter = firstWord.first {
                     initials += String(firstLetter).capitalized }
             }
             if initialsArray.count > 1, let lastWord = initialsArray.last {
                 if let lastLetter = lastWord.first { initials += String(lastLetter).capitalized
                 }
             }
         } else {
             return nil
         }
         nameLabel.text = initials
         UIGraphicsBeginImageContext(frame.size)
         if let currentContext = UIGraphicsGetCurrentContext() {
             nameLabel.layer.render(in: currentContext)
             let nameImage = UIGraphicsGetImageFromCurrentImageContext()
             return nameImage
         }
         return nil
     }
}
