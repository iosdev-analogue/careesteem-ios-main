import Foundation
import SwiftUI

import Foundation

struct URLConstants {
    static let kSTAGE_API_URL = "https://dev-api.careesteem.care/api/"//https://3.8.158.142:8443/api/"
//    static let kSTAGE_API_URL = "https://3.8.158.142:8443/api/"//https://3.8.158.142:8443/api/"
}

enum APIType {
    // MARK: - Login
    case createPasscode
    case verifyPasscode
    case resetPasscode
    case forgotPasscode
    case sendOtpUserLogin
    case verifyOtp
    case selectdbname
    
    // MARK: - Users
    case getAllUsers(userId: String)
    
    // MARK: - Visits
    case getVisitList(userId: String)
    case getVisitDetails(visitId: String,userId: String)
    case getClientNameList(userId: String)
    case updateVisitCheckinTime
    case updateVisitCheckoutTime(userId: String,visitId: String)
    case getVisitNotesDetails(visitId: String)
    case addVisitNotes
    case editVisitNotes(visitNotesId: String)
    
    // MARK: - Unscheduled Visits
    case addTodoDetails
    case getTodoDetails(todoId: String)
    case updateTodoDetails(todoId: String)
    case createUnscheduledVisit
    case getMedicationDetails(medicationId: String)
    case addMedicationDetails
    case getunscheduledMedicationPrn
    case editMedicationDetails(medicationId: String)
    case getVisitNotes(visitNotesId: String)
    case addUnscheduledVisitNotesDetails
    case updateUnscheduledVisitNotesDetails(visitNotesId: String)
    
    // MARK: - Medication
    case getMedicationDetailsById(medicationId: String)
    case medicationScheduledDetails(scheduleId: String)
    case medicationPRNDetails
    case unSchedulemedicationPRNDetails(id: String)
    case unSchedulemedicationPRNDetail
    case medicationBPDetails(bpId: String)
    case addMedicationAlertDetails
    
    // MARK: - Clients
    case getAllClients
    case getClientDetails(clientId: String)
    case getUploadedDocuments
    case getClientCarePlanAss(clientId: String)
    case medicationPrnDetails(cId: String)
    case getClientCarePlanRisk
    case verifyQRCode(clientId: String)
    case addAlertCheckInOut
    case gettodoessentialdetails(visitId: String)
    
    // MARK: - Alerts
    case getAlertList(alertId: String)
    case getallnotifications(userId: String)
    case addAlert
    
    // MARK: - Map
    case getMapLocation
    
    // MARK: - Visit ToDo
    case getVisitTodoDetails(todoId: String)
    case editVisitTodoDetails(todoId: String)
    case addTodoAlertDetails
    
    // MARK: - Utility
    var path: String {
        switch self {
        case .createPasscode: return "create-passcode"
        case .verifyPasscode: return "verify-passcode"
        case .resetPasscode: return "reset-passcode"
        case .forgotPasscode: return "forgot-passcode"
        case .sendOtpUserLogin: return "send-otp-user-login"
        case .verifyOtp: return "verify-otp"
        case .selectdbname: return "select-dbname"
        
        case .getAllUsers(let userId): return "get-all-users/\(userId)"
        
        case .getVisitList(let userId): return "getVisitList/\(userId)"
        case .getVisitDetails(let visitId,let userId): return "get-visit-details/\(visitId)/\(userId)"
        case .getClientNameList(let userId): return "getClientNameList/\(userId)"
        case .updateVisitCheckinTime: return "add-Visit-Checkin"
        case .updateVisitCheckoutTime(let userId,let visitId): return "update-visit-checkout/\(userId)/\(visitId)"
        case .getVisitNotesDetails(let visitId): return "getclientvisitnotesdetails/\(visitId)"
        case .addVisitNotes: return "addclientvisitnotesdetails"
        case .editVisitNotes(let visitNotesId): return "updatevisitnotesdetails/\(visitNotesId)"
        
        case .addTodoDetails: return "addUnscheduledTodoDetails"
        case .getTodoDetails(let todoId): return "getUnscheduledTodoDetails/\(todoId)"
        case .updateTodoDetails(let todoId): return "updateUnscheduledTodoDetails/\(todoId)"
        case .createUnscheduledVisit: return "addUnscheduledVisits"
        case .getMedicationDetails(let medicationId): return "getUnscheduledMedicationDetails/\(medicationId)"
        case .addMedicationDetails: return "addUnscheduledMedicationDetails"
        case .getunscheduledMedicationPrn: return "get-unscheduled-medication-prn"
        case .editMedicationDetails(let medicationId): return "updateUnscheduledMedicationDetails/\(medicationId)"
        case .getVisitNotes(let visitNotesId): return "getUnscheduledVisitNotesDetails/\(visitNotesId)"
        case .addUnscheduledVisitNotesDetails: return "addUnscheduledVisitNotesDetails"
        case .updateUnscheduledVisitNotesDetails(let visitNotesId): return "updateUnscheduledVisitNotesDetails/\(visitNotesId)"
        
        case .getMedicationDetailsById(let medicationId): return "get-medication-details/\(medicationId)"
        case .medicationScheduledDetails(let scheduleId): return "medication-scheduled/\(scheduleId)"
        case .medicationPRNDetails: return "medication-prn-details"
        case .unSchedulemedicationPRNDetails(let id): return "get-unscheduled-medication-prn/\(id)"
        case .unSchedulemedicationPRNDetail: return "medication-prn-details"
        case .medicationBPDetails(let bpId): return "medication-blister-pack/\(bpId)"
        case .addMedicationAlertDetails: return "add-Medication-Alert-Details"
        
        case .getAllClients: return "get-all-clients"
        case .getClientDetails(let clientId): return "get-client-details/\(clientId)"
        case .getClientCarePlanAss(let clientId): return "get-client-careplan-ass/\(clientId)"
        case .medicationPrnDetails(let str): return "medication-prn-details/\(str)"
        case .getClientCarePlanRisk: return "get-client-careplan-risk-ass"
        case .verifyQRCode(let clientId): return "verify-qrcode/\(clientId)"
        case .addAlertCheckInOut: return "add-Alert-Check-In-Out"
        case .gettodoessentialdetails(let visitId): return "get-todo-essential-details/\(visitId)"
        
        case .getAlertList(let alertId): return "alert-get-list/\(alertId)"
        case .getallnotifications(let userId): return "get-all-notifications/\(userId)"
        case .addAlert: return "alert"
        
        case .getMapLocation: return "distance-matrix"
        
        case .getVisitTodoDetails(let todoId): return "gettododetails/\(todoId)"
        case .editVisitTodoDetails(let todoId): return "updatetododetails/\(todoId)"
        case .addTodoAlertDetails: return "add-Todo-Alert-Details"
        case .getUploadedDocuments:
            return "get-uploaded-documents"
        }
    }
    
