
import UIKit

class CustomLoader {
    static let shared = CustomLoader()

    private init() {
    }

    private var loaderView: UIView?
    private var interactionBlockingView: UIView?

    func showLoader(on view: UIView) {
        guard loaderView == nil else { return }

        let blockingView = UIView()
        blockingView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        blockingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blockingView)

        let loader = UIView()
        loader.backgroundColor = .white
        loader.layer.cornerRadius = 10
        loader.layer.masksToBounds = false
        loader.layer.shadowColor = UIColor.black.cgColor
        loader.layer.shadowOpacity = 0.3
        loader.layer.shadowOffset = CGSize(width: 0, height: 2)
        loader.layer.shadowRadius = 4
        loader.translatesAutoresizingMaskIntoConstraints = false
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.tintColor = .black
        activityIndicator.color = .black
        activityIndicator.startAnimating()
        
        let label = UILabel()
        label.text = "Please Wait..."
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        
        let stackView = UIStackView(arrangedSubviews: [activityIndicator])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        loader.addSubview(stackView)
        
        view.addSubview(loader)
        
        NSLayoutConstraint.activate([
            blockingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blockingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blockingView.topAnchor.constraint(equalTo: view.topAnchor),
            blockingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loader.widthAnchor.constraint(equalToConstant: 70),
            loader.heightAnchor.constraint(equalToConstant: 70),
            stackView.centerXAnchor.constraint(equalTo: loader.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: loader.centerYAnchor)
        ])
        
        loaderView = loader
        interactionBlockingView = blockingView
    }

    func hideLoader() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {[weak self] in
            
            
            //        DispatchQueue.main.async {
            self?.loaderView?.removeFromSuperview()
            self?.interactionBlockingView?.removeFromSuperview()
            self?.loaderView = nil
            self?.interactionBlockingView = nil
        })
    }
}
