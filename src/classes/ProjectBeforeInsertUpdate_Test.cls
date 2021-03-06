@isTest
private class ProjectBeforeInsertUpdate_Test{
    private static List<Project__c> projectList = new List<Project__c>();
    private static final String PROJECT_VALIDATION_ERROR_RULE = 'You already have an active project.';
    
    static List<Project__c> createTestData(Integer size){
        List<Project__c> projList = new List<Project__c>();
            for(integer i = 1; i <= size; i++) {
            Project__c projObj = new Project__c();
                projObj.Name = 'TestProject';
                projObj.User_Name__c = 'test@test.com';
                projObj.Project_POC_Contact_Number__c = '99998888889';
                projObj.Project_POC_Email_Id__c = 'testPoc@test.com';
                projObj.Project_POC_Name__c = 'testPOC';
                projObj.Password__c = 'testPassword';
                projObj.Security_Token__c = 'AEJU4hMeWuw4YLZl262bFwKNA';
                projObj.Project_Start_Date__c = System.today();
                projObj.Project_End_Date__c = System.today().addDays(5);
                projList.add(projObj);
        }
        return projList;
    } 
    
    static testMethod void beforeInsertProject(){
        projectList = createTestData(1);
        Database.insert(projectList);
        try{
            projectList = createTestData(1);
            Database.insert(projectList);
        }
        catch(DMLException exp){
        	System.assert(exp.getDmlMessage(0).contains(PROJECT_VALIDATION_ERROR_RULE));
        }
    }
}