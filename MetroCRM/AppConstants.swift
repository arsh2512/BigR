//
//  AppConstants.swift
//  MetroCRM
//
//  Created by Ecsion Research Labs Pvt. Ltd. on 26/03/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct Url {
    static let mainUrl : String = "http://api.bigr.asia/api/crm/"
    //static let mainUrl : String = "http://demo10.absecmy.com/CRMAPI/API/CRM/"
    //static let mainUrl : String = "http://staging-api.bigr.asia/api/crm/"
    static let loginUrl : String = mainUrl + "GetLoginInfo?"
    static let signUpUrl : String = mainUrl + "SignupRegistration"
    static let afterLoginUrl : String = mainUrl + "UpdateLastLogin"
    static let getBannerDetailsByCategoryUrl : String = mainUrl + "GetBannerDetailsByCategory"
    static let getArticleList : String = mainUrl + "GetAllNewsArticlesView?"
    static let getDealsList : String = mainUrl + "GetVoucherListDetailsMobile"
    static let getNearByDeals : String = mainUrl + "GetVoucherListDetailsByStateIdMobile"
    static let imageBaseUrl : String = "https://www.bigr.asia/"
    static let bannerImageUrl : String = "https://www.bigr.asia/"
    static let profileImageUrl : String = "https://www.bigr.asia/crmapp/img/portfolio/"
    static let addWishListDetailsUrl : String = mainUrl + "AddWishListDetails"
    static let GetWishListDetails : String = mainUrl + "GetWishListDetails"
    static let GetOrderListCheckoutItems : String = mainUrl + "GetOrderListCheckoutItems"
    static let GetVoucherDetailsByIdUrl : String = mainUrl + "GetVoucherDetailsById?"
    static let GetOLCountByUserloginId : String = mainUrl + "GetOLCountByUserloginId"
    static let GetUserMobileDashboardData : String = mainUrl + "GetUserMobileDashboardData"
    static let DeleteWishListDetails : String = mainUrl + "DeleteWishListDetails"
    static let DeleteOrderList : String = mainUrl + "DeleteOrderList"
    static let GetFeedBackListByUser : String = mainUrl + "GetFeedBackListByUser"
    static let AddFeedback : String = mainUrl + "AddFeedback"
    static let GetemailblastingList : String = mainUrl + "GetemailblastingList"
    static let GetVoucherOutletsAddressById : String = mainUrl + "GetVoucherOutletsAddressById?"
    static let GetVoucherlistRedeemDetails : String = mainUrl + "GetVoucherlistRedeemDetails"
    static let UpdateProfileImage : String = mainUrl + "UpdateProfileImage?"
    static let UpdateNormalUserDetailsbyLoginId : String = mainUrl + "UpdateNormalUserDetailsbyLoginId"
    static let GetStateDetails : String = mainUrl + "GetStateDetails"
    static let GetCityListing : String = mainUrl + "GetCityListing"
    static let GetNormalUserDetailsbyLoginId : String = mainUrl + "GetNormalUserDetailsbyLoginId"
    static let GetOrderListRetailDetails : String = mainUrl + "GetOrderListRetailDetails"
    static let GetRedeemPointDetails : String = mainUrl + "GetRedeemPointDetails"
    static let AddOrderCheckOut : String = mainUrl + "AddOrderCheckOut"
    static let AddOrderListItems : String = mainUrl + "AddOrderListItems"
    static let GetVoucherMerchandiseDetailsBySearchKeyMobile : String = mainUrl + "GetVoucherMerchandiseDetailsBySearchKeyMobile"
    static let RegisterBigrCard : String = mainUrl + "RegisterBigrCard"
    static let GetTPinDetailsByUserId : String = mainUrl + "GetTPinDetailsByUserId"
    static let AddEditTransactionPin : String = mainUrl + "AddEditTransactionPin"
    static let ValidateTransactionPin : String = mainUrl + "ValidateTransactionPin"
}
