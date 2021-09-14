//
//  Databaseconnection.swift
//  tynorios
//
//  Created by Acxiom Consulting on 21/09/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import SQLite3

public class Databaseconnection: UIViewController {
    public static var dbs: OpaquePointer?
   
    public static func createdatabase (){
       
        let fileUrl = try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("TynorDatabase.sqlite")
  
        
         if sqlite3_open(fileUrl.path, &Databaseconnection.dbs) != SQLITE_OK{
            print("Error in opening Database")
            return
        }
        if(AppDelegate.isDebug){
        print("database created")
        print("path======> (\(fileUrl))")
        }
//        let configtable = "CREATE TABLE IF NOT EXISTS Login(id INTEGER PRIMARY KEY AUTOINCREMENT, usercode CHAR(255),username CHAR(255), stateid CHAR(255),password CHAR(255),usertype CHAR(255), userid CHAR(255),dataareaid CHAR(255), isblocked CHAR(255))"
        
         let CREATE_TABLE_CUSTOMER_DETAIL = "CREATE TABLE IF NOT EXISTS CustomerDetail(Contactname CHAR(255),Mobileno CHAR(255),tdmbdmcode CHAR(255),unitcode CHAR(255),customercode CHAR(255),Area CHAR(255),City CHAR(255),CustomerName CHAR(255),MetalTagId CHAR(255),Address CHAR(255),Distributor CHAR(255),State CHAR(255),lat CHAR(255),long CHAR(255))"
        
        if sqlite3_exec(dbs, CREATE_TABLE_CUSTOMER_DETAIL, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - customerdetail")
            return
        }
        
        let CREATE_TABLE_Asset_DETAIL = "CREATE TABLE IF NOT EXISTS AssetDetail(equipmentType CHAR(255),model CHAR(255),metalType CHAR(255),barCode CHAR(255),customerCode CHAR(255),assertcondition CHAR(255),actionrequired CHAR(255),workingcondition CHAR(255),complaintlodge,complainno CHAR(255),callcenter CHAR(255),purity CHAR(255),assetenvironment CHAR(255),assetvisiblefront CHAR(255),foundStatus CHAR(255),metaltagphoto blob,assestfrontphoto blob,customerSign blob,meeSign blob)"
        
        
        if sqlite3_exec(dbs, CREATE_TABLE_Asset_DETAIL, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table AssetDetail")
            return
        }
        
        let CREATE_TABLE_Cart_DETAIL = "CREATE TABLE IF NOT EXISTS CartTable(productCode CHAR(255),productName CHAR(255),size CHAR(255),qty float,totalAmount float)"
        if sqlite3_exec(dbs, CREATE_TABLE_Cart_DETAIL, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table CartTable")
            return
        }
        
        let CREATE_TABLE_RetailerList = "CREATE TABLE IF NOT EXISTS RetailerList(storeName CHAR(255),mi CHAR(255),complaint CHAR(255),dealerName CHAR(255),citys CHAR(255),lastVisitedDates CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_RetailerList, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table RetailerList")
            return
        }
        
        let CREATE_TABLE_UserPrimaryDashboard = "create table if not exists UserPrimaryDashboard(usercode text,tmonth text,targetmonth text,ptarget text,pachivement text)"
        if sqlite3_exec(dbs, CREATE_TABLE_UserPrimaryDashboard, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table UserPrimaryDashboard")
            return
        }
        let CREATE_TABLE_OrderHeader = "CREATE TABLE IF NOT EXISTS OrderHeader(orderNo CHAR(255),orderDate CHAR(255),orderValue CHAR(255),customerName CHAR(255),status CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_OrderHeader, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table OrderHeader")
            return
        }
        
        let CREATE_TABLE_OrderLine = "CREATE TABLE IF NOT EXISTS OrderLineActivity(orderNo CHAR(255),productCode CHAR(255),productName CHAR(255),size CHAR(255),orderQty CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_OrderLine, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table OrderLineActivity")
            return
        }
        
        let CREATE_TABLE_COMPETITORDETAIL = "CREATE TABLE IF NOT EXISTS COMPETITORDETAIL(dataareaid CHAR(255),compititorid CHAR(255),compititorname CHAR(255),itemid CHAR(255),itemname CHAR(255),post CHAR(255),isblocked CHAR(255),status CHAR(255), isapproved CHAR(255),createdtransactionid CHAR(255),modifiedtransactionid CHAR(255))"
        
        if sqlite3_exec(dbs, CREATE_TABLE_COMPETITORDETAIL, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table COMPETITORDETAIL")
            return
        }
        
        let CREATE_TABLE_USERDISTRIBUTOR = "CREATE TABLE IF NOT EXISTS USERDISTRIBUTOR(siteid CHAR(255),sitename CHAR(255),address CHAR(255),city CHAR(255),mobile CHAR(255),stateid CHAR(255),statename CHAR(255),salespersoncode CHAR(255),gstinno CHAR(255),email CHAR(255),pricegroup CHAR(255),plantcode text,plantstateid text,isdisplay text,distributortype text)"
        if sqlite3_exec(dbs, CREATE_TABLE_USERDISTRIBUTOR, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table USERDISTRIBUTOR")
            return
        }
        
        let CREATE_TABLE_PROFILE_DETAIL = "CREATE TABLE IF NOT EXISTS ProfileDetail(usercode CHAR(255),employeecode CHAR(255),employeename CHAR(255),address CHAR(255),city CHAR(255),pincode CHAR(255),stateid CHAR(255),statename CHAR(255),dob CHAR(255),doj CHAR(255),emailid CHAR(255),contactno CHAR(255),mobileno CHAR(255),password CHAR(255),pocket CHAR(255),sector CHAR(255),teritory CHAR(255),usertype CHAR(255),dataareaid CHAR(255),siteid CHAR(255),sponame CHAR(255),spomobile CHAR(255),asmname CHAR(255),asmmobile CHAR(255),rsmname CHAR(255),rsmmobile CHAR(255),zsmname CHAR(255),zsmmobile CHAR(255),tmname CHAR(255),tmmobile CHAR(255),nsmname CHAR(255),nsmmobile CHAR(255),salarymonth CHAR(255),aadhaar CHAR(255),docpan CHAR(255),docgst CHAR(255),docpdc CHAR(255),docaggreement CHAR(255),docaadhaar CHAR(255),doccancelledcheque CHAR(255),headquater CHAR(255),exheadquater CHAR(255),outstation CHAR(255),misc CHAR(255),Ismobileblock CHAR(255),alloweddisc CHAR(255),pricegroup CHAR(255),jobdesc CHAR(255),monthlyta CHAR(255), balanceta CHAR(255), oscount CHAR(255),balancemiscellaneous CHAR(255),showtrainbar text,istraining text)"
        if sqlite3_exec(dbs, CREATE_TABLE_PROFILE_DETAIL, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table ProfileDetail")
            return
        }
        
        let create_table_reasonmaster = "CREATE TABLE IF NOT EXISTS VW_PREFERREDREASONMASTER(dataareaid CHAR(255),reasonid CHAR(255),reasonremarks CHAR(255),CREATEDTRANSACTIONID CHAR(255),ModifiedTRANSACTIONID CHAR(255))"
        if sqlite3_exec(dbs, create_table_reasonmaster, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table VW_PREFERREDREASONMASTER")
            return
        }
        
        let CREATE_TABLE_Product_Day = "create table if not exists ProductDay(dataareaid CHAR(255),itemgroupid CHAR(255),usercode CHAR(255),pddate CHAR(255),post CHAR(255),isapprove CHAR(255),isdate CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_Product_Day, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table ProductDay")
            return
        }
        
        let CREATE_TABLE_Store_Image = "CREATE TABLE IF NOT EXISTS StoreImage(ids CHAR(255), userId CHAR(255),dataareaid CHAR(255),customercode CHAR(255),siteid CHAR(255),post CHAR(255),storestockimage blob,type CHAR(255),getdate CHAR(255),latitude CHAR(255),longitude CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_Store_Image, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table StoreImage")
            return
        }
        
        let CREATE_TABLE_item = "CREATE TABLE IF NOT EXISTS ItemMaster(itemgroup CHAR(255),itemsubgroup CHAR(255),itemgroupid CHAR(255),itemid CHAR(255),itemname CHAR(255),itemmrp CHAR(255),itempacksize CHAR(255),itemvarriantsize CHAR(255),uom CHAR(255),barcode CHAR(255),createdTransactionId CHAR(255),modifiedTransactionId CHAR(255),hsncode CHAR(255),isexempt CHAR(255),isblocked CHAR(255),ispcsapply CHAR(255),itembuyergroupid CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_item, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table ItemMaster")
            return
        }
        
        let Create_Table_postCompetitor = " CREATE TABLE IF NOT EXISTS COMPETITORDETAILPOST(DATAAREAID CHAR(255), CUSTOMERCODE CHAR(255),ITEMID CHAR(255),SITEID CHAR(255),USERCODE CHAR(255),post CHAR(255),Competitorid CHAR(255),reasonid CHAR(255),qty CHAR(255),sale CHAR(255),ispreffered CHAR(255),preffindex CHAR(255),brandname CHAR(255),isblocked CHAR(255),createdtransactionid CHAR(255),modifiedtransactionid CHAR(255))"
        if sqlite3_exec(dbs, Create_Table_postCompetitor, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table COMPETITORDETAILPOST")
            return
        }
        
        let Create_Table_saleorder = "CREATE TABLE IF NOT EXISTS sodetails(siteid CHAR(255), customercode CHAR(255),dataareaid CHAR(255),sono CHAR(255),sodate CHAR(255),sovalue CHAR(255),status CHAR(255),lineno CHAR(255),itemid CHAR(255),discamt CHAR(255),taxprec CHAR(255),taxamt CHAR(255),amount CHAR(255))"
        if sqlite3_exec(dbs, Create_Table_saleorder, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table sodetails")
            return
        }
        
        let CREATE_TABLE_ATTENDANCE = "create table if not exists Attendance(usercode CHAR(255),status CHAR(255),lat CHAR(255),lon CHAR(255),attendancedate,post CHAR(255),usertype CHAR(255),dataareaid CHAR(255),isblocked CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_ATTENDANCE, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table Attendance")
            return
        }
        
        let CREATE_TABLE_RETAILER_MASTER = "create table if not exists RetailerMaster(customercode CHAR(255),customername CHAR(255),customertype CHAR(255),contactperson CHAR(255),mobilecustcode CHAR(255),\n" +
        "mobileno CHAR(255),alternateno CHAR(255),emailid CHAR(255),address CHAR(255),pincode CHAR(255),city CHAR(255),stateid CHAR(255),gstno CHAR(255),gstregistrationdate CHAR(255),siteid CHAR(255),\n" +
        "salepersonid CHAR(255),keycustomer CHAR(255),isorthopositive CHAR(255),sizeofretailer CHAR(255),category CHAR(255),isblocked CHAR(255),pricegroup CHAR(255),dataareaid CHAR(255),\n" +
        "latitude CHAR(255),longitude CHAR(255),orthopedicsale CHAR(255),avgsale CHAR(255),prefferedbrand CHAR(255),secprefferedbrand CHAR(255),secprefferedsale CHAR(255),\n" +
        "prefferedsale CHAR(255),prefferedreasonid CHAR(255),secprefferedreasonid CHAR(255),createdtransactionid CHAR(255),modifiedtransactionid CHAR(255),post CHAR(255),referencecode CHAR(255),lastvisited CHAR(255),storeimage CHAR(255),stockimage CHAR(255),prefferedothbrand CHAR(255),secprefferedothbrand CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_RETAILER_MASTER, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table RetailerMaster")
            return
        }
        
        let CREATE_TABLE_City_Master = "create table if not exists CityMaster(CityID CHAR(255),CityName CHAR(255),stateid CHAR(255),createdtransactionid CHAR(255),modifiedtransactionid CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_City_Master, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table CityMaster")
            return
        }
        
        let CREATE_TABLE_State_Master = "create table if not exists StateMaster(StateID CHAR(255),StateName CHAR(255),Gststatecode CHAR(255),isunion CHAR(255),CREATEDTRANSACTIONID CHAR(255),ModifiedTransactionId CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_State_Master, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table StateMaster")
            return
        }
        
        let CREATE_TABLE_DOCTOR_MASTER = "CREATE TABLE IF NOT EXISTS DRMASTER(dataareaid CHAR(255) , drcode CHAR(255) , drname CHAR(255), mobileno CHAR(255),alternateno CHAR(255),emailid CHAR(255),address CHAR(255),pincode CHAR(255),city CHAR(255),stateid CHAR(255),dob CHAR(255),doa CHAR(255),isblocked CHAR(255),ispurchaseing CHAR(255),ispriscription CHAR(255),CREATEDTRANSACTIONID CHAR(255) ,MODIFIEDTRANSACTIONID CHAR(255),POST CHAR(255),drspecialization CHAR(255),purchaseamt CHAR(255),noofprescription CHAR(255),siteid CHAR(255),isbuying CHAR(255),drtype CHAR(255),custrefcode CHAR(255),salepersoncode CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_DOCTOR_MASTER, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table DRMASTER")
            return
        }
        
        let CREATE_TABLE_HOSPITAL_TYPE = "CREATE TABLE IF NOT EXISTS HospitalType(dataareaid CHAR(255) ,  typeid CHAR(255) , typedesc CHAR(255)  ,  isblocked CHAR(255), createdtransactionid CHAR(255),modifiedtransactionid CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_HOSPITAL_TYPE, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table HospitalType")
            return
        }
        
        let CREATE_TABLE_HOSPITAL_MASTER = "CREATE TABLE IF NOT EXISTS HospitalMaster(DATAAREAID CHAR(255) , TYPE CHAR(255) ,HOSCODE CHAR(255), HOSNAME CHAR(255) , MOBILENO CHAR(255) , ALTNUMBER CHAR(255)" +
        ",EMAILID CHAR(255),CityID CHAR(255),ADDRESS CHAR(255),PINCODE CHAR(255),STATEID CHAR(255),ISBLOCKED CHAR(255),CREATEDTRANSACTIONID CHAR(255),MODIFIEDTRANSACTIONID  CHAR(255),POST CHAR(255)," +
        "PURCHASEMGR  CHAR(255) ,AUTHORISEDPERSON   CHAR(255) ,PURCHMGRMOBILENO CHAR(255),AUTHPERSONMOBILENO CHAR(255),DEGISNATION  CHAR(255) ,BEDCOUNT  CHAR(255) ,CATEGORY  CHAR(255) ,SITEID  CHAR(255) ,HOSPITALTYPE  CHAR(255) ,ISPURCHASE CHAR(255),monthlypurchase CHAR(255),custrefcode CHAR(255),salepersoncode CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_HOSPITAL_MASTER, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table HospitalMaster")
            return
        }
        
        let CREATE_TABLE_USERDRLINKING = "CREATE TABLE IF NOT EXISTS userDRCustLinking( dataareaid  CHAR(255), siteid  CHAR(255),customercode  CHAR(255),drcode CHAR(255),isblocked  CHAR(255),ispurchaseing  CHAR(255),ispriscription  CHAR(255),createdtransactionid  CHAR(255),modifiedtransactionid  CHAR(255),post CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_USERDRLINKING, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table userDRCustLinking")
            return
        }
        
        let CREATE_TABLE_HospitalDRLinking = "CREATE TABLE IF NOT EXISTS HospitalDRLinking(dataareaid CHAR(255), drcode CHAR(255), hospitalcode   CHAR(255) ,isblocked CHAR(255),RECID CHAR(255),CREATEDBY datetime default current_timestamp,post CHAR(255),CREATEDTRANSACTIONID CHAR(255),ModifiedTransactionId CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_HospitalDRLinking, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table HospitalDRLinking")
            return
        }
        
        let CREATE_TABLE_UserPriceList = "CREATE TABLE IF NOT EXISTS UserPriceList(srl  CHAR(255), dataareaid CHAR(255) ,pricegroupid CHAR(255) ,itemid    CHAR(255) ,price   CHAR(255),uom    CHAR(255) ,mrp   CHAR(255),createdtransactionid   CHAR(255),modifiedtransactionid   CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_UserPriceList, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table UserPriceList")
            return
        }
        
        let CREATE_TABLE_SOHEADER = "Create table if not exists SOHEADER (USERID CHAR(255),SITEID CHAR(255), SONO  CHAR(255), SODATE  CHAR(255), CUSTOMERCODE  CHAR(255), APPAPPROVEDATE  CHAR(255), LATITUDE  CHAR(255), LONGITUDE  CHAR(255), DISTGSTNO  CHAR(255), CUSTGSTNO  CHAR(255),  DISTCOMPOSITIONSCHEME  CHAR(255), BILLADDRESS  CHAR(255),  BILLSTATEID  CHAR(255),approved CHAR(255),post CHAR(255),DISCPERC CHAR(255),Remark CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_SOHEADER, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table SOHEADER")
            return
        }
        
        let CREATE_TABLE_SOLINE = "Create table if not exists SOLINE (SITEID  CHAR(255) , SONO   CHAR(255),  LINENO   CHAR(255) , CUSTOMERCODE   CHAR(255) , ITEMID   CHAR(255),  QTY   CHAR(255) , RATE   CHAR(255) , LINEAMOUNT   CHAR(255), DISCPERC   CHAR(255), DISCAMT   CHAR(255) , DISCTYPE   CHAR(255) , SECPERC   CHAR(255) , SECAMT   CHAR(255) , TAXABLEAMOUNT   CHAR(255),  TAX1COMPONENT   CHAR(255) , TAX1PERC   CHAR(255),  TAX1AMT   CHAR(255) , TAX2COMPONENT   CHAR(255) , TAX2PERC   CHAR(255) , TAX2AMT   CHAR(255) , AMOUNT   CHAR(255), post CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_SOLINE, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table SOLINE")
            return
        }
        
        let CREATE_TABLE_SUBDEALERS = "create table if not exists SubDealers(customercode CHAR(255),expectedsale CHAR(255),expectedDiscount CHAR(255),dataareaid CHAR(255),recid CHAR(255),submitdate CHAR(255),status CHAR(255),approvedby CHAR(255),siteid CHAR(255),createdtransactionid CHAR(255),modifiedtransactionid CHAR(255),post CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_SUBDEALERS, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table SubDealers")
            return
        }
        
        let CREATE_TABLE_UserLinkCity = "create table if not exists UserLinkCity(cityid CHAR(255),locationtype CHAR(255),dataareaid CHAR(255),isblocked CHAR(255),createdtransactionid CHAR(255),modifiedtransactionid CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_UserLinkCity, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table UserLinkCity")
            return
        }
        
        let CREATE_TABLE_UserCurrentCity = "Create table if not exists UserCurrentCity(date CHAR(255),city CHAR(255),isblocked CHAR(255),post CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_UserCurrentCity, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table UserCurrentCity")
            return
        }
        
        let CREATE_TABLE_USERTAXSETUP = "Create table if not exists usertaxsetup(srl CHAR(255), hsncode CHAR(255), dataareaid CHAR(255),fromstateid CHAR(255),tostateid CHAR(255),taxserialno CHAR(255),taxcomponentid CHAR(255),taxper CHAR(255),createdtransactionid CHAR(255),modifiedtransactionid CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_USERTAXSETUP, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table usertaxsetup")
            return
        }
        
        let CREATE_TABLE_USERTYPE = "Create table if not exists usertype(sno CHAR(255),id CHAR(255),type CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_USERTYPE, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table usertype")
            return
        }
        
        
        
        let CREATE_TABLE_NoOrderReasonMaster = "create table if not exists NoOrderReasonMaster (recid CHAR(255),  reasoncode CHAR(255) , reasondescription CHAR(255) ,   createdtransactionid CHAR(255), modifiedtransactionid CHAR(255), isblock CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_NoOrderReasonMaster, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table NoOrderReasonMaster")
            return
        }
        
        let CREATE_TABLE_NoOrderRemarksPost = "create table if not exists NoOrderRemarksPost (DATAAREAID CHAR(255), STATUSID CHAR(255) ,REASONCODE CHAR(255) ,CUSTOMERCODE CHAR(255) ,SITEID CHAR(255) , SUBMITTIME CHAR(255) ,REMARKS CHAR(255),LATITUDE CHAR(255) ,LONGITUDE CHAR(255) ,USERCODE CHAR(255) ,ISMOBILE CHAR(255) ,post CHAR(255),date CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_NoOrderRemarksPost, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table NoOrderRemarksPost")
            return
        }
        
        let CREATE_TABLE_NoOrderRemarks = "create table if not exists NoOrderRemarks(DATAAREAID CHAR(255), STATUSID CHAR(255) ,REASONCODE CHAR(255) ,CUSTOMERCODE CHAR(255) ,SITEID CHAR(255) , SUBMITTIME CHAR(255),remarks CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_NoOrderRemarks, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table NoOrderRemarks")
            return
        }
        
        let CREATE_TABLE_ESCALATION_REASON = "create table if not exists EscalationReason(reasoncode CHAR(255),reasondescription CHAR(255),CREATEDTRANSACTIONID CHAR(255),ModifiedTransactionId CHAR(255),isblock CHAR(255),recid CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_ESCALATION_REASON, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table EscalationReason")
            return
        }
        
        let CREATE_TABLE_marketescalation = "CREATE TABLE IF NOT EXISTS MarketEscalationActivity(escalationCode CHAR(255),date CHAR(255),status CHAR(255),reason CHAR(255),detail CHAR(255),post CHAR(255),latitude CHAR(255),longitude CHAR(255),datareaid CHAR(255),customercode CHAR(255),siteid CHAR(255),createdby CHAR(255),username CHAR(255),closeremarks CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_marketescalation, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table MarketEscalationActivity")
            return
        }
        
        let CREATE_TABLE_COMPLAINT = "CREATE TABLE IF NOT EXISTS complains(compid CHAR(255),DATAAREAID CHAR(255), FEEDBACKTYPE CHAR(255), CATEGORY CHAR(255), SITEID CHAR(255), ITEMID CHAR(255), FEEDBACKDESC CHAR(255),SUBMITDATETIME CHAR(255),CUSTOMERCODE CHAR(255), USERCODE CHAR(255),post CHAR(255),LATITUDE CHAR(255),LONGITUDE CHAR(255),createdby CHAR(255),image text)"
        if sqlite3_exec(dbs, CREATE_TABLE_COMPLAINT, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table complains")
            return
        }
        
        let CREATE_TABLE_Feedbacktype = "CREATE TABLE IF NOT EXISTS feedbacktype(typecode CHAR(255),feedbacK_TYPE CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_Feedbacktype, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table feedbacktype")
            return
        }
        
        let CREATE_TABLE_Feedbacks = "CREATE TABLE IF NOT EXISTS feedbacks(dataareaid CHAR(255),feedbackcode CHAR(255),feedbacktype CHAR(255), category CHAR(255),itemid CHAR(255), feedbackstatus CHAR(255),  customercode CHAR(255),  submitdatetime CHAR(255) ,detail CHAR(255),colorstatus CHAR(255),closerremark CHAR(255),usercodename CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_Feedbacks, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table feedbacks")
            return
        }
        
        let CREATE_TABLE_CIRCULAR = "CREATE TABLE IF NOT EXISTS Circular(sno CHAR(255),filename CHAR(255),type CHAR(255),url CHAR(255),description CHAR(255),uploaddate CHAR(255),uploadtime CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_CIRCULAR, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table Circular")
            return
        }
        
        let CREATE_TABLE_USERCUSTOMEROTHINFO = "CREATE TABLE IF NOT EXISTS USERCUSTOMEROTHINFO (customercode CHAR(255) ,lms CHAR(255),avgsale CHAR(255),reasoN1 CHAR(255)  ,reasoN2 CHAR(255)  ,complain CHAR(255),escalation CHAR(255),currentmonth CHAR(255),lastvisit CHAR(255), isescalated text,lastactivity CHAR(255),lastactivityid CHAR(255),ispendingsubconv CHAR(255),ispendingcomplain CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_USERCUSTOMEROTHINFO, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table USERCUSTOMEROTHINFO")
            return
        }
        
        let CREATE_TABLE_attendancereport = "CREATE TABLE IF NOT EXISTS attendancereport(date CHAR(255),usercode CHAR(255),daystart CHAR(255),dayend CHAR(255),hours CHAR(255))"
        
        if sqlite3_exec(dbs, CREATE_TABLE_attendancereport, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table attendancereport")
            return
        }
        
        let CREATE_TABLE_SUBDEALERSENTRY = "create table if not exists SubDealersEntry(customercode CHAR(255),expectedsale CHAR(255),expectedDiscount CHAR(255),dataareaid CHAR(255),recid CHAR(255),submitdate CHAR(255),status CHAR(255),approvedby CHAR(255),siteid CHAR(255),createdtransactionid CHAR(255),modifiedtransactionid CHAR(255),rejectreason CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_SUBDEALERSENTRY, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table SubDealersEntry")
            return
        }
        
        let CREATE_TABLE_DRType = "create table if not exists DRType(sno CHAR(255), typeid CHAR(255), typedesc CHAR(255),status CHAR(255), isblocked CHAR(255),createdtransactionid CHAR(255), modifiedtransactionid CHAR(255),ismandatory CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_DRType, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table DRType")
            return
        }
        
        
      
        
        let CREATE_TABLE_DRSpecialization = "create table if not exists  DRSpecialization(sno CHAR(255), typeid CHAR(255), typedesc CHAR(255),status CHAR(255), isblocked CHAR(255),createdtransactionid CHAR(255), modifiedtransactionid CHAR(255),drtypeid CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_DRSpecialization, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table DRSpecialization")
            return
        }
        
        let CREATE_TABLE_hospitalspecialization = "create table if not exists hospitalspecialization (dataareaid    CHAR(255),typeid    CHAR(255),typedesc    CHAR(255),isblocked    CHAR(255), status   CHAR(255), createdtransactionid   CHAR(255), modifiedtransactionid   CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_hospitalspecialization, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table hospitalspecialization")
            return
        }
        
        let CREATE_TABLE_ChangePassword = "create table if not exists ChangePassword(id CHAR(255),password CHAR(255),userid CHAR(255),dataareaid CHAR(255),post CHAR(255),oldpassword CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_ChangePassword, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table ChangePassword")
            return
        }
        let CREATE_TABLE_ObjectionMaster = "create table if not exists ObjectionMaster(objectioncode CHAR(255),objectiondesc CHAR(255),createdtransactionid CHAR(255),modifiedtransactionid CHAR(255),status CHAR(255),isblocked CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_ObjectionMaster, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table ObjectionMaster")
            return
        }
        
        let CREATE_TABLE_ObjectionEntry = "create table if not exists ObjectionEntry (dataareaid CHAR(255), objectionid CHAR(255), objectioncode CHAR(255), customercode CHAR(255), siteid CHAR(255), submittime CHAR(255), status CHAR(255), remarks CHAR(255),latitude CHAR(255) ,longitude CHAR(255),userid CHAR(255),post CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_ObjectionEntry, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table ObjectionEntry")
            return
        }
        
        let CREATE_TABLE_CUSTHOSPITALLINKING = "create table if not exists CUSTHOSPITALLINKING(DATAAREAID CHAR(255),SITEID CHAR(255),CUSTOMERCODE CHAR(255),HOSPITALCODE CHAR(255),ISBLOCKED CHAR(255),CREATEDTRANSACTIONID CHAR(255),modifiedtransactionid CHAR(255),post CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_CUSTHOSPITALLINKING, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table CUSTHOSPITALLINKING")
            return
        }
        
        let CREATE_TABLE_USERHIERARCHY = "create table if not exists  USERHIERARCHY(usercode CHAR(255),usertype CHAR(255),employeecode CHAR(255), empname CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_USERHIERARCHY, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table USERHIERARCHY")
            return
        }
        
        let CREATE_TABLE_TRAININGDETAIL = "create table if not exists TrainingDetail(TRAININGID CHAR(255),DATAAREAID CHAR(255),TRAININGDATE CHAR(255),TRAINEDTO CHAR(255),TRAININGSTARTTIME CHAR(255),TRAININGENDTIME CHAR(255),REMARKS CHAR(255),USERCODE CHAR(255),USERTYPE CHAR(255),ISMOBILE CHAR(255),POST CHAR(255),status CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_TRAININGDETAIL, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table TrainingDetail")
            return
        }
        
        let CREATE_TABLE_TransportMode = "create table if not exists  TransportMode(sno CHAR(255), transpoterid CHAR(255), transpoterdesc CHAR(255), isblocked CHAR(255), status CHAR(255), createdtransactionid CHAR(255), modifiedtransactionid CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_TransportMode, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table TransportMode")
            return
        }
        
        let CREATE_TABLE_Miscellaneous = "create table if not exists  Miscellaneous(recid CHAR(255), expensecode CHAR(255), expensedescription CHAR(255), isblocked CHAR(255), status CHAR(255), createdtransactionid CHAR(255), modifiedtransactionid CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_Miscellaneous, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table Miscellaneous")
            return
        }
        
        
        let CREATE_TABLE_initiallog = "CREATE TABLE IF NOT EXISTS initiallog (sno CHAR(255), methodname CHAR(255),syncdatetime CHAR(255), logstat CHAR(255),post CHAR(255),decription CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_initiallog, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table initiallog")
            return
        }
        
        
        let CREATE_TABLE_userlog = "CREATE TABLE IF NOT EXISTS userlog (logid CHAR(255), syncdate CHAR(255),syncvrsn CHAR(255), manufacturer CHAR(255), model CHAR(255), osversion CHAR(255), logstat CHAR(255),post CHAR(255),tablename CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_userlog, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table userlog")
            return
        }
        
        
       
        let CREATE_TABLE_superdealer = "create table if not exists superdealer(partyname CHAR(255),ownername CHAR(255) ,boulder CHAR(255),sandpocket CHAR(255), transporter CHAR(255), postaladdress CHAR(255), pincode CHAR(255), state CHAR(255),city CHAR(255), gstnumber CHAR(255),dateofest CHAR(255), mobile CHAR(255), landline CHAR(255), permanentaddress CHAR(255),totsales CHAR(255),salepmnth CHAR(255), totdis CHAR(255), email CHAR(255),paymentmmthd CHAR(255),billinadd CHAR(255),shipnadd CHAR(255),pocket CHAR(255),sector CHAR(255),spclinstructions CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_superdealer, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table superdealer")
            return
        }
        
        let CREATE_TABLE_Transporters = "CREATE TABLE IF NOT EXISTS Transporters (sno CHAR(255),transpoterid CHAR(255),transpoterdesc CHAR(255),status CHAR(255),isblocked CHAR(255),createdtransactionid CHAR(255),modifiedtransactionid CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_Transporters, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table Transporters")
            return
        }
        let CREATE_TABLE_PaymentTerm = "CREATE TABLE IF NOT EXISTS PaymentTerm (paymentid CHAR(255),paymentdesc CHAR(255),status CHAR(255),isblocked CHAR(255),createdtransactionid CHAR(255),modifiedtransactionid CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_PaymentTerm, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table PaymentTerm")
            return
        }
        
        // USERMYPERFORMANCE(usercode CHAR(255), total CHAR(255), tynorp CHAR(255),tynorn CHAR(255),ptarget CHAR(255),pachivement CHAR(255))
        let CREATE_TABLE_USERMYPERFORMANCE = "CREATE TABLE IF NOT EXISTS USERMYPERFORMANCE(usercode CHAR(255), total CHAR(255), tynorp CHAR(255),tynorn CHAR(255),ptarget CHAR(255),pachivement CHAR(255),starget CHAR(255),sachivement CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_USERMYPERFORMANCE, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table USERMYPERFORMANCE")
            return
        }
        
        let CREATE_TABLE_UserNoOrderPerformance = "create table if not exists UserNoOrderPerformance(usercode CHAR(255),reasondescription CHAR(255),noofcount CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_UserNoOrderPerformance, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table UserNoOrderPerformance")
            return
        }
        
        let CREATE_TABLE_USERTARGETSALERATE = "create table if not exists USERTARGETSALERATE(usercode CHAR(255), ptarget CHAR(255), psalerate CHAR(255),preqrate CHAR(255), starget CHAR(255), ssalerate CHAR(255), sreqrate CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_USERTARGETSALERATE, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table USERTARGETSALERATE")
            return
        }
        
        let CREATE_TABLE_Expense = "create table if not exists Expense(expenseid CHAR(255),expensedate CHAR(255),location CHAR(255),da CHAR(255),ta CHAR(255),hotelexpense CHAR(255),miscellanous CHAR(255),expenseimage text,expenseimage2 text,expenseimage3 text,expenseimage4 text,post CHAR(255),workingtype CHAR(255) )"
        if sqlite3_exec(dbs, CREATE_TABLE_Expense, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table Expense")
            return
        }

        let CREATE_TABLE_PURCHINDENTHEADER = "create table if not exists   PURCHINDENTHEADER (SITEID CHAR(255),INDENTNO CHAR(255),INDENTDATE CHAR(255),DATAAREAID CHAR(255),STATUS CHAR(255),PLANTCODE CHAR(255),POST CHAR(255),LATITUDE CHAR(255) ,LONGITUDE CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_PURCHINDENTHEADER, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table PURCHINDENTHEADER")
            return
        }
        
        
        let CREATE_TABLE_PURCHINDENTLINE = "create table if not exists   PURCHINDENTLINE (INDENTNO CHAR(255),SITEID CHAR(255),LINENO CHAR(255),ITEMGROUP CHAR(255),ITEMID CHAR(255),QUANTITY CHAR(255),RATE CHAR(255),LINEAMOUNT CHAR(255),TAX1PER CHAR(255),TAX1AMT CHAR(255),TAX1COMPONENT CHAR(255),TAX2PER CHAR(255),TAX2AMT CHAR(255),TAX2COMPONENT CHAR(255),AMOUNT CHAR(255),POST CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_PURCHINDENTLINE, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table PURCHINDENTLINE")
            return
        }
        
        let CREATE_TABLE_ExpenseReport = "create table if not exists ExpenseReport(expenseid CHAR(255),expensedate CHAR(255),da CHAR(255),ta CHAR(255),hotelexpense CHAR(255),miscellanous CHAR(255),workingtype CHAR(255),total CHAR(255),cityname CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_ExpenseReport, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table ExpenseReport")
            return
        }
        
        //    AttendanceMaster(attnid CHAR(255),attndesc CHAR(255),isblock CHAR(255))
        let CREATE_TABLE_AttendanceMaster = "create table if not exists AttendanceMaster(attnid CHAR(255),attndesc CHAR(255),isblock CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_AttendanceMaster, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table AttendanceMaster")
            return
        }
        
        let CREATE_TABLE_Pendingsubdealer = "create table if not exists Pendingsubdealer(recid CHAR(255), customercode CHAR(255), customername CHAR(255) ,distributorcode CHAR(255), distributorname CHAR(255), expsale CHAR(255), expdiscount CHAR(255), usercode CHAR(255), submitdate CHAR(255), type CHAR(255), conV_REQUEST CHAR(255), username CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_Pendingsubdealer, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table Pendingsubdealer")
            return
        }
        let CREATE_TABLE_IndentDetails = "create table if not exists  IndentDetails (siteid CHAR(255) ,indentno CHAR(255) , indentdate CHAR(255) ,requireddate CHAR(255) ,plantcode CHAR(255)  ,plantname CHAR(255)  ,lineno CHAR(255)  ,itemid CHAR(255) , itemname CHAR(255) , itemvarriantsize CHAR(255)  , itemgroup CHAR(255) , lineamount CHAR(255) , quantity CHAR(255) , rate CHAR(255)  , uom CHAR(255)  , taX1COMPONENT CHAR(255) ,  taX1PER CHAR(255) , taX1AMT CHAR(255)  , taX2COMPONENT CHAR(255)  ,taX2PER CHAR(255)  , taX2AMT CHAR(255) , amount CHAR(255)  , generateD_BY CHAR(255)  , action CHAR(255), createdby text,sono CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_IndentDetails, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table IndentDetails")
            return
        }
        let CREATE_TABLE_USERDISTRIBUTORITEMLINK = "create table if not exists USERDISTRIBUTORITEMLINK(dataareaid CHAR(255),siteid CHAR(255),itemgrpid CHAR(255),createdtransactionid CHAR(255),modifiedtransactionid CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_USERDISTRIBUTORITEMLINK, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table USERDISTRIBUTORITEMLINK")
            return
        }
        
        let CREATE_TABLE_NOTIFICATIONTABLE = "create table if not exists NOTIFICATIONTABLE(datetime CHAR(255),title CHAR(255),message CHAR(255),status CHAR(255),recid CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_NOTIFICATIONTABLE, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table NOTIFICATIONTABLE")
            return
        }
        
        let CREATE_TABLE_fcmtable = "create table if not exists fcmtable(fcmkey CHAR(255),post CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_fcmtable, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table fcmtable")
            return
        }
        
        let CREATE_TABLE_Demonstrationtable = "create table if not exists demonstration(customercode CHAR(255),itemgroupid CHAR(255),date CHAR(255),latitude CHAR(255),longitude CHAR(255),post CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_Demonstrationtable, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table demonstration")
            return
        }
        
        let CREATE_TABLE_InsertSubDealerRequest = "create table if not exists InsertSubDealerRequest(dataareaid CHAR(255),status CHAR(255),expdiscount CHAR(255),recid CHAR(255),usercode CHAR(255),rejectreason CHAR(255),post CHAR(255),customercode CHAR(255))"
        if sqlite3_exec(dbs, CREATE_TABLE_InsertSubDealerRequest, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table InsertSubDealerRequest")
            return
        }
       
        let CREATE_TABLE_salelinkcity = "create table if not exists salelinkcity(usercode text,usertype text,cityid text,locationtype text,isblocked text,createdid text,modifiedid text,stateid text)"
        if sqlite3_exec(dbs, CREATE_TABLE_salelinkcity, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table salelinkcity")
            return
        }
        
        let CREATE_TABLE_USERDISTRIBUTORLIST = "create table if not exists USERDISTRIBUTORLIST(siteid text,usercode text,salepercent text,isdisplay text)";
        if sqlite3_exec(dbs, CREATE_TABLE_USERDISTRIBUTORLIST, nil, nil, nil) != SQLITE_OK
        {
            print("Error creating table USERDISTRIBUTORLIST")
            return
        }
        
        let CREATE_TABLE_usertrainings = "create table if not exists usertrainings(traineename text,trainingid text,startdatetime text)";
        
        if sqlite3_exec(dbs, CREATE_TABLE_usertrainings, nil, nil, nil) != SQLITE_OK
        {
            print("Error creating table usertrainings")
            return
        }
        
        let CREATE_TABLE_RetailerlistSearch = "create table if not exists retailerlistsearch(customername text, lastvisit text, cityname text ,sitename text, currmonth text, complain text, mi text, customercode text , keycustomer text)";
              if sqlite3_exec(dbs, CREATE_TABLE_RetailerlistSearch, nil, nil, nil) != SQLITE_OK
              {
                  print("Error creating table CREATE_TABLE_RetailerlistSearch")
                  return
              }
        
        print("Everything is Fine")
        
    }
    
    public func deletesubdealers (){
        let query = "delete from SubDealers"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table SubDealers ")
            return
        }
        print("SubDealers table deleted")
    }
    
    public func deleteretailerlistsearch (){
        let query = "delete from retailerlistsearch"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table retailerlistsearch ")
            return
        }
        if(AppDelegate.isDebug){
        print("retailerlistsearch table deleted")
        }
    }
    
    public func deleteusertrainings (){
        let query = "delete from usertrainings"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table usertrainings ")
            return
        }
        print("usertrainings table deleted")
    }
    public func deleteTrainingdetail (){
        let query = "delete from TrainingDetail"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table TrainingDetail ")
            return
        }
        print("TrainingDetail table deleted")
    }
    public func deleteProfiledetail(){
        let query = "delete from ProfileDetail"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table ProfileDetail ")
            return
        }
        print("ProfileDetail table ProfileDetail")
    }
    public func deleteescalationreason(){
        let query = "delete from EscalationReason"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table EscalationReason ")
            return
        }
        print("EscalationReason table EscalationReason")
    }
    public func deleteNoOrderReasonMaster(){
        let query = "delete from NoOrderReasonMaster"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table NoOrderReasonMaster ")
            return
        }
        print("NoOrderReasonMaster table NoOrderReasonMaster")
    }
    
    public func deleteitemmaster(){
        let query = "delete from ItemMaster"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table ItemMaster ")
            return
        }
        print("ItemMaster table deleted")
    }
    public func deleteattendancereport () {
        let query = "delete from attendancereport"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table attendance report")
            return
        }
        
        print("Attendance report table deleted")
    }
    public func deleteuserDRCustLinking () {
        let query = "delete from userDRCustLinking"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table userDRCustLinking")
            return
        }
        
        print("userDRCustLinking table deleted")
    }//userDRCustLinking
    public func deleteusercustomer () {
        let query = "delete from USERCUSTOMEROTHINFO"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table USERCUSTOMEROTHINFO")
            return
        }
        
        print("USERCUSTOMEROTHINFO table deleted")
    }
    public func deleteindentdetails(){
        let query = "delete from IndentDetails"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table IndentDetails ")
            return
        }
        print("IndentDetails table deleted")
    }
    
    public func deletesodeatils(){
        let query = "delete from sodetails"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table sodetails ")
            return
        }
        print("sodetails table deleted")
    }
    public func deletecomplaintreport () {
        let query = "delete from feedbacks"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table feedbacks report")
            return
        }
        
        print("feedbacks table deleted")
    }
    public func deletefeedbacktype () {
        let query = "delete from feedbacktype"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table feedbacktype")
            return
        }        
        print("feedbacktype table deleted")
    }
    public func deleteusertype () {
        let query = "delete from usertype"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table Usertype")
            return
        }
        
        print("usertype table deleted")
    }
    public func deleteEscalationReason () {
        let query = "delete from EscalationReason"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table EscalationReason")
            return
        }
        print("EscalationReason table deleted")
    }
    
    public func deleteescalationreport() {
        let query = "delete from MarketEscalationActivity where post='2'"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table MarketEscalationActivity")
            return
        }
        print("MarketEscalationActivity table deleted")
    }

    public func deletsubdelaerentry() {
        let query = "delete from SubDealersEntry"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table SubDealersEntry")
            return
        }
        
        print("SubDealersEntry table deleted")
    }
       public func deleteexpensereport () {
        let query = "delete from ExpenseReport"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table expense report")
            return
        }
        
        print("expense report table deleted")
    }
    public func deleteCircular(){
        let query = "delete from Circular"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table Circular ")
            return
        }
        print("Circular table deleted")
    }
    public func deleteExpense(){
        let query = "delete from Expense"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table Expense ")
            return
        }
        print("Expense table deleted")
    }
    public func deleteretailermaster ()
    {
        let query = "delete from RetailerMaster"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table RetailerMaster")
            return
        }
        print("RetailerMaster table deleted")
    }
    public func deleteAttendanceMaster ()
    {
        let query = "delete from AttendanceMaster"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table AttendanceMaster")
            return
        }
        print("AttendanceMaster table deleted")
    }
    public func deleteStateMaster ()
    {
        let query = "delete from StateMaster"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table StateMaster")
            return
        }
        print("StateMaster table deleted")
    }
    public func deleteCityMaster ()
    {
        let query = "delete from CityMaster"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            if(AppDelegate.isDebug){
                print("Error deleting Table CityMaster")
            }
            return
        }
        if(AppDelegate.isDebug){
            print("CityMaster table deleted")
        }
    }
    public func deleteUserLinkCity ()
    {
        let query = "delete from UserLinkCity"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table UserLinkCity")
            return
        }
        print("UserLinkCity table deleted")
    }
    public func deletehospitalspecialization ()
    {
        let query = "delete from hospitalspecialization"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table hospitalspecialization")
            return
        }
        print("hospitalspecialization table deleted")
    }
    public func deleteDRSpecialization ()
    {
        let query = "delete from DRSpecialization"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table DRSpecialization")
            return
        }
        print("DRSpecialization table deleted")
    }
    //DRSpecialization
    public func deleteUSERDISTRIBUTOR ()
    {
        let query = "delete from USERDISTRIBUTOR"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table USERDISTRIBUTOR")
            return
        }
        print("USERDISTRIBUTOR table deleted")
    }
    public func deleteUSERHIERARCHY(){
        let query = "delete from USERHIERARCHY"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table USERHIERARCHY ")
            return
        }
        print("USERHIERARCHY table deleted")
    }    
    
    public func deleteUserCurrentCity(){
        let query = "delete from UserCurrentCity"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table UserCurrentCity ")
            return
        }
        print("UserCurrentCity table deleted")
    }
    public func deleteuserprimary(){
        let query = "delete from UserPrimaryDashboard"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table UserPrimaryDashboard ")
            return
        }
        print("UserPrimaryDashboard table deleted")
    }
    public func deleteObjectionMaster(){
        let query = "delete from ObjectionMaster"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table ObjectionMaster ")
            return
        }
        print("ObjectionMaster table deleted")
    }
    public func deleteObjectionEntry(){
        let query = "delete from ObjectionEntry"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table ObjectionEntry ")
            return
        }
        print("ObjectionEntry table deleted")
    }
    public func deleteNoOrderRemarks(){
        let query = "delete from NoOrderRemarks"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table NoOrderRemarks ")
            return
        }
        print("NoOrderRemarks table deleted")
    }
    public func deletedashdetailcard(){
        let query = "delete from USERTARGETSALERATE"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table USERTARGETSALERATE ")
            return
        }
        print("USERTARGETSALERATE table deleted")
    }
    public func deleteproductday(){
        let query = "delete from ProductDay"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table ProductDay ")
            return
        }
        print("ProductDay table deleted")
    }
    public func deleteHospitaltype ()
    {
        let query = "delete from Hospitaltype"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table Hospitaltype")
            return
        }
        print("Hospitaltype table deleted")
    }
    public func deleteHospitalDRLinking ()
    {
        let query = "delete from HospitalDRLinking"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table HospitalDRLinking")
            return
        }
        print("HospitalDRLinking table deleted")
    }
    public func deleteHospitalMaster ()
    {
        let query = "delete from HospitalMaster"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table HospitalMaster")
            return
        }
        print("HospitalMaster table deleted")
    }
    
    public func deleteCOMPETITORDETAILPOST(){
        let query = "delete from COMPETITORDETAILPOST"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table COMPETITORDETAILPOST ")
            return
        }
        print("COMPETITORDETAILPOST table deleted")
    }
    public func deleteCOMPETITORDETAIL(){
        let query = "delete from COMPETITORDETAIL"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table COMPETITORDETAIL ")
            return
        }
        print("COMPETITORDETAIL table deleted")
    }
    public func deleteDRType(){
        let query = "delete from DRType"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table DRType ")
            return
        }
        print("DRType table deleted")
    }//DRType
    public func deleteAttendance(){
        let query = "delete from Attendance"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table Attendance ")
            return
        }
        print("Attendance table deleted")
    }
    public func deleteUSERCUSTOMERORTHOINFO(){
           let query = "delete from USERCUSTOMEROTHINFO"
           if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
               print("Error deleting Table USERCUSTOMEROTHINFO ")
               return
           }
           print("USERCUSTOMEROTHINFO table deleted")
       }
    
    public func deleteUserPriceList(){
        let query = "delete from UserPriceList"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table UserPriceList ")
            return
        }
        print("UserPriceList table deleted")
    }
    public func deletePendingsubdealer(){
        let query = "delete from Pendingsubdealer"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table Pendingsubdealer ")
            return
        }
        print("Pendingsubdealer table deleted")
    }
    
    public func deleteDRMASTER () {
        let query = "delete from DRMASTER"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table DRMASTER")
            return
        }
        
        print("DRMASTER table deleted")
    }
    public func deleteprereasonmaster()
    {
        let query = "delete from VW_PREFERREDREASONMASTER"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK {
            print("Errir deleting TAble VW_PREFERREDREASONMASTER ")
        }
        
        print("VW_PREFERREDREASONMASTER table deleted")
    }
    
    public func deleteCUSTHOSPITALLINKING()
    {
        let query = "delete from CUSTHOSPITALLINKING"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK {
            print("Errir deleting TAble VW_PREFERREDREASONMASTER ")
        }
        
        print("CUSTHOSPITALLINKING table deleted")
    }
    
    public func deleteUSERDISTRIBUTORITEMLINK(){
        let query = "delete from USERDISTRIBUTORITEMLINK"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table USERDISTRIBUTORITEMLINK ")
            return
        }
        print("USERDISTRIBUTORITEMLINK table deleted")
    }
    
    public func deleteInsertsubdealerrequest(){
        let query = "delete from InsertSubDealerRequest"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table InsertSubDealerRequest ")
            return
        }
        print("InsertSubDealerRequest table deleted")
    }
    
    public func deletesalelinkcity(){
        let query = "delete from salelinkcity"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table salelinkcity ")
            return
        }
        print("salelinkcity table deleted")
    }
    
    public func deleteUserdistributorlist(){
        let query = "delete from USERDISTRIBUTORLIST"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table USERDISTRIBUTORLIST ")
            return
        }
        print("USERDISTRIBUTORLIST table deleted")
    }
    
    public func insertprimarydashboard(usercode: NSString?, tmonth: NSString?, targetmonth: NSString?, ptarget: NSString?, pachivement: NSString?){
        var stmt3: OpaquePointer? = nil
        
        let query = "INSERT INTO UserPrimaryDashboard (usercode,tmonth,targetmonth,ptarget,pachivement) VALUES (?,?,?,?,?)"
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt3, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        // binding the parameters
        if sqlite3_bind_text(stmt3, 1, usercode!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: usercode)): \(errmsg)")
            return
        }
        print("\(String(describing: usercode))")
        if sqlite3_bind_text(stmt3, 2, tmonth!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: tmonth)): \(errmsg)")
            return
        }
        print("\(String(describing: tmonth))")
        if sqlite3_bind_text(stmt3, 3, targetmonth!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: targetmonth)): \(errmsg)")
            return
        }
        print("\(String(describing: targetmonth))")
        if sqlite3_bind_text(stmt3, 4, ptarget!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: ptarget)): \(errmsg)")
            return
        }
        print("\(String(describing: ptarget))")
        if sqlite3_bind_text(stmt3, 5, pachivement!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: pachivement)): \(errmsg)")
            return
        }
        print("\(String(describing: pachivement))")
        if sqlite3_step(stmt3) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure inserting getLevel data: \(errmsg)")
            return
        }
        print("data saved successfully in UserPrimaryDashboard Table")
    }

    public func insertdashdetailscard(usercode: NSString? ,ptarget: NSString? ,starget: NSString? ,psalerate: NSString? ,ssalerate: NSString? ,preqrate: NSString? ,sreqrate: NSString? ){
        
        var stmt: OpaquePointer? = nil
        let query  = "INSERT INTO USERTARGETSALERATE(usercode , ptarget, psalerate ,preqrate , starget , ssalerate , sreqrate ) VALUES (?,?,?,?,?,?,?)"
        
        if sqlite3_prepare(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        if sqlite3_bind_text(stmt, 1, usercode!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: usercode)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: usercode))")
        if sqlite3_bind_text(stmt, 2, ptarget!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: ptarget)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: ptarget))")
        if sqlite3_bind_text(stmt, 3, psalerate!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: psalerate)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: psalerate))")
        if sqlite3_bind_text(stmt, 4, preqrate!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: preqrate)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: preqrate))")
        if sqlite3_bind_text(stmt, 5, starget!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: starget)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: starget))")
        if sqlite3_bind_text(stmt, 6, ssalerate!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: ssalerate)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: ssalerate))")
        if sqlite3_bind_text(stmt, 7, sreqrate!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: sreqrate)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: sreqrate))")
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure inserting USERTARGETSALERATE  data: \(errmsg)")
            return
        }
        print("data saved successfully in USERTARGETSALERATE ")
    }
    
    public func insertattenreport(date: NSString?, usercode: NSString?, daystart: NSString?, dayend: NSString?, hours: NSString?){
        
        var stmt: OpaquePointer? = nil
        let query  = "INSERT INTO attendancereport(date,usercode,daystart,dayend ,hours ) VALUES (?,?,?,?,?)"
        
        if sqlite3_prepare(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        if sqlite3_bind_text(stmt, 1, date!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: date)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: date))")
        if sqlite3_bind_text(stmt, 2, usercode!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: usercode)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: usercode))")
        if sqlite3_bind_text(stmt, 3, daystart!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: daystart)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: daystart))")
        if sqlite3_bind_text(stmt, 4, dayend!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: dayend)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: dayend))")
        if sqlite3_bind_text(stmt, 5, hours!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: hours)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: hours))")
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure inserting Attendance Report data: \(errmsg)")
            return
        }
        print("data saved successfully in Attendance Report")
    }
    
    public func insertcomplaintreport (dataareaid: NSString?,feedbackcode: NSString? ,feedbacktype: NSString? , category: NSString?    ,itemid: NSString? , feedbackstatus: NSString?,  customercode: NSString?  ,  submitdatetime: NSString? ,detail: NSString?,colorstatus: NSString?,closerremark: NSString?,usercodename: NSString?){
        
        
        var stmt: OpaquePointer? = nil
        let query  = "INSERT INTO feedbacks(dataareaid ,feedbackcode ,feedbacktype , category    ,itemid , feedbackstatus,  customercode  ,  submitdatetime ,detail,colorstatus,closerremark,usercodename) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)"
        
        if sqlite3_prepare(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        if sqlite3_bind_text(stmt, 1, dataareaid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: dataareaid)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: dataareaid))")
        if sqlite3_bind_text(stmt, 2, feedbackcode!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: feedbackcode)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: feedbackcode))")
        if sqlite3_bind_text(stmt, 3, feedbacktype!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: feedbacktype)): \(errmsg)")
            return
        }
      
        print("inserted===============>  \(String(describing: feedbacktype))")
  
        if sqlite3_bind_text(stmt, 4, category!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: category)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: category))")
        if sqlite3_bind_text(stmt, 5, itemid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: itemid)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: itemid))")
        
        if sqlite3_bind_text(stmt, 6, feedbackstatus!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: feedbackstatus)): \(errmsg)")
            return
        }
        
        print("inserted===============>  \(String(describing: feedbackstatus))")
        if sqlite3_bind_text(stmt, 7, customercode!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: customercode)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: customercode))")
        
        if sqlite3_bind_text(stmt, 8, submitdatetime!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: submitdatetime)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: submitdatetime))")
        if sqlite3_bind_text(stmt, 9, detail!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: detail)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: detail))")
        if sqlite3_bind_text(stmt, 10, colorstatus!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: colorstatus)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: colorstatus))")
        if sqlite3_bind_text(stmt, 11, closerremark!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: closerremark)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: closerremark))")
        if sqlite3_bind_text(stmt, 12, usercodename!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: usercodename)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: usercodename))")
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure inserting Attendance Report data: \(errmsg)")
            return
        }
        print("data saved successfully in Attendance Report")
    }
    
    public func insertretailermaster (customercode: String?,customername: String? ,customertype: String? , contactperson: String?    ,mobilecustcode: String? , mobileno: String?,  alternateno: String?  ,  emailid: String? ,address: String?,pincode: String?,city: String?,stateid: String?,gstno: String? ,gstregistrationdate: String? , siteid: String?    ,salepersonid: String? , keycustomer: String?,  isorthopositive: String?  ,  sizeofretailer: String? ,category: String?,isblocked: String?,pricegroup: String?,dataareaid: String?,latitude: String? ,longitude: String? , orthopedicsale: String?    ,avgsale: String? , prefferedbrand: String? ,secprefferedbrand: String? ,secprefferedsale: String? ,prefferedsale: String? ,prefferedreasonid : String?,secprefferedreasonid : String?,createdtransactionid: String? ,modifiedtransactionid: String? ,post: String? ,referencecode : String?,lastvisited : String?,storeimage : String?,stockimage: String? ,prefferedothbrand : String?,secprefferedothbrand: String?)
    {
        var stmt1: OpaquePointer?
        let q = "select * from RetailerMaster where customercode='\(customercode!)'"
        if sqlite3_prepare_v2(Databaseconnection.dbs, q, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            //update query goes here
            let query  = "update RetailerMaster set customercode='\(customercode!)',customername='\(customername!)',customertype='\(customertype!)',contactperson='\(contactperson!)',mobilecustcode='\(mobilecustcode!)', mobileno ='\(mobileno!)',alternateno='\(alternateno!)' ,emailid ='\(emailid!)',address='\(address!)' ,pincode ='\(pincode!)',city ='\(city!)',stateid ='\(stateid!)',gstno ='\(gstno!)',gstregistrationdate ='\(gstregistrationdate!)',siteid='\(siteid!)' ,salepersonid ='\(salepersonid!)',keycustomer ='\(keycustomer!)',isorthopositive ='\(isorthopositive!)',sizeofretailer ='\(sizeofretailer!)',category='\(category!)' ,isblocked ='\(isblocked!)',pricegroup ='\(pricegroup!)',dataareaid ='\(dataareaid!)',latitude ='\(latitude!)',longitude ='\(longitude!)',orthopedicsale ='\(orthopedicsale!)',avgsale ='\(avgsale!)',prefferedbrand ='\(prefferedbrand!)',secprefferedbrand ='\(secprefferedbrand!)',secprefferedsale ='\(secprefferedsale!)',prefferedsale ='\(prefferedsale!)',prefferedreasonid ='\(prefferedreasonid!)',secprefferedreasonid ='\(secprefferedreasonid!)',createdtransactionid ='\(createdtransactionid!)',modifiedtransactionid='\(modifiedtransactionid!)' ,post ='\(post!)',referencecode ='\(referencecode!)',lastvisited ='\(lastvisited!)',storeimage='\(storeimage!)' ,stockimage ='\(stockimage!)',prefferedothbrand ='\(prefferedothbrand!)',secprefferedothbrand='\(secprefferedothbrand!)' where customercode='\(customercode!)'"

            if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
                print("Error updating in RetailerMaster Table")
                return
            }
        }else{
            let query  = "INSERT INTO RetailerMaster(customercode,customername,customertype,contactperson,mobilecustcode, mobileno ,alternateno ,emailid ,address ,pincode ,city ,stateid ,gstno ,gstregistrationdate ,siteid ,salepersonid ,keycustomer ,isorthopositive ,sizeofretailer ,category ,isblocked ,pricegroup ,dataareaid ,latitude ,longitude ,orthopedicsale ,avgsale ,prefferedbrand ,secprefferedbrand ,secprefferedsale ,prefferedsale ,prefferedreasonid ,secprefferedreasonid ,createdtransactionid ,modifiedtransactionid ,post ,referencecode ,lastvisited ,storeimage ,stockimage ,prefferedothbrand ,secprefferedothbrand ) VALUES ('\(customercode!)','\(customername!)','\(customertype!)','\(contactperson!)','\(mobilecustcode!)','\(mobileno!)','\(alternateno!)','\(emailid!)','\(address!)','\(pincode!)','\(city!)','\(stateid!)','\(gstno!)','\(gstregistrationdate!)','\(siteid!)','\(salepersonid!)','\(keycustomer!)','\(isorthopositive!)','\(sizeofretailer!)','\(category!)','\(isblocked!)','\(pricegroup!)','\(dataareaid!)','\(latitude!)','\(longitude!)','\(orthopedicsale!)','\(avgsale!)','\(prefferedbrand!)','\(secprefferedbrand!)','\(secprefferedsale!)','\(prefferedsale!)','\(prefferedreasonid!)','\(secprefferedreasonid!)','\(createdtransactionid!)','\(modifiedtransactionid!)','\(post!)','\(referencecode!)','\(lastvisited!)','\(storeimage!)','\(stockimage!)','\(prefferedothbrand!)','\(secprefferedothbrand!)')"
            
            if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
                print("Error inserting in RetailerMaster Table")
                return
            }
        }
        if post! == "0"{
            var pointer: OpaquePointer? = nil
            let query1 = "SELECT * FROM USERCUSTOMEROTHINFO where customercode like '\(customercode!)'"
            if sqlite3_prepare_v2(Databaseconnection.dbs, query1 , -1, &pointer, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                print("error preparing get: \(errmsg)")
                return
            }
            if(sqlite3_step(pointer) != SQLITE_ROW){
                self.insertgetusercustomer(customercode: customercode as NSString?, lms: "0.0", avgsale: "0", reasoN1: "", reasoN2: "", complain: "0", escalation: "0", currentmonth: "0.0", lastvisit: "No Visit", usertypeapi: "0", lastactivity: "", lastactivityid: "0", ispendingsubconv: "0", ispendingcomplain: "0",usertype: "20")
            }
        }
        
        print("data inserted in RetailerMaster table")
    }
    
    public func updatelastvisitid(lastvistactivityid: String?, customercode: String?)
    {
        let base = Baseactivity()
        let query = "update USERCUSTOMEROTHINFO SET lastactivityid = '\(lastvistactivityid!)', lastvisit = '\(base.getTodaydatetime())' where customercode = '\(customercode!)'"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error updating Table USERCUSTOMEROTHINFO")
            return
        }
        print("USERCUSTOMEROTHINFO table updated")
    }
    
    public func updatelastvisitidForEscalation(lastvistactivityid: String?, customercode: String?)
       {
           let base = Baseactivity()
           let query = "update USERCUSTOMEROTHINFO SET lastactivityid = '\(lastvistactivityid!)', lastvisit = '\(base.getTodaydatetime())',isescalated= 'true' where customercode = '\(customercode!)'"
           if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
               print("Error updating Table USERCUSTOMEROTHINFO")
               return
           }
           print("USERCUSTOMEROTHINFO table updated")
       }
    
    public func updatependingsubconv(customercode: String?)
       {
           let base = Baseactivity()
           let query = "update USERCUSTOMEROTHINFO SET ispendingsubconv = 'true' where customercode = '\(customercode!)'"
           if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
               print("Error updating Table USERCUSTOMEROTHINFO")
               return
           }
           print("USERCUSTOMEROTHINFO table updated")
       }
    
  
    public func updatelastvisit(customercode: String?)
    {
        let base = Baseactivity()
        let query = "update USERCUSTOMEROTHINFO SET lastvisit = '\(base.getTodaydatetime())' where customercode = '\(customercode!)'"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error updating Table USERCUSTOMEROTHINFO")
            return
        }
        print("USERCUSTOMEROTHINFO table updated")
    }
    
    public func insertusertype (sno: NSString?, custtypeid: NSString?,custtypedesc: NSString?){
        var stmt: OpaquePointer? = nil
        let query = "INSERT INTO usertype(sno ,id,type) VALUES (?,?,?)"
        
        if sqlite3_prepare(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        if sqlite3_bind_text(stmt, 1, sno!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: sno)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: sno))")
        if sqlite3_bind_text(stmt, 2, custtypeid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: custtypeid)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: custtypeid))")
        if sqlite3_bind_text(stmt, 3, custtypedesc!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: custtypedesc)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: custtypedesc))")
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure inserting Attendance Report data: \(errmsg)")
            return
        }
        print("data saved successfully in Usertype table")
    }
    public func insertescalationreport(dataareaid : NSString?, escalationid: NSString?, customercode: NSString?, siteid: NSString?, submittime: NSString?, createdby : NSString?,status: NSString?, remark: NSString?, reasoncode: NSString? , username: NSString? , closeremarks: NSString?,post: NSString?,latitude: NSString? ,longitude: NSString? ) {
        
        var stmt: OpaquePointer? = nil
        let query = "INSERT INTO MarketEscalationActivity(escalationCode,date,status ,reason ,detail ,post ,latitude ,longitude ,datareaid ,customercode ,siteid ,createdby,username,closeremarks) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
        
        if sqlite3_prepare(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        if sqlite3_bind_text(stmt, 1, escalationid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: escalationid)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: escalationid))")
        if sqlite3_bind_text(stmt, 2, submittime!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: submittime)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: submittime))")
        if sqlite3_bind_text(stmt, 3, status!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: status)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: status))")
        if sqlite3_bind_text(stmt, 4, reasoncode!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: reasoncode)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: reasoncode))")
        if sqlite3_bind_text(stmt, 5, remark!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: remark)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: remark))")
        if sqlite3_bind_text(stmt, 6, post!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: post)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: post))")
        if sqlite3_bind_text(stmt, 7, latitude!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: latitude)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: latitude))")
        if sqlite3_bind_text(stmt, 8, longitude!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: longitude)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: longitude))")
        if sqlite3_bind_text(stmt, 9, dataareaid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: dataareaid)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: dataareaid))")
        if sqlite3_bind_text(stmt, 10, customercode!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: customercode)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: customercode))")
        if sqlite3_bind_text(stmt, 11, siteid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: siteid)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: siteid))")
        if sqlite3_bind_text(stmt, 12, createdby!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: createdby)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: createdby))")
        if sqlite3_bind_text(stmt, 13, username!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: username)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: username))")
        if sqlite3_bind_text(stmt, 14, closeremarks!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: closeremarks)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: closeremarks))")
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure inserting escalation Report data: \(errmsg)")
            return
        }
        print("data saved successfully in escalation report table")
    }
    public func insertreasonmaster(reasoncode: NSString? ,reasondescription: NSString? ,createdtransationid: NSString? ,modifiedtransactionid: NSString? ,isblock: NSString? ,recid: NSString?){
        
        var stmt: OpaquePointer? = nil
        let query = "INSERT INTO EscalationReason(reasoncode ,reasondescription ,CREATEDTRANSACTIONID ,modifiedtransactionid ,isblock ,recid) VALUES (?,?,?,?,?,?)"
        
        
        if sqlite3_prepare(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        if sqlite3_bind_text(stmt, 1, reasoncode!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: reasoncode)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: reasoncode))")
        if sqlite3_bind_text(stmt, 2, reasondescription!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: reasondescription)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: reasondescription))")
        if sqlite3_bind_text(stmt, 3, createdtransationid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: createdtransationid)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: createdtransationid))")
        if sqlite3_bind_text(stmt, 4, modifiedtransactionid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: modifiedtransactionid)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: modifiedtransactionid))")
        if sqlite3_bind_text(stmt, 5, isblock!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: isblock)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: isblock))")
        if sqlite3_bind_text(stmt, 6, recid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: recid)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: recid))")
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure inserting reasonmaster data: \(errmsg)")
            return
        }
        print("data saved successfully in reasonmaster table")
    }
    
    public func insertdealerreport(customercode: NSString? ,expectedsale: NSString? ,expectedDiscount: NSString? ,dataareaid: NSString? ,recid: NSString? ,submitdate: NSString?,status: NSString? ,approvedby: NSString? ,siteid: NSString? ,createdtransactionid: NSString?,modifiedtransactionid: NSString? ,rejectreason: NSString?){
        
        var stmt: OpaquePointer? = nil
        let query = "INSERT INTO SubDealersEntry(customercode ,expectedsale ,expectedDiscount ,dataareaid ,recid ,submitdate,status,approvedby,siteid,createdtransactionid,modifiedtransactionid,rejectreason) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)"
        
        if sqlite3_prepare(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        if sqlite3_bind_text(stmt, 1, customercode!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: customercode)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: customercode))")
        if sqlite3_bind_text(stmt, 2, expectedsale!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: expectedsale)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: expectedsale))")
        if sqlite3_bind_text(stmt, 3, expectedDiscount!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: expectedDiscount)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: expectedDiscount))")
        if sqlite3_bind_text(stmt, 4, dataareaid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: dataareaid)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: dataareaid))")
        if sqlite3_bind_text(stmt, 5, recid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: recid)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: recid))")
        if sqlite3_bind_text(stmt, 6, submitdate!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: submitdate)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: submitdate))")
        if sqlite3_bind_text(stmt, 7, status!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: status)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: status))")
        if sqlite3_bind_text(stmt, 8, approvedby!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: approvedby)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: approvedby))")
        if sqlite3_bind_text(stmt, 9, siteid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: siteid)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: siteid))")
        if sqlite3_bind_text(stmt, 10, createdtransactionid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: createdtransactionid)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: createdtransactionid))")
        if sqlite3_bind_text(stmt, 11, modifiedtransactionid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: modifiedtransactionid)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: modifiedtransactionid))")
        if sqlite3_bind_text(stmt, 12, rejectreason!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: rejectreason)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: rejectreason))")
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure inserting SubDealersEntry data: \(errmsg)")
            return
        }
        print("data saved successfully in SubDealersEntry table")
    }
    
    public func insertattendancemaster(attnid: NSString?,attndesc: NSString? ,isblock: NSString?){
        var stmt: OpaquePointer? = nil
        let query = "INSERT INTO AttendanceMaster(attnid,attndesc ,isblock ) VALUES (?,?,?)"
        
        
        if sqlite3_prepare(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        if sqlite3_bind_text(stmt, 1, attnid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: attnid)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: attnid))")
        if sqlite3_bind_text(stmt, 2, attndesc!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: attndesc)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: attndesc))")
        if sqlite3_bind_text(stmt, 3, isblock!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: isblock)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: isblock))")
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure inserting AttendanceMaster data: \(errmsg)")
            return
        }
        print("data saved successfully in AttendanceMaster table")
    }

    public func insertattendance(usercode: NSString? ,status: NSString?,lat: NSString? ,lon: NSString? ,attendancedate: NSString?,post : NSString?,usertype: NSString? ,dataareaid: NSString? ,isblocked: NSString?){
        
        var stmt: OpaquePointer? = nil
        let query = "INSERT INTO Attendance(usercode ,status,lat ,lon ,attendancedate,post ,usertype ,dataareaid ,isblocked ) VALUES (?,?,?,?,?,?,?,?,?)"
        
        
        if sqlite3_prepare(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        if sqlite3_bind_text(stmt, 1, usercode!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: usercode)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: usercode))")
        if sqlite3_bind_text(stmt, 2, status!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: status)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: status))")
        if sqlite3_bind_text(stmt, 3, lat!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: lat)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: lat))")
        if sqlite3_bind_text(stmt, 4, lon!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: lon)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: lon))")
        if sqlite3_bind_text(stmt, 5, attendancedate!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: attendancedate)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: attendancedate))")
        if sqlite3_bind_text(stmt, 6, post!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: post)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: post))")
        if sqlite3_bind_text(stmt, 7, usertype!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: usertype)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: usertype))")
        if sqlite3_bind_text(stmt, 8, dataareaid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: dataareaid)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: dataareaid))")
        if sqlite3_bind_text(stmt, 9, isblocked!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: isblocked)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: isblocked))")
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure inserting Attendance data: \(errmsg)")
            return
        }
        print("data saved successfully in Attendance table")
    }
    public func updateattendance(usercode: String?, status: String?, date: String?)
        {
            let query = "update Attendance SET post = 2 where usercode='" + usercode! + "' and status='" + status! + "'and attendancedate='" + date! + "'"
            if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
                print("Error updating Table Attendance")
                return
            }
            print("attendance table updated")
    }

    public func insertusercity(CityID: String? ,CityName: String? ,stateid: String? ,createdtransactionid: String? ,modifiedtransactionid: String?){
        
        var stmt1: OpaquePointer?
        let q = "select * from CityMaster where CityID = '\(CityID!)'"
        if sqlite3_prepare_v2(Databaseconnection.dbs, q, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        //127 cast as int, 53
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            let query = "update CityMaster set CityID='\(CityID!)',CityName='\(CityName!)',stateid='\(stateid!)',createdtransactionid='\(createdtransactionid!)',modifiedtransactionid='\(modifiedtransactionid!)' where CityID = '\(CityID!)'"
            
            if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
               if(AppDelegate.isDebug){
                print("Error inserting in CityMaster Table")
                }
                return
            }
            if(AppDelegate.isDebug){
            print("data Updated in CityMaster table")
            }
        }
        else{
            let query = "INSERT INTO CityMaster(CityID ,CityName ,stateid ,createdtransactionid ,modifiedtransactionid ) VALUES ('\(CityID!)','\(CityName!)','\(stateid!)','\(createdtransactionid!)','\(modifiedtransactionid!)')"
            
            if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
                if(AppDelegate.isDebug){
                print("Error inserting in CityMaster Table")
                }
                return
            }
            if(AppDelegate.isDebug){
            print("data saved successfully in CityMaster table")
            }
        }
    }
    
    public func insertuserlinkedcity(cityid: NSString? ,locationtype: NSString? ,dataareaid: NSString?,isblocked: NSString? ,createdtransactionid: NSString? ,modifiedtransactionid: NSString?){
        var stmt: OpaquePointer? = nil
        let query = "INSERT INTO UserLinkCity(cityid ,locationtype ,dataareaid ,isblocked ,createdtransactionid ,modifiedtransactionid ) VALUES (?,?,?,?,?,?)"
        
        
        if sqlite3_prepare(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        if sqlite3_bind_text(stmt, 1, cityid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: cityid)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: cityid))")
        if sqlite3_bind_text(stmt, 2, locationtype!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: locationtype)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: locationtype))")
        if sqlite3_bind_text(stmt, 3, dataareaid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: dataareaid)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: dataareaid))")
        if sqlite3_bind_text(stmt, 4, isblocked!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: isblocked)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: isblocked))")
        if sqlite3_bind_text(stmt, 5, createdtransactionid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: createdtransactionid)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: createdtransactionid))")
        if sqlite3_bind_text(stmt, 6, modifiedtransactionid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: modifiedtransactionid)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: modifiedtransactionid))")
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure inserting UserLinkCity data: \(errmsg)")
            return
        }
        print("data saved successfully in UserLinkCity table")
    }

    public func insertexpensereport(expenseid: NSString? ,expensedate: NSString? ,da: NSString?,ta: NSString? ,hotelexpense: NSString? ,miscellanous: NSString? ,workingtype: NSString? ,total: NSString?,cityname: NSString?){
        
        var stmt: OpaquePointer? = nil
        let query = "INSERT INTO ExpenseReport(expenseid,expensedate ,da ,ta ,hotelexpense ,miscellanous,workingtype,total,cityname) VALUES (?,?,?,?,?,?,?,?,?)"
        
        if sqlite3_prepare(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        if sqlite3_bind_text(stmt, 1, expenseid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: expenseid)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: expenseid))")
        if sqlite3_bind_text(stmt, 2, expensedate!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: expensedate)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: expensedate))")
        if sqlite3_bind_text(stmt, 3, da!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: da)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: da))")
        if sqlite3_bind_text(stmt, 4, ta!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: ta)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: ta))")
        if sqlite3_bind_text(stmt, 5, hotelexpense!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: hotelexpense)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: hotelexpense))")
        if sqlite3_bind_text(stmt, 6, miscellanous!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: miscellanous)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: miscellanous))")
        if sqlite3_bind_text(stmt, 7, workingtype!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: workingtype)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: workingtype))")
        if sqlite3_bind_text(stmt, 8, total!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: total)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: total))")
        if sqlite3_bind_text(stmt, 9, cityname!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: cityname)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: cityname))")
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure inserting Expensereport data: \(errmsg)")
            return
        }
        print("data saved successfully in ExpenseReport table")
    }
    
    func updategetusercustomer(customercode: String? ,lms: String? ,avgsale: String?,reasoN1: String? ,reasoN2: String? ,complain: String? ,escalation: String? ,currentmonth: String? ,lastvisit: String?, usertypeapi: String?,lastactivity: String?,lastactivityid: String?,ispendingsubconv: String?,ispendingcomplain: String?,usertype: NSString?){
        
        var isescalated: String?
         if(AppDelegate.isDebug){
        print("usertypeapi ===> \(usertypeapi) - usertype ===> \(Int(usertype! as String)!))")
        }
        
        if (Int(usertype! as String)! <= Int(usertypeapi! as String)!) {
            isescalated = "true"
        }
        else {
            isescalated = "false"
        }
        
        let query = "update USERCUSTOMEROTHINFO set lms = '\(lms!)',avgsale = '\(avgsale!)',reasoN1 = '\(reasoN1!)',reasoN2 = '\(reasoN2!)',complain = '\(complain!)',escalation = '\(escalation!)',currentmonth = '\(currentmonth!)',lastvisit = '\(lastvisit!)', lastactivity = '\(lastactivity!)',lastactivityid = '\(lastactivityid!)',ispendingsubconv = '\(ispendingsubconv!)',ispendingcomplain = '\(ispendingcomplain!)' ,isescalated = '\(isescalated!)' where customercode = '\(customercode!)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
             if(AppDelegate.isDebug){
            print("Error updating Table USERCUSTOMEROTHINFO")
            }
            return
        }
         if(AppDelegate.isDebug){
        print("USERCUSTOMEROTHINFO table updated")
        }
    }
    
    public func insertgetusercustomer(customercode: NSString? ,lms: NSString? ,avgsale: NSString?,reasoN1: NSString? ,reasoN2: NSString? ,complain: NSString? ,escalation: NSString? ,currentmonth: NSString? ,lastvisit: NSString?, usertypeapi: NSString?,lastactivity: NSString?,lastactivityid: NSString?,ispendingsubconv: NSString?,ispendingcomplain: NSString?,usertype: NSString?){
        
        var stmt: OpaquePointer? = nil
        let query = "INSERT INTO USERCUSTOMEROTHINFO (customercode,lms,avgsale,reasoN1 ,reasoN2 ,complain ,escalation,currentmonth ,lastvisit, isescalated, lastactivity, lastactivityid,ispendingsubconv,ispendingcomplain) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
        
        var isescalated: String?
         if(AppDelegate.isDebug){
        print("usertypeapi ===> \(usertypeapi) - usertype ===> \(Int(usertype! as String)!))")
        }
        if (Int(usertype! as String)! <= Int(usertypeapi! as String)!) {
            isescalated = "true"
        }
        else {
            isescalated = "false"
        }
        if sqlite3_prepare(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 1, customercode!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: customercode)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: customercode))")
        if sqlite3_bind_text(stmt, 2, lms!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: lms)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: lms))")
        if sqlite3_bind_text(stmt, 3, avgsale!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: avgsale)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: avgsale))")
        if sqlite3_bind_text(stmt, 4, reasoN1!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: reasoN1)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: reasoN1))")
        if sqlite3_bind_text(stmt, 5, reasoN2!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: reasoN2)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: reasoN2))")
        if sqlite3_bind_text(stmt, 6, complain!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: complain)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: complain))")
        if sqlite3_bind_text(stmt, 7, escalation!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: escalation)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: escalation))")
        if sqlite3_bind_text(stmt, 8, currentmonth!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: currentmonth)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: currentmonth))")
        if sqlite3_bind_text(stmt, 9, lastvisit!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: lastvisit)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: lastvisit))")
        
        if sqlite3_bind_text(stmt, 10, (isescalated! as NSString).utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: isescalated)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: isescalated))")
        if sqlite3_bind_text(stmt, 11, (lastactivity! as NSString).utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: lastactivity)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: lastactivity))")
        if sqlite3_bind_text(stmt, 12, (lastactivityid! as NSString).utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: lastactivityid)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: lastactivityid))")
        if sqlite3_bind_text(stmt, 13, (ispendingsubconv! as NSString).utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: ispendingsubconv)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: ispendingsubconv))")
        if sqlite3_bind_text(stmt, 14, (ispendingcomplain! as NSString).utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: ispendingcomplain)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: ispendingcomplain))")
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure inserting USERCUSTOMEROTHINFO data: \(errmsg)")
            return
        }
        print("data saved successfully in USERCUSTOMEROTHINFO table")
    }
    public func insertgetUSERDISTRIBUTOR(siteid: NSString? ,sitename: NSString? ,address: NSString? ,city: NSString? ,mobile: NSString? ,stateid: NSString? ,statename: NSString? ,salespersoncode: NSString? ,gstinno: NSString? ,email: NSString? ,pricegroup: NSString? ,plantcode: NSString? ,plantstateid: NSString?,isdisplay: NSString?,distributortype: String){
        
        var stmt: OpaquePointer? = nil
        let query = "INSERT INTO USERDISTRIBUTOR(siteid ,sitename ,address ,city ,mobile ,stateid ,statename ,salespersoncode ,gstinno ,email ,pricegroup ,plantcode ,plantstateid, isdisplay, distributortype) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
        
        if sqlite3_prepare(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 1, siteid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: siteid)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: siteid))")
        if sqlite3_bind_text(stmt, 2, sitename!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: sitename)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: sitename))")
        if sqlite3_bind_text(stmt, 3, address!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: address)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: address))")
        if sqlite3_bind_text(stmt, 4, city!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: city)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: city))")
        if sqlite3_bind_text(stmt, 5, mobile!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: mobile)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: mobile))")
        if sqlite3_bind_text(stmt, 6, stateid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: stateid)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: stateid))")
        if sqlite3_bind_text(stmt, 7, statename!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: statename)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: statename))")
        if sqlite3_bind_text(stmt, 8, salespersoncode!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: salespersoncode)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: salespersoncode))")
        if sqlite3_bind_text(stmt, 9, gstinno!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: gstinno)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: gstinno))")
        
        if sqlite3_bind_text(stmt, 10, email!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: email)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: email))")
        if sqlite3_bind_text(stmt, 11, pricegroup!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: pricegroup)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: pricegroup))")
        if sqlite3_bind_text(stmt, 12, plantcode!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: plantcode)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: plantcode))")
        if sqlite3_bind_text(stmt, 13, plantstateid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: plantstateid)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: plantstateid))")
        if sqlite3_bind_text(stmt, 14, isdisplay!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: isdisplay)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: isdisplay))")
        if sqlite3_bind_text(stmt, 15, distributortype, -1, nil) != SQLITE_OK{
             let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
             print("failure binding \(String(describing: distributortype)): \(errmsg)")
             return
        }
        print("inserted===============>  \(String(describing: distributortype))")
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure inserting USERDISTRIBUTOR data: \(errmsg)")
            return
        }
        print("data saved successfully in USERDISTRIBUTOR table")
    }
    
    //USERDISTRIBUTOR(siteid ,sitename ,address ,city ,mobile ,stateid ,statename ,salespersoncode ,gstinno ,email ,pricegroup ,plantcode ,plantstateid )
    public func insertIndentDetails(siteid: NSString? ,indentno: NSString? ,indentdate: NSString? ,lineno: NSString? ,itemid: NSString? ,itemname: NSString? ,itemvarriantsize: NSString? ,itemgroup: NSString? ,quantity: NSString? ,rate: NSString? ,amount: NSString? ,action: NSString? ,createdby: NSString?,sono: NSString?){
        
        var stmt: OpaquePointer? = nil
        let query = "INSERT INTO IndentDetails(siteid ,indentno ,indentdate ,lineno ,itemid ,itemname ,itemvarriantsize ,itemgroup ,quantity ,rate ,amount ,action,createdby,sono) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
        
        if sqlite3_prepare(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 1, siteid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: siteid)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: siteid))")
        if sqlite3_bind_text(stmt, 2, indentno!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: indentno)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: indentno))")
        if sqlite3_bind_text(stmt, 3, indentdate!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: indentdate)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: indentdate))")
        if sqlite3_bind_text(stmt, 4, lineno!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: lineno)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: lineno))")
        if sqlite3_bind_text(stmt, 5, itemid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: itemid)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: itemid))")
        if sqlite3_bind_text(stmt, 6, itemname!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: itemname)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: itemname))")
        if sqlite3_bind_text(stmt, 7, itemvarriantsize!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: itemvarriantsize)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: itemvarriantsize))")
        if sqlite3_bind_text(stmt, 8, itemgroup!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: itemgroup)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: itemgroup))")
        if sqlite3_bind_text(stmt, 9, quantity!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: quantity)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: quantity))")
        
        if sqlite3_bind_text(stmt, 10, rate!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: rate)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: rate))")
        if sqlite3_bind_text(stmt, 11, amount!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: amount)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: amount))")
        if sqlite3_bind_text(stmt, 12, action!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: action)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: action))")
        if sqlite3_bind_text(stmt, 13, createdby!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: createdby)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: createdby))")
        if sqlite3_bind_text(stmt, 14, sono!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: sono)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: sono))")
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure inserting IndentDetails data: \(errmsg)")
            return
        }
        print("data saved successfully in IndentDetails table")
    }
    
    //    siteid CHAR(255), customercode CHAR(255),dataareaid CHAR(255),sono CHAR(255),sodate CHAR(255),sovalue CHAR(255),status CHAR(255),lineno CHAR(255),itemid CHAR(255),discamt CHAR(255),taxprec CHAR(255),taxamt CHAR(255),amount CHAR(255)
    
    public func insertSoDetails(siteid: NSString? ,customercode: NSString?,dataareaid: NSString? ,sono: NSString?,sodate: NSString? ,sovalue: NSString?,status: NSString?,lineno: NSString? ,itemid: NSString?, discamt: NSString?,taxprec: NSString?,taxamt: NSString? ,amount: NSString?){
        
        var stmt: OpaquePointer? = nil
        let query = "INSERT INTO sodetails(siteid ,customercode ,dataareaid ,sono ,sodate ,sovalue ,status ,lineno ,itemid ,discamt ,taxprec ,taxamt,amount) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)"
        
       
        if sqlite3_prepare(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 1, siteid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: siteid)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: siteid))")
        if sqlite3_bind_text(stmt, 2, customercode!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: customercode)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: customercode))")
        if sqlite3_bind_text(stmt, 3, dataareaid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: dataareaid)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: dataareaid))")
        if sqlite3_bind_text(stmt, 4, sono!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: sono)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: sono))")
        if sqlite3_bind_text(stmt, 5, sodate!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: sodate)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: sodate))")
        //siteid ,customercode ,dataareaid ,sono ,sodate ,sovalue ,status ,lineno ,itemid ,discamt ,taxprec ,taxamt,amount
        
        if sqlite3_bind_text(stmt, 6, sovalue!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: sovalue)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: sovalue))")
        if sqlite3_bind_text(stmt, 7, status!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: status)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: status))")
        if sqlite3_bind_text(stmt, 8, lineno!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: lineno)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: lineno))")
        
        //lineno ,itemid ,discamt ,taxprec ,taxamt,amount
        
        if sqlite3_bind_text(stmt, 9, itemid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: itemid)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: itemid))")
        if sqlite3_bind_text(stmt, 10, discamt!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: discamt)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: discamt))")
        if sqlite3_bind_text(stmt, 11, taxprec!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: taxprec)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: taxprec))")
        if sqlite3_bind_text(stmt, 12, taxamt!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: taxamt)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: taxamt))")
        if sqlite3_bind_text(stmt, 13, amount!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: itemid)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: itemid))")
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure inserting SOdetail data: \(errmsg)")
            return
        }
        print("data saved successfully in SOdetail table")
    }
    public func insertItemmaster(itemgroup: String? ,itemsubgroup: String?,itemgroupid: String? ,itemid: String?,itemname: String? ,itemmrp: String?,itempacksize: String?,itemvarriantsize: String? ,uom: String?, barcode: String?,createdTransactionId: String?,modifiedTransactionId: String? ,hsncode: String?,isexempt: String?,isblocked: String? ,ispcsapply: String?,itembuyergroupid: String?){
        
        let query = "INSERT INTO ItemMaster(itemgroup ,itemsubgroup ,itemgroupid ,itemid ,itemname ,itemmrp ,itempacksize ,itemvarriantsize ,uom ,barcode ,createdTransactionId ,modifiedTransactionId,hsncode,isexempt,isblocked,ispcsapply,itembuyergroupid) VALUES ('\(itemgroup!)','\(itemsubgroup!)','\(itemgroupid!)','\(itemid!)','\(itemname!)','\(itemmrp!)','\(itempacksize!)','\(itemvarriantsize!)','\(uom!)','\(barcode!)','\(createdTransactionId!)','\(modifiedTransactionId!)','\(hsncode!)','\(isexempt!)','\(isblocked!)','\(ispcsapply!)','\(itembuyergroupid!)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in ItemMaster Table")
            return
        }
        if(AppDelegate.isDebug){
        print("data saved successfully in ItemMaster table")
        }
    }
    public func insertProfiledetail(usercode: NSString? ,employeecode: NSString?,employeename: NSString? ,address: NSString?,city: NSString? ,pincode: NSString?,stateid: NSString?,statename: NSString? ,dob: NSString?, doj: NSString?,emailid: NSString?,contactno: NSString? ,mobileno: NSString?,password: NSString?,pocket: NSString? ,sector: NSString?,teritory: NSString?, usertype: NSString? ,dataareaid: NSString?,siteid: NSString? ,sponame: NSString?,spomobile: NSString? ,asmname: NSString?,asmmobile: NSString?,rsmname: NSString? ,rsmmobile: NSString?, zsmname: NSString?,zsmmobile: NSString?,tmname: NSString? ,tmmobile: NSString?,nsmname: NSString?,nsmmobile: NSString? ,salarymonth: NSString?,aadhaar: NSString?,   docpan: NSString?,docgst: NSString? ,docpdc: NSString?,docaggreement: NSString?,docaadhaar: NSString? ,doccancelledcheque: NSString?,headquater: NSString?, exheadquater: NSString? ,outstation: NSString?,misc: NSString? ,Ismobileblock: NSString?,alloweddisc: NSString? ,pricegroup: NSString?,jobdesc: NSString?,monthlyta: NSString?,balanceta: NSString? ,oscount: NSString?,balancemiscellaneous: NSString?,showtrainbar: NSString?,istraining: NSString?){
        
        var stmt: OpaquePointer? = nil
        let query = "INSERT INTO ProfileDetail(usercode ,employeecode ,employeename ,address ,city ,pincode ,stateid ,statename ,dob ,doj ,emailid ,contactno, mobileno, password, pocket, sector,teritory,usertype,dataareaid,siteid,sponame,spomobile,asmname,asmmobile,rsmname,rsmmobile,zsmname,zsmmobile,tmname,tmmobile,nsmname,nsmmobile,salarymonth,aadhaar,docpan,docgst,docpdc,docaggreement,docaadhaar,doccancelledcheque,headquater,exheadquater,outstation,misc,Ismobileblock,alloweddisc,pricegroup,jobdesc,monthlyta,balanceta,oscount,balancemiscellaneous,showtrainbar,istraining) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
        
        if sqlite3_prepare(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 1, usercode!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: usercode)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: usercode))")
        if sqlite3_bind_text(stmt, 2, employeecode!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: employeecode)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: employeecode))")
        if sqlite3_bind_text(stmt, 3, employeename!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: employeename)): \(errmsg)")
            return
        }
        
        print("inserted===============>  \(String(describing: employeename))")
        if sqlite3_bind_text(stmt, 4, address!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: address)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: address))")
        
        if sqlite3_bind_text(stmt, 5, city!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: city)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: city))")
        
        if sqlite3_bind_text(stmt, 6, pincode!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: pincode)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: pincode))")
        if sqlite3_bind_text(stmt, 7, stateid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: stateid)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: stateid))")
        if sqlite3_bind_text(stmt, 8, statename!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: statename)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: statename))")
        
        if sqlite3_bind_text(stmt, 9, dob!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: dob)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: dob))")
        
        
        if sqlite3_bind_text(stmt, 10, doj!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: doj)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: doj))")
        if sqlite3_bind_text(stmt, 11, emailid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: emailid)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: emailid))")
        if sqlite3_bind_text(stmt, 12, contactno!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: contactno)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: contactno))")
        if sqlite3_bind_text(stmt, 13, mobileno!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: mobileno)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: mobileno))")
        if sqlite3_bind_text(stmt, 14, password!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: password)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: password))")
        if sqlite3_bind_text(stmt, 15, pocket!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: pocket)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: pocket))")
        if sqlite3_bind_text(stmt, 16, sector!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: sector)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: sector))")
        if sqlite3_bind_text(stmt, 17, teritory!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: teritory)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: teritory))")
        
        if sqlite3_bind_text(stmt, 18, usertype!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: usertype)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: usertype))")
        if sqlite3_bind_text(stmt, 19, dataareaid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: dataareaid)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: dataareaid))")
        if sqlite3_bind_text(stmt, 20, siteid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: siteid)): \(errmsg)")
            return
        }
        
        print("inserted===============>  \(String(describing: siteid))")
        if sqlite3_bind_text(stmt, 21, sponame!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: sponame)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: sponame))")
        
        if sqlite3_bind_text(stmt, 22, spomobile!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: spomobile)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: spomobile))")
        
        if sqlite3_bind_text(stmt, 23, asmname!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: asmname)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: asmname))")
        if sqlite3_bind_text(stmt, 24, asmmobile!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: asmmobile)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: asmmobile))")
        if sqlite3_bind_text(stmt, 25, rsmname!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: rsmname)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: rsmname))")
        
        if sqlite3_bind_text(stmt, 26, rsmmobile!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: rsmmobile)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: rsmmobile))")
        
        if sqlite3_bind_text(stmt, 27, zsmname!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: zsmname)): \(errmsg)")
            return
        }
        
        print("inserted===============>  \(String(describing: zsmname))")
        if sqlite3_bind_text(stmt, 28, zsmmobile!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: zsmmobile)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: zsmmobile))")
        if sqlite3_bind_text(stmt, 29, tmname!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: tmname)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: tmname))")
        if sqlite3_bind_text(stmt, 30, tmmobile!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: tmmobile)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: tmmobile))")
        if sqlite3_bind_text(stmt, 31, nsmname!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: nsmname)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: nsmname))")
        
        if sqlite3_bind_text(stmt, 32, nsmmobile!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: nsmmobile)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: nsmmobile))")
        if sqlite3_bind_text(stmt, 33, salarymonth!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: salarymonth)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: salarymonth))")
        if sqlite3_bind_text(stmt, 34, aadhaar!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: aadhaar)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: aadhaar))")
        
        if sqlite3_bind_text(stmt, 35, docpan!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: docpan)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: docpan))")
        
        if sqlite3_bind_text(stmt, 36, docgst!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: docgst)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: docgst))")
        if sqlite3_bind_text(stmt, 37, docpdc!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: docpdc)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: docpdc))")
        
        if sqlite3_bind_text(stmt, 38, docaggreement!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: docaggreement)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: docaggreement))")
        
        if sqlite3_bind_text(stmt, 39, docaadhaar!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: docaadhaar)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: docaadhaar))")
        
        
        if sqlite3_bind_text(stmt, 40, doccancelledcheque!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: doccancelledcheque)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: doccancelledcheque))")
        if sqlite3_bind_text(stmt, 41, headquater!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: headquater)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: headquater))")
        if sqlite3_bind_text(stmt, 42, exheadquater!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: exheadquater)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: exheadquater))")
        if sqlite3_bind_text(stmt, 43, outstation!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: outstation)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: outstation))")
        
        if sqlite3_bind_text(stmt, 44, misc!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: misc)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: misc))")
        if sqlite3_bind_text(stmt, 45, Ismobileblock!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: Ismobileblock)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: Ismobileblock))")
        if sqlite3_bind_text(stmt, 46, alloweddisc!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: alloweddisc)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: alloweddisc))")
        if sqlite3_bind_text(stmt, 47, pricegroup!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: pricegroup)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: pricegroup))")
        if sqlite3_bind_text(stmt, 48, jobdesc!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: jobdesc)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: jobdesc))")
        if sqlite3_bind_text(stmt, 49, monthlyta!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: monthlyta)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: monthlyta))")
        if sqlite3_bind_text(stmt, 50, balanceta!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: balanceta)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: balanceta))")
        if sqlite3_bind_text(stmt, 51, oscount!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: oscount)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: oscount))")
        if sqlite3_bind_text(stmt, 52, balancemiscellaneous!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: balancemiscellaneous)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: balancemiscellaneous))")
        if sqlite3_bind_text(stmt, 53, showtrainbar!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: showtrainbar)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: showtrainbar))")
        if sqlite3_bind_text(stmt, 54, istraining!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: istraining)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: istraining))")
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure inserting Profile Detail data: \(errmsg)")
            return
        }
        print("data saved successfully in Profile Detail table")
    }
    
    public func insertescalation(reasoncode: NSString? ,reasondescription: NSString? ,CREATEDTRANSACTIONID: NSString?,ModifiedTransactionId: NSString? ,isblock: NSString? ,recid: NSString? ){
        
        var stmt: OpaquePointer? = nil
        let query = "INSERT INTO EscalationReason(reasoncode ,reasondescription,CREATEDTRANSACTIONID ,ModifiedTransactionId ,isblock ,recid ) VALUES (?,?,?,?,?,?)"
        
        if sqlite3_prepare(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        if sqlite3_bind_text(stmt, 1, reasoncode!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: reasoncode)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: reasoncode))")
        if sqlite3_bind_text(stmt, 2, reasondescription!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: reasondescription)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: reasondescription))")
        if sqlite3_bind_text(stmt, 3, CREATEDTRANSACTIONID!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: CREATEDTRANSACTIONID)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: CREATEDTRANSACTIONID))")
        if sqlite3_bind_text(stmt, 4, ModifiedTransactionId!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: ModifiedTransactionId)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: ModifiedTransactionId))")
        if sqlite3_bind_text(stmt, 5, isblock!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: isblock)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: isblock))")
        if sqlite3_bind_text(stmt, 6, recid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: recid)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: recid))")
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure inserting escalation data: \(errmsg)")
            return
        }
        print("data saved successfully in escalation table")
    }
    public func insertnoorder(reasoncode: NSString? ,reasondescription: NSString? ,createdtransactionid: NSString?,modifiedtransactionid: NSString? ,isblock: NSString? ,recid: NSString? ){
        
        var stmt: OpaquePointer? = nil
        let query = "INSERT INTO NoOrderReasonMaster (recid ,  reasoncode  , reasondescription  ,   createdtransactionid , modifiedtransactionid, isblock ) VALUES (?,?,?,?,?,?)"
        
        if sqlite3_prepare(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        if sqlite3_bind_text(stmt, 1, recid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: recid)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: recid))")
        if sqlite3_bind_text(stmt, 2, reasoncode!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: reasoncode)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: reasoncode))")
        if sqlite3_bind_text(stmt, 3, reasondescription!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: reasondescription)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: reasondescription))")
        if sqlite3_bind_text(stmt, 4, createdtransactionid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: createdtransactionid)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: createdtransactionid))")
        if sqlite3_bind_text(stmt, 5, modifiedtransactionid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: modifiedtransactionid)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: modifiedtransactionid))")
        if sqlite3_bind_text(stmt, 6, isblock!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: isblock)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: isblock))")
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure inserting noorder data: \(errmsg)")
            return
        }
        print("data saved successfully in noorder table")
    }
    public func insertUSERHIERARCHY(usercode: NSString?, usertype: NSString?, employeecode: NSString?, empname: NSString?){
        var stmt3: OpaquePointer? = nil
        //       create table if not exists  USERHIERARCHY(usercode CHAR(255),usertype CHAR(255),employeecode CHAR(255), empname CHAR(255))
        let query = "INSERT INTO USERHIERARCHY (usercode,usertype,employeecode,empname) VALUES (?,?,?,?)"
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt3, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        // binding the parameters
        if sqlite3_bind_text(stmt3, 1, usercode!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: usercode)): \(errmsg)")
            return
        }
        print("\(String(describing: usercode))")
        if sqlite3_bind_text(stmt3, 2, usertype!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: usertype)): \(errmsg)")
            return
        }
        print("\(String(describing: usertype))")
        if sqlite3_bind_text(stmt3, 3, employeecode!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: employeecode)): \(errmsg)")
            return
        }
        print("\(String(describing: employeecode))")
        if sqlite3_bind_text(stmt3, 4, empname!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: empname)): \(errmsg)")
            return
        }
        print("\(String(describing: empname))")
        
        if sqlite3_step(stmt3) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure inserting getLevel data: \(errmsg)")
            return
        }
        print("data saved successfully in USERHIERARCHY Table")
    }
    public func insertnoorderremark(DATAAREAID: NSString? ,STATUSID: NSString? ,REASONCODE: NSString?,CUSTOMERCODE: NSString? ,SITEID: NSString? ,SUBMITTIME: NSString?,remarks: NSString? ){
        
        var stmt: OpaquePointer? = nil
        let query = "INSERT INTO NoOrderRemarks(DATAAREAID , STATUSID  ,REASONCODE ,CUSTOMERCODE  ,SITEID , SUBMITTIME ,remarks) VALUES (?,?,?,?,?,?,?)"
        
        if sqlite3_prepare(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        if sqlite3_bind_text(stmt, 1, DATAAREAID!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: DATAAREAID)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: DATAAREAID))")
        if sqlite3_bind_text(stmt, 2, STATUSID!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: STATUSID)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: STATUSID))")
        if sqlite3_bind_text(stmt, 3, REASONCODE!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: REASONCODE)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: REASONCODE))")
        if sqlite3_bind_text(stmt, 4, CUSTOMERCODE!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: CUSTOMERCODE)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: CUSTOMERCODE))")
        if sqlite3_bind_text(stmt, 5, SITEID!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: SITEID)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: SITEID))")
        if sqlite3_bind_text(stmt, 6, SUBMITTIME!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: SUBMITTIME)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: SUBMITTIME))")
        if sqlite3_bind_text(stmt, 7, remarks!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: remarks)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: remarks))")
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure inserting NoOrderRemarks data: \(errmsg)")
            return
        }
        print("data saved successfully in NoOrderRemarks table")
    }
    public func insertnoorderremarkpost(DATAAREAID: NSString? ,STATUSID: NSString? ,REASONCODE: NSString?,CUSTOMERCODE: NSString? ,SITEID: NSString? ,SUBMITTIME: NSString?,remarks: NSString?,LATITUDE: NSString? ,LONGITUDE: NSString? ,USERCODE: NSString?  ,ISMOBILE: NSString?  ,post: NSString?,date: NSString?){
        
        var stmt: OpaquePointer? = nil
        let query = "INSERT INTO NoOrderRemarksPost (DATAAREAID , STATUSID ,REASONCODE ,CUSTOMERCODE ,SITEID , SUBMITTIME ,REMARKS ,LATITUDE ,LONGITUDE ,USERCODE ,ISMOBILE ,post ,date) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)"
        
        if sqlite3_prepare(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        if sqlite3_bind_text(stmt, 1, DATAAREAID!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: DATAAREAID)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: DATAAREAID))")
        if sqlite3_bind_text(stmt, 2, STATUSID!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: STATUSID)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: STATUSID))")
        if sqlite3_bind_text(stmt, 3, REASONCODE!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: REASONCODE)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: REASONCODE))")
        if sqlite3_bind_text(stmt, 4, CUSTOMERCODE!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: CUSTOMERCODE)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: CUSTOMERCODE))")
        if sqlite3_bind_text(stmt, 5, SITEID!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: SITEID)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: SITEID))")
        if sqlite3_bind_text(stmt, 6, SUBMITTIME!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: SUBMITTIME)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: SUBMITTIME))")
        if sqlite3_bind_text(stmt, 7, remarks!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: remarks)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: remarks))")
        if sqlite3_bind_text(stmt, 8, LATITUDE!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: LATITUDE)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: LATITUDE))")
        if sqlite3_bind_text(stmt, 9, LONGITUDE!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: LONGITUDE)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: LONGITUDE))")
        if sqlite3_bind_text(stmt, 10, USERCODE!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: USERCODE)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: USERCODE))")
        if sqlite3_bind_text(stmt, 11, ISMOBILE!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: ISMOBILE)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: ISMOBILE))")
        if sqlite3_bind_text(stmt, 12, post!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: post)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: post))")
        if sqlite3_bind_text(stmt, 13, date!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: date)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: date))")
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure inserting NoOrderRemarkspost data: \(errmsg)")
            return
        }
        print("data saved successfully in NoOrderRemarkspost table")
    }
    public func insertProductDay(dataareaid: NSString?, itemgroupid: NSString?, usercode: NSString?, pddate: NSString?, post: NSString?, isapprove: NSString?){
        var stmt3: OpaquePointer? = nil
        
        let base = Baseactivity()
        
        
        let query = "INSERT INTO ProductDay (dataareaid,itemgroupid,usercode,pddate,post,isapprove,isdate) VALUES (?,?,?,?,?,?,?)"
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt3, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        // binding the parameters
        if sqlite3_bind_text(stmt3, 1, dataareaid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: dataareaid)): \(errmsg)")
            return
        }
        print("\(String(describing: dataareaid))")
        if sqlite3_bind_text(stmt3, 2, itemgroupid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: itemgroupid)): \(errmsg)")
            return
        }
        print("\(String(describing: itemgroupid))")
        if sqlite3_bind_text(stmt3, 3, usercode!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: usercode)): \(errmsg)")
            return
        }
        print("\(String(describing: usercode))")
        if sqlite3_bind_text(stmt3, 4, pddate!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: pddate)): \(errmsg)")
            return
        }
        print("\(String(describing: pddate))")
        
        if sqlite3_bind_text(stmt3, 5, post!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: post)): \(errmsg)")
            return
        }
        print("\(String(describing: post))")
        if sqlite3_bind_text(stmt3, 6, isapprove!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: isapprove)): \(errmsg)")
            return
        }
        print("\(String(describing: isapprove))")
        if sqlite3_bind_text(stmt3, 7, (base.getdate() as NSString).utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: base.getdate())): \(errmsg)")
            return
        }
        print("\(String(describing: base.getdate()))")
        
        
        if sqlite3_step(stmt3) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure inserting ProductDay data: \(errmsg)")
            return
        }
        print("data saved successfully in ProductDay Table")
        
    }
    
    public func deleteproductofday(itemgroupid: String?){
        let query = "delete from ProductDay where itemgroupid = '\(itemgroupid!)'"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table ProductDay ")
            return
        }
        print("ProductDay table deleted")
    }
    
    public func insertUserCurrentCity(date: NSString?, city: NSString?, isblocked: NSString?, post: NSString?){
        var stmt3: OpaquePointer? = nil
        
        let query = "INSERT INTO UserCurrentCity (date,city,isblocked,post) VALUES (?,?,?,?)"
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt3, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt3, 1, date!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: date)): \(errmsg)")
            return
        }
        print("\(String(describing: date))")
        if sqlite3_bind_text(stmt3, 2, city!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: city)): \(errmsg)")
            return
        }
        print("\(String(describing: city))")
        if sqlite3_bind_text(stmt3, 3, isblocked!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: isblocked)): \(errmsg)")
            return
        }
        print("\(String(describing: isblocked))")
        if sqlite3_bind_text(stmt3, 4, post!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: post)): \(errmsg)")
            return
        }
        print("\(String(describing: post))")
        
        
        if sqlite3_step(stmt3) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure inserting UserCurrentCity data: \(errmsg)")
            return
        }
        print("data saved successfully in UserCurrentCity Table")
        
    }
    public func insertsubdealers(customercode: NSString?, expectedsale: NSString?, expectedDiscount: NSString?, dataareaid: NSString?, recid: NSString?, submitdate: NSString?, status: NSString?, approvedby: NSString?, siteid: NSString?, createdtransactionid: NSString?, modifiedtransactionid: NSString?, post: NSString?){
        
        var stmt3: OpaquePointer? = nil
        let query = "INSERT INTO subdealers (customercode,expectedsale,expectedDiscount,dataareaid,recid,submitdate,status,approvedby,siteid,createdtransactionid,modifiedtransactionid,post) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt3, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt3, 1, customercode!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: customercode)): \(errmsg)")
            return
        }
        print("\(String(describing: customercode))")
        if sqlite3_bind_text(stmt3, 2, expectedsale!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: expectedsale)): \(errmsg)")
            return
        }
        print("\(String(describing: expectedsale))")
        if sqlite3_bind_text(stmt3, 3, expectedDiscount!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: expectedDiscount)): \(errmsg)")
            return
        }
        print("\(String(describing: expectedDiscount))")
        if sqlite3_bind_text(stmt3, 4, dataareaid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: dataareaid)): \(errmsg)")
            return
        }
        print("\(String(describing: dataareaid))")
        if sqlite3_bind_text(stmt3, 5, recid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: recid)): \(errmsg)")
            return
        }
        print("\(String(describing: recid))")
        if sqlite3_bind_text(stmt3, 6, submitdate!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: submitdate)): \(errmsg)")
            return
        }
        print("\(String(describing: submitdate))")
        if sqlite3_bind_text(stmt3, 7, status!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: status)): \(errmsg)")
            return
        }
        print("\(String(describing: status))")
        if sqlite3_bind_text(stmt3, 8, approvedby!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: approvedby)): \(errmsg)")
            return
        }
        print("\(String(describing: approvedby))")
        
        if sqlite3_bind_text(stmt3, 9, siteid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: siteid)): \(errmsg)")
            return
        }
        print("\(String(describing: siteid))")
        if sqlite3_bind_text(stmt3, 10, createdtransactionid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: createdtransactionid)): \(errmsg)")
            return
        }
        print("\(String(describing: createdtransactionid))")
        if sqlite3_bind_text(stmt3, 11, modifiedtransactionid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: modifiedtransactionid)): \(errmsg)")
            return
        }
        print("\(String(describing: modifiedtransactionid))")
        if sqlite3_bind_text(stmt3, 12, post!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: post)): \(errmsg)")
            return
        }
        print("\(String(describing: post))")
        
        
        if sqlite3_step(stmt3) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure inserting subdealers data: \(errmsg)")
            return
        }
        print("data saved successfully in subdealers Table")
    }
    public func insertObjectionmaster(objectioncode: NSString?, objectiondesc: NSString?, isblocked: NSString?, createdtransactionid: NSString?,modifiedtransactionid: NSString?,status: NSString?){
        var stmt3: OpaquePointer? = nil
        
        let query = "INSERT INTO ObjectionMaster(objectioncode ,objectiondesc ,createdtransactionid ,modifiedtransactionid ,status ,isblocked ) VALUES (?,?,?,?,?,?)"
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt3, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt3, 1, objectioncode!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: objectioncode)): \(errmsg)")
            return
        }
        print("\(String(describing: objectioncode))")
        if sqlite3_bind_text(stmt3, 2, objectiondesc!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: objectiondesc)): \(errmsg)")
            return
        }
        print("\(String(describing: objectiondesc))")
        if sqlite3_bind_text(stmt3, 3, createdtransactionid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: createdtransactionid)): \(errmsg)")
            return
        }
        print("\(String(describing: createdtransactionid))")
        if sqlite3_bind_text(stmt3, 4, modifiedtransactionid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: modifiedtransactionid)): \(errmsg)")
            return
        }
        print("\(String(describing: modifiedtransactionid))")
        if sqlite3_bind_text(stmt3, 5, status!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: status)): \(errmsg)")
            return
        }
        print("\(String(describing: status))")
        if sqlite3_bind_text(stmt3, 6, isblocked!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: isblocked)): \(errmsg)")
            return
        }
        print("\(String(describing: isblocked))")
        
        if sqlite3_step(stmt3) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure inserting Objectionmaster data: \(errmsg)")
            return
        }
        print("data saved successfully in Objectionmaster Table")
        
    }
    public func insertObjectionEntry(objectioncode: NSString?, objectionid: NSString?, dataareaid: NSString?, customercode: NSString?,siteid: NSString?,submittime: NSString?,status: NSString?, remarks: NSString?, latitude: NSString?, longitude: NSString?,userid: NSString?,post: NSString?){
        var stmt3: OpaquePointer? = nil
        
        let query = "INSERT INTO ObjectionEntry (dataareaid , objectionid , objectioncode, customercode , siteid , submittime , status , remarks ,latitude  ,longitude ,userid ,post ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)"
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt3, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt3, 1, dataareaid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: dataareaid)): \(errmsg)")
            return
        }
        print("\(String(describing: dataareaid))")
        if sqlite3_bind_text(stmt3, 2, objectionid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: objectionid)): \(errmsg)")
            return
        }
        print("\(String(describing: objectionid))")
        if sqlite3_bind_text(stmt3, 3, objectioncode!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: objectioncode)): \(errmsg)")
            return
        }
        print("\(String(describing: objectioncode))")
        if sqlite3_bind_text(stmt3, 4, customercode!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: customercode)): \(errmsg)")
            return
        }
        print("\(String(describing: customercode))")
        if sqlite3_bind_text(stmt3, 5, siteid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: siteid)): \(errmsg)")
            return
        }
        print("\(String(describing: siteid))")
        if sqlite3_bind_text(stmt3, 6, submittime!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: submittime)): \(errmsg)")
            return
        }
        print("\(String(describing: submittime))")
        if sqlite3_bind_text(stmt3, 7, status!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: status)): \(errmsg)")
            return
        }
        print("\(String(describing: status))")
        if sqlite3_bind_text(stmt3, 8, remarks!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: remarks)): \(errmsg)")
            return
        }
        print("\(String(describing: remarks))")
        if sqlite3_bind_text(stmt3, 9, latitude!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: latitude)): \(errmsg)")
            return
        }
        print("\(String(describing: latitude))")
        if sqlite3_bind_text(stmt3, 10, longitude!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: longitude)): \(errmsg)")
            return
        }
        print("\(String(describing: longitude))")
        if sqlite3_bind_text(stmt3, 11, userid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: userid)): \(errmsg)")
            return
        }
        print("\(String(describing: userid))")
        if sqlite3_bind_text(stmt3, 12, post!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: post)): \(errmsg)")
            return
        }
        print("\(String(describing: post))")
        
        if sqlite3_step(stmt3) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure inserting Objectionentry data: \(errmsg)")
            return
        }
        print("data saved successfully in Objectionentry Table")
        
    }
  
    public func insertPriceList(srl: String?,dataareaid: String?,pricegroupid: String?,itemid: String?,price: String?,uom: String?,mrp: String?, createdtransactionid: String?,modifiedtransactionid: String?){
        
        let query = "INSERT INTO UserPriceList(srl,dataareaid,pricegroupid,itemid,price,uom,mrp,createdtransactionid,modifiedtransactionid) VALUES ('\(srl!)','\(dataareaid!)','\(pricegroupid!)','\(itemid!)','\(price!)','\(uom!)','\(mrp!)','\(createdtransactionid!)','\(modifiedtransactionid!)')"
    
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in UserPriceList Table")
            return
        }
        print("data inserted in UserPriceList table")
    }

    public func insertTaxSetup(srl: NSString?, hsncode: NSString?, dataareaid: NSString?, fromstateid: NSString?, tostateid: NSString?, taxserialno: NSString?, taxcomponentid: NSString?, taxper: NSString?,createdtransactionid: NSString?, modifiedtransactionid: NSString?){
        
        var stmt3: OpaquePointer? = nil
        let query = "INSERT INTO usertaxsetup(srl ,hsncode , dataareaid , fromstateid , tostateid , taxserialno , taxcomponentid ,taxper ,createdtransactionid,modifiedtransactionid) VALUES (?,?,?,?,?,?,?,?,?,?)"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt3, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt3, 1, srl!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: srl)): \(errmsg)")
            return
        }
        print("\(String(describing: srl))")
        
        if sqlite3_bind_text(stmt3, 2, hsncode!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: hsncode)): \(errmsg)")
            return
        }
        print("\(String(describing: hsncode))")
        if sqlite3_bind_text(stmt3, 3, dataareaid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: dataareaid)): \(errmsg)")
            return
        }
        print("\(String(describing: dataareaid))")
        if sqlite3_bind_text(stmt3, 4, fromstateid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: fromstateid)): \(errmsg)")
            return
        }
        print("\(String(describing: fromstateid))")
        if sqlite3_bind_text(stmt3, 5, tostateid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: tostateid)): \(errmsg)")
            return
        }
        print("\(String(describing: tostateid))")
        if sqlite3_bind_text(stmt3, 6, taxserialno!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: taxserialno)): \(errmsg)")
            return
        }
        print("\(String(describing: taxserialno))")
        if sqlite3_bind_text(stmt3, 7, taxcomponentid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: taxcomponentid)): \(errmsg)")
            return
        }
        print("\(String(describing: taxcomponentid))")
        if sqlite3_bind_text(stmt3, 8, taxper!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: taxper)): \(errmsg)")
            return
        }
        print("\(String(describing: taxper))")
        
        if sqlite3_bind_text(stmt3, 9, createdtransactionid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: createdtransactionid)): \(errmsg)")
            return
        }
        print("\(String(describing: createdtransactionid))")
        
        if sqlite3_bind_text(stmt3, 10, modifiedtransactionid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: modifiedtransactionid)): \(errmsg)")
            return
        }
        print("\(String(describing: modifiedtransactionid))")
        
        
        if sqlite3_step(stmt3) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure inserting usertaxsetup data: \(errmsg)")
            return
        }
        print("data saved successfully in usertaxsetup Table")
    }
    public func insertcomplains(compid: NSString?, DATAAREAID: NSString?, FEEDBACKTYPE: NSString?, CATEGORY: NSString?, SITEID: NSString?, ITEMID: NSString?, FEEDBACKDESC: NSString?, SUBMITDATETIME: NSString?, CUSTOMERCODE: NSString?, USERCODE: NSString?, post: NSString?, LATITUDE: NSString?, LONGITUDE: NSString?, createdby: NSString?, image: NSString?){
        
        var stmt3: OpaquePointer? = nil
        let query = "INSERT INTO complains(compid ,DATAAREAID , FEEDBACKTYPE , CATEGORY , SITEID , ITEMID , FEEDBACKDESC ,SUBMITDATETIME ,CUSTOMERCODE , USERCODE ,post ,LATITUDE ,LONGITUDE ,createdby,image) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt3, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt3, 1, compid!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: compid)): \(errmsg)")
            return
        }
        print("\(String(describing: compid))")
        if sqlite3_bind_text(stmt3, 2, DATAAREAID!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: DATAAREAID)): \(errmsg)")
            return
        }
        print("\(String(describing: DATAAREAID))")
        if sqlite3_bind_text(stmt3, 3, FEEDBACKTYPE!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: FEEDBACKTYPE)): \(errmsg)")
            return
        }
        print("\(String(describing: FEEDBACKTYPE))")
        if sqlite3_bind_text(stmt3, 4, CATEGORY!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: CATEGORY)): \(errmsg)")
            return
        }
        print("\(String(describing: CATEGORY))")
        if sqlite3_bind_text(stmt3, 5, SITEID!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: SITEID)): \(errmsg)")
            return
        }
        print("\(String(describing: SITEID))")
        if sqlite3_bind_text(stmt3, 6, ITEMID!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: ITEMID)): \(errmsg)")
            return
        }
        print("\(String(describing: ITEMID))")
        if sqlite3_bind_text(stmt3, 7, FEEDBACKDESC!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: FEEDBACKDESC)): \(errmsg)")
            return
        }
        print("\(String(describing: FEEDBACKDESC))")
        if sqlite3_bind_text(stmt3, 8, SUBMITDATETIME!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: SUBMITDATETIME)): \(errmsg)")
            return
        }
        print("\(String(describing: SUBMITDATETIME))")
        
        if sqlite3_bind_text(stmt3, 9, CUSTOMERCODE!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: CUSTOMERCODE)): \(errmsg)")
            return
        }
        print("\(String(describing: CUSTOMERCODE))")
        if sqlite3_bind_text(stmt3, 10, USERCODE!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: USERCODE)): \(errmsg)")
            return
        }
        print("\(String(describing: USERCODE))")
        if sqlite3_bind_text(stmt3, 11, post!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: post)): \(errmsg)")
            return
        }
        print("\(String(describing: post))")
        if sqlite3_bind_text(stmt3, 12, LATITUDE!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: LATITUDE)): \(errmsg)")
            return
        }
        print("\(String(describing: LATITUDE))")
        if sqlite3_bind_text(stmt3, 13, LONGITUDE!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: LONGITUDE)): \(errmsg)")
            return
        }
        print("\(String(describing: LONGITUDE))")
        if sqlite3_bind_text(stmt3, 14, createdby!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: createdby)): \(errmsg)")
            return
        }
        print("\(String(describing: createdby))")
        if sqlite3_bind_text(stmt3, 15, image!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: image)): \(errmsg)")
            return
        }
        print("\(String(describing: image))")
        
        if sqlite3_step(stmt3) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure inserting complains data: \(errmsg)")
            return
        }
        print("data saved successfully in complains Table")
    }
    public func insertfeedbacktype(typecode: NSString?, feedbacK_TYPE: NSString?){
        
        var stmt3: OpaquePointer? = nil
        let query = "INSERT INTO feedbacktype(typecode ,feedbacK_TYPE ) VALUES (?,?)"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt3, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt3, 1, typecode!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: typecode)): \(errmsg)")
            return
        }
        print("\(String(describing: typecode))")
        if sqlite3_bind_text(stmt3, 2, feedbacK_TYPE!.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure binding \(String(describing: feedbacK_TYPE)): \(errmsg)")
            return
        }
        print("\(String(describing: feedbacK_TYPE))")
        if sqlite3_step(stmt3) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("failure inserting feedbacktype data: \(errmsg)")
            return
        }
        print("data saved successfully in feedbacktype Table")
    }
 
    func updatesubdealerconversion(pkey: String?)
    {
        let updatesubdealer = "UPDATE SubDealers  SET post = '2' WHERE customercode = '" + pkey! + "'"
        if sqlite3_exec(Databaseconnection.dbs, updatesubdealer, nil, nil, nil) != SQLITE_OK{
            print("Error Updating Table \(updatesubdealer)")
            return
            
        }
    }
    
    func updatemarketescalation(escalationcode:String?)
    {
        let updatemarketescalation = "UPDATE MarketEscalationActivity  SET post = '2' WHERE escalationcode = '" + escalationcode! + "'"
        if sqlite3_exec(Databaseconnection.dbs, updatemarketescalation, nil, nil, nil) != SQLITE_OK{
            print("Error Updating Table \(updatemarketescalation)")
            return
            
        }
    }

    func updateSubDealerconvert(customercode:String?)
    {
        let updateSubDealerConversion = "delete from InsertSubDealerRequest WHERE customercode = '" + customercode! + "'"
        if sqlite3_exec(Databaseconnection.dbs, updateSubDealerConversion, nil, nil, nil) != SQLITE_OK{
            print("Error Updating Table \(updateSubDealerConversion)")
            return
            
        }
    }
    
    func updateObjectionEntry(ObjectionCode:String?)
    {
        let updatemarketescalation = "UPDATE ObjectionEntry  SET post = '2' WHERE OBJECTIONCODE = '" + ObjectionCode! + "'"
        if sqlite3_exec(Databaseconnection.dbs, updatemarketescalation, nil, nil, nil) != SQLITE_OK{
            print("Error Updating Table ObjectionEntry")
            return
            
        }
    }
    func updateNoOrderReason(STATUSID:String?) {
        let updatemarketescalation = "UPDATE NoOrderRemarksPost  SET post = '2' WHERE statusid = '" + STATUSID! + "'"
        if sqlite3_exec(Databaseconnection.dbs, updatemarketescalation, nil, nil, nil) != SQLITE_OK{
            print("Error Updating Table NoOrderRemarksPost")
            return
            
        }
    }
    func updateComplains(compid:String?) {
        let updatemarketescalation = "UPDATE complains  SET post = '2' WHERE compid = '" + compid! + "'"
        if sqlite3_exec(Databaseconnection.dbs, updatemarketescalation, nil, nil, nil) != SQLITE_OK{
            print("Error Updating Table complains")
            return

        }
    }
    
    func updateAttendance(attendancedate:String?) {
        let updateattandence = "UPDATE Attendance  SET post = '2' WHERE attendancedate = '" + attendancedate! + "'"
        if sqlite3_exec(Databaseconnection.dbs, updateattandence, nil, nil, nil) != SQLITE_OK{
            print("Error Updating Table Attandence")
            return
        }
    }
    
    func createSoOrder(userid:String?,todaydate:String?,siteid:String?,customercode:String?,latitude:String?,longitude:String?,percent:String?,sono:String?){
      
        var stmt1:OpaquePointer?
        
        var query = "select * from SOHEADER where SONO='\(CustomerCard.orderid!)' and (SITEID<>'\(siteid!)'or DISCPERC<>'\(percent!)')"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            if sqlite3_exec(Databaseconnection.dbs, "delete from soline where SONO='\(CustomerCard.orderid!)'", nil, nil, nil) != SQLITE_OK{
                print("Error deleting Table sono")
                return
            }
        }
        
        query = "select * from SOHEADER where SONO='\(CustomerCard.orderid!)'"
        
        var stmt2:OpaquePointer?

        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt2, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        if(sqlite3_step(stmt2) == SQLITE_ROW){
            if sqlite3_exec(Databaseconnection.dbs, "UPDATE SOHEADER set USERID='\(userid!)',SITEID='\(siteid!)',SODATE='\(todaydate!)',CUSTOMERCODE='\(customercode!)',LATITUDE='\(latitude!)',LONGITUDE='\(longitude!)',post='0',APPROVED='0',DISCPERC='\(percent!)' where SONO='\(CustomerCard.orderid!)'", nil, nil, nil) != SQLITE_OK{
                print("Error UPDATING Table SOHEADER")
                return
                
            }
        } else{
            if sqlite3_exec(Databaseconnection.dbs, "INSERT INTO SOHEADER(USERID,SITEID,SONO,SODATE,CUSTOMERCODE,LONGITUDE,LATITUDE,POST,APPROVED,DISCPERC,Remark) values('\(userid!)','\(siteid!)','\(CustomerCard.orderid!)','\(todaydate!)','\(customercode!)','\(longitude!)','\(latitude!)','0','0','\(percent!)','') ", nil, nil, nil) != SQLITE_OK{
                print("Error INSERTING Table SOHEADER")
                return
                
            }
        }
        
        if sqlite3_exec(Databaseconnection.dbs, "UPDATE SOLINE set SITEID='\(siteid!)',secperc='\(percent!)' where SONO='\(CustomerCard.orderid!)'", nil, nil, nil) != SQLITE_OK{
            print("Error UPDATING Table SOLINE")
            return
        }
    }
    
    func insertSoLine(siteid:String?,sono:String?, customercode:String?,itemid:String?,qtyInt:Int!,price:String!,discperc:String!,custstate:String?) -> Int32{
        
        var count: Int32! = 0
        var stmt1:OpaquePointer?
        
        var TAX1COMPONENT: String?
        var TAX1PERC: String?
        
        var TAX2COMPONENT: String?
        var TAX2PERC: String?
        
        
        let taxQuery = "select taxcomponentid,taxper from usertaxsetup where fromstateid= (select stateid from userdistributor where siteid = '\(siteid!)') and tostateid= '\(custstate!)' and hsncode = (select hsncode from ItemMaster where itemid = '\(itemid!)')"
       
        if sqlite3_prepare_v2(Databaseconnection.dbs, taxQuery, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return -1;
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            var stmt2:OpaquePointer?

            let gstQuery = "select gstinno from USERDISTRIBUTOR where siteid= '\(siteid!)' and gstinno<>'' "
            
            if sqlite3_prepare_v2(Databaseconnection.dbs, gstQuery, -1, &stmt2, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                print("error preparing get: \(errmsg)")
                return -1;

            }
            
            if sqlite3_step(stmt2) == SQLITE_ROW {
                
                TAX1PERC = String(cString: sqlite3_column_text(stmt1, 1))
                TAX1COMPONENT = String(cString: sqlite3_column_text(stmt1, 0))

                
                    if sqlite3_step(stmt1) == SQLITE_ROW
                    {
                        TAX2PERC = String(cString: sqlite3_column_text(stmt1, 1))
                        TAX2COMPONENT = String(cString: sqlite3_column_text(stmt1, 0))
                    }
                    else{
                        TAX2COMPONENT = ""
                        TAX2PERC = "0"

                    }
                
            }
            else{
                TAX1COMPONENT = ""
                TAX2COMPONENT = ""
                TAX1PERC = "0"
                TAX2PERC = "0"
            }
            if sqlite3_exec(Databaseconnection.dbs, "delete from SOLINE where SONO='\(CustomerCard.orderid!)' and ITEMID= '\(itemid!)' ", nil, nil, nil) != SQLITE_OK{
                print("Error deleting Table SOLINE")
                return -1;

            }
            if qtyInt > 0
            {
                
                let d2 = Double(price)! * Double(qtyInt)
                
                if sqlite3_exec(Databaseconnection.dbs, "INSERT INTO SOLINE(QTY,SITEID,SONO,ITEMID,CUSTOMERCODE,RATE,LINEAMOUNT,POST,DISCPERC,DISCAMT,DISCTYPE,SECPERC,TAX1PERC,TAX1COMPONENT,TAX2PERC,TAX2COMPONENT) VALUES('\(qtyInt!)','\(siteid!)','\(CustomerCard.orderid!)','\(itemid!)','\(customercode!)','\(price!)','\(d2)','0','0','0','-1','\(discperc!)','\(TAX1PERC!)','\(TAX1COMPONENT!)','\(TAX2PERC!)','\(TAX2COMPONENT!)')", nil, nil, nil) != SQLITE_OK{
                    print("Error INSERTING Table SOLINE")
                    return -1;
                    
                }
                
                let a:Int  = (discperc as NSString).integerValue
                let b:Int = 100 - a
                if sqlite3_exec(Databaseconnection.dbs, "update SOLINE set SECAMT=((\(discperc!) * Lineamount)/100) ,TAXABLEAMOUNT =((\(b) * Lineamount)/100) where SONO= '\(CustomerCard.orderid!)'", nil, nil, nil) != SQLITE_OK{
                    print("Error INSERTING Table SOLINE")
                    return -1;
                    
                    
                }
                if sqlite3_exec(Databaseconnection.dbs, "update SOLINE set TAX1AMT =((TAX1PERC * TAXABLEAMOUNT)/100) , TAX2AMT = ((TAX2PERC * TAXABLEAMOUNT)/100) where SONO= '\(CustomerCard.orderid!)'", nil, nil, nil) != SQLITE_OK{
                    print("Error INSERTING Table SOLINE")
                    return -1;
                    
                    
                }
                if sqlite3_exec(Databaseconnection.dbs, "update SOLINE set  AMOUNT = (TAXABLEAMOUNT +  TAX1AMT + TAX2AMT) where SONO= '\(CustomerCard.orderid!)'", nil, nil, nil) != SQLITE_OK{
                    print("Error INSERTING Table SOLINE")
                    return -1;
                    
                }
                count = 1
            }
        }
        else{
            count = 0
        }
        return count
    }
    
 func deleteTaxSetup()
 {
    let query = "delete from usertaxsetup"
    if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
        print("Error deleting Table usertaxsetup ")
        return
    }
    print("usertaxsetup table deleted")

    }
    
    func approveorder(orderno: String?, approvedate: String?,Remark: String?)
    {
        var query = "update soheader set approved = '1',APPAPPROVEDATE = '\(approvedate!)',Remark = '\(Remark!)' where sono = '\(CustomerCard.orderid!)' "
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error Updating Table soheader ")
            return
        }
        
        query = "update PURCHINDENTHEADER set status = '1',INDENTDATE = '\(approvedate!)' where INDENTNO = '\(CustomerCard.orderid!)' "
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error Updating Table soheader ")
            return
        }
        print("soheader table updated")
    }
    
    func createindent(todaydate: String?, siteid: String?, indentid: String?,status: String?,plantcode: String?,dataareaid: String?)
        
    {
        if sqlite3_exec(Databaseconnection.dbs, "INSERT INTO purchindentheader(SITEID,INDENTNO,INDENTDATE,STATUS,POST,PLANTCODE,DATAAREAID) VALUES('\(siteid!)','\(indentid!)','\(todaydate!)','\(status!)','0','\(plantcode!)','\(dataareaid!)') ", nil, nil, nil) != SQLITE_OK{
            print("Error INSERTING Table PurchaseIndent")
            return;
            
        }
        
        print("Sucessfully INSERTING Table PurchaseIndent")
    }
    
    func insertindentline(siteid: String?,indentid: String?,itemid: String?,itemgroupid: String?,packsize: String?,shipper: String?,qty: Int!,price: String!,plantstateid: String?,stateid: String?) -> Int
    {
        var stmt1:OpaquePointer?
        
        var TAX1COMPONENT: String?
        var TAX1PERC: String?
        
        var TAX2COMPONENT: String?
        var TAX2PERC: String?
        
        let taxQuery = "select taxcomponentid,taxper from usertaxsetup where fromstateid = '\(CustomerCard.plantstateid!)' and tostateid = '\(CustomerCard.stateid!)' and hsncode = (select hsncode from itemmaster where itemid = '\(itemid!)')"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, taxQuery, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return -1;
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            
            TAX1PERC = String(cString: sqlite3_column_text(stmt1, 1))
            TAX1COMPONENT = String(cString: sqlite3_column_text(stmt1, 0))
            
            if sqlite3_step(stmt1) == SQLITE_ROW
            {
                TAX2PERC = String(cString: sqlite3_column_text(stmt1, 1))
                TAX2COMPONENT = String(cString: sqlite3_column_text(stmt1, 0))
            }
            else{
                TAX2COMPONENT = ""
                TAX2PERC = "0"
                
            }
            
            if sqlite3_exec(Databaseconnection.dbs, "delete from PURCHINDENTLINE where INDENTNO = '\(CustomerCard.orderid!)' and ITEMID = '\(itemid!)' ", nil, nil, nil) != SQLITE_OK{
                print("Error deleting Table PURCHINDENTLINE")
                return -1;
            }
            let d2 = Double(price)! * Double(qty)
            if qty > 0
            {
                let query:String = "insert into PURCHINDENTLINE(INDENTNO,SITEID,ITEMID,ITEMGROUP,RATE,LINEAMOUNT,QUANTITY,TAX1COMPONENT,TAX1PER,TAX2COMPONENT,TAX2PER) VALUES ('\(CustomerCard.orderid!)','\(siteid!)','\(itemid!)','\(itemgroupid!)','\(price!)','\(d2)','\(qty!)','\(TAX1COMPONENT!)','\(TAX1PERC!)','\(TAX2COMPONENT!)','\(TAX2PERC!)')"
            
            if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
                print("Error inserting Table PURCHINDENTLINE")
                return -1;
                
            }
            }
            if sqlite3_exec(Databaseconnection.dbs, "update PURCHINDENTLINE set TAX1AMT = ((TAX1PER * LINEAMOUNT)/100), TAX2AMT = ((TAX2PER * LINEAMOUNT)/100) WHERE INDENTNO = '\(CustomerCard.orderid!)'", nil, nil, nil) != SQLITE_OK{
                
                print("Error updating Table PURCHINDENTLINE")
                
                return -1;
                
            }
            
            if sqlite3_exec(Databaseconnection.dbs, "update PURCHINDENTLINE set AMOUNT = (LINEAMOUNT + TAX1AMT + TAX2AMT) where INDENTNO = '\(CustomerCard.orderid!)' ", nil, nil, nil) != SQLITE_OK{
                
                print("Error updating Table PURCHINDENTLINE")
                
                return -1;
                
            }
        }
        else{
            return 0
        }
        return 1
    }
    
    func deleteindent(indentid: String?)
    {
        let deltquery = " delete from PURCHINDENTHEADER where indentno = '\(indentid!)'"
        
        if sqlite3_exec(Databaseconnection.dbs, deltquery, nil, nil, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return;
        }
        
        let query = " delete from PURCHINDENTLINE where indentno = '\(indentid!)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return;
        }
    }
    
    func deleteIndentMultiSelect(indentid: String?, Itemid: [String]){
        
        for index in 0..<Itemid.count{
             let deltquery = "delete from PURCHINDENTLINE where indentno = '\(CustomerCard.orderid!)' and itemid = '\(Itemid[index])'"
            
            if sqlite3_exec(Databaseconnection.dbs, deltquery, nil, nil, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                print("error preparing get: \(errmsg)")
                return;
            }
        }
    }
    
    func deleteSoLineMultiSelect(sono: String?, Itemid: [String]){
        
        for index in 0..<Itemid.count{
            let deltquery = "delete from SOLINE where sono = '\(CustomerCard.orderid!)' and itemid = '\(Itemid[index])'"
            
            if sqlite3_exec(Databaseconnection.dbs, deltquery, nil, nil, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                print("error preparing get: \(errmsg)")
                return;
            }
        }
    }
    
    
    func updatePrimaryOrder(indentid: String?,sysindentid: String?)
    { 
        let updateQuery = " update PURCHINDENTHEADER set post = '2',indentno = '\(sysindentid!)' where indentno = '\(indentid!)'"
        
        if sqlite3_exec(Databaseconnection.dbs, updateQuery, nil, nil, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return;
        }
        let updateQueryLine = " update PURCHINDENTLINE set post = '2',indentno = '\(sysindentid!)' where indentno = '\(indentid!)'"
        
        if sqlite3_exec(Databaseconnection.dbs, updateQueryLine, nil, nil, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return;
        }

    }
    
    func updatePrimaryOrder(itemgroupid: String?)
    {
        let updateQuery = " update ProductDay set post = '2' where itemgroupid = '\(itemgroupid!)'"
        
        if sqlite3_exec(Databaseconnection.dbs, updateQuery, nil, nil, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return;
        }
    }
    
    func updateWorkDate(Date: String?){
        let updateQuery = " update UserCurrentCity set post = '2' where date = '\(Date!)'"
        
        if sqlite3_exec(Databaseconnection.dbs, updateQuery, nil, nil, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return;
        }
    }
    func updatelog(tablename: String?, status: String?, datetime: String?)

    {

        var stmt1: OpaquePointer?

        if (status != nil){

            let query = "select * from initiallog where methodname ='\(tablename!)'"

                  

                  if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{

                      let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)

                      print("error preparing get: \(errmsg)")

                      return ;

                  }

                  if(sqlite3_step(stmt1) == SQLITE_ROW){

            

                      if sqlite3_exec(Databaseconnection.dbs,  "update initiallog set logstat = '\(status!)',syncdatetime = '\(datetime!)',post= '0' where methodname = '\(tablename!)' ", nil, nil, nil) != SQLITE_OK{

                          let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)

                          print("error preparing get: \(errmsg)")

                          return;

                      }

                  }

                  else{

                      if sqlite3_exec(Databaseconnection.dbs, "insert into initiallog(logstat,syncdatetime,post,methodname) values('\(status!)','\(datetime!)','0','\(tablename!)') ", nil, nil, nil) != SQLITE_OK{

                          let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)

                          print("error preparing get: \(errmsg)")

                          return;

                      }

        }

        

        }

    }
    
