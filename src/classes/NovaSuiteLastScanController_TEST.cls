@isTest
private class NovaSuiteLastScanController_TEST {

    static testMethod void testNovaSuiteLastScan() {
        Project__c testProject = new Project__c();
        testProject.Name = 'Test Project';
        testProject.Project_POC_Name__c = 'Mr. Hunt';
        testProject.Project_POC_Email_Id__c = 'k.narasiman@accenture.com';
        testProject.Project_POC_Contact_Number__c = '+91-8050390430';
        testProject.Project_Start_Date__c = System.today();
        testProject.Project_End_Date__c = System.today()+10;
        Database.insert(testProject);
        
        Test.startTest();
            NovaSuiteLastScanController ctr = new NovaSuiteLastScanController();
            System.assert(!ctr.projectList.isEmpty());
            System.assertEquals(1, ctr.projectList.size());    
        Test.stopTest();
    }
    
}