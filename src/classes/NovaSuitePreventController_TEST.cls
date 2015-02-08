@isTest
private class NovaSuitePreventController_TEST {
    static testMethod void testNovaSuitePreventDelete() {
        Project__c testProject = new Project__c();
        testProject.Name = 'Test Project';
        testProject.Project_POC_Name__c = 'Mr. Hunt';
        testProject.Project_POC_Email_Id__c = 'k.narasiman@accenture.com';
        testProject.Project_POC_Contact_Number__c = '+91-8050390430';
        testProject.Project_Start_Date__c = System.today();
        testProject.Project_End_Date__c = System.today()+10;
        Database.insert(testProject);
        
        NovaRun__c run = new NovaRun__c();
        run.P1_Records__c = 10;
        run.P2_Records__c = 20;
        run.P3_Records__c = 30;
        run.P4_Records__c = 40;
        run.NQI__c = 8;
        run.DateRun__c = Date.Today();
        run.Incident_Measure__c = 1;
        run.Total_Violations__c = 1000;
        run.Total_lines_of_code__c = 10000;
        run.Project__c = testProject.id;   
        Database.insert(run); 
        ApexPages.currentPage().getParameters().put('retURL', run.id);
        Test.startTest();
            ApexPages.StandardController controller = new ApexPages.StandardController(run);
            NovaSuitePreventController cont = new NovaSuitePreventController(controller);
            NovaSuitePreventController.preventNovaRunEdit();
            NovaSuitePreventController.preventNovaRunDelete();
        Test.stopTest();
    }
    
    static testMethod void testNovaSuitePrevent() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Novacop Users']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com.novaTest');
                
        Project__c testProject = new Project__c();
        testProject.Name = 'Test Project';
        testProject.Project_POC_Name__c = 'Mr. Hunt';
        testProject.Project_POC_Email_Id__c = 'k.narasiman@accenture.com';
        testProject.Project_POC_Contact_Number__c = '+91-8050390430';
        testProject.Project_Start_Date__c = System.today();
        testProject.Project_End_Date__c = System.today()+10;
        Database.insert(testProject);
        
        NovaRun__c run = new NovaRun__c();
        run.P1_Records__c = 10;
        run.P2_Records__c = 20;
        run.P3_Records__c = 30;
        run.P4_Records__c = 40;
        run.NQI__c = 8;
        run.DateRun__c = Date.Today();
        run.Incident_Measure__c = 1;
        run.Total_Violations__c = 1000;
        run.Total_lines_of_code__c = 10000;
        run.Project__c = testProject.id;   
        Database.insert(run); 
        ApexPages.currentPage().getParameters().put('retURL', run.id);
        System.runAs(u){
            Test.startTest();
                ApexPages.StandardController controller = new ApexPages.StandardController(run);
                NovaSuitePreventController cont = new NovaSuitePreventController(controller);
                NovaSuitePreventController.preventNovaRunEdit();
                NovaSuitePreventController.preventNovaRunDelete();
            Test.stopTest();
        }
    }
}