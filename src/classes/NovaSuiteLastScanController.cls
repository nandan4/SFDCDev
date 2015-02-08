public with sharing class NovaSuiteLastScanController {
    public List<Project__c> projectList {get; set;}
    
    public NovaSuiteLastScanController() {
        projectList = new List<Project__c>();
        projectList = [SELECT Id, Name, Last_Scan_Date__c FROM Project__c ORDER BY Name ASC];
    }
}