//    func updatelog(tablename: String?, status: String?, datetime: String?)
//    {
//        var stmt1: OpaquePointer?
//        
//        let query = "select * from initiallog where methodname ='\(tablename!)'"
//        
//        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
//            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
//            print("error preparing get: \(errmsg)")
//            return ;
//        }
//        if(sqlite3_step(stmt1) == SQLITE_ROW){
//  
//            if sqlite3_exec(Databaseconnection.dbs,  "update initiallog set logstat = '\(status!)',syncdatetime = '\(datetime!)',post= '0' where methodname = '\(tablename!)' ", nil, nil, nil) != SQLITE_OK{
//                let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
//                print("error preparing get: \(errmsg)")
//                return;
//            }
//        }
//        else{
//            if sqlite3_exec(Databaseconnection.dbs, "insert into initiallog(logstat,syncdatetime,post,methodname) values('\(status!)','\(datetime!)','0','\(tablename!)') ", nil, nil, nil) != SQLITE_OK{
//                let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
//                print("error preparing get: \(errmsg)")
//                return;
//            }
//        }
//    }
    
    func postLog(tablename: String?, logstat: String?, syncdate: String?,logid: String?)
    {
        var stmt1: OpaquePointer?
        let query = "select * from userlog where tablename ='\(tablename!)'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return ;
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            
            // yha p logstate ki value nil mil rhi h.. q ki secondary ordr post krne p vo response code ka status faliure m gus jta h 
            
            if sqlite3_exec(Databaseconnection.dbs,  "update userlog set logstat = '\(logstat!)',syncdate = '\(syncdate!)',post= '0',logid='\(logid!)' where tablename = '\(tablename!)'", nil, nil, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                print("error preparing get: \(errmsg)")
                return;
            }
        }
        else{
            
           // tablename: String?, logstat: String?, syncdate: String?,logid: String?
            if sqlite3_exec(Databaseconnection.dbs, "insert into userlog(tablename,logstat,syncdate,logid,post) values ('\(tablename!)','\(logstat!)','\(syncdate!)','\(logid!)','0')", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                print("error preparing get: \(errmsg)")
                return;
            }
        }
    }
    func insertExpense(expenseid: String? ,expensedate: String? ,location: String? ,da: String? ,ta: String? ,hotelexpense: String? ,miscellanous: String? ,expenseimage: String? ,expenseimage2: String? ,expenseimage3: String? ,expenseimage4: String? ,post: String? ,workingtype: String?)
    {
        let query = "insert into Expense(expenseid ,expensedate ,location ,da ,ta ,hotelexpense ,miscellanous ,expenseimage ,expenseimage2 ,expenseimage3 ,expenseimage4 ,post ,workingtype ) values ('\(expenseid!)','\(expensedate!)','\(location!)','\(da!)','\(ta!)','\(hotelexpense!)','\(miscellanous!)','\(expenseimage!)','\(expenseimage2!)','\(expenseimage3!)','\(expenseimage4!)','\(post!)','\(workingtype!)')"
        // Expense(expenseid ,expensedate ,location ,da ,ta ,hotelexpense ,miscellanous ,expenseimage ,expenseimage2 ,expenseimage3 ,expenseimage4 ,post ,workingtype )
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in expense Table")
            return
        }
        print("data inserted in expense table")
    }
    
    func insertstatemaster(StateID: String? ,StateName: String? ,Gststatecode: String? ,isunion: String? ,CREATEDTRANSACTIONID: String? ,ModifiedTransactionId: String?)
    {
        var stmt1: OpaquePointer?
        
        let q = "select * from statemaster where StateID='\(StateID!)'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, q, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
       
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            let query = "update StateMaster set StateID='\(StateID!)',StateName='\(StateName!)',Gststatecode='\(Gststatecode!)',isunion='\(isunion!)',CREATEDTRANSACTIONID='\(CREATEDTRANSACTIONID!)',ModifiedTransactionId='\(ModifiedTransactionId!)' where StateID='\(StateID!)"
            
            if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
                print("Error inserting in state master Table")
                return
            }
            print("data Updated in state master table")
            
        }
        else{
            let query = "insert into StateMaster(StateID ,StateName ,Gststatecode ,isunion ,CREATEDTRANSACTIONID ,ModifiedTransactionId) values ('\(StateID!)','\(StateName!)','\(Gststatecode!)','\(isunion!)','\(CREATEDTRANSACTIONID!)','\(ModifiedTransactionId!)')"
            
            if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
                print("Error inserting in state master Table")
                return
            }
            print("data inserted in state master table")
        }
    }
