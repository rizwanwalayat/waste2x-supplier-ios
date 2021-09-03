//
//  Constants.swift
//  Haid3r
//
//  Created by a on 04/10/2020.
//  Copyright © 2020 Haider Awan. All rights reserved.
//

import UIKit

var kApplicationWindow = Utility.getAppDelegate()!.window
var googleAPIKey = "AIzaSyBp9ntlNiyAFvV8qxdXrBvBAOz_xasmvS0"


//"https://enmass-cache-programme.appspot.com/"
//"https://cache-admin-panel-production.appspot.com/"
//"https://app.enmassenergy.com/"

struct APIRoutes {
    static var baseUrl = "https://app.enmassenergy.com/" //Live
//    static var baseUrl = "https://enmass-cache-programme.appspot.com/" //Stagging
    static var imageBaseUrl = "/api/shared/user/userImage"
    static var login = "paudapay_us/send_code/"
    static var registration = "paudapay_us/registration/"
    static var emailVerification = "paudapay_us/verify_email/"
    static var weatherAPi = "https://api.openweathermap.org/data/2.5/forecast?lat=\(Global.shared.current_lat)&lon=\(Global.shared.current_lng)&units=metric&appid=43ac4491d3ab773330ca34850c08ac7d"
    static var polyLineUrl = ""
    static var fetchSupplyProcessData = "paudapay_us/waste_types/"
    static var faqUrl = "paudapay_us/fetch_faqs/1"
    static var paymentFetch = ""
    
    
    static var postSupplyProcessDataNewUser = "paudapay_us/waste_type_selection_v2/"
    static var postSupplyProcessDataUser = "paudapay_us/create_farm_v2/"
    static var fetchSitesHomeProcessDataUser = "paudapay_us/fetch_sites/"
    static var createUser = "/api/shared/user/create"
    static var updateUser = "/api/shared/user/update"
    static var forgotPassword = "/api/shared/user/forgetPassword"
    static var widthdrawFromDonee = "/api/payments/paypal/donee/withdrawRequest"
    static var getDoneeUserTransactions = "/api/payments/paypal/donee/transactions"
    static var newsUrl = "paudapay_us/fetch_news/"
    static var pickupSchedulePostData = "paudapay_us/schedule_waste/"
    static var wasteDetailData = "paudapay_us/details/"
    static var wasteDetailImageUpload = baseUrl + "paudapay_us/save_user_activity/"
    static var wasteDetailSizeUpdate = "paudapay_us/update_site/"
    static var wasteDetailLocationUpdate = "paudapay_us/update_farm_address/"
    static var paymentUrl = "paudapay_us/payments"
    static var createPaymentUrl = "payment_method/api_create_stripe"
    static var notificationUrl = "paudapay_us/fetch_notifications/"
    static var notificationResponceUrl = "paudapay_us/send_notification_response/"
    static var pendingCollectionFetchUrl = "paudapay_us/pending_collections/"
    static var fetchTwillioAccessToken = "paudapay_us/fetch_twilio_access_token/"
    static var pendingDetailUrl = "paudapay_us/pending_collection_detail/"
    static var contacFetchUrl = "paudapay_us/invited_suppliers/"
    static var contacSendUrl = "paudapay_us/invite_supplier/"
    static var siteDeleteSendUrl = "paudapay_us/delete_site/"
}
struct FireBaseVariables {
    static var fireBaseToken = ""
}