    var url: String {
        return URLConstants.kSTAGE_API_URL + self.path
    }
}

enum HTTPMethod : String {
    case get        = "GET"
    case post       = "POST"
    case put        = "PUT"
    case delete     = "DELETE"
}

enum HTTPHeaderString : String {
    case authorization    = "Authorization"
    case contentType      = "Content-Type"
    case accept           = "Accept"
    case jsonTypeValue    = "application/json"
    
    var string : String {
        return self.rawValue
    }
}

enum HTTPError: LocalizedError {
    case statusCode
}

enum ErrorModel: Error {
    case invalidURL
    case parsingError
    case internetConnectionError
    case somethingWentWrong
    case serverError
    case badRequest
    case forbiddenErrror
    case notFoundErrror
    case internalServerError
    case badGatewayErrror
    case serviceUnavailableErrror
    case gatewayTimeoutErrror
    
    case unknown(error: String)
    
    func description() -> String {
        switch self {
        case .parsingError:
            return errorMessage.parsingError.rawValue
        case .invalidURL:
            return errorMessage.invalidURL.rawValue
        case .serverError:
            return errorMessage.serverErrror.rawValue
        case .badRequest:
            return errorMessage.badRequest.rawValue
        case .forbiddenErrror:
            return errorMessage.forbiddenErrror.rawValue
        case .notFoundErrror:
            return errorMessage.notFoundErrror.rawValue
        case .internalServerError:
            return errorMessage.internalServerError.rawValue
        case .badGatewayErrror:
            return errorMessage.badGatewayErrror.rawValue
        case .serviceUnavailableErrror:
            return errorMessage.serviceUnavailableErrror.rawValue
        case .gatewayTimeoutErrror:
            return errorMessage.gatewayTimeoutErrror.rawValue
        case .unknown(let error):
            return error
        case .internetConnectionError:
            return errorMessage.internetConnectionError.rawValue
        case .somethingWentWrong:
            return errorMessage.somethingWentWrong.rawValue
        }
    }
}

enum errorMessage: String {
    case invalidURL                       = "Invalid API URL"
    case parsingError                       = "Invalid Parameter JSON"
    case serverErrror                       = "Someting went wrong with server. Please try again later."
    case badRequest                         = "Bad Request."
    case forbiddenErrror                    = "Forbidden."
    case notFoundErrror                     = "Not Found."
    case internalServerError                = "Internal Server Error."
    case badGatewayErrror                   = "Bad Gateway."
    case serviceUnavailableErrror           = "Service Unavailable."
    case gatewayTimeoutErrror               = "Gateway Timeout."
    case internetConnectionError            = "No Internet Connection"
    case somethingWentWrong                 = "Something Went Wrong"
    case unAuthenticateUser                 = "Unauthenticated user!"
}

func errorMsg(_ statusCode: Int) -> ErrorModel {
    
    switch statusCode {
    case 400:
        return ErrorModel.badRequest
    case 401:
        return ErrorModel.serverError
    case 403:
        return ErrorModel.forbiddenErrror
    case 404:
        return ErrorModel.notFoundErrror
    case 500:
        return ErrorModel.internalServerError
    case 502:
        return ErrorModel.badGatewayErrror
    case 503:
        return ErrorModel.serviceUnavailableErrror
    case 504:
        return ErrorModel.gatewayTimeoutErrror
    default:
        return ErrorModel.unknown(error: "Unknown error!")
    }
    
}