//    func insertcompetitor(dataareaid: String? ,compititorid: String? ,compititorname: String? ,itemid: String? ,itemname: String? ,post: String?,isblocked: String?,status: String?,isapproved: String?)
//    {
//        let query = "insert into COMPETITORDETAIL(dataareaid,compititorid ,compititorname,itemid ,itemname ,post ,isblocked ,status,isapproved) values ('\(dataareaid!)','\(compititorid!)','\(compititorname!)','\(itemid!)','\(itemname!)','\(post!)','\(isblocked!)','\(status!)','\(isapproved!)')"
//
//        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
//            print("Error inserting in COMPETITORDETAIL Table")
//            return
//        }
//        print("data inserted in COMPETITORDETAIL table")
//    }
     func insertcompetitor(dataareaid: String? ,compititorid: String? ,compititorname: String? ,itemid: String? ,itemname: String? ,post: String?,isblocked: String?,status: String?,isapproved: String?,createdtransactionid: String?,modifiedtransactionid: String?)
    {
        var stmt1: OpaquePointer?
        
        let q = "select * from COMPETITORDETAIL where itemid='\(itemid!)'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, q, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
       
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            let query = "update COMPETITORDETAIL set dataareaid='\(dataareaid!)',compititorid='\(compititorid!)',compititorname='\(compititorname!)',itemid='\(itemid!)',itemname='\(itemname!)',post='\(post!)',isblocked='\(isblocked!)',status='\(status!)' ,isapproved='\(isapproved!)',createdtransactionid='\(createdtransactionid!)' ,modifiedtransactionid='\(modifiedtransactionid!)' where itemid='\(itemid!)' "
            
            if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
                print("Error Updated in COMPETITORDETAIL Table")
                return
            }
            print("data Updated in COMPETITORDETAIL table")
            
        }
        else{
           let query = "insert into COMPETITORDETAIL(dataareaid,compititorid ,compititorname,itemid ,itemname ,post ,isblocked ,status,isapproved,createdtransactionid,modifiedtransactionid) values ('\(dataareaid!)','\(compititorid!)','\(compititorname!)','\(itemid!)','\(itemname!)','\(post!)','\(isblocked!)','\(status!)','\(isapproved!)','\(createdtransactionid!)','\(modifiedtransactionid!)')"
            
             if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in COMPETITORDETAIL Table")
            return
        }
        print("data inserted in COMPETITORDETAIL table")
        }
    }
