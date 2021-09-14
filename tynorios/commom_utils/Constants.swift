//
//  Constants.swift
//  tynorios
//
//  Created by Acxiom Consulting on 21/09/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//
import UIKit
public class constant {
    
    //    NEW URLS ==============>>>>>>
    
    public static let Base_url = "http://103.25.172.118:8089/api/";    //UAT new
    
    //    public static let Base_url = "http://tynor.co:82/api/";    //azure2 recent 8 jun'19
    
    //    public static let Base_url = "http://163.47.143.188:4845/api/";  //DEV
    
    public static let onlyhidden : Bool = false
    public static let isDebug: Bool = false
    public static var taxUpdate: Bool = true
    
    public static let key = "tynor.acxiom.ios"
//    public static var configInfo = "CONFIGINFO?usercode=" + UserDefaults.standard.string(forKey: "usercode")! + "&password="

    public static func configInfo() -> String {
           let URL =  "CONFIGINFO?usercode=" + UserDefaults.standard.string(forKey: "usercode")! + "&password="
           return URL
       }
    
//    public static var URL_userDR  = "GetUserDRCustLinking?USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREDID=" + UserDefaults.standard.string(forKey: "dataareaid")!
    
    public static func URL_userDRConst() -> String {
           let URL =  "GetUserDRCustLinking?USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREDID=" + UserDefaults.standard.string(forKey: "dataareaid")!

           return URL
       }
    
    public static let getuserbymobilemob = "GetUserByMobileNo?MOBILENO="
    public static let postresetpwd = "ResetPasswordPost?"
//    public static let URL_dashboardprimary = "GetUserPrimaryDashboard?USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "ismobile=" + UserDefaults.standard.string(forKey: "ismobile")!
    
    public static func URL_dashboardprimaryConst() -> String {
             let URL =  "GetUserPrimaryDashboard?USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "ismobile=" + UserDefaults.standard.string(forKey: "ismobile")!
         return URL
         }
    
//    public static var URL_retailermaster = "RetailerMaster?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")!
    
    public static func URL_retailermasterConst() -> String {
                let URL =  "RetailerMaster?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")!
         return URL
            }
    
//    public static let URL_getusertype = "GetUsertype?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")!
    
    public static func URL_getusertypeConst() -> String {
                  let URL =  "GetUsertype?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")!
         return URL
              }
    
//    public static var URL_getescalationreason = "GetEscalationReason?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! +  "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&CREATEDTRANSACTIONID=0&MODIFIEDTRANSACTIONID=0"
    
    public static func URL_getescalationreasonConst() -> String {
                     let URL =  "GetEscalationReason?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! +  "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&CREATEDTRANSACTIONID=0&MODIFIEDTRANSACTIONID=0"
         return URL
                 }
    
//    public static let URL_Attendancemaster = "GetUserAttnMaster?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&CREATEDTRANSACTIONID=0&MODIFIEDTRANSACTIONID=0"
    
    public static func URL_AttendancemasterConst() -> String {
                       let URL =  "GetUserAttnMaster?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&CREATEDTRANSACTIONID=0&MODIFIEDTRANSACTIONID=0"
                     return URL
                   }
    
//    public static let URL_getusercity = "GetUserCity?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&CREATEDTRANSACTIONID="
    
    public static func URL_getusercityConst() -> String {
                          let URL =  "GetUserCity?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&CREATEDTRANSACTIONID="
                    return URL
                      }
    
//    public static var URL_userlinkedcity = "GetUSERLINKCITY?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")!
    
    public static func URL_userlinkedcityConst() -> String {
        let URL =  "GetUSERLINKCITY?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")!
         return URL
    }
    
//    public static let URL_dashdetailscard = "GETUSERTARGETSALERATE?DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&ismobile=" + UserDefaults.standard.string(forKey: "ismobile")!
    
    public static func URL_dashdetailscardConst() -> String {
           let URL =  "GETUSERTARGETSALERATE?DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&ismobile=" + UserDefaults.standard.string(forKey: "ismobile")!
         return URL
       }
    
//    public static let URL_GETUSERCUSTOMEROTHINFO = "GETUSERCUSTOMEROTHINFO?DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&customercode="
    
    public static func URL_GETUSERCUSTOMEROTHINFOConst() -> String {
              let URL = "GETUSERCUSTOMEROTHINFO?DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&customercode="
              
            return URL
          }
    
    
