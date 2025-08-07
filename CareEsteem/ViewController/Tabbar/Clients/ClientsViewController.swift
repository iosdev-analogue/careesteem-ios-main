//
//  ClientsViewController.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 07/03/25.
//

import UIKit

class ClientsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tf: UITextField!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var list:[ClientModel] = []
    var filterList:[ClientModel] = []
    var searchActive = false

    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldoutLines(txtFld: tf)
        self.tableView.pullToRefreshScroll = { pull in
            pull.endRefreshing()
            self.getClientList_APICall()
        }
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getClientList_APICall()
    }
    
    func textFieldoutLines(txtFld: UITextField) {
        txtFld.delegate = self
        txtFld.layer.borderWidth = 1
        txtFld.layer.borderColor = UIColor(named: "appGreen")?.cgColor
        txtFld.layer.cornerRadius = 5
        txtFld.clipsToBounds = true
        txtFld.leftViewMode = .always
        let imagView = UIImageView(frame: CGRect(x: 5, y: 5, width: 15, height: 15))
        let image = UIImage(named: "searchIcon")
        imagView.image = image
        let bg = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 28))
        bg.addSubview(imagView)
        txtFld.leftView = bg
    }
}
extension ClientsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchActive ? self.filterList.count : self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClassIdentifier: ClientListTableViewCell.self,for: indexPath)
        cell.setupData(model: searchActive ? self.filterList[indexPath.row] : self.list[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = Storyboard.Clients.instantiateViewController(withViewClass: ClientDetailViewController.self)
        vc.client =  searchActive ? self.filterList[indexPath.row] : self.list[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


// MARK: API Call
extension ClientsViewController {
    
    private func getClientList_APICall() {
        searchActive = false
        tf.text = ""
        CustomLoader.shared.showLoader(on: self.view)
        WebServiceManager.sharedInstance.callAPI(apiPath: .getAllClients, method: .get, params: [:],isAuthenticate: true, model: CommonRespons<[ClientModel]>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        
                        self?.list = data.data ?? []
//                        self.list = data.finalData?.filter({ c in
//                            c.id == 234
//                        }) ?? []
                        self?.tableView.reloadData()
                    }else{
                        self?.view.makeToast(data.message ?? "")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {[weak self] in
                    self?.view.makeToast(error.localizedDescription)
                }
            }
        }
    }
}

extension ClientsViewController {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var search = textField.text ?? ""
        if let r = Range(range, in: search){
            search.removeSubrange(r) // it will delete any deleted string.
        }
        search.insert(contentsOf: string, at: search.index(search.startIndex, offsetBy: range.location)) // it will insert any text.
        print(search)
      
        searchActive = true
        filterList = list.filter { $0.fullName?.lowercased().contains(search.lowercased()) ?? false
        }
        if search.count == 0 {
            filterList = list
        }
        self.tableView.reloadData()
        return true
    }

}