//    func insertDemonstration(customercode: String? ,itemgroupid: String? ,date: String? ,latitude: String? ,longitude: String? ,post: String?)
//    {
//        let query = "insert into demonstration(customercode,itemgroupid ,date,latitude ,longitude ,post) values ('\(customercode!)','\(itemgroupid!)','\(date!)','\(latitude!)','\(longitude!)','\(post!)')"
//
//        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
//            print("Error inserting in Demonstration Table")
//            return
//        }
//        print("data inserted in Demonstration table")
//    }
    
//    func insertusercompetitor(DATAAREAID: String? ,CUSTOMERCODE: String?,ITEMID: String? ,SITEID: String? ,USERCODE: String? ,post: String? ,Competitorid: String?,reasonid: String?,qty: String?,sale: String? ,ispreffered: String? ,preffindex: String?,brandname: String?,isblocked: String?)
//    {
//        let query = "insert into COMPETITORDETAILPOST(DATAAREAID , CUSTOMERCODE,ITEMID ,SITEID ,USERCODE ,post ,Competitorid ,reasonid ,qty ,sale ,ispreffered ,preffindex ,brandname,isblocked) values ('\(DATAAREAID!)','\(CUSTOMERCODE!)','\(ITEMID!)','\(SITEID!)','\(USERCODE!)','\(post!)','\(Competitorid!)','\(reasonid!)','\(qty!)','\(sale!)','\(ispreffered!)','\(preffindex!)','\(brandname!)','\(isblocked!)')"
//
//        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK
//        {
//            print("Error inserting in COMPETITORDETAILPOST Table")
//            return
//        }
//        print("data inserted in COMPETITORDETAILPOST table")
//    }
    
    
    func insertusercompetitor(DATAAREAID: String? ,CUSTOMERCODE: String?,ITEMID: String? ,SITEID: String? ,USERCODE: String? ,post: String? ,Competitorid: String?,reasonid: String?,qty: String?,sale: String? ,ispreffered: String? ,preffindex: String?,brandname: String?,isblocked: String?,createdtransactionid: String?,modifiedtransactionid: String?)
    {
        var stmt1: OpaquePointer?
        
        let q = "select * from COMPETITORDETAILPOST where itemid='\(ITEMID!)'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, q, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
       
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            let query = "update COMPETITORDETAILPOST set DATAAREAID='\(DATAAREAID!)',CUSTOMERCODE='\(CUSTOMERCODE!)',ITEMID='\(ITEMID!)',SITEID='\(SITEID!)',USERCODE='\(USERCODE!)',post='\(post!)',Competitorid='\(Competitorid!)',reasonid='\(reasonid!)',qty='\(qty!)', sale='\(sale!)',ispreffered='\(ispreffered!)',preffindex='\(preffindex!)',brandname='\(brandname!)' ,isblocked='\(isblocked!)',createdtransactionid='\(createdtransactionid!)' ,modifiedtransactionid='\(modifiedtransactionid!)'  where ITEMID='\(ITEMID!)' "
            
            if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
                print("Error Updating in COMPETITORDETAILPOST Table")
                return
            }
            print("data Updated in COMPETITORDETAILPOST table")
            
        }
        else{
          let query = "insert into COMPETITORDETAILPOST(DATAAREAID , CUSTOMERCODE,ITEMID ,SITEID ,USERCODE ,post ,Competitorid ,reasonid ,qty ,sale ,ispreffered ,preffindex ,brandname,isblocked,createdtransactionid,modifiedtransactionid) values ('\(DATAAREAID!)','\(CUSTOMERCODE!)','\(ITEMID!)','\(SITEID!)','\(USERCODE!)','\(post!)','\(Competitorid!)','\(reasonid!)','\(qty!)','\(sale!)','\(ispreffered!)','\(preffindex!)','\(brandname!)','\(isblocked!)','\(createdtransactionid!)','\(modifiedtransactionid!)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK
        {
            print("Error inserting in COMPETITORDETAILPOST Table")
            return
        }
        print("data inserted in COMPETITORDETAILPOST table")
        }
    }
    
    
    func insertuserDR(dataareaid: String? ,siteid: String?,customercode: String? ,drcode: String? ,isblocked: String? ,ispurchaseing: String?,ispriscription: String? ,createdtransactionid: String?,modifiedtransactionid: String?,post: String?)
    {
        //userDRCustLinking( dataareaid , siteid  ,customercode  ,drcode ,isblocked  ,ispurchaseing  ,ispriscription  ,createdtransactionid  ,modifiedtransactionid  ,post )
        let query = "insert into userDRCustLinking( dataareaid , siteid  ,customercode  ,drcode ,isblocked  ,ispurchaseing  ,ispriscription  ,createdtransactionid  ,modifiedtransactionid  ,post ) values ('\(dataareaid!)','\(siteid!)','\(customercode!)','\(drcode!)','\(isblocked!)','\(ispurchaseing!)','\(ispriscription!)','\(createdtransactionid!)','\(modifiedtransactionid!)','\(post!)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in userDRCustLinking Table")
            return
        }
        print("data inserted in userDRCustLinking table")
    }
    func updateExpense(expenseid: String?) {
        let updateexpense = "UPDATE Expense  SET post = '2' WHERE expenseid = '" + expenseid! + "'"
        if sqlite3_exec(Databaseconnection.dbs, updateexpense, nil, nil, nil) != SQLITE_OK{
            print("Error Updating Table Expense")
            return
        }
    }
    func updateproductday(itemgroupId: String) {
//        let updateexpense = "UPDATE productday  SET post = '2' WHERE pddate = '" + uid + "'"
        let updateproductday
            = "UPDATE productday  SET post = '2', isapprove = '1' WHERE itemgroupid = '" + itemgroupId + "'"
   
        if sqlite3_exec(Databaseconnection.dbs, updateproductday, nil, nil, nil) != SQLITE_OK{
            print("Error Updating Table productday")
            return
        }
    }
    
    func deleteOrder(sono: String?)
    {
        let deltquery = " delete from SOHEADER where SONO = '\(sono!)'"
        
        if sqlite3_exec(Databaseconnection.dbs, deltquery, nil, nil, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return;
        }
        
        
        let query = " delete from SOLINE where SONO = '\(sono!)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return;
        }
    }
    
    func insertCircular(sno: String? ,filename: String? ,type: String? ,url: String? ,description: String? ,uploaddate: String? ,uploadtime: String?)
    {
        let query = "insert into Circular(sno ,filename ,type ,url ,description ,uploaddate ,uploadtime) values ('\(sno!)','\(filename!)','\(type!)','\(url!)','\(description!)','\(uploaddate!)','\(uploadtime!)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in Circular Table")
            return
        }
        print("data inserted in Circular table")
    }
    
    func insertUSERDISTRIBUTORITEMLINK(dataareaid: String? ,siteid: String? ,itemgrpid: String? ,createdtransactionid: String? ,modifiedtransactionid: String?)
    {
        let query = "insert into USERDISTRIBUTORITEMLINK(dataareaid ,siteid ,itemgrpid ,createdtransactionid ,modifiedtransactionid) values ('\(dataareaid!)','\(siteid!)','\(itemgrpid!)','\(createdtransactionid!)','\(modifiedtransactionid!)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in USERDISTRIBUTORITEMLINK Table")
            return
        }
        print("data inserted in USERDISTRIBUTORITEMLINK table")
    }
    
    func insertStartTraining(trainedto: String?,trainingid: String?, trainingstarttime: String?, trainingstartdate: String?,post: String?)
    {
        var stmt: OpaquePointer? = nil
        let base = Baseactivity()
        let q = "select * from TrainingDetail where TRAINEDTO = '\(trainedto!)'"
        if sqlite3_prepare_v2(Databaseconnection.dbs, q, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        //127 cast as int, 53
        if(sqlite3_step(stmt) == SQLITE_ROW){
            let query = "update TrainingDetail set TRAININGID = '\(trainingid!)', TRAININGDATE= '\(trainingstartdate!)', TRAINEDTO= '\(trainedto!)', TRAININGSTARTTIME= '\(trainingstarttime!)', TRAININGENDTIME= '\(base.getdate()) 00:00:00.000',REMARKS = '', POST= '\(post!)' where TRAINEDTO= '\(trainedto!)'"
            
            if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
                print("Error updating in Training Table")
                return
            }
        }else{
            let query = "insert into TrainingDetail(TRAININGID, TRAININGDATE, TRAINEDTO, TRAININGSTARTTIME, TRAININGENDTIME, POST) values ('\(trainingid!)','\(trainingstartdate!)','\(trainedto!)','\(trainingstarttime!)','','\(post!)')"
            
            if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
                print("Error inserting in Training Table")
                return
            }
        }
        
        print("data inserted in Training table")
    }
    
    func endTraining(trainingid: String?, remark: String?,traingendtime: String?)
    {
        let query = "update TrainingDetail set TRAININGENDTIME='\(traingendtime!)',REMARKS='\(remark!)' where TRAININGID='\(trainingid!)'  "
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error updating in Training Table")
            return
        }
        print("data updated in Training table")
    }
    
    func inserttariningdetail(TRAININGID: String?,DATAAREAID: String?,TRAININGDATE: String?,TRAINEDTO: String?,TRAININGSTARTTIME: String?,TRAININGENDTIME: String?,REMARKS: String?,USERCODE: String?,USERTYPE: String?,ISMOBILE: String?,POST: String?,status: String?,Trainedtoname: String?){
        
        let query = "insert into TrainingDetail(TRAININGID,DATAAREAID,TRAININGDATE,TRAINEDTO,TRAININGSTARTTIME,TRAININGENDTIME,REMARKS,USERCODE,USERTYPE,ISMOBILE,POST,status) values('\(TRAININGID!)','\(DATAAREAID!)','\(TRAININGDATE!)','\(TRAINEDTO!)','\(TRAININGSTARTTIME!)','\(TRAININGENDTIME!)','\(REMARKS!)','\(USERCODE!)','\(USERTYPE!)','\(ISMOBILE!)','\(POST!)','\(status!)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in TrainingDetail Table")
            return
        }
        if status == "0"
        {
            self.insertusertrainings(traineename: Trainedtoname!, trainingid: TRAININGID!, startdatetime: TRAININGSTARTTIME!)
        }
        print("data inserted in TrainingDetail table")
    }
    
    func updateSecondaryOrder(sono: String?,syssono: String?)
    {
        let updateQuery = " update SOHEADER set post = '2',sono = '\(syssono!)' where sono = '\(sono!)'"
        
        if sqlite3_exec(Databaseconnection.dbs, updateQuery, nil, nil, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return;
        }
        let updateQueryLine = " update SOLINE set SONO = '\(syssono!)' where sono = '\(sono!)'"
        
        if sqlite3_exec(Databaseconnection.dbs, updateQueryLine, nil, nil, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return;
        }
    }
    
    func updatestarttraining(trainingid: String?)
    {
        let query = "update TrainingDetail set post='1', status = '0' where TRAININGID ='\(trainingid!)' and post = '0'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error updating in Training Table")
            return
        }
        print("data updated in Training table")
    }
    
    func updateendtraining(trainingid: String?)
    {
        let query = "update TrainingDetail set post='2', status = '1' where TRAININGID ='\(trainingid!)' and post = '1'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error updating in Training Table")
            return
        }
        print("data updated in Training table")
    }
 
    func insertPendingsubdealer(recid: String?,customercode: String?, customername: String?, distributorcode: String?,distributorname: String?,expsale: String?,expdiscount: String?, usercode: String?, submitdate: String?,type: String?, conV_REQUEST: String?, username: String?)
    {
     
        let query = "insert into Pendingsubdealer(recid, customercode, customername, distributorcode, distributorname, expsale, expdiscount,usercode,submitdate,type,conV_REQUEST,username) values ('\(recid!)','\(customercode!)','\(customername!)','\(distributorcode!)','\(distributorname!)','\(expsale!)','\(expdiscount!)','\(usercode!)','\(submitdate!)','\(type!)','\(conV_REQUEST!)','\(username!)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in Pendingsubdealer Table")
            return
        }
        print("data inserted in Pendingsubdealer table")
    }
    //create table if not exists usertrainings(traineename text,trainingid text,startdatetime text)"
    
    func insertusertrainings(traineename: String?,trainingid: String?, startdatetime: String?)
    {
        
        let query = "insert into usertrainings(traineename, trainingid, startdatetime) values ('\(traineename!)','\(trainingid!)','\(startdatetime!)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in usertrainings Table")
            return
        }
        print("data inserted in usertrainings table")
    }
    
    func insertHospitalType(dataareaid: String? ,typeid: String? ,typedesc: String? ,isblocked: String? ,createdtransactionid: String? ,modifiedtransactionid: String? )
    {
        let query = "insert into HospitalType(dataareaid , typeid,typedesc,isblocked, createdtransactionid ,modifiedtransactionid ) values ('\(dataareaid!)','\(typeid!)','\(typedesc!)','\(isblocked!)','\(createdtransactionid!)','\(modifiedtransactionid!)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in HospitalType Table")
            return
        }
        print("data inserted in HospitalType table")
    }
    
    func insertHospitalMaster(DATAAREAID: String?,TYPE: String?, HOSCODE: String?, HOSNAME: String?,MOBILENO: String?,ALTNUMBER: String?, EMAILID: String?,CityID: String?,ADDRESS: String?, PINCODE: String?, STATEID: String?,ISBLOCKED: String?,CREATEDTRANSACTIONID: String?, MODIFIEDTRANSACTIONID: String?,POST: String?,PURCHASEMGR: String?, AUTHORISEDPERSON: String?, PURCHMGRMOBILENO: String?,AUTHPERSONMOBILENO: String?,DEGISNATION: String?, BEDCOUNT: String?, CATEGORY: String?,SITEID: String?,HOSPITALTYPE: String?, ISPURCHASE: String?,monthlypurchase: String?,custrefcode: String?,salepersoncode: String?)
    {
        var stmt1: OpaquePointer?
        let q = "select * from HospitalMaster where HOSCODE='\(HOSCODE!)'"
        if sqlite3_prepare_v2(Databaseconnection.dbs, q, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        //127 cast as int, 53
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            let query = "update HospitalMaster set DATAAREAID='\(DATAAREAID!)',TYPE='\(TYPE!)',HOSCODE='\(HOSCODE!)',HOSNAME='\(HOSNAME!)',MOBILENO='\(MOBILENO!)',ALTNUMBER='\(ALTNUMBER!)',EMAILID='\(EMAILID!)',CityID='\(CityID!)',ADDRESS='\(ADDRESS!)',PINCODE='\(PINCODE!)',STATEID='\(STATEID!)',ISBLOCKED='\(ISBLOCKED!)',CREATEDTRANSACTIONID='\(CREATEDTRANSACTIONID!)',MODIFIEDTRANSACTIONID='\(MODIFIEDTRANSACTIONID!)',POST='\(POST!)',PURCHASEMGR='\(PURCHASEMGR!)',AUTHORISEDPERSON='\(AUTHORISEDPERSON!)',PURCHMGRMOBILENO='\(PURCHMGRMOBILENO!)',AUTHPERSONMOBILENO='\(AUTHPERSONMOBILENO!)',DEGISNATION='\(DEGISNATION!)',BEDCOUNT='\(BEDCOUNT!)',CATEGORY='\(CATEGORY!)',SITEID='\(SITEID!)',HOSPITALTYPE='\(HOSPITALTYPE!)',ISPURCHASE='\(ISPURCHASE!)',monthlypurchase='\(monthlypurchase!)',custrefcode='\(custrefcode!)',salepersoncode='\(salepersoncode!)' where HOSCODE='\(HOSCODE!)'"
            
            if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
                print("Error inserting in HospitalMaster Table")
                return
            }
            print("data Updated in HospitalMaster table")
        }
        else{
            let query = "insert into HospitalMaster(DATAAREAID , TYPE ,HOSCODE , HOSNAME , MOBILENO ,ALTNUMBER ,EMAILID ,CityID ,ADDRESS ,PINCODE ,STATEID ,ISBLOCKED ,CREATEDTRANSACTIONID ,MODIFIEDTRANSACTIONID  ,POST ,PURCHASEMGR ,AUTHORISEDPERSON ,PURCHMGRMOBILENO ,AUTHPERSONMOBILENO ,DEGISNATION   ,BEDCOUNT ,CATEGORY ,SITEID ,HOSPITALTYPE ,ISPURCHASE,monthlypurchase,custrefcode,salepersoncode ) values ('\(DATAAREAID!)','\(TYPE!)','\(HOSCODE!)','\(HOSNAME!)','\(MOBILENO!)','\(ALTNUMBER!)','\(EMAILID!)','\(CityID!)','\(ADDRESS!)','\(PINCODE!)','\(STATEID!)','\(ISBLOCKED!)','\(CREATEDTRANSACTIONID!)','\(MODIFIEDTRANSACTIONID!)','\(POST!)','\(PURCHASEMGR!)','\(AUTHORISEDPERSON!)','\(PURCHMGRMOBILENO!)','\(AUTHPERSONMOBILENO!)','\(DEGISNATION!)','\(BEDCOUNT!)','\(CATEGORY!)','\(SITEID!)','\(HOSPITALTYPE!)','\(ISPURCHASE!)','\(monthlypurchase!)','\(custrefcode!)','\(salepersoncode!)')"
            
            if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
                print("Error inserting in HospitalMaster Table")
                return
            }
            print("data inserted in HospitalMaster table")
        }
    }
    
    
    func insertHospitalMaster1(DATAAREAID: String?,TYPE: String?, HOSCODE: String?, HOSNAME: String?,MOBILENO: String?,ALTNUMBER: String?, EMAILID: String?,CityID: String?,ADDRESS: String?, PINCODE: String?, STATEID: String?,ISBLOCKED: String?,CREATEDTRANSACTIONID: String?, MODIFIEDTRANSACTIONID: String?,POST: String?,PURCHASEMGR: String?, AUTHORISEDPERSON: String?, PURCHMGRMOBILENO: String?,AUTHPERSONMOBILENO: String?,DEGISNATION: String?, BEDCOUNT: String?, CATEGORY: String?,SITEID: String?,HOSPITALTYPE: String?, ISPURCHASE: String?,monthlypurchase: String?,custrefcode: String?,salepersoncode: String?)
       {
           var stmt1: OpaquePointer?
           let q = "select * from HospitalMaster where HOSCODE='\(HOSCODE!)'"
           if sqlite3_prepare_v2(Databaseconnection.dbs, q, -1, &stmt1, nil) != SQLITE_OK{
               let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
               print("error preparing get: \(errmsg)")
               return
           }
           //127 cast as int, 53
           if(sqlite3_step(stmt1) == SQLITE_ROW){
               let query = "update HospitalMaster set DATAAREAID='\(DATAAREAID!)',TYPE='\(TYPE!)',HOSCODE='\(HOSCODE!)',HOSNAME='\(HOSNAME!)',MOBILENO='\(MOBILENO!)',ALTNUMBER='\(ALTNUMBER!)',EMAILID='\(EMAILID!)',CityID='\(CityID!)',ADDRESS='\(ADDRESS!)',PINCODE='\(PINCODE!)',STATEID='\(STATEID!)',ISBLOCKED='\(ISBLOCKED!)',CREATEDTRANSACTIONID='\(CREATEDTRANSACTIONID!)',MODIFIEDTRANSACTIONID='\(MODIFIEDTRANSACTIONID!)',POST='\(POST!)',PURCHASEMGR='\(PURCHASEMGR!)',AUTHORISEDPERSON='\(AUTHORISEDPERSON!)',PURCHMGRMOBILENO='\(PURCHMGRMOBILENO!)',AUTHPERSONMOBILENO='\(AUTHPERSONMOBILENO!)',DEGISNATION='\(DEGISNATION!)',BEDCOUNT='\(BEDCOUNT!)',CATEGORY='\(CATEGORY!)',SITEID='\(SITEID!)',HOSPITALTYPE='\(HOSPITALTYPE!)',ISPURCHASE='\(ISPURCHASE!)',monthlypurchase='\(monthlypurchase!)' where HOSCODE='\(HOSCODE!)'"
               
               if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
                   print("Error inserting in HospitalMaster Table")
                   return
               }
               print("data Updated in HospitalMaster table")
           }
           else{
               let query = "insert into HospitalMaster(DATAAREAID , TYPE ,HOSCODE , HOSNAME , MOBILENO ,ALTNUMBER ,EMAILID ,CityID ,ADDRESS ,PINCODE ,STATEID ,ISBLOCKED ,CREATEDTRANSACTIONID ,MODIFIEDTRANSACTIONID  ,POST ,PURCHASEMGR ,AUTHORISEDPERSON ,PURCHMGRMOBILENO ,AUTHPERSONMOBILENO ,DEGISNATION   ,BEDCOUNT ,CATEGORY ,SITEID ,HOSPITALTYPE ,ISPURCHASE,monthlypurchase,custrefcode,salepersoncode ) values ('\(DATAAREAID!)','\(TYPE!)','\(HOSCODE!)','\(HOSNAME!)','\(MOBILENO!)','\(ALTNUMBER!)','\(EMAILID!)','\(CityID!)','\(ADDRESS!)','\(PINCODE!)','\(STATEID!)','\(ISBLOCKED!)','\(CREATEDTRANSACTIONID!)','\(MODIFIEDTRANSACTIONID!)','\(POST!)','\(PURCHASEMGR!)','\(AUTHORISEDPERSON!)','\(PURCHMGRMOBILENO!)','\(AUTHPERSONMOBILENO!)','\(DEGISNATION!)','\(BEDCOUNT!)','\(CATEGORY!)','\(SITEID!)','\(HOSPITALTYPE!)','\(ISPURCHASE!)','\(monthlypurchase!)','\(custrefcode!)','\(salepersoncode!)')"
               
               if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
                   print("Error inserting in HospitalMaster Table")
                   return
               }
               print("data inserted in HospitalMaster table")
           }
       }

    func insertHospitalDRLinking(dataareaid: String?,drcode: String?, hospitalcode: String?, isblocked: String?,RECID: String?,CREATEDBY: String?, post: String?,CREATEDTRANSACTIONID: String?,ModifiedTransactionId: String?)
    {
        var stmt1: OpaquePointer?
        let q = "select * from HospitalDRLinking where hospitalcode='\(hospitalcode!)' and drcode='\(drcode!)' and CREATEDBY='\(CREATEDBY!)'"
        if sqlite3_prepare_v2(Databaseconnection.dbs, q, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        //127 cast as int, 53
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            let query = "update HospitalDRLinking set dataareaid='\(dataareaid!)',drcode='\(drcode!)',hospitalcode='\(hospitalcode!)',isblocked='\(isblocked!)',RECID='\(RECID!)',CREATEDBY='\(CREATEDBY!)' ,post='2',CREATEDTRANSACTIONID='\(CREATEDTRANSACTIONID!)',ModifiedTransactionId='\(ModifiedTransactionId!)' where hospitalcode='\(hospitalcode!)' and drcode='\(drcode!)' and CREATEDBY='\(CREATEDBY!)'"
            
            if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
                print("Error inserting in HospitalDRLinking Table")
                return
            }
            print("data Updated in HospitalDRLinking table")
        }
        else{
            let query = "insert into HospitalDRLinking(dataareaid , drcode , hospitalcode ,isblocked ,RECID ,CREATEDBY ,post,CREATEDTRANSACTIONID,ModifiedTransactionId) values ('\(dataareaid!)','\(drcode!)','\(hospitalcode!)','\(isblocked!)','\(RECID!)','\(CREATEDBY!)','\(post!)','\(CREATEDTRANSACTIONID!)','\(ModifiedTransactionId!)')"
            
            if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
                print("Error inserting in HospitalDRLinking Table")
                return
            }
            print("data inserted in HospitalDRLinking table")
        }
    }
    
    func insertDRmaster(dataareaid: String?,drcode: String?, drname: String?, mobileno: String?,alternateno: String?,emailid: String?, address: String?, pincode: String?,city: String?,stateid: String?, dob: String?, doa: String?,isblocked: String?, ispurchaseing: String?, ispriscription: String?, CREATEDTRANSACTIONID: String?,MODIFIEDTRANSACTIONID: String?,POST: String?, drspecialization: String?, purchaseamt: String?,noofprescription: String?,siteid: String?, isbuying: String?, drtype: String?,custrefcode: String?,salepersoncode: String?)
    {
        var stmt1: OpaquePointer?
        let q = "select * from DRMASTER where drcode = '\(drcode!)' "
        if sqlite3_prepare_v2(Databaseconnection.dbs, q, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        //127 cast as int, 53
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            let query = "update DRMASTER set dataareaid='\(dataareaid!)',drcode='\(drcode!)',drname='\(drname!)',mobileno='\(mobileno!)',alternateno='\(alternateno!)',emailid='\(emailid!)',address='\(address!)',pincode='\(pincode!)',city='\(city!)',stateid='\(stateid!)',dob='\(dob!)',doa='\(doa!)',isblocked='\(isblocked!)',ispurchaseing='\(ispurchaseing!)',ispriscription='\(ispriscription!)',CREATEDTRANSACTIONID='\(CREATEDTRANSACTIONID!)',MODIFIEDTRANSACTIONID='\(MODIFIEDTRANSACTIONID!)',POST='\(POST!)',drspecialization='\(drspecialization!)',purchaseamt='\(purchaseamt!)',noofprescription='\(noofprescription!)',siteid='\(siteid!)',isbuying='\(isbuying!)',drtype='\(drtype!)',custrefcode='\(custrefcode!)',salepersoncode='\(salepersoncode!)' where drcode = '\(drcode!)'"
            
            if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
                print("Error inserting in DRMASTER Table")
                return
            }
            print("data updated in DRMASTER table")
        }
        else{
            let query = "insert into DRMASTER(dataareaid  , drcode  , drname , mobileno ,alternateno ,emailid ,address ,pincode ,city ,stateid ,dob ,doa ,isblocked ,ispurchaseing ,ispriscription ,CREATEDTRANSACTIONID  ,MODIFIEDTRANSACTIONID ,POST ,drspecialization ,purchaseamt ,noofprescription ,siteid ,isbuying ,drtype,custrefcode,salepersoncode) values ('\(dataareaid!)','\(drcode!)','\(drname!)','\(mobileno!)','\(alternateno!)','\(emailid!)','\(address!)','\(pincode!)','\(city!)','\(stateid!)','\(dob!)','\(doa!)','\(isblocked!)','\(ispurchaseing!)','\(ispriscription!)','\(CREATEDTRANSACTIONID!)','\(MODIFIEDTRANSACTIONID!)','\(POST!)','\(drspecialization!)','\(purchaseamt!)','\(noofprescription!)','\(siteid!)','\(isbuying!)','\(drtype!)','\(custrefcode!)','\(salepersoncode!)')"
            
            if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
                print("Error inserting in DRMASTER Table")
                return
            }
            print("data inserted in DRMASTER table")
        }
    }
    
    func insertDRmaster1(dataareaid: String?,drcode: String?, drname: String?, mobileno: String?,alternateno: String?,emailid: String?, address: String?, pincode: String?,city: String?,stateid: String?, dob: String?, doa: String?,isblocked: String?, ispurchaseing: String?, ispriscription: String?, CREATEDTRANSACTIONID: String?,MODIFIEDTRANSACTIONID: String?,POST: String?, drspecialization: String?, purchaseamt: String?,noofprescription: String?,siteid: String?, isbuying: String?, drtype: String?,custrefcode: String?,salepersoncode: String?)
       {
           var stmt1: OpaquePointer?
           let q = "select * from DRMASTER where drcode = '\(drcode!)' "
           if sqlite3_prepare_v2(Databaseconnection.dbs, q, -1, &stmt1, nil) != SQLITE_OK{
               let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
               print("error preparing get: \(errmsg)")
               return
           }
           //127 cast as int, 53
           
           if(sqlite3_step(stmt1) == SQLITE_ROW){
               let query = "update DRMASTER set dataareaid='\(dataareaid!)',drcode='\(drcode!)',drname='\(drname!)',mobileno='\(mobileno!)',alternateno='\(alternateno!)',emailid='\(emailid!)',address='\(address!)',pincode='\(pincode!)',city='\(city!)',stateid='\(stateid!)',dob='\(dob!)',doa='\(doa!)',isblocked='\(isblocked!)',ispurchaseing='\(ispurchaseing!)',ispriscription='\(ispriscription!)',CREATEDTRANSACTIONID='\(CREATEDTRANSACTIONID!)',MODIFIEDTRANSACTIONID='\(MODIFIEDTRANSACTIONID!)',POST='\(POST!)',drspecialization='\(drspecialization!)',purchaseamt='\(purchaseamt!)',noofprescription='\(noofprescription!)',siteid='\(siteid!)',isbuying='\(isbuying!)',drtype='\(drtype!)',salepersoncode='\(salepersoncode!)' where drcode = '\(drcode!)'"
               
               if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
                   print("Error inserting in DRMASTER Table")
                   return
               }
               print("data updated in DRMASTER table")
           }
           else{
               let query = "insert into DRMASTER(dataareaid  , drcode  , drname , mobileno ,alternateno ,emailid ,address ,pincode ,city ,stateid ,dob ,doa ,isblocked ,ispurchaseing ,ispriscription ,CREATEDTRANSACTIONID  ,MODIFIEDTRANSACTIONID ,POST ,drspecialization ,purchaseamt ,noofprescription ,siteid ,isbuying ,drtype,custrefcode,salepersoncode) values ('\(dataareaid!)','\(drcode!)','\(drname!)','\(mobileno!)','\(alternateno!)','\(emailid!)','\(address!)','\(pincode!)','\(city!)','\(stateid!)','\(dob!)','\(doa!)','\(isblocked!)','\(ispurchaseing!)','\(ispriscription!)','\(CREATEDTRANSACTIONID!)','\(MODIFIEDTRANSACTIONID!)','\(POST!)','\(drspecialization!)','\(purchaseamt!)','\(noofprescription!)','\(siteid!)','\(isbuying!)','\(drtype!)','\(custrefcode!)','\(salepersoncode!)')"
               
               if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
                   print("Error inserting in DRMASTER Table")
                   return
               }
               print("data inserted in DRMASTER table")
           }
       }
    
    func inserthospitalspecialization(dataareaid: String?,typeid: String?, typedesc: String?, isblocked: String?,status: String?,createdtransactionid: String?, modifiedtransactionid: String?)
    {
        let query = "insert into hospitalspecialization (dataareaid ,typeid ,typedesc ,isblocked , status   , createdtransactionid  , modifiedtransactionid ) values ('\(dataareaid!)','\(typeid!)','\(typedesc!)','\(isblocked!)','\(status!)','\(createdtransactionid!)','\(modifiedtransactionid!)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in hospitalspecialization Table")
            return
        }
        print("data inserted in hospitalspecialization table")
    }
    func insertDRSpecialization(sno: String?,typeid: String?, typedesc: String?, isblocked: String?,status: String?,createdtransactionid: String?, modifiedtransactionid: String?,drtypeid: String?)
    {
        let query = "insert into DRSpecialization(sno , typeid , typedesc ,status , isblocked ,createdtransactionid , modifiedtransactionid ,drtypeid) values ('\(sno!)','\(typeid!)','\(typedesc!)','\(isblocked!)','\(status!)','\(createdtransactionid!)','\(modifiedtransactionid!)','\(drtypeid!)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in DRSpecialization Table")
            return
        }
        print("data inserted in DRSpecialization table")
    }
    public func getmiimage(s: String?,customercode: String?)-> Float{
        var stmt1:OpaquePointer?
        var x:Float = 0;
        let query = "select * from StoreImage where type= '" + s! + "' and customercode = '" + customercode! + "'"
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            AppDelegate.retailerper += 20;
            x = 20.0
        }else{
            if s == "1" {
             x += getstockimage(customercode: customercode!)
            }else if s == "0"{
             x += getstoreimage(customercode: customercode!)
            }
           
        }
        return x;
    }
    func insertDRType(sno: String?,typeid: String?, typedesc: String?, isblocked: String?,status: String?,createdtransactionid: String?, modifiedtransactionid: String?, ismandatory: String?)
    {
        let query = "insert into DRType(sno , typeid , typedesc ,status , isblocked ,createdtransactionid , modifiedtransactionid ,ismandatory ) values ('\(sno!)','\(typeid!)','\(typedesc!)','\(isblocked!)','\(status!)','\(createdtransactionid!)','\(modifiedtransactionid!)','\(ismandatory!)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in DRType Table")
            return
        }
        print("data inserted in DRType table")
    }
