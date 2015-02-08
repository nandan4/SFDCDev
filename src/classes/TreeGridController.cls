Global Class TreeGridController{
    
    /* Variables */
    public static Account upACC {get;set;}
    public static Contact upCON {get;set;}
    public static Boolean showDiv {get;set;}
    public static List<Account> acc {get;set;}
    public List<Contact> con {get;set;}
    public static String accountsJSON {get;set;}
    public static String pretty {get;set;}
    public static String jsString {get;set;}
    
    
    /* Constructor */
    public TreeGridController(){        
        pretty = generateJSON();
        showDiv = true; 
    }
    
    /* Method For JSON Generation */
    public static String generateJSON(){
        String jsonString;
        acc =[ SELECT Account.Id,Account.Name,Account.BillingCity,Account.BillingState,Account.AnnualRevenue, (SELECT Contact.FirstName,Contact.LastName,Contact.MailingCity,Contact.MailingState FROM Account.Contacts) FROM Account];
        accountsJSON = JSON.serialize(acc);
        System.debug('** Account-Contacts ==>'+acc[0]);
        System.debug('** JSON ==> '+accountsJSON);
        JSONGenerator generator = JSON.createGenerator(true);
        generator.writeStartObject();
        generator.writeFieldName('rows');
        generator.writeStartArray();
        for(Account a:acc){
            generator.writeStartObject();
            generator.writeStringField('id',a.id);
            generator.writeStringField('xmlkids','1');
            generator.writeFieldName('data');
            generator.writeStartArray();
            generator.writeStartObject();
            generator.writeStringField('value',a.Name);
            generator.writeEndObject();
            generator.writeString(''+a.BillingCity);
            generator.writeString(''+a.BillingState);
            generator.writeString(''+a.AnnualRevenue);
            generator.writeEndArray();
            generator.writeFieldName('rows');
            generator.writeStartArray();                       
                   
            for(integer i=0;i<a.Contacts.size();i++){                
                         
                generator.writeStartObject();
                generator.writeStringField('id',a.Contacts[i].id);
                generator.writeFieldName('data');
                generator.writeStartArray();
                generator.writeStartObject();
                generator.writeStringField('value',a.Contacts[i].FirstName+' '+a.Contacts[i].LastName);
                generator.writeEndObject();
                generator.writeString(''+a.Contacts[i].MailingCity);
                generator.writeString(''+a.Contacts[i].MailingState );
                generator.writeEndArray();
                generator.writeEndObject();
                
            }            
            generator.writeEndArray();
            generator.writeEndObject();
        }    
        System.debug('** JSON Generator ==> '+generator);
        jsonString = generator.getAsString();
        System.debug('** JSON String ==> '+jsonString);
        return jsonString;
    }
    
    /* Method For Record Update */
    @RemoteAction
    global static String updateRecords(String recId,Integer colIndex,String oldVal,String newVal){
        showDiv = true;
        upACC = new Account();   
        upCON = new Contact();
        System.debug('** Record Id ==>'+recId);
        String Id = recId.substring(0,3);
        Account ac=new Account();
        Contact co=new Contact();
        System.debug('** ID ==> '+Id);
        if(Id.equals('001')){
            String accQuery = 'SELECT Id,Name,BillingCity,BillingState,AnnualRevenue FROM Account WHERE Id = \'' +recId+ '\'';
            System.debug('** Query ==>'+accQuery);
            upACC = Database.Query(accQuery);
            if(colIndex == 0){
                upACC .Name = newVal;
            }else if(colIndex == 1){
                upACC.BillingCity = newVal;
            }else if(colIndex == 2){
                upACC.BillingState = newVal;
            }else {
                upACC.AnnualRevenue = decimal.valueOf(newVal);
            }
            Database.Update(upACC,false);         
        } else if(Id.equals('003')) {
            String conQuery = 'SELECT Id,FirstName,LastName,MailingCity,MailingState FROM Contact WHERE Id = \'' +recId+ '\'';
            System.debug('** Query ==>'+conQuery );
            upCON = Database.Query(conQuery);
            if(colIndex == 0){
                String[] name = newVal.split(' ');
                upCON.FirstName = name[0];
                upCON.LastName = name[1];
            }else if(colIndex == 1){
                upCON.MailingCity= newVal;
            }else {
                upCON.MailingState = newVal;
            }
            Database.Update(upCON,false);    
        }        
        jsString = generateJSON(); 
        return jsString ;   
    }   
    
    /* Method for Drag-Drop Event */
    @RemoteAction
    global static String updateDropRecords(String sId,String tId,String dId){
        showDiv = true;
        String dropQuery;
        System.debug('** Ids '+sId +','+tId+','+dId);
        if(dId.substring(0,3).equals('003')){
            dropQuery = 'SELECT Id,FirstName,LastName,MailingCity,MailingState,AccountId FROM Contact WHERE Id = \'' + dId + '\'';
            Contact dropCon = Database.Query(dropQuery);
            dropCon.AccountId = tId;
            Database.Update(dropCon,false);
        }else if(dId.substring(0,3).equals('001')){
            dropQuery = 'SELECT Id,Name,BillingCity,BillingState,ParentId FROM Account WHERE Id = \'' + dId + '\'';
            Account dropAcc = Database.Query(dropQuery);
            dropAcc.ParentId = tId;
            Database.Update(dropAcc,false);
        }
        jsString = generateJSON(); 
        return jsString ; 
    }   
}