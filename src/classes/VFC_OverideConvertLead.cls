Public Class VFC_OverideConvertLead {
    
    /* Variables */
    Public String leadID {get;set;}
    Public Lead led {get;set;}
    Public CampaignMember mbr;
    Public String lobSelected {get;set;}
    Public static List<SelectOption> lob{get;set;}
    
    Public VFC_OverideConvertLead(ApexPages.StandardController controller){
        leadID = Apexpages.currentpage().getparameters().get('id');
        System.debug('** Lead ID ==> '+LeadID);
       // led = new Lead();
        led = [SELECT Id,Name,AnnualRevenue,NumberOfEmployees,FirstName,LastName,LeadSource
               FROM Lead WHERE Id =: leadID]; 
        //mbr = [SELECT Id FROM CampaignMember WHERE leadId =: led.Id];                 
    }
    
    Public Static PageReference lobList()
    {
        lob = new List<SelectOption>();
        lob.add(new SelectOption('Auto','Auto'));
        lob.add(new SelectOption('Fire','Fire'));
        lob.add(new SelectOption('Bank','Bank'));
        lob.add(new SelectOption('Health','Health'));
        lob.add(new SelectOption('Mutual Funds','MutualFunds'));
        return null;
    }
    
    Public PageReference convertLead(){
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(leadID);
        lc.setdoNotCreateOpportunity(true);
        System.debug('****'+lobSelected);
        lc.opportunityname = lobSelected;
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        Database.LeadConvertResult lcr = Database.convertLead(lc);  
        System.debug('** Converted Lead ==> '+lcr);
        Database.Delete(led);
       // Database.Delete(mbr);
       return new Pagereference('/00Q90000008wQSU');
        
    }
    
    Public void test()
    {
        System.debug('******* Test *******');
    }
}