//    func insertStoreImage(ids: String?,userId: String?, dataareaid: String?, customercode: String?,siteid: String?,post: String?, type: String?, getdate: String?, latitude: String?, longitude: String?, storestockimage: String?)
//    {
//        var stmt1: OpaquePointer?
//        let q = "select * from StoreImage where customercode = '\(customercode!)' and type='\(type!)'"
//
//        var query = ""
//
//        if sqlite3_prepare_v2(Databaseconnection.dbs, q, -1, &stmt1, nil) != SQLITE_OK{
//            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
//            print("error preparing get: \(errmsg)")
//            return
//        }
//
//        if(sqlite3_step(stmt1) == SQLITE_ROW){
//            query = "update StoreImage set ids=\(ids!), siteid =\(siteid!),post = '0',storestockimage ='\(storestockimage!)',type ='\(type!)',getdate ='\(getdate!)',latitude ='\(latitude!)',longitude = '\(longitude!)' where  customercode = '\(customercode!)' and type='\(type!)'"
//        }else{
//            query = "insert into StoreImage(ids , userId ,dataareaid ,customercode ,siteid ,post ,storestockimage ,type ,getdate ,latitude ,longitude ) values ('\(ids!)','\(userId!)','\(dataareaid!)','\(customercode!)','\(siteid!)','\(post!)','\(storestockimage!)','\(type!)','\(getdate!)','\(latitude!)','\(longitude!)')"
//        }
//        stmt1=nil
//        if sqlite3_prepare_v2(Databaseconnection.dbs, q, -1, &stmt1, nil) != SQLITE_OK{
//            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
//            print("error preparing insert/uppdate: \(errmsg)")
//            return
//        }
//        print("data inserted in StoreImage table")
//    }
    // StoreImage(ids , userId ,dataareaid ,customercode ,siteid ,post ,storestockimage blob,type ,getdate ,latitude ,longitude )
    
    func insertStoreImage(ids: String?,userId: String?, dataareaid: String?, customercode: String?,siteid: String?,post: String?, type: String?, getdate: String?, latitude: String?, longitude: String?, storestockimage: String?)
        {
            var stmt1: OpaquePointer?
            let q = "select * from StoreImage where customercode = '\(customercode!)' and type='\(type!)'"
            var query = ""
            if sqlite3_prepare_v2(Databaseconnection.dbs, q, -1, &stmt1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                print("error preparing get: \(errmsg)")
                return
            }
            if(sqlite3_step(stmt1) == SQLITE_ROW){
                query = "update StoreImage set ids=\(ids!), siteid =\(siteid!),post = '0',storestockimage ='\(storestockimage!)',type ='\(type!)',getdate ='\(getdate!)',latitude ='\(latitude!)',longitude = '\(longitude!)' where  customercode = '\(customercode!)' and type='\(type!)'"
            }else{
                query = "insert into StoreImage(ids , userId ,dataareaid ,customercode ,siteid ,post ,storestockimage ,type ,getdate ,latitude ,longitude ) values ('\(ids!)','\(userId!)','\(dataareaid!)','\(customercode!)','\(siteid!)','\(post!)','\(storestockimage!)','\(type!)','\(getdate!)','\(latitude!)','\(longitude!)')"
            }
            stmt1=nil
            if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
                print("Error inserting/updating in storeimage Table")
                return
            }else{
                print("inserting/updating in storeimage Table")
            }
    
        }
    
    
    func insertMyperformance(usercode: String?,total: String?,tynorp: String?, tynorn: String?,ptarget: String?,pachivement: String?,starget: String?,sachivement: String?){
        let query = "insert into USERMYPERFORMANCE(usercode , total , tynorp ,tynorn ,ptarget ,pachivement,starget ,sachivement ) values ('\(usercode!)','\(total!)','\(tynorp!)','\(tynorn!)','\(ptarget!)','\(pachivement!)','\(starget!)','\(sachivement!)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in USERMYPERFORMANCE Table")
            return
        }
        print("data inserted in USERMYPERFORMANCE table")
    }
    
    
    //    UserNoOrderPerformance(usercode CHAR(255),reasondescription CHAR(255),noofcount CHAR(255))
    
    func insertUserNoOrderPerformance(usercode: String?,reasondescription: String?, noofcount: String?){
        let query = "insert into UserNoOrderPerformance(usercode , reasondescription , noofcount ) values ('\(usercode!)','\(reasondescription!)','\(noofcount!)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in UserNoOrderPerformance Table")
            return
        }
        print("data inserted in UserNoOrderPerformance table")
    }
    func deleteUserNoOrderPerformance(){
        let query = "delete from UserNoOrderPerformance"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting in UserNoOrderPerformance Table")
            return
        }
        print("data deleteed in UserNoOrderPerformance table")
    }
    public func deleteUSERMYPERFORMANCE(){
        let query = "delete from USERMYPERFORMANCE"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table USERMYPERFORMANCE ")
            return
        }
        print("ItemMaster table USERMYPERFORMANCE")
    }
    
    func insertpreresionmaster(dataareaid: String?,reasonid: String?, reasonremarks: String?, CREATEDTRANSACTIONID: String?, ModifiedTRANSACTIONID: String?){
        var stmt1: OpaquePointer?
        let q = "select * from VW_PREFERREDREASONMASTER where reasonid = '\(reasonid!)'"
        if sqlite3_prepare_v2(Databaseconnection.dbs, q, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            let query = "update VW_PREFERREDREASONMASTER set dataareaid='\(dataareaid!)',reasonid='\(reasonid!)',reasonremarks='\(reasonremarks!)',CREATEDTRANSACTIONID='\(CREATEDTRANSACTIONID!)',ModifiedTRANSACTIONID='\(ModifiedTRANSACTIONID!)'"
            
            if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
                print("Error inserting in VW_PREFERREDREASONMASTER Table")
                return
            }
            print("data updated in VW_PREFERREDREASONMASTER table")
        }
        else{
            let query = "insert into VW_PREFERREDREASONMASTER(dataareaid , reasonid , reasonremarks, CREATEDTRANSACTIONID, ModifiedTRANSACTIONID  ) values ('\(dataareaid!)','\(reasonid!)','\(reasonremarks!)','\(CREATEDTRANSACTIONID!)','\(ModifiedTRANSACTIONID!)')"
            
            if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
                print("Error inserting in VW_PREFERREDREASONMASTER Table")
                return
            }
            print("data inserted in VW_PREFERREDREASONMASTER table")
        }
    }
    
    func insertSubdealerRequest(dataareaid: String?,status: String?, expdiscount: String?, recid: String?, usercode: String?,rejectreason: String?, post: String?, customercode: String?){
        
        let query = "insert into InsertSubDealerRequest(dataareaid , status , expdiscount, recid, usercode, rejectreason, post, customercode  ) values ('\(dataareaid!)','\(status!)','\(expdiscount!)','\(recid!)','\(usercode!)','\(rejectreason!)','\(post!)','\(customercode!)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in InsertSubDealerRequest Table")
            return
        }
        print("data inserted in InsertSubDealerRequest table")
    }
    
    func updateCompetitorDetails(olditemid: String?, newitemid: String?){
        let query = "update COMPETITORDETAIL set itemid ='\(newitemid!)' , POST='2' where itemid='\(olditemid!)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error updating in COMPETITORDETAIL Table")
            return
        }
        print("COMPETITORDETAIL Updated olditemid = \(olditemid!)  newitemid = \(newitemid!)")
        
        let query1 = "update COMPETITORDETAILPOST set itemid ='\(newitemid!)' where itemid='\(olditemid!)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query1, nil, nil, nil) != SQLITE_OK{
            print("Error updating in COMPETITORDETAILPOST Table")
            return
        }
        print("COMPETITORDETAILPOST Updated olditemid = \(olditemid!)  newitemid = \(newitemid!)")
    }
    
    func updateCompetitorDetailsPost3(itemid: String?, customercode: String?){
        let query = "update COMPETITORDETAILPOST set POST='2' where itemid='\(itemid!)' and customercode='\(customercode!)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error updating in COMPETITORDETAILPOST Table")
            return
        }
        print("COMPETITORDETAILPOST Updated ")
    }
    
    func updateHospitalMaster(oldhosid: String?, newhosid: String?)
    {
        
        let query1 = "update HospitalMaster set hoscode ='\(newhosid!)' , POST='2' where hoscode='\(oldhosid!)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query1, nil, nil, nil) != SQLITE_OK{
            print("Error updating in HospitalMaster Table")
            return
        }
        print("HospitalMaster Updated oldid = \(oldhosid!)  newid = \(newhosid!)")
        
        let query2 = "update HospitalDRLinking set hospitalcode ='\(newhosid!)'  where hospitalcode='\(oldhosid!)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query2, nil, nil, nil) != SQLITE_OK{
            print("Error updating in HospitalDRLinking Table")
            return
        }
        print("HospitalDRLinking Updated oldid = \(oldhosid!)  newid = \(newhosid!)")
        
        
         let query3 = "update RetailerMaster set referencecode ='\(newhosid!)'  where referencecode='\(oldhosid!)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query3, nil, nil, nil) != SQLITE_OK{
            print("Error updating in RetailerMaster Table")
            return
        }
        print("RetailerMaster Updated oldid = \(oldhosid!)  newid = \(newhosid!)")
        
        let query4 = "update CUSTHOSPITALLINKING set HOSPITALCODE ='\(newhosid!)'  where HOSPITALCODE='\(oldhosid!)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query4, nil, nil, nil) != SQLITE_OK{
            print("Error updating in CUSTHOSPITALLINKING Table")
            return
        }
        print("CUSTHOSPITALLINKING Updated oldid = \(oldhosid!)  newid = \(newhosid!)")
    }
    
    func updateDoctorMaster(olddocid: String?, newdocid: String?)
    {
        let query1 = "update DRMASTER set drcode ='\(newdocid!)', post='2' where drcode='\(olddocid!)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query1, nil, nil, nil) != SQLITE_OK{
            print("Error updating in HospitalMaster Table")
            return
        }
        print("DRMASTER Updated oldid = \(olddocid!)  newid = \(newdocid!)")
        
        let query2 = "update RetailerMaster set referencecode ='\(newdocid!)'  where referencecode='\(olddocid!)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query2, nil, nil, nil) != SQLITE_OK{
            print("Error updating in RetailerMaster Table")
            return
        }
        print("HospitalDRLinking Updated oldid = \(olddocid!)  newid = \(newdocid!)")
        
        let query3 = "update HospitalDRLinking set drcode ='\(newdocid!)'  where drcode='\(olddocid!)'  "
        
        if sqlite3_exec(Databaseconnection.dbs, query3, nil, nil, nil) != SQLITE_OK{
            print("Error updating in HospitalDRLinking Table")
            return
        }
        print("RetailerMaster Updated oldid = \(olddocid!)  newid = \(newdocid!)")
        
        let query4 = "update userDRCustLinking set drcode ='\(newdocid!)'  where drcode='\(olddocid!)' "
        
        if sqlite3_exec(Databaseconnection.dbs, query4, nil, nil, nil) != SQLITE_OK{
            print("Error updating in userDRCustLinking Table")
            return
        }
        print("userDRCustLinking Updated oldid = \(olddocid!)  to newid = \(newdocid!)")
    }
    
    func updateRetailerMaster(oldcusid: String?, newcusid: String?)
    {
        let query1 = "update RetailerMaster set customercode ='\(newcusid!)' , post='2' where customercode='\(oldcusid!)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query1, nil, nil, nil) != SQLITE_OK{
            print("Error updating in RetailerMaster Table")
            return
        }
        
        let query2 = "update DRMASTER set custrefcode ='\(newcusid!)' where custrefcode='\(oldcusid!)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query2, nil, nil, nil) != SQLITE_OK{
            print("Error updating in DRMASTER Table")
            return
        }
        print("DRMASTER Updated oldid = \(oldcusid!)  to newid = \(newcusid!)")
        
        let query3 = "update HospitalMaster set custrefcode ='\(newcusid!)' where custrefcode='\(oldcusid!)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query3, nil, nil, nil) != SQLITE_OK{
            print("Error updating in HospitalMaster Table")
            return
        }
        print("HospitalMaster Updated oldid = \(oldcusid!)  to newid = \(newcusid!)")
        
        self.update(Table: "userDRCustLinking", oldid: oldcusid!, newid: newcusid!)
        self.update(Table: "CUSTHOSPITALLINKING", oldid: oldcusid!, newid: newcusid!)
        self.update(Table: "COMPETITORDETAILPOST", oldid: oldcusid!, newid: newcusid!)
        self.update(Table: "StoreImage", oldid: oldcusid!, newid: newcusid!)
        self.update(Table: "NoOrderRemarksPost", oldid: oldcusid!, newid: newcusid!)
        self.update(Table: "SubDealers", oldid: oldcusid!, newid: newcusid!)
        self.update(Table: "ObjectionEntry", oldid: oldcusid!, newid: newcusid!)
        self.update(Table: "MarketEscalationActivity", oldid: oldcusid!, newid: newcusid!)
        self.update(Table: "complains", oldid: oldcusid!, newid: newcusid!)
        self.update(Table: "SOHEADER", oldid: oldcusid!, newid: newcusid!)
        self.update(Table: "SOLINE", oldid: oldcusid!, newid: newcusid!)
        self.update(Table: "demonstration", oldid: oldcusid!, newid: newcusid!)
        self.update(Table: "USERCUSTOMEROTHINFO", oldid: oldcusid!, newid: newcusid!)
        
    }
    func update(Table: String?, oldid: String?, newid: String?){
        let query1 = "update \(Table!) set customercode ='\(newid!)' where customercode='\(oldid!)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query1, nil, nil, nil) != SQLITE_OK{
            print("Error updating in \(Table!) Table")
            return
        }
        print("\(Table!) Updated oldid = \(oldid!)  to newid = \(newid!)")
    }
    
    func UpdateHospitalDRLinking(hospitalcode: String?, doccode: String?)
    {
        let query = "update HospitalDRLinking set post='2' where hospitalcode = '\(hospitalcode!)' and drcode= '\(doccode!)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error updating in HospitalDRLinking Table")
            return
        }
        print("HospitalDRLinking Updated  ")
    }
    
    func UpdateDocCustomerLinking(customercode: String?, doccode: String?)
    {
        let query = "update userDRCustLinking set post='2' where customercode= '\(customercode!)' and drcode= '\(doccode!)' "
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error updating in userDRCustLinking Table")
            return
        }
        print("Doctor CustomerLinking Updated  ")
    }
    
    func insertCUSTHOSPITALLINKING(dataareaid: String?,siteid: String?, customercode: String?, hospitalcode: String?, isblocked: String?, createdtransactionid: String?, modifiedtransactionid: String?, post: String?){
        let query = "insert into  CUSTHOSPITALLINKING(DATAAREAID , SITEID , CUSTOMERCODE, HOSPITALCODE, ISBLOCKED, CREATEDTRANSACTIONID,modifiedtransactionid,post) values ('\(dataareaid!)','\(siteid!)','\(customercode!)','\(hospitalcode!)','\(isblocked!)','\(createdtransactionid!)','\(modifiedtransactionid!)','\(post!)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in CUSTHOSPITALLINKING Table")
            return
        }
        print("data inserted in CUSTHOSPITALLINKING table")
    }
    
