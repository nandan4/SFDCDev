/**
  *  @Author      : ATL Team
  *  @Name        : ApexRulesV2_AvoidDescribeCallInLoop
  *  @Date        : 09/11/2012 
  *  @Description : Avoid Schema Describe Call In Loop - Priority P1 - Design        I
*/
public class ApexRulesV3_AvoidDescribeCallInLoop {
            
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void picklistDescribeCallBadPractice_First(){
        for(Integer i=0 ; i<10 ; i++){
            Schema.DescribeFieldResult F = Account.Industry.getDescribe();
            List<Schema.PicklistEntry> P = F.getPicklistValues();
        }
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void fieldPicklistDescribeCallBadPractice_First(){
        List<String> pickListField = new List<String>{'Industry','Source'};
        for(String field : pickListField ){
            List<Schema.PicklistEntry> P = Account.SObjectType.getDescribe().fields.getMap().get(field).getDescribe().getPicklistValues();
        }
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void fieldPicklistDescribeCallBadPractice_Second(){
        List<String> pickListField = new List<String>{'Industry','Source'};
        for(String field : pickListField ){
            List<Schema.PicklistEntry> P = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get(field).getDescribe().getPicklistValues();
        }
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void fieldPicklistDescribeCallBadPractice_Third(){
        for(Integer i=0 ; i<10 ; i++){
            List<Schema.PicklistEntry> P = Schema.SObjectType.Account.fields.Industry.getPicklistValues();
        }
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void fieldDescribeCallBadPractice_First(){
        for(Integer i=0 ; i<10 ; i++){
            Schema.DescribeFieldResult F = Schema.SObjectType.Account.fields.Name;
        }
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void fieldDescribeCallBadPractice_Second(){
        List<String> pickListField = new List<String>{'Industry','Source'};
        for(String field : pickListField ){
            Schema.SObjectType t = Schema.getGlobalDescribe().get('Account');
            Schema.DescribeSObjectResult r = t.getDescribe();
            Schema.DescribeFieldResult f = r.fields.getMap().get(field).getDescribe();
        }
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void fieldDescribeCallBadPractice_Third(){
        List<String> pickListField = new List<String>{'Industry','Source'};
        for(String field : pickListField ){
            Schema.DescribeFieldResult f = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get(field).getDescribe();
        }
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void fieldDescribeCallBadPractice_Fourth(){
        List<String> pickListField = new List<String>{'Industry','Source'};
        for(String field : pickListField ){
            Schema.DescribeFieldResult f = Account.SObjectType.getDescribe().fields.getMap().get(field).getDescribe();
        }
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void childDescribeCallBadPractice_First(){
        for(Integer i=0 ; i<10 ; i++){
            Schema.DescribeSObjectResult R = Account.SObjectType.getDescribe();
            List<Schema.ChildRelationship> C = R.getChildRelationships();
        }
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void childDescribeCallBadPractice_Second(){
        for(Integer i=0 ; i<10 ; i++){
            List<Schema.ChildRelationship> C = Schema.Sobjecttype.Account.getChildRelationships();
        }
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void childDescribeCallBadPractice_Third(){
        for(Integer i=0 ; i<10 ; i++){
            List<Schema.ChildRelationship> C = Schema.getGlobalDescribe().get('Account').getDescribe().getChildRelationships();
        }
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void recordTypeDescribeCallBadPractice_First(){
        for(Integer i=0 ; i<10 ; i++){
            Schema.DescribeSObjectResult R = Account.SObjectType.getDescribe();
            List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();
        }
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void recordTypeDescribeCallBadPractice_Second(){
        for(Integer i=0 ; i<10 ; i++){
            List<Schema.RecordTypeInfo> RT = Account.SObjectType.getDescribe().getRecordTypeInfos();
        }
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void recordTypeDescribeCallBadPractice_Third(){
        for(Integer i=0 ; i<10 ; i++){
            List<Schema.RecordTypeInfo> RT = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfos();
        }
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void recordTypeDescribeCallBadPractice_Four(){
        for(Integer i=0 ; i<10 ; i++){
            Map<String, Schema.Recordtypeinfo> schemaRtMap = Schema.Sobjecttype.Account.getRecordTypeInfosByName();
        }
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void picklistDescribeCallBadPractice_Second(){
        Integer i =0;
        While(i<10){
            Schema.DescribeFieldResult F = Account.Industry.getDescribe();
            List<Schema.PicklistEntry> P = F.getPicklistValues();
            i++;
        }
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void fieldPicklistDescribeCallBadPractice_Four(){       
        Integer i =0;
        While(i<10){
            List<Schema.PicklistEntry> P = Account.SObjectType.getDescribe().fields.getMap().get('Industry').getDescribe().getPicklistValues();
            i++;
        }
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void fieldPicklistDescribeCallBadPractice_Five(){
        Integer i =0;
        While(i<10){
            List<Schema.PicklistEntry> P = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Industry').getDescribe().getPicklistValues();
            i++;
        }
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void fieldPicklistDescribeCallBadPractice_Six(){
        Integer i =0;
        While(i<10){
            List<Schema.PicklistEntry> P = Schema.SObjectType.Account.fields.Industry.getPicklistValues();
            i++;
        }
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void fieldDescribeCallBadPractice_Five(){
        Integer i =0;
        While(i<10){
            Schema.DescribeFieldResult F = Schema.SObjectType.Account.fields.Name;
            i++;
        }
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void fieldDescribeCallBadPractice_Six(){
        Integer i =0;
        While(i<10){
            Schema.SObjectType t = Schema.getGlobalDescribe().get('Account');
            Schema.DescribeSObjectResult r = t.getDescribe();
            Schema.DescribeFieldResult f = r.fields.getMap().get('Industry').getDescribe();
            i++;
        }
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void fieldDescribeCallBadPractice_Seven(){
        Integer i =0;
        While(i<10){
            Schema.DescribeFieldResult f = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Industry').getDescribe();
            i++;
        }
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void fieldDescribeCallBadPractice_Eight(){
        Integer i =0;
        While(i<10){
            Schema.DescribeFieldResult f = Account.SObjectType.getDescribe().fields.getMap().get('Industry').getDescribe();
            i++;
        }
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void childDescribeCallBadPractice_Four(){
        Integer i =0;
        While(i<10){
            Schema.DescribeSObjectResult R = Account.SObjectType.getDescribe();
            List<Schema.ChildRelationship> C = R.getChildRelationships();
            i++;
        }
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void childDescribeCallBadPractice_Five(){
        Integer i =0;
        While(i<10){
            List<Schema.ChildRelationship> C = Schema.Sobjecttype.Account.getChildRelationships();
            i++;
        }
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void childDescribeCallBadPractice_Six(){
        Integer i =0;
        While(i<10){
            List<Schema.ChildRelationship> C = Schema.getGlobalDescribe().get('Account').getDescribe().getChildRelationships();
            i++;
        }
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void recordTypeDescribeCallBadPractice_Five(){
        Integer i =0;
        While(i<10){
            Schema.DescribeSObjectResult R = Account.SObjectType.getDescribe();
            List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();
            i++;
        }
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void recordTypeDescribeCallBadPractice_Six(){
        Integer i =0;
        While(i<10){
            List<Schema.RecordTypeInfo> RT = Account.SObjectType.getDescribe().getRecordTypeInfos();
            i++;
        }
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void recordTypeDescribeCallBadPractice_Seven(){
        Integer i =0;
        While(i<10){
            List<Schema.RecordTypeInfo> RT = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfos();
            i++;
        }
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void recordTypeDescribeCallBadPractice_Eight(){
        Integer i =0;
        While(i<10){
            Map<String, Schema.Recordtypeinfo> schemaRtMap = Schema.Sobjecttype.Account.getRecordTypeInfosByName();
            i++;
        }
    }
    
        /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void picklistDescribeCallBadPractice_Third(){
        Integer i =0;
        do{     
            Schema.DescribeFieldResult F = Account.Industry.getDescribe();
            List<Schema.PicklistEntry> P = F.getPicklistValues();
            i++;
        }While(i<10);
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void fieldPicklistDescribeCallBadPractice_Seven(){      
        Integer i =0;
        do{
            List<Schema.PicklistEntry> P = Account.SObjectType.getDescribe().fields.getMap().get('Industry').getDescribe().getPicklistValues();
            i++;
        }While(i<10);
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void fieldPicklistDescribeCallBadPractice_Eight(){
        Integer i =0;
        do{
            List<Schema.PicklistEntry> P = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Industry').getDescribe().getPicklistValues();
            i++;
        }While(i<10);
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void fieldPicklistDescribeCallBadPractice_Nine(){
        Integer i =0;
        do{
            List<Schema.PicklistEntry> P = Schema.SObjectType.Account.fields.Industry.getPicklistValues();
            i++;
        }While(i<10);
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void fieldDescribeCallBadPractice_Nine(){
        Integer i =0;
        do{
            Schema.DescribeFieldResult F = Schema.SObjectType.Account.fields.Name;
            i++;
        }While(i<10);
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void fieldDescribeCallBadPractice_Ten(){
        Integer i =0;
        do{
            Schema.SObjectType t = Schema.getGlobalDescribe().get('Account');
            Schema.DescribeSObjectResult r = t.getDescribe();
            Schema.DescribeFieldResult f = r.fields.getMap().get('Industry').getDescribe();
            i++;
        }While(i<10);
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void fieldDescribeCallBadPractice_Eleven(){
        Integer i =0;
        do{
            Schema.DescribeFieldResult f = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Industry').getDescribe();
            i++;
        }While(i<10);
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void fieldDescribeCallBadPractice_Twelve(){
        Integer i =0;
        do{
            Schema.DescribeFieldResult f = Account.SObjectType.getDescribe().fields.getMap().get('Industry').getDescribe();
            i++;
        }While(i<10);
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void childDescribeCallBadPractice_Seven(){
        Integer i =0;
        do{
            Schema.DescribeSObjectResult R = Account.SObjectType.getDescribe();
            List<Schema.ChildRelationship> C = R.getChildRelationships();
            i++;
        }While(i<10);
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void childDescribeCallBadPractice_Eight(){
        Integer i =0;
        do{
            List<Schema.ChildRelationship> C = Schema.Sobjecttype.Account.getChildRelationships();
            i++;
        }While(i<10);
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void childDescribeCallBadPractice_Nine(){
        Integer i =0;
        do{
            List<Schema.ChildRelationship> C = Schema.getGlobalDescribe().get('Account').getDescribe().getChildRelationships();
            i++;
        }While(i<10);
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void recordTypeDescribeCallBadPractice_Nine(){
        Integer i =0;
        do{
            Schema.DescribeSObjectResult R = Account.SObjectType.getDescribe();
            List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();
            i++;
        }While(i<10);
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void recordTypeDescribeCallBadPractice_Ten(){
        Integer i =0;
        do{
            List<Schema.RecordTypeInfo> RT = Account.SObjectType.getDescribe().getRecordTypeInfos();
            i++;
        }While(i<10);
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void recordTypeDescribeCallBadPractice_Eleven(){
        Integer i =0;
        do{
            List<Schema.RecordTypeInfo> RT = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfos();
            i++;
        }While(i<10);
    }
    
    /**
      * Bad Practice: Method shows bad practice of Describe Call within For Loop.        
      */
    private void recordTypeDescribeCallBadPractice_Twelve(){
        Integer i =0;
        do{
            Map<String, Schema.Recordtypeinfo> schemaRtMap = Schema.Sobjecttype.Account.getRecordTypeInfosByName();
            i++;
        }While(i<10);
    }
    
    /**
      * Good Practice: Method shows Good practice of Describe Call within For Loop.        
      */
    private void picklistDescribeCallGoodPractice(){      
        Schema.DescribeFieldResult F = Account.Industry.getDescribe();
        List<Schema.PicklistEntry> P = F.getPicklistValues();
    }
    
    /**
      * Good Practice: Method shows Good practice of Describe Call within For Loop.        
      */
    private void fieldPicklistDescribeCallGoodPractice_First(){     
        List<Schema.PicklistEntry> P = Account.SObjectType.getDescribe().fields.getMap().get('Industry').getDescribe().getPicklistValues();         
    }
    
    /**
      * Good Practice: Method shows Good practice of Describe Call within For Loop.        
      */
    private void fieldPicklistDescribeCallGoodPractice_Second(){
        List<Schema.PicklistEntry> P = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Industry').getDescribe().getPicklistValues();
    }
    
    /**
      * Good Practice: Method shows Good practice of Describe Call within For Loop.        
      */
    private void fieldPicklistDescribeCallGoodPractice_Third(){
        List<Schema.PicklistEntry> P = Schema.SObjectType.Account.fields.Industry.getPicklistValues();
    }
    
    /**
      * Good Practice: Method shows Good practice of Describe Call within For Loop.        
      */
    private void fieldDescribeCallGoodPractice_First(){
        Schema.DescribeFieldResult F = Schema.SObjectType.Account.fields.Name;
    }
    
    /**
      * Good Practice: Method shows Good practice of Describe Call within For Loop.        
      */
    private void fieldDescribeCallGoodPractice_Second(){
        Schema.SObjectType t = Schema.getGlobalDescribe().get('Account');
        Schema.DescribeSObjectResult r = t.getDescribe();
        Schema.DescribeFieldResult f = r.fields.getMap().get('Industry').getDescribe();
    }
    
    /**
      * Good Practice: Method shows Good practice of Describe Call within For Loop.        
      */
    private void fieldDescribeCallGoodPractice_Third(){
        Schema.DescribeFieldResult f = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Industry').getDescribe();
    }
    
    /**
      * Good Practice: Method shows Good practice of Describe Call within For Loop.        
      */
    private void fieldDescribeCallGoodPractice_Four(){
        Schema.DescribeFieldResult f = Account.SObjectType.getDescribe().fields.getMap().get('Industry').getDescribe();
    }
    
    /**
      * Good Practice: Method shows Good practice of Describe Call within For Loop.        
      */
    private void childDescribeCallGoodPractice_First(){
        Schema.DescribeSObjectResult R = Account.SObjectType.getDescribe();
        List<Schema.ChildRelationship> C = R.getChildRelationships();
    }
    
    /**
      * Good Practice: Method shows Good practice of Describe Call within For Loop.        
      */
    private void childDescribeCallGoodPractice_Second(){
        List<Schema.ChildRelationship> C = Schema.Sobjecttype.Account.getChildRelationships();          
    }
    
    /**
      * Good Practice: Method shows Good practice of Describe Call within For Loop.        
      */
    private void childDescribeCallGoodPractice_Third(){
        List<Schema.ChildRelationship> C = Schema.getGlobalDescribe().get('Account').getDescribe().getChildRelationships();
    }
    
    /**
      * Good Practice: Method shows Good practice of Describe Call within For Loop.        
      */
    private void recordTypeDescribeCallGoodPractice_First(){
        Schema.DescribeSObjectResult R = Account.SObjectType.getDescribe();
        List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();
    }
    
    /**
      * Good Practice: Method shows Good practice of Describe Call within For Loop.        
      */
    private void recordTypeDescribeCallGoodPractice_Second(){
        List<Schema.RecordTypeInfo> RT = Account.SObjectType.getDescribe().getRecordTypeInfos();
    }
    
    /**
      * Good Practice: Method shows Good practice of Describe Call within For Loop.        
      */
    private void recordTypeDescribeCallGoodPractice_Third(){
        List<Schema.RecordTypeInfo> RT = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfos();
    }
    
    /**
      * Good Practice: Method shows Good practice of Describe Call within For Loop.        
      */
    private void recordTypeDescribeCallGoodPractice_Four(){       
        Map<String, Schema.Recordtypeinfo> schemaRtMap = Schema.Sobjecttype.Account.getRecordTypeInfosByName();
    }
}