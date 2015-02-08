/**
  * @author                 : candidate@408970advdev.org
  * @date                   : 28/12/2014
  * @description            : Extension for Handyman Licenses page. 
                              Below are the functionalities :
                                1. Contractor id can be updated by either System Administrator or
                                   if running user is same as user being viewed and once updated only System administrator
                                   can modify it.
                                   
                                2. On update of contractor id, a real-time integration is made to Handyman site to fetch 
                                   the licenses, returned HTML response is parsed using parseResponse method in
                                   HandymanServiceHelper class.
                                   
                                   a. If the contractor name and the user being viewed are different then error message
                                      is displayed.
                                   b. If site is not reachable or other errors, message is displayed.
                                   c. On match, licenses are created, updated or deleted in Salesforce. 
                                
                                3. If refresh date on user is current date, licenses are fetched from Salesforce.
                                
                                4. If refresh date is blank or previous date or on click of refresh button, a real-time integration  
                                   is made to Handyman site to fetch the licenses.  

    @Design Consideration   :   1. Only System administrator has CRDU permissions, records cannot be displayed without
                                   read permission. Hence overcame this with a decorator pattern (wrapper class) to display
                                   licenses.
                                2. On chatter profile page, user id is not displayed as URL parameter if logged in user and
                                   user being viewed are same; also for different user param is 'u'. To use it as a 
                                   standard controller, user id is fetched from URL parameters (sfdc.userid) and set as a
                                   id for the visualforce page.
                                3. On parsing the HTML response from Handyman site, there is an parse error for the content in script tag
                                   at the end. With assumption that response from Handyman site is consistent, the parse error is ignored
                                   as it is thrown for the content at the end. 
                                4. Assumption is that there will not be duplicate license record for the user, even if exists on real-time
                                   integration, license modified recently would be updated and duplicate will be deleted.
                                5. On create,update or deletion of handyman licenses, if any failure transaction is rolled back and an empty
                                   list returned to page and message displayed to user stating license not found.                     
  */ 
