/**
  *  @Author      : ATL Team
  *  @Name        : ApexRulesV3_AvoidHardCodedIDs
  *  @Date        : 15/09/2012 
  *  @Description : Examples of Bad & Good Practice of
                    Avoid hardcoded Ids - Priority P1 - Design
*/
public class ApexRulesV3_AvoidHardCodedIDs  {
            
    /**
      * Bad Practice: Method shows bad practice of hardcoding Ids
      */      
    public void hardcodedIdBadPractice_First(){
        /*String recordTypeId = '01290000000gr2FAAQ';
        Campaign cmp = new Campaign(Name = 'ATL Campaign',RecordTypeId = recordTypeId);
        Database.insert(cmp);*/
    }
    
    /**
      * Bad Practice: Method shows bad practice of hardcoding Ids
      */      
    public void hardcodedIdBadPractice_Second(){
        String profileId = '00e90000001MAQyAAO';
        List<User> stdUsers = [SELECT Name FROM User WHERE profileId =: profileId];
    }
    
    /**
      * Bad Practice: Method shows bad practice of hardcoding Ids
      */
    public void hardcodedIdBadPractice_Third(){
        String accId = '0019000000SvUVZAA3';
        Contact con = new Contact(lastName = 'ATL', AccountId = accId);
        Database.insert(con);
    }
    
    /**
      * Good Practice: Method shows Good practice of avoiding hardcoded Ids
      */
    public void hardcodedIdGoodPractice_First(){
        /*Map<String,Schema.RecordTypeInfo> recordTypes = Campaign.SObjectType.getDescribe().getRecordTypeInfosByName();
        String recordTypeId = recordTypes.get('Corporate Campaign').getRecordTypeId();
        Campaign cmp = new Campaign(Name = 'ATL Campaign',RecordTypeId = recordTypeId);
        Database.insert(cmp);*/
    }
    
    /**
      * Good Practice: Method shows Good practice of avoiding hardcoded Ids
      */
    public void hardcodedIdGoodPractice_Second(){
        String profileName = 'Standard User';
        List<User> stdUsers = [SELECT Name FROM User WHERE profile.Name =: profileName];
    }
    
    /**
      * Good Practice: Method shows Good practice of avoiding hardcoded Ids
      */
    public void hardcodedIdGoodPractice_Third(){
        String accId = [SELECT Name FROM Account WHERE Name = 'GenePoint' LIMIT 1].id;
        Contact con = new Contact(lastName = 'ATL', AccountId = accId);
        Database.insert(con);
    }
    
    /**
      * Good Practice: Method shows Good practice of avoiding hardcoded Ids using Custom Settings
      */
    public void hardcodedIdGoodPractice_Fourth(){
        // Custom Setting Should be created with recordType and its id
        /*Map<String,CS_RecordTypeIds__c> recordTypeMap = CS_RecordTypeIds__c.getAll();
        Id recordTypeId = recordTypeMap.get('Corporate Campaign').RecordTypeId__c;
        Campaign cmp = new Campaign(Name = 'ATL Campaign',RecordTypeId = recordTypeId);
        Database.insert(cmp);*/
    }
}