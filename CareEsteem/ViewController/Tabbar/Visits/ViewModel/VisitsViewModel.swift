//
//  VisitsViewModel.swift
//  CareEsteem
//
//  Created by Gaurav Agnihotri on 31/07/25.
//

import Foundation

class VisitsViewModel {
    
    // MARK: - Properties
    var visitsSections: [VisitsSectionModel] = [] {
        didSet {
            onDataUpdate?()
        }
    }
    
    var onDataUpdate: (() -> Void)?
    var onError: ((String) -> Void)?
    var isLoading: ((Bool) -> Void)?
    
    var selectedDate: Date = Date()
    var currentDate: Date = Date()
    var startOfWeek: Date = Date()

    // MARK: - API Calls
    func fetchVisits() {
        isLoading?(true)
        let dateString = convertDateToString(date: selectedDate, format: "yyyy-MM-dd")

        WebServiceManager.sharedInstance.callAPI(
            apiPath: .getVisitList(userId: UserDetails.shared.user_id),
            queryParams: [APIParameters.Visits.visitDate: dateString],
            method: .get,
            params: [:],
            isAuthenticate: true,
            model: CommonRespons<[VisitsModel]>.self
        ) { [weak self] response, _ in
            self?.isLoading?(false)
            switch response {
            case .success(let data):
                guard data.statusCode == 200 else {
                    self?.onError?(data.message ?? "Unexpected error")
                    return
                }

                var completed = [VisitsModel]()
                var notCompleted = [VisitsModel]()
                var ongoing = [VisitsModel]()
                var upcoming = [VisitsModel]()

                for item in data.data ?? [] {
                    if (item.actualStartTime?.first ?? "").isEmpty && (item.actualEndTime?.first ?? "").isEmpty {
                        let dateTime = "\(item.visitDate ?? "") \(item.plannedStartTime ?? "")"
                        if let visitDate = convertStringToDate(dateString: dateTime, format: "yyyy-MM-dd HH:mm"),
                           Calendar.current.dateComponents([.hour], from: visitDate, to: Date()).hour ?? 0 >= 4 {
                            notCompleted.append(item)
                        } else {
                            upcoming.append(item)
                        }
                    } else if !(item.actualStartTime?.first ?? "").isEmpty && (item.actualEndTime?.first ?? "").isEmpty {
                        ongoing.append(item)
                    } else {
                        completed.append(item)
                    }
                }

                self?.visitsSections = [
                    VisitsSectionModel(title: "Not Completed Visits", type: .notcompleted, isExpand: true, data: notCompleted),
                    VisitsSectionModel(title: "Completed Visits", type: .completed, isExpand: true, data: completed),
                    VisitsSectionModel(title: "Ongoing Visits", type: .onging, isExpand: true, data: ongoing),
                    VisitsSectionModel(title: "Upcoming Visits", type: .upcoming, isExpand: true, data: upcoming)
                ]

            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }

    func fetchNotifications(completion: @escaping (Int) -> Void) {
        WebServiceManager.sharedInstance.callAPI(
            apiPath: .getallnotifications(userId: UserDetails.shared.user_id),
            method: .get,
            params: [:],
            isAuthenticate: true,
            model: CommonRespons<[NotificationModel]>.self
        ) { response, _ in
            if case let .success(data) = response, data.statusCode == 200 {
                completion(data.data?.count ?? 0)
            }
        }
    }
}
