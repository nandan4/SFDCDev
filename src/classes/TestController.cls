Global class TestController
{
public List<String> accList {get;set;}
public Integer acc{get;set;}
public string ac{get;set;}

public TestController(Map<Id,Account> oldAccountMap,Map<Id,Account> newAccountMap,List<Account> oldOpps, List<Account> newOpps){
    System.debug('** oldAccountMap **' + oldAccountMap);
    System.debug('** newAccountMap **'+ newAccountMap);
    System.debug('** oldOpps **'+ oldOpps);
    System.debug('** newOpps **'+ newOpps);
}

public TestController()
{
accList = new List<String>();
for(Integer i=0;i<5;i++){
    
       accList.add('');
}
list<String> codeBlock = new list<String>();
acc = 1234;
String tsv = 'Salesforce.com';
String tv = 'Salesforce.com';
string s = '\'';
String v = 'stg\'';
ac = 'Test';
map<String,String> testMap = new map<String,String>();
testMap.put('Hello','World');
String test = 'Query'+ac+'Debug';
String query = 'Select Id From Account Where Name = '+ ac;
String Tstquery = 'Select Id From Account Where Id = \''+ acc + 'And Name = '+ ac;
//Test
Account accnt = new Account(Name = ac , BillingCity = 'Test City' , BillingState = 'Test',
BillingCountry = '',phone = '123');
codeBlock.add('StaticStringCustomSettings__c csObj'+acc+' = new StaticStringCustomSettings__c(Name = \'CL_'+ acc +'\', StaticStringValue__c = \''+ ac + '\', Reference__c = \''+ ac +'\');');
Boolean b = acc > 1234? true:false;
String t = '\\';
VFC_OverideConvertLead.lobList();
System.debug('** Test Called **');
}

Webservice static string testCall(String txt){
System.debug('** Test Called **');
return 'Hello ' + txt;
}

/*
<td>                           
    <div class="requiredBlock"  style="background-color: #CC0000; bottom: -50px; height: 1.5em; left: -8px; top: 0px; width: 3px;"></div>
</td>
*/

    public List<SelectOption> getObjects() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
        options.add(new SelectOption('Account','Account'));
        options.add(new SelectOption('Contact','Contact'));
        return options;
    }
    
    public String objectName {get;set;}
    
    public List<SelectOption> records{get;set;}
    
    public void fetchRecords(){
        List<SelectOption> options = new List<SelectOption>();
        String query = null;
        if(String.isNotBlank(objectName)){
            query = 'SELECT Id,Name FROM '+ objectName;
        }
        if(String.isNotBlank(query)){
            for(sObject obj : Database.query(query) ){
                options.add(new SelectOption(String.valueOf(obj.get('Id')),String.valueOf(obj.get('Name'))));
            }
        }  
        records = options;  
    }
    public String[] recordList {get;set;}
    
    
    public static void testAddError(Map<Id,sObject> accList){
        List<Account> diffList = [SELECT Id,Name FROM Account WHERE Id IN: accList.keyset()];
        //for(Account acc : diffList ){
          //  acc.addError('In Class Error');
        //}
        difflist[0].addError('Error');
        //accList.values().get(0).addError('In Class Error');
    }
}