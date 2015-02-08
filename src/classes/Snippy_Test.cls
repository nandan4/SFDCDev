@isTest
private class Snippy_Test {
     static testMethod void newSnippets() {
         
     
         Snippy__c snp = new Snippy__c(Name = 'Snippy');
         Database.insert(snp);
         
         Set<String> snippetIds = new Set<String>{'Insert','Update','UpsertWithoutExternalId',
                                                  'UpsertWithExternalId','Delete','UnDelete'};
         
         List<SnippyEffortSaving__c > csList = new List<SnippyEffortSaving__c >();
         for(String str : snippetIds){
             SnippyEffortSaving__c cs = new SnippyEffortSaving__c(Name = str, EffortSaving__c = 10);
             csList.add(cs);
         }
         Database.insert(csList);
         
         List<Snippet__c > snippetsList = new List<Snippet__c>();                                         
         for(String str : snippetIds){
             Snippet__c snpt = new Snippet__c(SnippetId__c = str, Snippy__c = snp.id);
             snippetsList.add(snpt);
         } 
         
         Database.insert(snippetsList);
     }
}