public with sharing class HandymanExtension{
    
    // Variables
    private ApexPages.standardController stdController;         // instance of standardcontroller to user standard actions
    private String dispUserId ;                                 // Id of the user being viewed in the chatter profile
    private String runningUserId ;                              // Id of the logged-in/running user
    private String contractId ;                                 // contractor id of the user
    private Id adminProfileId ;                                 // profile id of system administrator
    private User userRec;                                       // record of the user being viewed
    
    // Page Variables    
    public boolean isEditable {get;set;}                        // variable to toggle update button for user
    public boolean showDetail {get;set;}                        // variable to rendering license detail section
    public List<HandymanLicense> licenseList {get;set;}         // list of handyman licenses of user
    
    /*
        @description : Constructor for the extension with standardcontroller as parameter.
                       Sets user being viewed to standardcontroller, determines if user can update
                       the contractor id and fetch handyman licenses if refresh date for user is today.
    */
    public HandymanExtension(ApexPages.standardController controller){
        isEditable = false;     // Setting default value
        showDetail = false;     // Setting default value
        licenseList = new List<HandymanLicense>();
        runningUserId = Userinfo.getUserId().substring(0,15);   // 15-digit id of logged in user for comparison with user being viewed
        dispUserId = getDisplayedUserId();                      // method invoked to determine id of user being viewed.
        
        // check if id of user being viewed is not blank
        if(String.isNotBlank(dispUserId)){
            // Set user being viewed as the user for Handyman Licenses page
            ApexPages.currentPage().getParameters().put(Constants.URL_PARAM_ID,dispUserId);
            stdController = controller;                 // setting instance standardcontroller variable
            userRec = (User) stdController.getRecord(); // get the user record being viewed
            contractId = userRec.Contractor_ID__c;      
            
            adminProfileId = getProfileId(Constants.ADMIN_PROFILE);     // fetch the profile Id of the system administrator
            
            setUpdate();    // toggle the update button based on profile
            
            // Fetch the licenses from Salesforce if user has contractor id and the refresh date is today
            if(userRec.Contractor_ID__c != null && userRec.Refresh_Date__c == Date.Today()){                
                licenseList = getLicenseWrapper(getLicenses(userRec.id));       // get the wrapper list of handyman licenses
                // verify if list contain handyman licenses
                if(licenseList.isEmpty()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.License_NotFound));
                    showDetail = false;
                }
                else{
                    showDetail = true;  // set rendering variable if user has licenses
                }
            }           
        }
        
    }
    
    /**
      * @description       This method is invoked from constructor and updateData to toggle the update button
                           for System administrator and Standard user
      * @param             NA
      * @return            void
      * @throws            NA
      */ 
    private void setUpdate(){
        /* 
            validate if running user is system administrator or contractor id is null and running user is same as user being viewed.
            This is used to toggle update button i.e, to enable the button if criteria is matched.
        */
        if(( runningUserId.equalsIgnoreCase(dispUserId) && userRec.Contractor_ID__c == null ) || 
            adminProfileId == Userinfo.getProfileId()){
            isEditable = true;  // enable update button for user
        }
        else{
            isEditable = false; // disable update button for user
        }
        
    }
    
    /**
      * @description       This method is invoked from constructor to fetch the id of user 
                           being viewed from chatter profile page parameters.
      * @param             NA
      * @return            String
      * @throws            NA
      */ 
    private String getDisplayedUserId(){
        return ApexPages.currentPage().getParameters().get(Constants.URL_PARAM_USERID); // get user id from URL parameter ('sfdc.userid')
    }
    
    /**
      * @description       This method is invoked from constructor to fetch the 
                           profile id based on name.
      * @param             profileName - name of the profile for which id is returned 
      * @return            Id
      * @throws            Exception will be thrown if the profile doesn't exist. 
                           For current scenario its used only to fetch System administrator
                           profile id. If used for different profiles, exception to be handled
                           by calling methods.
      */ 
    private Id getProfileId(String profileName){
        return [SELECT Id,Name FROM PROFILE WHERE Name =: profileName LIMIT 1].id;
    }
    
    /**
      * @description       This method is fetch the handyman licenses for the user being viewed
      * @param             userId - id of user being viewed
      * @return            List<Handyman_License__c>
      * @throws            Method will not throw QueryException, an empty list would be returned
                           if rows not found.
      */ 
    private List<Handyman_License__c> getLicenses(Id userId){
        return [SELECT Name,License__c,License_Date__c,User__c 
                FROM Handyman_License__c WHERE User__c =: userId ORDER BY LastmodifiedDate
                LIMIT : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
    }
    
    /**
      * @description       This method is invoked from page on click of Update button which updates
                           contractor id for a user and an real-time integration is made to handyman
                           site to fetch the licenses for the contractor, name is verified and based
                           on the response handyman licenses are created,updated or deleted.
      * @param             NA
      * @return            void
      * @throws            Method is not throwing exception, error messages added to the page in the 
                           fetchData method for error scenarios.
      */ 
    public void updateData(){
        userRec = (User) stdController.getRecord();     //setting user record with updated contractor id from standardcontroller
        // fetchData method is invoked for a real-time integration passing the Contractor Id entered by running user
        fetchData(userRec.Contractor_ID__c);        
    }
    
    /**
      * @description       This method is invoked from page on click of refresh button which makes
                           an real-time integration to handyman site to fetch the licenses for the
                           contractor, name is verified and based on the response handyman licenses
                           are created,updated or deleted.
      * @param             NA 
      * @return            void
      * @throws            Method is not throwing exception, error messages added to the page in the 
                           fetchData method for error scenarios.
      */ 
    public void refresh(){
        // fetchData method is invoked for a real-time integration passing the Contractor Id of user stored in Salesforce
        fetchData(contractId);
    }
    
    /**
      * @description       This method is invoked when a page is loaded, user has contractor id and refresh date is
                           either blank or previous date, real-time integration to handyman site is made to fetch the 
                           licenses for the contractor, name is verified and based on the response handyman licenses
                           are created,updated or deleted.
      * @param             NA
      * @return            void
      * @throws            Method is not throwing exception, error messages added to the page in the 
                           fetchData method for error scenarios.
      */ 
    public void refreshLicenses(){
        // verify if user has contractor id and refresh date is blank or previous date
        if(String.isNotBlank(userRec.Contractor_ID__c) && 
            (userRec.Refresh_Date__c == null || userRec.Refresh_Date__c < Date.Today())){
            fetchData(userRec.Contractor_ID__c);
        }
    }
    
    /**
      * @description       This method is invoked from updateData, refresh and refreshLicenses method which makes an 
                           real-time integration using callHandymanService method of HandymanServiceHelper class.
      * @param             contId - Contractor id of the user
      * @return            void
      * @throws            Method is not throwing exception, error messages added to the page for error scenarios.
      */ 
    private void fetchData(String contId){
        List<HandymanLicense> licResultList = new List<HandymanLicense>();  
        List<Handyman_License__c> dbLicList = new List<Handyman_License__c>(); // list of licenses in SFDC for user
        
        // Invoke handyman service passing the contractor id which returns a decorated response with HandymanResponse as a return type 
        HandymanServiceHelper.HandymanResponse handymanResponse = HandymanServiceHelper.callHandymanService(contId);
        dbLicList = getLicenses(userRec.Id);       // fetch the licenses available in database for a user 
        
        // Check if the response from the handyman site is null and display an error message that site couldn't be reached
        if(handymanResponse == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Site_NotReachable));
            licenseList = getLicenseWrapper(dbLicList); // get the wrapper list of handyman licenses
            if(!licenseList.isEmpty()){     
                showDetail = true;  // Detail section rendered in case of error scenarios with licenses available in database
            }
        }
        // If response returned, verify if the user name and the contractor name from response are same
        else if(handymanResponse.contractorName != userRec.Name){   
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Name_NotMatch));
            licenseList = getLicenseWrapper(dbLicList); // get the wrapper list of handyman licenses
            if(!licenseList.isEmpty()){     
                showDetail = true;  // Detail section rendered in case of error scenarios with licenses available in database 
            }
        }
        else{
            licResultList = handymanResponse.licenseList; 
            // method invoked to handle license list to either create,update or delete and final list of licenses are returned
            licenseList = handleLicenseResult(licResultList,dbLicList);   
            if(!licenseList.isEmpty()){
                showDetail = true;                          // Detail section on page is rendered
                userRec.Refresh_Date__c = Date.Today();    //  Set refresh date to current date
                userRec.Contractor_ID__c = contId;         // valid contractor id retained
            }             
                        
            // Error message displayed if the toggle is not set to render detail section in page
            if(!showDetail){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.License_NotFound));
            }
            stdController.save();   // invoke standard controller save method
            setUpdate();    // toggle the update button based on profile 
        }
    }
    
    /**
      * @description       This method is invoked from fetchData to handle the list of handyman 
                           licenses from response i.e, to either create, update or delete the
                           handyman licenses for a user.
      * @param             licResultList - list of handyman licenses from response, dbLicList - list of licenses in SFDC for user 
      * @return            List<HandymanLicense>
      * @throws            Method throws Exception which is handled by try-catch block, rolls
                           back to savepoint
      */ 
    private List<HandymanLicense> handleLicenseResult(List<HandymanLicense> licResultList,List<Handyman_License__c> dbLicList){
        Map<String,Date> licResultMap = new Map<String,Date>();     // Map to store license & the date
        List<Handyman_License__c> delLicList = new List<Handyman_License__c>(); // list of licenses to be deleted
        List<Handyman_License__c> usrLicList = new List<Handyman_License__c>(); // list of licenses to be created or updated
        List<HandymanLicense> licList = new List<HandymanLicense>();    // final list of licenses for a user returned to fetchData
        
        // Setting a savepoint before handling list of licenses to rollback in case of failure
        Savepoint sPoint = Database.setSavePoint();
        try{
            usrLicList = dbLicList;       // licenses available in database for a user
            
            // check if input list is not empty            
            if(!licResultList.isEmpty()){
                // Iterate through licenses from response and create a map of license and date
                for(HandymanLicense lic : licResultList){
                    licResultMap.put(lic.licenseName,Date.parse(lic.licenseDate));  // Date parsed as its a string in the inner class
                }
            }
            
            /*
                Verify if user has licenses available in database is not empty.
                If criteria is matched, licenses are updated with license date if available else created and other license
                available in database which is not returned from service will be deleted.
            */
            if(!usrLicList.isEmpty()){
                for(Integer i=0; i < usrLicList.size() ; i++){
                    if(licResultMap.containsKey(usrLicList[i].License__c)){
                        usrLicList[i].License_Date__c = licResultMap.get(usrLicList[i].License__c); // updating the license date
                        licResultMap.remove(usrLicList[i].License__c);  // removing the matched license from the map to skip the creation list
                    }
                    else{
                        delLicList.add(usrLicList[i]);      // create list of license to be deleted
                        usrLicList.remove(i);               // removing license to be deleted from the list to be upserted
                    }
                }
            }
            
            // check if the map is not empty for creation of handyman licenses            
            if(!licResultMap.isEmpty()){
                Handyman_License__c handyLic = null;
                // Iterate through licenses and create a list to be saved to database
                for(String licName : licResultMap.keyset()){
                    handyLic = new Handyman_License__c();
                    handyLic.License__c = licName;
                    handyLic.License_Date__c = licResultMap.get(licName);
                    handyLic.User__c = userRec.id;
                    usrLicList.add(handyLic);
                }
            } 
            
            // verify the delete list is not empty before DML operation            
            if(!delLicList.isEmpty()){
                Database.delete(delLicList);
            }
            
            // Verifying if list contains elements and not updated due to list from handyman site to avoid unnecessary DML
            if(!usrLicList.isEmpty() && !licResultMap.isEmpty()){
                Database.upsert(usrLicList);
            }
            licList = getLicenseWrapper(usrLicList);    //return the final list of licenses of a user to fetchData method
        }
        catch(Exception exp){
            Database.rollBack(sPoint); // Rolled back to savepoint in case of failure
        }
        return licList;
    }
    
    /**
      * @description       This method is invoked from constructor and handleLicenseResult to get the 
                           handyman licenses list in decorated HandymanLicense format
      * @param             licenseList - list of handyman licenses for a user 
      * @return            List<HandymanLicense>
      * @throws            NA
      */ 
    private List<HandymanLicense> getLicenseWrapper(List<Handyman_License__c> licenseList){
        List<HandymanLicense> licList = new List<HandymanLicense>();
        HandymanLicense tmpLic = null;
        for(Handyman_License__c lic : licenseList){
            tmpLic = new HandymanLicense();
            tmpLic.licenseName = lic.License__c;
            tmpLic.licenseDate = lic.License_Date__c.format();  // converting date to string
            licList.add(tmpLic);
        }
        return licList;
    }
    
    /*
        Wrapper class created to overcome the access constraint for the profile on Handyman License object.
        Only System administrator has CRDU permissions, records cannot be displayed without read permission.
    */
    public class HandymanLicense{
        public String licenseName {get;set;}
        public String licenseDate {get;set;}
    }
}