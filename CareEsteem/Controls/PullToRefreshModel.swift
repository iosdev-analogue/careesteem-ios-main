//
//  PullToRefreshModel.swift
//  Ozag
//
//  Created by iOSTemplate on 22/06/18.
//  Copyright © 2018 KZ. All rights reserved.
//

import UIKit

class PullToRefreshModel {
    
    private var isLastData: Bool = false
    private var isWebDataLoaded: Bool = false
    private var isWebServicesCallRuning: Bool = false
    private var page: Int = 1
    private var isFailedWebApi: Bool = false
    
    init(page: Int) {
        self.page = page
        isLastData = false
        isWebDataLoaded = false
        isWebServicesCallRuning = false
        isFailedWebApi = false
    }
    
    func resetWithPage(page: Int) {
        self.page = page
        isLastData = false
        isWebDataLoaded = false
        isFailedWebApi = false
    }
    
    func getPageIndex() -> Int { return page }
    
    func isLoadMoreDataWebservices(index: IndexPath, data: [Any], completionsHandler: (() -> Void)) {
        if !isLastData && !isWebServicesCallRuning && data.count != 0 && !isFailedWebApi && index.row != 0{
            if (data.count - 2) <= index.row {
                self.start()
                completionsHandler()
            }
        }
    }
    
    func showSkeltoneView(data: [Any]) -> Bool {
        return data.count == 0 && !self.isWebDataLoaded && !self.isFailedWebApi
    }
    
    func responseData(withNewData data: [Any],lastPage:Int = -1) {
        if lastPage == -1{
            if data.count == 0 {
                isLastData = true
            }
            else{
                isLastData = false
                page += 1
            }
            self.isWebDataLoaded = true
            self.isFailedWebApi = false
            self.isWebServicesCallRuning = false
        }else{
            if data.count == 0 || lastPage == page{
                isLastData = true
            }
            else{
                isLastData = false
                page += 1
            }
            self.isWebDataLoaded = true
            self.isFailedWebApi = false
            self.isWebServicesCallRuning = false
        }
    }
    
    func apiFailer() {
        self.stop()
        self.isFailedWebApi = true
    }
    
    func start() {
        self.isWebServicesCallRuning = true
    }
    
    func stop() {
        self.isWebServicesCallRuning = false
    }
}