//    public static let URL_GETUSERDISTRIBUTOR = "GETUSERDISTRIBUTOR?USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")!
//
    public static func URL_GETUSERDISTRIBUTORConst() -> String {
                 let URL = "GETUSERDISTRIBUTOR?USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")!
                 
               return URL
             }
    
//    public static var URL_ITEMMASTER = "GetUserItemMaster?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")!
//
    public static func URL_ITEMMASTERConst() -> String {
                    let URL = "GetUserItemMaster?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")!
                    
                  return URL
                }
    
//    public static let URL_PROFILEDETAIL = "GETUSERPROFILE?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")!
//
    public static func URL_PROFILEDETAILConst() -> String {
        let URL = "GETUSERPROFILE?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")!
        
      return URL
    }
//    public static let URL_GetEscalationReason = "GetEscalationReason?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&CREATEDTRANSACTIONID="
    
    public static func URL_GetEscalationReasonConst() -> String {
        let URL = "GetEscalationReason?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&CREATEDTRANSACTIONID="
        
      return URL
    }
    
//    public static var URL_GetNoOrderReasion = "GetNoOrderReasion?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")!
    
    public static func URL_GetNoOrderReasionConst() -> String {
           let URL = "GetNoOrderReasion?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")!
           
         return URL
       }
    
//    public static let URL_GETUSERHIERARCHY = "GETUSERHIERARCHY?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&CREATEDTRANSACTIONID=0&MODIFIEDTRANSACTIONID=0"
    
    public static func URL_GETUSERHIERARCHYConst() -> String {
              let URL = "GETUSERHIERARCHY?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&CREATEDTRANSACTIONID=0&MODIFIEDTRANSACTIONID=0"
              
            return URL
          }
    
//    public static let URL_GETProductCurrentday = "GetProductOfCurrentDay?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")!
    
    public static func URL_GETProductCurrentdayConst() -> String {
        let URL = "GetProductOfCurrentDay?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")!
        
      return URL
    }
    public static func URL_GETProductDayConst() -> String {
           let URL = "GetProductDay?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")!

           
         return URL
       }
    public static func URL_GETUserCurrentCityConst() -> String {
        let URL = "GetUserCurrentCity?USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")!
        
      return URL
    }
    public static func URL_GETDealerConvertConst() -> String {
        let URL = "GetDealerConvert?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")!
        
      return URL
    }
    public static func URL_ObjectionmasterConst() -> String {
           let URL = "GetObjectionMaster?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")!
           
         return URL
       }
    public static func URL_GetattandenceConst() -> String {
              let URL = "AttendanceGet?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")!
              
            return URL
          }
    public static func URL_statemasterConst() -> String {
                 let URL = "GetUserState?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&CREATEDTRANSACTIONID="
                 
               return URL
             }
