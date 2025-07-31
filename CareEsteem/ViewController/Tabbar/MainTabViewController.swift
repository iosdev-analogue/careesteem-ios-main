//
//  MainTabViewController.swift
//  careesteem
//
//  Created by Gaurav Gudaliya on 07/03/25.
//

import UIKit
let customTransitioningDelegate = CenterTransitioningDelegate()

class MainTabViewController:UITabBarController,UITabBarControllerDelegate {
    var selectedIndex1:Int = 0
     var loaderView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loaderView = UIImageView(frame: CGRect(x: 0, y: 0, width: Int(self.view.frame.width), height: Int(self.view.frame.height)))
        let imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 350, height: 350))
        loaderView.backgroundColor = UIColor(named: "appGreen")
        let imageData = try! Data(contentsOf: Bundle.main.url(forResource: "animation_fadeSmooth", withExtension: "gif")!)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage.sd_image(withGIFData: imageData)
        imageView.center = loaderView.center
//        imageView.image = UIImage(named: "preLoaderIcon")
        loaderView.addSubview(imageView)
        self.view.addSubview(loaderView)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {[weak self] in
            self?.getProfile_APICall()
        })
    }
    func setupDatabar(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {[weak self] in
            self?.loaderView.removeFromSuperview()
        })
        let vc1 = Storyboard.Visits.instantiateViewController(withViewClass: VisitsViewController.self)
        let vc2 = Storyboard.Clients.instantiateViewController(withViewClass: ClientsViewController.self)
        let vc3 = Storyboard.Alerts.instantiateViewController(withViewClass: AlertsViewController.self)
        
        // Embed each view controller in a UINavigationController
        let nav1 = UINavigationController(rootViewController: vc1)
        nav1.setupBlackTintColor()
        let nav2 = UINavigationController(rootViewController: vc2)
        nav2.setupBlackTintColor()
        let nav3 = UINavigationController(rootViewController: vc3)
        nav3.setupBlackTintColor()
        
        // Set the tab bar items
        setupTabBarItems(vc1: vc1, vc2: vc2, vc3: vc3)

        // Add view controllers to the tab bar controller
        viewControllers = [nav1, nav2, nav3]

        self.selectedIndex = self.selectedIndex1
        // Tab bar appearance customization
        setupTabBarAppearance()
    }
    private func setupTabBarItems(vc1: VisitsViewController, vc2: ClientsViewController, vc3: AlertsViewController) {
        vc1.tabBarItem = UITabBarItem(
            title: "Visits",
            image: UIImage(named: "visits")?.withRenderingMode(.alwaysTemplate),
            selectedImage: UIImage(named: "visits")?.withRenderingMode(.alwaysTemplate)
        )

        vc2.tabBarItem = UITabBarItem(
            title: "Clients",
            image: UIImage(named: "clients")?.withRenderingMode(.alwaysTemplate),
            selectedImage: UIImage(named: "clients")?.withRenderingMode(.alwaysTemplate)
        )

        vc3.tabBarItem = UITabBarItem(
            title: "Alerts",
            image: UIImage(named: "alerts")?.withRenderingMode(.alwaysTemplate),
            selectedImage: UIImage(named: "alerts")?.withRenderingMode(.alwaysTemplate)
        )
    }

    private func setupTabBarAppearance() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = UIColor(named: "appGreen") ?? .green // Set your background color

        // Normal state appearance (unselected)
        let normalColor: UIColor = UIColor.white.withAlphaComponent(0.8)
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = normalColor
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: normalColor,
            .font: UIFont.systemFont(ofSize: 12, weight: .medium)
        ]

        // Selected state appearance
        let selectedColor: UIColor = .white
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = selectedColor
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: selectedColor,
            .font: UIFont.systemFont(ofSize: 12, weight: .medium)
        ]

        tabBar.standardAppearance = tabBarAppearance

        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = tabBarAppearance
        }

        // Apply shadow to the tab bar
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBar.layer.shadowRadius = 5
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.80
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTabBarAppearance()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Apply corner radius and border to the tab bar
        let radius: CGFloat = 15
        let borderWidth: CGFloat = 0
        
        let borderColor = UIColor.systemGray6.cgColor
        var bounds = tabBar.bounds
        bounds.size = CGSize(width: bounds.width, height: bounds.height+5)
        // Corner radius mask
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: radius, height: radius))

        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        maskLayer.frame = bounds
        tabBar.layer.mask = maskLayer
        
        // Border layer
        let borderLayer = CAShapeLayer()
        borderLayer.path = maskPath.cgPath
        borderLayer.frame = bounds
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor
        borderLayer.lineWidth = borderWidth
        tabBar.layer.addSublayer(borderLayer)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension MainTabViewController{
    private func getProfile_APICall() {
        
//        CustomLoader.shared.showLoader(on: self.view)
        WebServiceManager.sharedInstance.callAPI(apiPath: .getAllUsers(userId: UserDetails.shared.user_id), method: .get, params: [:],isAuthenticate: true, model: CommonRespons<[ProfileModel]>.self) { response, successMsg in
//            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        UserDetails.shared.profileModel = data.data?.first
                    }else{
                        self?.view.makeToast(data.message ?? "")
                    }
                    DispatchQueue.main.async {[weak self] in
                        
                        self?.setupDatabar()
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {[weak self] in
                    self?.view.makeToast(error.localizedDescription)
                    DispatchQueue.main.async {
                        self?.setupDatabar()
                    }                }
            }
        }
    }
}
