//
//  LoginViewModel.swift
//  CareEsteem
//
//  Created by Gaurav Agnihotri on 31/07/25.
//

import Foundation
import UIKit

class LoginViewModel {

    // MARK: - Properties

    var listCountry: [Country] = []
    var selectedCountry: Country?
    var mobileNumber: String = ""

    // MARK: - Output Callbacks (Binding)

    var onCountryUpdated: (() -> Void)?
    var onOTPRequestSuccess: (( String, String, String) -> Void)?
    var onError: ((String) -> Void)?
    var onLoadingStateChange: ((Bool) -> Void)?

    // MARK: - Initializer

    init() {
        self.listCountry = loadJSONFromFile() ?? []
        self.selectedCountry = listCountry.first(where: { $0.countryCode == "44" }) ??
                               listCountry.first(where: { $0.countryCode == "91" })
    }

    // MARK: - Public Methods

    func selectCountry(at index: Int) {
        selectedCountry = listCountry[index]
        onCountryUpdated?()
    }

    func canEnableOTPButton(for text: String) -> Bool {
        mobileNumber = text
        return !text.isEmpty
    }

    func requestOTP() {
        guard let countryID = selectedCountry?.id,
              let countryCode = selectedCountry?.countryCode else {
            onError?("Country selection is invalid.")
            return
        }

        let params: [String: Any] = [
            APIParameters.Login.contactNumber: mobileNumber,
            APIParameters.Login.telephoneCodes: countryID
        ]

        onLoadingStateChange?(true)

        WebServiceManager.sharedInstance.callAPI(
            apiPath: .sendOtpUserLogin,
            method: .post,
            params: params,
            isAuthenticate: false,
            model: CommonRespons<LoginUserModel>.self
        ) { [weak self] response, _ in
            DispatchQueue.main.async {
                self?.onLoadingStateChange?(false)

                switch response {
                case .success(let data):
                    print("✅ API Success. Status code: \(String(describing: data.statusCode))")

                    if data.statusCode == 200 {
                        print("✅ OTP sent successfully. No user data returned.")
                        self?.onOTPRequestSuccess?(
                            self?.mobileNumber ?? "",
                            countryID,
                            countryCode
                        )
                    } else {
                        self?.onError?(data.message ?? "Unknown error")
                    }

                case .failure(let error):
                    print("❌ API Failed: \(error.localizedDescription)")
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }

    // MARK: - Private Methods

    private func loadJSONFromFile() -> [Country]? {
        guard let url = Bundle.main.url(forResource: "country", withExtension: "json") else { return nil }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([Country].self, from: data)
        } catch {
            print("JSON Decoding Error: \(error)")
            return nil
        }
    }
}
