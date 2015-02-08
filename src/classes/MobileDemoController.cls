public with sharing class MobileDemoController{

    private static final string ACCOUNT_VAL = 'Account';
    private static final string CONTACT_VAL = 'Contact';    
    public string sObjectName{get;set;}
    public List<WrapperRecord> recList {get;set;}
    
    public MobileDemoController(){
        recList = new List<WrapperRecord>();
        sObjectName = 'Contact';
        System.debug('** sObjectName==>'+sObjectName);
        if(ACCOUNT_VAL.equalsIgnoreCase(sObjectName)){
            for(Account acc: [SELECT Id,Name,BillingCity,BillingCountry FROM Account limit 5]){
                System.debug('** acc ==>'+acc);
                WrapperRecord rec = new WrapperRecord();
                rec.name = acc.Name;
                rec.city = acc.BillingCity;
                rec.country = acc.BillingCountry ;
                
                recList.add(rec);
            }
        }
        else if(CONTACT_VAL.equalsIgnoreCase(sObjectName)){
            for(Contact con: [SELECT Id,Name,MailingCity,MailingCountry,(SELECT Id, Name FROM Attachments) FROM Contact limit 5]){
                System.debug('** con ==>'+con);
                WrapperRecord rec = new WrapperRecord();
                rec.name = con.Name;
                rec.city = con.MailingCity;
                rec.country = con.MailingCountry ;
                for(attachment a:con.attachments) {
                         rec.photo = con.attachments[0].id ;
                         System.debug('** rec.photo ==>'+rec.photo);
                    }
               
                
                recList.add(rec);
            }
        }  
        System.debug('** recList ==>'+recList);      
    }
    
    public class WrapperRecord{
        public string name {get;set;}
        public string city {get;set;}
        public string country {get;set;}
        public string Photo {get;set;}
    }
}