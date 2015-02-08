global class WS_SubmitDataToPega{
    
    
    static String UnderwriterID = 'rakeshvadlamuri';
      
    /**
      * @description       This method is used to send Submission details to Pega System
      * @param             recId - SFDC id of the Submission record
      * @return            void
      * @throws            NA
      */
    Webservice static String sendDataToPega(String id){
        String returnVal; 
        try{
            List<pegarulesSoapAigfwmncpsubmissionsvcSt.IssuingOfficeDetail_element> iOfcList = new List<pegarulesSoapAigfwmncpsubmissionsvcSt.IssuingOfficeDetail_element>();
            /*                                           
            for(SOV__c obj: [SELECT Pct_F_Fee_Local__c,USD_Policy_Limit__c,Amt_F_Fee_Total__c,TIV_USD_Values_M_E__c,TIV_USD_Values_Building__c,TIV_USD_Total_PD_BI__c,TIV_USD_Total_PD__c,TIV_USD_Business_Interruption__c,Policy_Type__c,Policy_Count__c,Terr_Count__c,Tariff_Non_Tariff__c,Square_Footage__c,Sprinklered_Pct__c,Amt_F_Fee_RISO__c,Reins_Tax__c,Rate_AV_Term__c,Permitted_US_DLRS__c,PCT_EXP__c,PCT_BRKG__c,Payment_Recd__c,Omega_Count__c,Occupancy_Mfg_Whse__c,Method_of_Payment__c,Local_Policy_Limit__c,Local_Curr__c,Invoice_Count__c,GWP_USDLRS__c,GWP_Local__c,Exch_Rate__c,EDP_Equip_Software__c,Contents_Including_Inventory_and_F_F__c,Construction__c,Amount_Paid__c,Amt_F_Fee_Local__c,Central_Collect__c,Territory__c,Local_Insured__c,Address__c,City__c,Postal_Code__c
                                 FROM SOV__c WHERE Submission__c =: id]){
            
                pegarulesSoapAigfwmncpsubmissionsvcSt.IssuingOfficeDetail_element iofc = new pegarulesSoapAigfwmncpsubmissionsvcSt.IssuingOfficeDetail_element();
                iofc.PermittedUSDLRS = obj.Permitted_US_DLRS__c;
                iofc.LocalFeeAmount = obj.Amt_F_Fee_Local__c;
                iofc.CentralCollect = obj.Central_Collect__c;
                iofc.AmountPaid = obj.Amount_Paid__c;
                iofc.Construction = obj.Construction__c;
                iofc.ContentsIncludingInventory = obj.Contents_Including_Inventory_and_F_F__c;
                iofc.EDPEquipSoftware = obj.EDP_Equip_Software__c;
                iofc.ExchangeRate = obj.Exch_Rate__c;
                iofc.GWPLocal = obj.GWP_Local__c;
                iofc.GWPUSDLRS = obj.GWP_USDLRS__c;
                iofc.InvoiceCount = obj.Invoice_Count__c;
                iofc.LocalCurrency = obj.Local_Curr__c;
                iofc.LocalPCTAmount = obj.Pct_F_Fee_Local__c;
                iofc.LocalPolicyLimit = obj.Local_Policy_Limit__c;
                iofc.ModeOfPayment = obj.Method_of_Payment__c;
                iofc.Occupancy = obj.Occupancy_Mfg_Whse__c;
                iofc.OmegaCount = obj.Omega_Count__c;
                iofc.PaymentReceived = obj.Payment_Recd__c;
                iofc.PCTBRKG = obj.PCT_BRKG__c;         
                iofc.PCTEXP = obj.PCT_EXP__c;
                iofc.ProdOfficeFeeAmount = 
                iofc.RateAVTerm = obj.Rate_AV_Term__c;
                iofc.ReinsuranceTax = obj.Reins_Tax__c;
                iofc.RISOFeeAmount = obj.Amt_F_Fee_RISO__c;
                iofc.SprinkleredPct = obj.Sprinklered_Pct__c;
                iofc.SquareFootage = obj.Square_Footage__c;
                iofc.TariffIndicator = obj.Tariff_Non_Tariff__c;
                iofc.PolicyCount = obj.Policy_Count__c;
                iofc.PolicyType = obj.Policy_Type__c;           
                iofc.Territory = obj.Territory__c;
                iofc.TerritoryCount = obj.Terr_Count__c;
                iofc.TIVUSDBusinessInterruption = obj.TIV_USD_Business_Interruption__c;
                iofc.TIVUSDTotalPD = obj.TIV_USD_Total_PD__c;
                iofc.TIVUSDTotalPDBI = obj.TIV_USD_Total_PD_BI__c;
                iofc.TIVUSDValuesBuilding = obj.TIV_USD_Values_Building__c;
                iofc.TIVUSDValuesME = obj.TIV_USD_Values_M_E__c;
                iofc.TotalFeeAmount = obj.Amt_F_Fee_Total__c;
                iofc.USDPolicyLimit = obj.USD_Policy_Limit__c;
                iofc.LocalInsuredName = obj.Local_Insured__c ;
                
                iOfcList.add(iofc);
                
            }
            */
            pegarulesSoapAigfwmncpsubmissionsvcSt.StartMNCPPortSOAP pegaService = new pegarulesSoapAigfwmncpsubmissionsvcSt.StartMNCPPortSOAP ();
            
            pegarulesSoapAigfwmncpsubmissionsvcSt.SubmissionDetails_element subRecord = new pegarulesSoapAigfwmncpsubmissionsvcSt.SubmissionDetails_element();                          
            subRecord.SubmissionData = new pegarulesSoapAigfwmncpsubmissionsvcSt.SubmissionData_element ();
            /*
            Submission__c submission = [SELECT Id,pegaSubmissionId__c, Account_Name__r.Name,Address__c,Eff_Date__c,Exp_Date__c, Building_Values__c,
                                        City__c, Construction__c, Coverage__c,Exchange_Rate__c, Local_Currency__c, Postal_Code__c, Producing_Office__c, Properties__c
                                        FROM Submission__c WHERE Id =: id];
            */                           
            subRecord.AccountID = '0011100000E5Ap7';
            subRecord.ProducingOffice = 'USA';
            subRecord.POAddress = 'USA';
            subRecord.EffectiveDate = String.valueOf(Date.Today());
            subRecord.ExpiryDate = String.valueOf(Date.Today() +1);
                    
            subRecord.SubmissionData.SubmissionID = 'a0111000007TK6S';
            subRecord.SubmissionData.InsuredName = 'Yahoo';
            
            subRecord.IssuingOfficeDetail= iOfcList;    
            
            String auth = 'Basic ' + EncodingUtil.base64Encode(Blob.valueof('rakeshvadlamuri:rules'));
            pegaService.inputHttpHeaders_x = new Map<String,String>();
            //pegaService.inputHttpHeaders_x.put('Authorization', 'Basic cmFrZXNodmFkbGFtdXJpOnJ1bGVz');  
            pegaService.inputHttpHeaders_x.put('Authorization', auth);                            
            pegarulesSoapAigfwmncpsubmissionsvcSt.CreateNewWorkResponseType resp =  pegaService.CreateNewWork(UnderwriterID,subRecord);         
            
            if(resp.Status.equalsIgnoreCase('Success')){
                /*
                submission.pegaSubmissionId__c =  resp.SubmissionWorkID;
                submission.AccountStructureID__c = resp.AccountStructureID;
                
                Database.update(submission);  
                
                List<AccountStructure__c> accStrList = new List<AccountStructure__c>();
                for(pegarulesSoapAigfwmncpsubmissionsvcSt.AccountStructure_element elem : resp.AccountStructure){
                    AccountStructure__c accStr = new AccountStructure__c();
                    accStr.Type__c = elem.PolicyType;
                    accStr.Territory__c = elem.Territory;
                    if(elem.NetWorkPartner.equalsIgnorecase('yes')){
                        accStr.Network_Partner__c = true;
                    }
                    else{
                        accStr.Network_Partner__c = false;
                    }
                    accStrList.add(accStr);
                } 
                Database.insert(accStrList);  
                */
                returnVal = resp.SubmissionWorkID;  
            }
            else{
                returnVal = 'Failure';
            }
        }
        catch(CalloutException exp){
            returnVal = 'Failure'; 
            System.debug('** Callout Exception ==> '+exp.getStackTraceString());   
        }
        return returnVal ;
    }
        
}