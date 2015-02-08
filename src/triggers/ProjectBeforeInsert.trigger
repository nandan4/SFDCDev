trigger ProjectBeforeInsert on Project__c (before insert) {
    List<Id> listProjOwnerId = new List<Id>();
    Set<Id> setProjOwnerId = new Set<Id>();
        for(Project__c proj :[SELECT Id,OwnerId FROM Project__c WHERE Project_Start_Date__c<= Today
                                                AND Project_END_Date__c>= Today LIMIT 500]){
            listProjOwnerId.add(proj.OwnerId);
        }
        setProjOwnerId.addAll(listProjOwnerId);
        
        for(Project__c proj :Trigger.New){
            if(setProjOwnerId.contains(proj.OwnerId)){
                proj.addError(System.Label.ProjectExisting);
            }
        }
}