//    create table if not exists salelinkcity(usercode text,usertype text,cityid text,locationtype text,isblocked text,createdid text,modifiedid text,stateid text)"
    
    
    func insertsalelinkcity(usercode: String?,usertype: String?, cityid: String?, locationtype: String?, isblocked: String?, createdid: String?, modifiedid: String?, stateid: String?){
        let query = "insert into  salelinkcity(usercode , usertype , cityid, locationtype, isblocked, createdid,modifiedid,stateid) values ('\(usercode!)','\(usertype!)','\(cityid!)','\(locationtype!)','\(isblocked!)','\(createdid!)','\(modifiedid!)','\(stateid!)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in salelinkcity Table")
            return
        }
        print("data inserted in salelinkcity table")
    }
    //siteid text,usercode text,salepercent text,isdisplay text
    func insertUserdistributorlist(siteid: String?,usercode: String?, salepercent: String?, isdisplay: String?){
        let query = "insert into  USERDISTRIBUTORLIST(siteid , usercode , salepercent, isdisplay) values ('\(siteid!)','\(usercode!)','\(salepercent!)','\(isdisplay!)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in USERDISTRIBUTORLIST Table")
            return
        }
        print("data inserted in USERDISTRIBUTORLIST table")
    }
    
    public func getdoctorper (docid: String?){
        var per = 0;
        var stmt1:OpaquePointer?
        var count = 18
        let query = "select  drname , mobileno ,alternateno ,emailid , address ,pincode ,city ,stateid ,dob ,doa ,ispurchaseing ,ispriscription ,drspecialization ,purchaseamt ,noofprescription ,siteid ,isbuying ,drtype  from drmaster where drcode = '\(docid!)'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        var i = 0;
        while (sqlite3_step(stmt1) == SQLITE_ROW) {
        while (i<count) {
            var cursor = String(cString: sqlite3_column_text(stmt1, Int32(i)))
            print("cursor=======\(cursor)   \(i)  \(per)")
            if  (cursor.count>0 && cursor != "" && cursor != "0"){
                per = per + 1
                print("per===== \(per)")
            }
            i = i + 1
            } }

        AppDelegate.doctorper = Float((per * 40/count))
    }

    public func gethosdoctors(query: String?,refcode: String?)-> Float {
        var stmt1:OpaquePointer?
        let query = "select distinct drcode, drname,mobileno,emailid  from DRMASTER where drcode in (select drcode from HospitalDRLinking where hospitalcode= '" + refcode! + "'  and isblocked = 'false') and (drcode like '%" + query! + "%' or drname like '%" + query! + "%' or mobileno like '%" + query! + "%' )"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
           return 25.0
        }else {
            return 0.0
        }
    }
    
    public func gethoschemist(query: String?,refcode: String? )-> Float {
        var stmt1:OpaquePointer?
        let query = "select distinct customercode, customername,mobileno,emailid  from RetailerMaster where customercode in (select customercode from CUSTHOSPITALLINKING where hospitalcode= '" + refcode! + "' and isblocked = 'false') and (customercode like '%" + query! + "%' or customername like '%" + query! + "%' or mobileno like '%" + query! + "%')"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            return 25.0
        }else {
            return 0.0
        }
    }
   
    public func gethospitalpercent (hosid: String?)-> Float {
        var per = 0;
        var count = 1
        var stmt1:OpaquePointer?
        
        let query1 = "select ISPURCHASE from hospitalMaster  where Hoscode= '\(hosid!)' and HOSCODE <> '' "
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query1 , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let ISPURCHASE = String(cString: sqlite3_column_text(stmt1, 0))
            
         //   if ISPURCHASE == "1"{
                if ISPURCHASE == "true"{
                
                var stmt2:OpaquePointer?
                count = 16
//                let query2 = "select DISTINCT TYPE   , HOSNAME  ,  A.mobileno , case when A.ALTNUMBER = '' then '0000000000' else A.ALTNUMBER end as ALTNUMBER, A.EMAILID ,CityID ,A.ADDRESS ,A.PINCODE ,A.STATEID , PURCHASEMGR  ,PURCHMGRMOBILENO ,A.monthlypurchase,  BEDCOUNT   ,A.CATEGORY   ,A.SITEID , HOSPITALTYPE  from HospitalMaster A left join RetailerMaster B  on A.hoscode= B.referencecode  where Hoscode= '\(hosid!)' and HOSCODE <> ''"
                 let query2 = "select DISTINCT TYPE   , HOSNAME  ,  A.mobileno , case when A.ALTNUMBER = '' then '0000000000' else A.ALTNUMBER end as ALTNUMBER, A.EMAILID ,CityID ,A.ADDRESS ,A.PINCODE ,A.STATEID , PURCHASEMGR  ,PURCHMGRMOBILENO ,A.monthlypurchase,  case when A.BEDCOUNT = '0.0' then '' else A.BEDCOUNT end as BEDCOUNT    ,A.CATEGORY   ,A.SITEID , HOSPITALTYPE  from HospitalMaster A left join RetailerMaster B  on A.hoscode= B.referencecode  where Hoscode= '\(hosid!)' and HOSCODE <> ''"
                    if(AppDelegate.isDebug){
                print("ispurchase=="+query2)
                    }
                if sqlite3_prepare_v2(Databaseconnection.dbs, query2 , -1, &stmt2, nil) != SQLITE_OK{
                    let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                    print("error preparing get: \(errmsg)")
                }
                while(sqlite3_step(stmt2) == SQLITE_ROW){
                    var i:Int32? = 0
                    while(i!<count){
                        let t = String(cString: sqlite3_column_text(stmt2, i!))
                        if t.count > 0 && !t.isEmpty && t != "0" {
                            per += 1
                        }
                        i! += 1
                    }
                }
            }
                else {
                    var stmt3:OpaquePointer?
                    count = 17
//                    let query3 = "select DISTINCT TYPE   , HOSNAME  ,  A.mobileno , case when A.ALTNUMBER = '' then '0000000000' else A.ALTNUMBER end as ALTNUMBER , A.EMAILID ,CityID ,A.ADDRESS ,A.PINCODE ,A.STATEID  ,  AUTHPERSONMOBILENO ,DEGISNATION ,AUTHORISEDPERSON ,A.monthlypurchase  , BEDCOUNT   ,A.CATEGORY   ,A.SITEID   , HOSPITALTYPE from HospitalMaster A left join RetailerMaster B  on A.hoscode= B.referencecode  where Hoscode= '\(hosid!)' and HOSCODE <> '' "
                    
                    let query3 = "select DISTINCT TYPE   , HOSNAME  ,  A.mobileno , case when A.ALTNUMBER = '' then '0000000000' else A.ALTNUMBER end as ALTNUMBER , A.EMAILID ,CityID ,A.ADDRESS ,A.PINCODE ,A.STATEID  ,  AUTHPERSONMOBILENO ,DEGISNATION ,AUTHORISEDPERSON ,A.monthlypurchase  , case when A.BEDCOUNT = '0.0' then '' else A.BEDCOUNT end as BEDCOUNT    ,A.CATEGORY   ,A.SITEID   , HOSPITALTYPE from HospitalMaster A left join RetailerMaster B  on A.hoscode= B.referencecode  where Hoscode= '\(hosid!)' and HOSCODE <> '' "
                    if(AppDelegate.isDebug){
                    print("ispurchasefalse=="+query3)
                    }
                    if sqlite3_prepare_v2(Databaseconnection.dbs, query3 , -1, &stmt3, nil) != SQLITE_OK{
                        let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                        print("error preparing get: \(errmsg)")
                    }
                    while(sqlite3_step(stmt3) == SQLITE_ROW){
                        var i:Int32? = 0
                        while(i!<count){
                            let t = String(cString: sqlite3_column_text(stmt3, i!))
                            if t.count > 0 && !t.isEmpty && t != "0" {
                                per += 1
                            }
                            i! += 1
                        }
                }
            }
        }
  //      per = 16
        AppDelegate.hospitalper = Float((per * 25/count))
        return Float((per * 25/count))
    }

    public func updatestoreimage(id: String) {
        let query = "Update StoreImage set post = '2' where ids = '\(id)'"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error updating in StoreImage Table")
            return
        }
        print("StoreImage Updated for id = \(id)")
        
    }
    public func getcusttype(customercode: String)-> String{
        var stmt1:OpaquePointer?
        var custype: String = "";
        var t: String = "";
        let query = "select customertype from RetailerMaster where customercode = '" + customercode + "' "
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            custype = String(cString: sqlite3_column_text(stmt1, 0))
        }
        if custype == "CG0003"{
            t = "Doctor"
        }else if custype == "CG0001"{
            t = "Retailer"
        }else if custype == "CG0005"{
            t = "Hospital"
        } else if custype == "CG0004"{
            t = "Sub-Dealer"
        }
        return t
    }
    public func getcusttypeCustomerCard(customercode: String)-> String{
        var stmt1:OpaquePointer?
        var custype: String = "";
        var t: String = "";
        let query = "select customertype from RetailerMaster where customercode = '" + customercode + "' "
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            custype = String(cString: sqlite3_column_text(stmt1, 0))
        }
        if custype == "CG0003"{
            t = "Doctor"
        }else if custype == "CG0001"{
            t = "Retailer"
        }else if custype == "CG0005"{
            t = "Hospital"
        } else if custype == "CG0004"{
            t = "Sub-Dealer"
        }
        else if custype == "CG0004"{
            t = "Super Dealer"
        }
        return t
    }
    public func getretailerpecent(customercode: String?)-> Float {
        var per = 0;
        var stmt1:OpaquePointer?
        let count = 15
        let query = "select customername ,customertype ,contactperson  , mobileno ,alternateno ,emailid ,address ,pincode ,city ,stateid ,gstno  ,siteid   ,isorthopositive   ,orthopedicsale ,avgsale from RetailerMaster where customercode ='\(customercode!)'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            var i:Int32? = 0
            while(i!<15){
                let t = String(cString: sqlite3_column_text(stmt1, i!))
                if t.count > 0 && !t.isEmpty && t != "0"{
                    per += 1
                }
                i! += 1
            }
        }
        AppDelegate.retailerper = Float((per * 20/count))
        AppDelegate.genralDetailsper = Float((per * 20/count))
        return Float((per * 20/count))
    }

    public func getstockimage(customercode: String?)-> Float{
        var stmt1:OpaquePointer?
        let query = "select * from RetailerMaster where customercode='" + customercode! + "' and stockimage= '1'"
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
//            var stockimage=
            AppDelegate.retailerper += 20;
            return 20.0;
        }else{
            return 0.0;
        }
    }
    public func getstoreimage(customercode: String?)-> Float{
        var stmt1:OpaquePointer?
        let query = "select * from RetailerMaster where customercode='" + customercode! + "' and storeimage= '1'"
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            //            var stockimage=
            AppDelegate.retailerper += 20;
            return 20.0;
        }else{
            return 0.0;
        }
    }
    
    public func getcustdoctor(query: String?,customercode: String?)-> Float {
        var stmt1:OpaquePointer?
        let query = "select distinct 1 as _id,drcode, drname,mobileno,emailid  from DRMASTER where drcode in (select drcode from         userDRCustLinking where customercode= '" + customercode! + "'  and isblocked = 'false' ) and (drcode like '%" + query! + "%' or drname like '%" + query! + "%' or   mobileno like '%" + query! + "%' )"
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            AppDelegate.retailerper += 20;
            return 20.0
        }else {
            return 0.0
        }
    }
    public func getcompetitor(customercode: String?) -> Float{
        var stmt1:OpaquePointer?
        var Vatage: Float = 0;
        let query = "select customertype from RetailerMaster where customercode = '" + customercode! + "' "
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
             let t = String(cString: sqlite3_column_text(stmt1, 0))
            if t == "CG0003"{
                Vatage = 30;
            }else if (t == "CG0001" || t == "CG0004") {
                Vatage = 20;
            }else if t == "CG0005"{
                Vatage = 25;
            }
            let query1 = "select 1 _id,B.rowid,A.compititorname,A.itemname from COMPETITORDETAIL A INNER JOIN COMPETITORDETAILPOST B ON A.itemid = B.itemid where B.CUSTOMERCODE='" + customercode! + "' AND B.isblocked= 'false' "
            if(AppDelegate.isDebug){
            print("getcompetitor")
            print(query1)
            }
            if sqlite3_prepare_v2(Databaseconnection.dbs, query1 , -1, &stmt1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                print("error preparing get: \(errmsg)")
            }
            if(sqlite3_step(stmt1) == SQLITE_ROW){
                AppDelegate.retailerper += Vatage;
                return Vatage
            }else{
                return 0.0
            }
        }else{
            return 0
        }
    }
    
    public func getdoctorpecent(docid: String?)-> Float {
        var per = 0;
        var stmt1:OpaquePointer?
        var count = 18
        let query = "select  drname , mobileno ,alternateno ,emailid , address ,pincode ,city ,stateid ,dob ,doa ,case when ispurchaseing = 'false' then '-1' when ispurchaseing = 'true' then ispurchaseing end as ispurchased,case when ispriscription = 'false' then '-1' when ispriscription = 'true' then ispriscription end as ispriscriptioned,drspecialization ,case when purchaseamt = '0.0' then '-1' when purchaseamt = '' then '-1' when purchaseamt > '0.0' then purchaseamt end as purchaseamt,  CASE when noofprescription  = '0'  then '-1' when noofprescription  = '0.0'  then '' when noofprescription  = ' ' then '-1' when noofprescription  > '0'  then noofprescription else '' end as noofprescription,siteid ,case when isbuying == 'false' then 'no' when  isbuying == 'true' then 'yes' end as isbuying ,drtype  from drmaster  where drcode ='" + docid! + "'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        if(AppDelegate.isDebug){
        print("getdoctorpecent====="+query)
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            var i:Int32? = 0
            while(i!<18){
                let t = String(cString: sqlite3_column_text(stmt1, i!))
                if t.count > 0 && !t.isEmpty && t != "0"{
                    per += 1
                }
                i! += 1
            }
        }
        AppDelegate.retailerper = Float((per * 40/count))
        return Float((per * 40/count))
    }
    
    public func gethospitallist(docid: String?)-> Float{
        var stmt1:OpaquePointer?
        let query = "select distinct 1 as _id,A.HOSNAME,A.ADDRESS,B.CityName,C.typedesc  from HospitalMaster A left outer join CityMaster B on A.CityID = B.CityID left outer join HospitalType C on A.type = C.typeid where A.hoscode in (select hospitalcode from HospitalDRLinking where drcode= '" + docid! + "')"
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")

        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            AppDelegate.retailerper += 30;
            return 30.0
       } else{
      return  0.0
       }
    }
    
    func insertSoLineQty(siteid:String?,sono:String?, customercode:String?,itemid:String?,qtyInt:Int!,price:String!,discperc:String!,custstate:String?) -> Int32{
        
        var count: Int32! = 0
        var stmt1:OpaquePointer?
        
        var TAX1COMPONENT: String?
        var TAX1PERC: String?
        
        var TAX2COMPONENT: String?
        var TAX2PERC: String?
        
        
        let taxQuery = "select taxcomponentid,taxper from usertaxsetup where fromstateid= (select stateid from userdistributor where siteid = '\(siteid!)') and tostateid= '\(custstate!)' and hsncode = (select hsncode from ItemMaster where itemid = '\(itemid!)')"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, taxQuery, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return -1;
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            var stmt2:OpaquePointer?
            
            let gstQuery = "select gstinno from USERDISTRIBUTOR where siteid= '\(siteid!)' and gstinno<>'' "
            
            if sqlite3_prepare_v2(Databaseconnection.dbs, gstQuery, -1, &stmt2, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                print("error preparing get: \(errmsg)")
                return -1;
                
            }
            
            if sqlite3_step(stmt2) == SQLITE_ROW {
                
                TAX1PERC = String(cString: sqlite3_column_text(stmt1, 1))
                TAX1COMPONENT = String(cString: sqlite3_column_text(stmt1, 0))
                
                
                if sqlite3_step(stmt1) == SQLITE_ROW
                {
                    TAX2PERC = String(cString: sqlite3_column_text(stmt1, 1))
                    TAX2COMPONENT = String(cString: sqlite3_column_text(stmt1, 0))
                }
                else{
                    TAX2COMPONENT = ""
                    TAX2PERC = "0"
                    
                }
                
            }
            else{
                TAX1COMPONENT = ""
                TAX2COMPONENT = ""
                TAX1PERC = "0"
                TAX2PERC = "0"
            }
            if sqlite3_exec(Databaseconnection.dbs, "delete from SOLINE where SONO='\(CustomerCard.orderid!)' and ITEMID= '\(itemid!)' ", nil, nil, nil) != SQLITE_OK{
                print("Error deleting Table SOLINE")
                return -1;
                
            }
            if qtyInt > 0
            {
                
                let d2 = Double(price)! * Double(qtyInt)
                
                
                if sqlite3_exec(Databaseconnection.dbs, "INSERT INTO SOLINE(QTY,SITEID,SONO,ITEMID,CUSTOMERCODE,RATE,LINEAMOUNT,POST,DISCPERC,DISCAMT,DISCTYPE,SECPERC,TAX1PERC,TAX1COMPONENT,TAX2PERC,TAX2COMPONENT) VALUES('\(qtyInt!)','\(siteid!)','\(CustomerCard.orderid!)','\(itemid!)','\(customercode!)','\(price!)','\(d2)','0','0','0','-1','\(self.getDiscountNew())','\(TAX1PERC!)','\(TAX1COMPONENT!)','\(TAX2PERC!)','\(TAX2COMPONENT!)')", nil, nil, nil) != SQLITE_OK{
                    print("Error INSERTING Table SOLINE")
                    return -1;
                    
                }
               
                let a:Int  = (self.getDiscountNew() as NSString).integerValue
                let b:Int = 100 - a
                if sqlite3_exec(Databaseconnection.dbs, "update SOLINE set SECAMT=((\(discperc!) * Lineamount)/100) ,TAXABLEAMOUNT =((\(b) * Lineamount)/100) where SONO= '\(CustomerCard.orderid!)'", nil, nil, nil) != SQLITE_OK{
                    print("Error INSERTING Table SOLINE")
                    return -1;
                    
                    
                }
                if sqlite3_exec(Databaseconnection.dbs, "update SOLINE set TAX1AMT =((TAX1PERC * TAXABLEAMOUNT)/100) , TAX2AMT = ((TAX2PERC * TAXABLEAMOUNT)/100) where SONO= '\(CustomerCard.orderid!)'", nil, nil, nil) != SQLITE_OK{
                    print("Error INSERTING Table SOLINE")
                    return -1;
                    
                    
                }
                if sqlite3_exec(Databaseconnection.dbs, "update SOLINE set  AMOUNT = (TAXABLEAMOUNT +  TAX1AMT + TAX2AMT) where SONO= '\(CustomerCard.orderid!)'", nil, nil, nil) != SQLITE_OK{
                    print("Error INSERTING Table SOLINE")
                    return -1;
                    
                }
                count = 1
            }
        }
        else{
            count = 0
        }
        return count
    }
    func getDiscountNew() -> String
    {
        var  discountper:String! = ""
        var stmt1: OpaquePointer?
        let query = "select discperc from SOHEADER WHERE SONO = '\(CustomerCard.orderid!)'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return "0"
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            discountper = String(cString: sqlite3_column_text(stmt1, 0))
        }
        return discountper
    }
    func UpdateCUSTHOSPITALLINKING(customercode: String?, hoscode: String?)
    {
        let query = "update CUSTHOSPITALLINKING set post='2' where customercode= '\(customercode!)' and hospitalcode= '\(hoscode!)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error updating in CUSTHOSPITALLINKING Table")
            return
        }
        print("CUSTHOSPITALLINKING Updated  ")
    }
    
  public func deleteDatabase()
    {
            let filemManager = FileManager.default
            do {
              //  let fileURL = NSURL(fileURLWithPath: filePath)
                let fileURL = try!
                FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("TynorDatabase.sqlite")

                try filemManager.removeItem(at: fileURL as URL)
                print("Database Deleted!")
            } catch {
                print("Error on Delete Database!!!")
            }
    }
    
    
    public func insertretailerlistsearch(customername: String? ,lastvisit: String? ,cityname: String? ,sitename: String? ,currmonth: String?,complain: String? ,mi: String? ,customercode: String?,keycustomer: String?)
    {
        var stmt1: OpaquePointer?
        let q = "select * from retailerlistsearch where customercode = '\(customercode!)'"
        if sqlite3_prepare_v2(Databaseconnection.dbs, q, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            let query = "update retailerlistsearch set customername='\(customername!)',lastvisit='\(lastvisit!)',cityname='\(cityname!)',sitename='\(sitename!)',currmonth='\(currmonth!)',complain='\(complain!)',mi='\(mi!)',customercode='\(customercode!)',keycustomer='\(keycustomer!)' where customercode = '\(customercode!)'"

            if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
                print("Error inserting in retailerlistsearch Table")
                return
            }
            print("data Updated in retailerlistsearch table")
        }
        else{
            let query = "INSERT INTO retailerlistsearch(customername,lastvisit,cityname,sitename,currmonth,complain,mi,customercode,keycustomer) VALUES ('\(customername!)','\(lastvisit!)','\(cityname!)','\(sitename!)','\(currmonth!)','\(complain!)','\(mi!)','\(customercode!)','\(keycustomer!)')"
            
            if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
                print("Error inserting in retailerlistsearch Table")
                return
            }
            if(AppDelegate.isDebug){
            print("data saved successfully in retailerlistsearch table")
            }
        }
    }
    
    public func clearData (){

           var stmt1:OpaquePointer?
           
           let query = "select  name from sqlite_master where type = 'table' "
           print("cleardata==="+query)
           if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
               let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
               print("error preparing get: \(errmsg)")
               return
           }
           let count = query.count
           print("cleardatacount==="+String(count))
            
            if(sqlite3_step(stmt1) == SQLITE_ROW){
                self.deleteDRType()
                self.deleteExpense()
                self.deleteCircular()
                self.deleteDRMASTER()
                self.deleteTaxSetup()
                self.deleteitemmaster()
                self.deleteattendancereport()
                self.deletecomplaintreport()
                self.deleteescalationreport()
                self.deleteindentdetails()
                self.deletesodeatils()
                self.deleteuserprimary()
                self.deletedashdetailcard()
                self.deleteusertype()
                self.deleteUSERDISTRIBUTORITEMLINK()
                self.deleteAttendanceMaster()
                self.deleteusercustomer()
                self.deleteUSERDISTRIBUTOR ()
                self.deleteusercustomer()
                self.deleteProfiledetail()
                self.deleteUSERHIERARCHY()
                self.deleteUserCurrentCity()
                self.deletefeedbacktype()
                self.deleteHospitaltype()
                self.deleteretailermaster()
                self.deleteHospitalMaster()
                self.deleteproductday()
                self.deleteNoOrderRemarks()
                self.deleteStateMaster()
                self.deleteCityMaster()
                self.deleteAttendance()
                self.deleteUSERCUSTOMERORTHOINFO()
                self.deleteUserdistributorlist()
                
                
                
                
         //   var query1 = ""
//            query1 = "delete from CustomerDetail "
//            query1 = "delete from AssetDetail "
//            query1 = "delete from CartTable "
//            query1 = "delete from RetailerList "
//            query1 = "delete from UserPrimaryDashboard "
//            query1 = "delete from OrderHeader "
//            query1 = "delete from OrderLineActivity "
//            query1 = "delete from COMPETITORDETAIL "
//            query1 = "delete from USERDISTRIBUTOR "
//            query1 = "delete from ProfileDetail "
//            query1 = "delete from VW_PREFERREDREASONMASTER "
//            query1 = "delete from StoreImage "
//            query1 = "delete from ItemMaster "
//            query1 = "delete from COMPETITORDETAILPOST "
//            query1 = "delete from sodetails "
//            query1 = "delete from Attendance "
//            query1 = "delete from RetailerMaster "
//            query1 = "delete from CityMaster "
//            query1 = "delete from StateMaster "
//            query1 = "delete from DRMASTER "
//            query1 = "delete from HospitalType "
//            query1 = "delete from HospitalMaster "
//            query1 = "delete from userDRCustLinking "
//            query1 = "delete from HospitalDRLinking "
//            query1 = "delete from UserPriceList "
//            query1 = "delete from SOHEADER "
//            query1 = "delete from SOLINE "
//            query1 = "delete from SubDealers "
//            query1 = "delete from UserLinkCity "
//            query1 = "delete from UserCurrentCity "
//            query1 = "delete from usertaxsetup "
//            query1 = "delete from usertype "
//                query1 = "delete from NoOrderReasonMaster "
//                query1 = "delete from NoOrderRemarksPost "
//                query1 = "delete from NoOrderRemarks "
//                query1 = "delete from EscalationReason "
//                query1 = "delete from MarketEscalationActivity "
//                query1 = "delete from complains "
//                query1 = "delete from feedbacktype "
//                query1 = "delete from feedbacks "
//                query1 = "delete from Circular "
//                query1 = "delete from USERCUSTOMEROTHINFO "
//                query1 = "delete from attendancereport "
//                query1 = "delete from SubDealersEntry "
//                query1 = "delete from DRType "
//                query1 = "delete from DRSpecialization "
//                query1 = "delete from hospitalspecialization "
//                query1 = "delete from ChangePassword "
//                query1 = "delete from ObjectionMaster "
//                query1 = "delete from ObjectionEntry "
//                query1 = "delete from CUSTHOSPITALLINKING "
//                query1 = "delete from USERHIERARCHY "
//                query1 = "delete from TrainingDetail "
//                query1 = "delete from TransportMode "
//                query1 = "delete from Miscellaneous "
//                query1 = "delete from initiallog "
//                query1 = "delete from userlog "
//                query1 = "delete from superdealer "
//                query1 = "delete from Transporters "
//                query1 = "delete from PaymentTerm "
//                query1 = "delete from USERMYPERFORMANCE "
//                query1 = "delete from UserNoOrderPerformance "
//                query1 = "delete from USERTARGETSALERATE "
//                query1 = "delete from Expense "
//                query1 = "delete from PURCHINDENTHEADER "
//                query1 = "delete from PURCHINDENTLINE "
//                query1 = "delete from ExpenseReport "
//                query1 = "delete from AttendanceMaster "
//                query1 = "delete from Pendingsubdealer "
//                query1 = "delete from IndentDetails "
//                query1 = "delete from USERDISTRIBUTORITEMLINK "
//                query1 = "delete from fcmtable "
//                query1 = "delete from demonstration "
//                query1 = "delete from InsertSubDealerRequest "
//                query1 = "delete from salelinkcity "
//                query1 = "delete from USERDISTRIBUTORLIST "
//                query1 = "delete from usertrainings "
                
        }
       }
    }
    

