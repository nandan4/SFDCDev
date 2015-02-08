trigger CalculateEffortSaving on Snippet__c (before insert) {
    Map<String,SnippyEffortSaving__c> csMap = SnippyEffortSaving__c.getAll();
    
    for(Snippet__c snp : Trigger.New){
        if(csMap.keyset().contains(snp.SnippetId__c)){
            snp.EffortSaving__c = csMap.get(snp.SnippetId__c).EffortSaving__c;
        }
    }
}