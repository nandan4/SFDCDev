/**
  * @author       : candidate@408970advdev.org
  * @date         : 21/12/2014
  * @description  : Helper class for Handyman License trigger which includes context-specific methods 
                    that are automatically called when a trigger is executed.
                    As per the requirement, Chatter post is made whenever user achieves HandymanLicense only and
                    update or deletion of license are not handled.
  */
public with sharing class HandymanLicenseHelper{
    
    /**
      * @description       This method is invoked from createChatterPost to fetch the 
                           chatter group based on name.
      * @param             grpName - chatter group name 
      * @return            CollaborationGroup
      * @throws            Method throws QueryException which is handled by try-catch block
      */ 
    private CollaborationGroup getChatterGroup(String grpName){
        CollaborationGroup grp = null;     // chatter group variable to be returned to the calling method
        try{
            // Querying Chatter group based on input parameter
            grp = [SELECT Id,Name,OwnerId FROM CollaborationGroup WHERE Name =: grpName LIMIT 1];
        }
        catch(System.QueryException exp){
            grp = null; // Setting chatter group to null incase group doesn't exist in the organziation
        }
        return grp;
    }
    
    /**
      * @description       This method is invoked from handler class of Handyman License to create 
                           chatter post when a user achieves Handyman License.
      * @param             licenseList - List of Handyman License 
      * @return            void
      * @throws            Method might throw Exception which is handled by try-catch block
      */ 
    public void createChatterPost(List<Handyman_License__c> licenseList){
        List<FeedItem> postList = new List<FeedItem>();     // list of feed item to be posted to chatter group
        Map<Id,Integer> userLicenseCountMap = new Map<Id,Integer>();        // Map of user id and count of handyman licenses
        Map<Id,User> userMap = new Map<Id,User>();          // Map of user id and user record
        Set<Id> userIdSet = new Set<Id>();                  // Set of user ids for the licenses in trigger context
        CollaborationGroup chatterGroup = getChatterGroup(Constants.CHATTER_GROUP_NAME);    // chatter group where post are made for user
        
        // Setting the savepoint before making the chatter post to rollback incase of failure
        Savepoint sPoint  = Database.setSavePoint();            
        try{
            // Iterating through list of Handyman licenses and adding to set
            for(Handyman_License__c license : licenseList){
                if(license != null && license.User__c != null){
                    userIdSet.add(license.User__c);
                }
            }
            
            Integer tmpCount = 0 ;      // temporary count variable used in for loop to store the license count for user
            
            // Iterating through all handyman licenses for the users in a set to find the total license count
            for(Handyman_License__c license : [SELECT User__c,User__r.Name,User__r.isActive 
                                                FROM Handyman_License__c WHERE User__c IN: userIdSet
                                                LIMIT : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
                tmpCount = 0;
                // Check to verify if user id is present in map and increment the previous value
                if(userLicenseCountMap.containsKey(license.User__c)){
                    tmpCount = userLicenseCountMap.get(license.User__c) + 1;
                }
                else{
                    tmpCount = 1;
                    userMap.put(license.User__c,license.User__r);
                }
                userLicenseCountMap.put(license.User__c,tmpCount);
            }
            FeedItem post = null;           // variable to set the chatter post details
            DateTime licDateTime = null;    // variable to store handyman license date with time stamp to format date in 'MMMM d,  yyyy'
            // Check if the Chatter group returned from getChatterGroup method is not null. If null no action performed.
            if(chatterGroup != null){
                /*
                    If chatter group exists, iterated through list of handyman licenses; if license has active user and the license date is
                    within 15 days then parent id is set as chatter group id, created by id as the group owner, created date as current date
                    and post body like 
                    "Please congratulate Brute Force, who recently achieved the Handyman Licensed Contractor credential on October 14, 2014. 
                     Brute Force has now achieved 2 Handyman Licenses."
                */
                for(Handyman_License__c license : licenseList){
                    if(license != null && license.User__c != null && userMap.get(license.User__c) != null){
                        // check for licensed date within 15 days and user is active
                        if(license.License_Date__c != null && license.License_Date__c.daysBetween(Date.Today()) >= 0 &&  
                           license.License_Date__c.daysBetween(Date.Today()) <= 15 && userMap.get(license.User__c).isActive){
                            
                            // license date stored in date time to use the format method to format date in 'MMMM d,  yyyy'
                            licDateTime = DateTime.newInstance(license.License_Date__c.year(), license.License_Date__c.month(),
                                                                license.License_Date__c.day());

                            post = new FeedItem();
                            post.ParentId = chatterGroup.Id;        // Post is made in Handyman Licenses chatter group
                            post.CreatedById = chatterGroup.OwnerId;    // Creator would be chatter group owner
                            post.CreatedDate = System.now();            // Post date is current date
                            post.Type = Constants.TYPE_TEXT_POST;   // Type of chatter post is TextPost
                            
                            // Content in a chatter post except dynamic values are stored in Custom label for translation if required in future. 
                            post.Body = Label.MSG_Congratulate + Constants.WHITE_SPACE + userMap.get(license.User__c).Name + Label.MSG_Achieved +
                                        Constants.WHITE_SPACE + license.License__c + Constants.WHITE_SPACE + Label.MSG_Credential + Constants.WHITE_SPACE + 
                                        licDateTime.format(Label.Date_Format) + Constants.MSG_DOT + userMap.get(license.User__c).Name + Constants.WHITE_SPACE + 
                                        Label.MSG_Now_Achieved + Constants.WHITE_SPACE + userLicenseCountMap.get(license.User__c) + Constants.WHITE_SPACE + 
                                        Label.MSG_Handyman_License;
                                        
                            postList.add(post);
                        }
                    }
                }
                // Check for list emptiness to avoid unnecessary DML operation
                if(!postList.isEmpty()){
                    /*
                        Partial success of a bulk DML operation is used and not handled records with failure in Database.Saveresult as 
                        creation of chatter post is for informational purpose only.
                    */
                    Database.insert(postList,false); 
                }
            }
        }
        catch(Exception exp){
            /*
                Since Chatter post is for informational purpose only, if there is any failure error is not thrown to user
                using addError as it would prevent creation of Handyman License record. Hence it is rolled back to the 
                savepoint before chatter post creation.
            */
            Database.rollBack(sPoint);
        }
    }
}