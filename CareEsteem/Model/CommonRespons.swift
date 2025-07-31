//
//  CommonRespons.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 08/03/25.
//
import UIKit
import AVFoundation

struct CommonRespons<T: Codable>: Codable {
    let message: String?
    let statusCode:Int?
    let data: T?
    let finalData: T?
    let userActualTimeData: T?
}
struct CommonRespons1<T: Codable,T1: Codable>: Codable {
    let message: String?
    let statusCode:Int?
    let data: T?
    let dbList: T1?
}
struct EmptyReponse: Codable {
    let message: String?
    let statusCode:Int?
}
//struct CommonRespons1<T: Codable>: Codable {
//    let message: String?
//    let statusCode:Int?
//    let data: [[String: CodableValue]]
//}
