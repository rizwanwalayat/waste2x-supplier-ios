//
//  Constants.swift
//  Doro
//
//  Created by a on 04/10/2020.
//  Copyright © 2020 codesrbit. All rights reserved.
//

import UIKit

var kApplicationWindow = Utility.getAppDelegate()!.window
var skipButtonTapped = false
var retryButtonPressed = false
var uiButtonColor = false
var backButtonTapped = false
var backOnRetryTapped = false
var notificationButton = false
var tapValidate = false
var tapToCancel = false
var googleAPIKey = "AIzaSyBp9ntlNiyAFvV8qxdXrBvBAOz_xasmvS0"
var apiRequestObject: [String: String] = [:]

enum PaymentMethod {
    case paypal
    case venmo
    case creditCard
}


enum UserType: String {
    case donor = "1"
    case donee = "0"
}


struct APIRoutes {
    static var baseUrl = "https://doro-backend.codesorbit.com"
    static var imageBaseUrl = "/api/shared/user/userImage"
    static var login = "/api/auth/login"
    static var getUserProfile = "/api/shared/user/userProfile"
    static var createUser = "/api/shared/user/create"
    static var updateUser = "/api/shared/user/update"
    static var forgotPassword = "/api/shared/user/forgetPassword"
    static var widthdrawFromDonee = "/api/payments/paypal/donee/withdrawRequest"
    static var getDoneeUserTransactions = "/api/payments/paypal/donee/transactions"
}
