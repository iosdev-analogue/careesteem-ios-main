//
//  VisitMedicationModel.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 09/03/25.
//


import Foundation

// MARK: - VisitMedicationModel
struct VisitMedicationModel: Codable {
    let medicationID, blisterPackID: String?
    let visitDetailsID: CodableValue?
    let blisterPackDetailsID: String?
    let clientID, nhsMedicineName, medicationRouteName: String?
    let quantityEachDose: String?
    let medicationSupport, medicationType, blisterPackStartDate, blisterPackEndDate: String?
    let blisterPackDate: String?
    let blisterPackUserID: String?
    let status, blisterPackCreatedBy, dayName: String?
    let scheduledID, scheduledDetailsID: String?
    let scheduledStartDate, scheduledEndDate, scheduledDate, selectPreference: String?
    let byExactStartDate, byExactEndDate, byExactDate, by_exact_time, session_type: String?
    let scheduledUserID: String?
    let scheduledCreatedBy: String?
    let prnID: String?
    let body_map_image_url, body_part_names: [String?]?
    let prnStartDate, prnEndDate: String?
    let dosePer, doses: Int?
    let timeFrame, prnOffered, prnBeGiven: String?
    let prnUserID: String?
    let carerNotes, medicationTime, prnCreatedBy: String?
    let prnDetailsClientID, prnDetailsPrnID, prnDetailsID, prnDetailsMedicationID: String?
    let prnDetailsVisitDetailsID, prnDetailsNhsMedicineName, prnDetailsMedicationRouteName: String?
    let prnDetailsQuantityEachDose: Int?
    let prnDetailsMedicationSupport, prnDetailsMedicationType: String?
    let prnDetailsDosePer, prnDetailsDoses: Int?
    let prnDetailsTimeFrame, prnDetailsPrnOffered, prnDetailsPrnBeGiven: String?
    let prnDetailsUserID: String?
    let prnDetailsUserName, prnDetailsStatus, prnDetailsCarerNotes, prnDetailsMedicationTime: String?
    
    enum CodingKeys: String, CodingKey {
        case clientID = "client_id"
        case medicationID = "medication_id"
        case blisterPackID = "blister_pack_id"
        case visitDetailsID = "visit_details_id"
        case blisterPackDetailsID = "blister_pack_details_id"
        case nhsMedicineName = "nhs_medicine_name"
        case medicationRouteName = "medication_route_name"
        case quantityEachDose = "quantity_each_dose"
        case medicationSupport = "medication_support"
        case medicationType = "medication_type"
        case blisterPackStartDate = "blister_pack_start_date"
        case blisterPackEndDate = "blister_pack_end_date"
        case blisterPackDate = "blister_pack_date"
        case blisterPackUserID = "blister_pack_user_id"
        case status, by_exact_time, session_type
        case blisterPackCreatedBy = "blister_pack_created_by"
        case dayName = "day_name"
        case scheduledID = "scheduled_id"
        case scheduledDetailsID = "scheduled_details_id"
        case scheduledStartDate = "scheduled_start_date"
        case scheduledEndDate = "scheduled_end_date"
        case scheduledDate = "scheduled_date"
        case selectPreference = "select_preference"
        case byExactStartDate = "by_exact_start_date"
        case byExactEndDate = "by_exact_end_date"
        case byExactDate = "by_exact_date"
        case scheduledUserID = "scheduled_user_id"
        case scheduledCreatedBy = "scheduled_created_by"
        case prnID = "prn_id"
        case prnStartDate = "prn_start_date"
        case prnEndDate = "prn_end_date"
        case dosePer = "dose_per"
        case doses, body_map_image_url, body_part_names
        case timeFrame = "time_frame"
        case prnOffered = "prn_offered"
        case prnBeGiven = "prn_be_given"
        case prnUserID = "prn_user_id"
        case carerNotes = "carer_notes"
        case medicationTime = "medication_time"
        case prnCreatedBy = "prn_created_by"
        case prnDetailsClientID = "prn_details_client_id"
        case prnDetailsPrnID = "prn_details_prn_id"
        case prnDetailsID = "prn_details_id"
        case prnDetailsMedicationID = "prn_details_medication_id"
        case prnDetailsVisitDetailsID = "prn_details_visit_details_id"
        case prnDetailsNhsMedicineName = "prn_details_nhs_medicine_name"
        case prnDetailsMedicationRouteName = "prn_details_medication_route_name"
        case prnDetailsQuantityEachDose = "prn_details_quantity_each_dose"
        case prnDetailsMedicationSupport = "prn_details_medication_support"
        case prnDetailsMedicationType = "prn_details_medication_type"
        case prnDetailsDosePer = "prn_details_dose_per"
        case prnDetailsDoses = "prn_details_doses"
        case prnDetailsTimeFrame = "prn_details_time_frame"
        case prnDetailsPrnOffered = "prn_details_prn_offered"
        case prnDetailsPrnBeGiven = "prn_details_prn_be_given"
        case prnDetailsUserID = "prn_details_user_id"
        case prnDetailsUserName = "prn_details_user_name"
        case prnDetailsStatus = "prn_details_status"
        case prnDetailsCarerNotes = "prn_details_carer_notes"
        case prnDetailsMedicationTime = "prn_details_medication_time"
    }
    
}