//    public static func URL_getusercompetitorConst() -> String {
//        let URL = "GETUSERCOMPITITOR?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&CREATEDTRANSACTIONID=0&MODIFIEDTRANSACTIONID=0"
//
//      return URL
//    }
    
    public static func URL_getusercompetitorConst() -> String {
           let URL = "GETUSERCOMPITITOR?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")!
           
         return URL
       }
    
    public static func URL_getpendingsubdealerConst() -> String {
        let URL = "GetUserPendingSubDealerConversion?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")!
        
      return URL
    }
    public static func URL_getpendingescalationConst() -> String {
           let URL = "GETUSERPENDINGESCALATIONConversion?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")!
           
         return URL
       }
    public static func URL_getuserdrmasterConst() -> String {
              let URL = "GetUSERDRMASTER?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&CREATEDTRANSACTIONID="
              
            return URL
          }
    public static func URL_HospitalMasterConst() -> String {
        let URL = "GetHospitalMaster?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREDID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&CREATEDTRANSACTIONID="
        
      return URL
    }
    
    public static func URL_HospitalDRLinkingConst() -> String {
           let URL = "GetHospitalDRLinking?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&CREATEDTRANSACTIONID="
           
         return URL
       }
    
    public static func URL_HospitaltypeConst() -> String {
              let URL = "GetHospitalType?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREDID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&CREATEDTRANSACTIONID=0&MODIFIEDTRANSACTIONID=0"
              
            return URL
          }
    public static func URL_DRSpecializationConst() -> String {
        let URL = "DRSpecialization?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&CREATEDTRANSACTIONID=0&MODIFIEDTRANSACTIONID=0"
        
      return URL
    }
    public static func URL_GetHospitalSpecializationConst() -> String {
           let URL = "GetHospitalSpecialization?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")!
           
         return URL
       }
    public static func URL_DRTypeConst() -> String {
              let URL = "DRType?&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")!
              
            return URL
          }
    public static func URL_GetUserPriceListConst() -> String {
                 let URL = "GetUserPriceList?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREDID=" + UserDefaults.standard.string(forKey: "dataareaid")!
                 
               return URL
             }
    public static func URL_GetpdffileConst() -> String {
        let URL = "GetCircular?&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&CREATEDTRANSACTIONID=0&MODIFIEDTRANSACTIONID=0&ISMOBILE=1"
        
      return URL
    }
    public static func URL_GETUSERTAXSETUPConst() -> String {
           var URL = "GETUSERTAXSETUP?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")!
           
         return URL
       }
    public static func URL_GETUSERMYPERFORMANCEConst() -> String {
        let URL = "GETUSERMYPERFORMANCE?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")!
        
      return URL
    }
    public static func URL_GetUserNoOrderPerformanceConst() -> String {
           let URL = "GetUserNoOrderPerformance?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&ISMOBILE=1"
           
         return URL
       }
    public static func URL_GetReasonMasterConst() -> String {
              let URL = "GetReasonMaster?DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&CREATEDTRANSACTIONID="
              
            return URL
          }
    public static func URL_GetCusthospitalLinkingConst() -> String {
        let URL = "GetCustHospitalLinking?DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")!
        
      return URL
    }
    public static func URL_GetUserdeistributerLinkConst() -> String {
        let URL = "GetUserDISTRIBUTORITEMLINK?USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&CREATEDTRANSACTIONID=0&MODIFIEDTRANSACTIONID=0"
        
      return URL
    }
    public static func URL_GetsalelinkcityConst() -> String {
           let URL = "GetUserHierarchyCityLinking?USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&CREATEDTRANSACTIONID=0&MODIFIEDTRANSACTIONID=0"
           
         return URL
       }
    
    public static func URL_GetUserDistributorListConst() -> String {
              let URL = "UDF_GETUSERDISTRIBUTORLIST?USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")!
              
            return URL
          }
    public static func URL_GetTrainingDetailConst() -> String {
        let URL = "Gettraining?USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")!
        
      return URL
    }
    public static func URL_GETUSERTAXSETUPCOUNTConst() -> String {
        let URL = "GETUSERTAXSETUPCOUNT?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")!
        
        return URL
    }
    public static func URL_GetUserPriceListcountConst() -> String {
        let URL = "GetUserPriceListCount?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREDID=" + UserDefaults.standard.string(forKey: "dataareaid")!
        return URL
    }
//    public static let URL_GETProductDay = "GetProductDay?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")!
//    public static let URL_GETUserCurrentCity = "GetUserCurrentCity?USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")!
//    public static var URL_GETDealerConvert = "GetDealerConvert?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")!
//    public static var URL_Objectionmaster = "GetObjectionMaster?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")!
    public static let URL_feedbacktype = "GetDRFeedbackCode"
//    public static let URL_Getattandence = "AttendanceGet?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")!
//    public static let URL_statemaster = "GetUserState?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&CREATEDTRANSACTIONID="
 //   public static let URL_getcompetitor = "CompetitorDetails"
    
    public static func URL_getcompetitorConst() -> String {
        let URL = "CompetitorDetails1?"
        return URL
    }
    
