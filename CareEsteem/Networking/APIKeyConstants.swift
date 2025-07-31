import Foundation

enum APIParameters {
    // MARK: - Login
    
    static let hashToken = "hash_token"
    
    enum Login {
        static let passcode = "passcode" // create-passcode, verify-passcode
        static let contactNumber = "contact_number" // verify-otp, send-otp-user-login
        static let otp = "otp" // verify-otp, send-otp-user-login
        static let telephoneCodes = "telephone_codes" // send-otp-user-login, forgot-passcode
        static let fcmToken = "fcm_token" // send-otp-user-login
        static let countryCode = "country_code" // send-otp-user-login
    }
    
    // MARK: - Users
    enum Users {
        static let userId = "user_id" // get-all-users
    }
    
    // MARK: - Unscheduled Visits
    enum UnscheduledVisits {
        // JSON Body Parameters
        static let visitNotes = "visit_notes"
        static let visitCreatedAt = "visit_created_at"
        static let visitUpdatedAt = "visit_updated_at"
        static let visitDetailsId = "visit_details_id"
        static let visitUserId = "visit_user_id"
        static let medicationNotes = "medication_notes"
        static let medicationUpdatedAt = "medication_updated_at"
        static let medicationCreatedAt = "medication_created_at"
        static let medicationUserId = "medication_user_id"
        static let userId = "user_id"
        static let clientId = "client_id"
        static let visitDate = "visit_date"
        static let actualStartTime = "actual_start_time"
        static let createdAt = "created_at"
        static let todoNotes = "todo_notes"
        static let todoUpdatedAt = "todo_updated_at"
        static let todoUserId = "todo_user_id"
        static let todoCreatedAt = "todo_created_at"
        static let createdbyUserid = "createdby_userid"
        static let status = "status" // add-Visit-Checkin
    }
    
    // MARK: - Visits
    enum Visits {
        static let visitId = "visit_id" // getVisitList, update-visit-checkout
        static let clientId = "client_id" // getVisitList, add-Visit-Checkin
        static let userId = "user_id" // add-Visit-Checkin
        static let status = "status" // add-Visit-Checkin
        static let actualStartTime = "actual_start_time" // add-Visit-Checkin
        static let actualEndTime = "actual_end_time" // add-Visit-Checkin
        static let createdAt = "created_at" // add-Visit-Checkin
        static let updatedAt = "updated_at" // add-Visit-Checkin
        static let visit_details_id = "visit_details_id" // getVisitList, add-Visit-Checkin
        static let visitDate = "visit_date" // getVisitList
        static let createdbyUserid = "createdby_userid" // addclientvisitnotesdetails, updatevisitnotesdetails
        static let updatedbyUserid = "updatedby_userid" //  addclientvisitnotesdetails, updatevisitnotesdetails
        static let visitNotes = "visit_notes" // addclientvisitnotesdetails, updatevisitnotesdetails
        static let alert_type = "alert_type"
        static let alert_status = "alert_status"
        static let uat_id = "uat_id"
    }
    
    // MARK: - Medication
    enum Medication {
        // Query Parameters
        static let medicationId = "medication_id" // get-medication-details
        static let scheduleId = "schedule_id" // medication-scheduled
        static let blister_pack_id = "blister_pack_id" // medication-scheduled
        
        // JSON Body Parameters
        static let dosage = "dosage" // medication-scheduled
        static let frequency = "frequency" // medication-scheduled
        static let clientId = "client_id" // Medication Entry
        static let prnId = "prn_id" // Medication Entry
        static let dosePer = "dose_per" // Medication Entry
        static let doses = "doses" // Medication Entry
        static let timeFrame = "time_frame" // Medication Entry
        static let prnOffered = "prn_offered" // Medication Entry
        static let prnBeGiven = "prn_be_given" // Medication Entry
        static let visitDetailsId = "visit_details_id" // Medication Entry
        static let userId = "user_id" // Medication Entry
        static let carerNotes = "carer_notes" // Medication Entry
        static let status = "status" // Medication Entry
        static let medicationTime = "medication_time" // Medication Entry
        static let createdAt = "created_at" // Medication Entry
        static let alert_type = "alert_type"
        static let alert_status = "alert_status"
    }
    // MARK: - Clients
    enum Clients {
        static let clientName = "client_name" // get-client-details
        static let carePlanId = "care_plan_id" // get-client-careplan-ass
        static let qrCode = "qrcode_token" // verify-qrcode
    }
    
    // MARK: - Alerts
    enum Alerts {
        // Query Parameters
        static let alertId = "alert_id" // alert-get-list
        
        // JSON Body Parameters
        static let alertMessage = "alert_message" // alert
        static let clientId = "client_id"
        static let userId = "user_id"
        static let visitDetailsId = "visit_details_id"
        static let severityOfConcern = "severity_of_concern"
        static let concernDetails = "concern_details"
        static let bodyPartType = "body_part_type"
        static let bodyPartNames = "body_part_names"
        static let fileName = "file_name"
        static let images = "images"
        static let createdAt = "created_at"
    }
    
    // MARK: - Map
    enum Map {
        static let origins = "origins" // distance-matrix
        static let destinations = "destinations" // distance-matrix
    }
    
    // MARK: - ToDo
    enum ToDo {
        static let carerNotes = "carer_notes" // Medication Entry
        static let todoId = "todo_id" // gettododetails, updatetododetails
        static let todoDetails = "todo_details" // addUnscheduledTodoDetails
        static let todoOutcome = "todo_outcome" // addUnscheduledTodoDetails
        static let clientId = "client_id"
        static let todo_details_id = "todo_details_id"
        static let alert_type = "alert_type"
        static let alert_status = "alert_status"
        static let createdAt = "created_at"
        static let visitDetailsId = "visit_details_id"
    }
}