//    public static let URL_getusercompetitor = "GETUSERCOMPITITOR?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&CREATEDTRANSACTIONID=0&MODIFIEDTRANSACTIONID=0"
//    public static let URL_getpendingsubdealer = "GetUserPendingSubDealerConversion?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")!
//    public static let URL_getpendingescalation = "GETUSERPENDINGESCALATIONConversion?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")!
//    public static let URL_getuserdrmaster = "GetUSERDRMASTER?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&CREATEDTRANSACTIONID="
//    public static let URL_HospitalMaster = "GetHospitalMaster?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREDID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&CREATEDTRANSACTIONID="
//    public static let URL_HospitalDRLinking = "GetHospitalDRLinking?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&CREATEDTRANSACTIONID="
//    public static let URL_Hospitaltype = "GetHospitalType?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREDID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&CREATEDTRANSACTIONID=0&MODIFIEDTRANSACTIONID=0"
//    public static let URL_DRSpecialization = "DRSpecialization?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&CREATEDTRANSACTIONID=0&MODIFIEDTRANSACTIONID=0"
//    public static var URL_GetHospitalSpecialization = "GetHospitalSpecialization?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")!
//    public static var URL_DRType = "DRType?&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")!
    //+ "&CREATEDTRANSACTIONID=0&MODIFIEDTRANSACTIONID=0"
//    public static var URL_GetUserPriceList = "GetUserPriceList?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREDID=" + UserDefaults.standard.string(forKey: "dataareaid")!
//    public static let URL_Getpdffile = "GetCircular?&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&CREATEDTRANSACTIONID=0&MODIFIEDTRANSACTIONID=0&ISMOBILE=1"
    //    public static let URL_GETUSERTAXSETUP = "GETUSERTAXSETUP?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")!+"&CREATEDTRANSACTIONID=0&MODIFIEDTRANSACTIONID=0&ISMOBILE=1"
//    public static var URL_GETUSERTAXSETUP = "GETUSERTAXSETUP?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")!
//    public static let URL_GETUSERMYPERFORMANCE = "GETUSERMYPERFORMANCE?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaGetAttendance==
//    public static let URL_GetUserNoOrderPerformance = "GetUserNoOrderPerformance?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&ISMOBILE=1"
//    public static let URL_GetReasonMaster = "GetReasonMaster?DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&CREATEDTRANSACTIONID="
//    public static var URL_GetCusthospitalLinking = "GetCustHospitalLinking?DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")!
//    public static let URL_GetUserdeistributerLink = "GetUserDISTRIBUTORITEMLINK?USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&CREATEDTRANSACTIONID=0&MODIFIEDTRANSACTIONID=0"
//    public static let URL_Getsalelinkcity = "GetUserHierarchyCityLinking?USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&CREATEDTRANSACTIONID=0&MODIFIEDTRANSACTIONID=0"
//    public static let URL_GetUserDistributorList = "UDF_GETUSERDISTRIBUTORLIST?USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")!
//    public static let URL_GetTrainingDetail = "Gettraining?USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")!
    
//    public static var URL_GETUSERTAXSETUPCOUNT = "GETUSERTAXSETUPCOUNT?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")!
//       public static var URL_GetUserPriceListcount = "GetUserPriceListCount?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREDID=" + UserDefaults.standard.string(forKey: "dataareaid")!
    
    // Post Api's
    public static let URL_PostSubDealer = "SubDealerConversionPost"
    public static let URL_PostMarketEscalation = "EscalationRemarksPost"
    public static let URL_PostObjection = "INS_ObjectionEntry"
    public static let URL_PostNoOrderReason = "NoOrderRemarksPost"
    public static let URL_FeedBackSubmitPostVersion2 = "FeedBackSubmitPostVersion2"
    public static let URL_PostExpense = "InsertExpenseEntry2"
    public static let URL_PostAttendance = "AttendancePost"
    public static let URL_PostHospitalMaster = "HospitalMaster3"
    public static let URL_PostDoctorMaster = "DoctorMasterPost2"
    public static let URL_PostRetailerMaster = "CustMasterPost"
    public static let URL_PosthospitalDrlinking = "HOSPITALDRLINKING"
    public static let URL_PostDoctorCustomerLinking = "DoctorCustomerLinking"
    public static let URL_postmiimage = "MIImageVersion2"
    public static let URL_postSubDealerRequest = "InsertSubDealerConversion"
    public static let URL_postCompetitorDetail = "COMPITITORDETAILSPost"
    public static let URL_postCompetitorDetailPost3 = "CustCompititorDetailsPost3"
    public static let URL_postCustHospitalLinking = "CustHospitalLinking"
    
}
