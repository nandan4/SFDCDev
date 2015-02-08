public class InputRadioController{
    
    public Id contId {get;set;}
    public List<ContactWrapper> conList {get;set;}
    public ContactWrapper con {get;set;}
    
    public InputRadioController(){
        conList = new List<ContactWrapper>();
        for(Contact con : [SELECT Id,Name FROM Contact LIMIT 5]){
            ContactWrapper wrp = new ContactWrapper();
            wrp.contactId = con.Id;
            wrp.contactName = con.Name;
            conList.add(wrp);
        }
    }
    
    public void methodCall(){
        System.debug('** contId ==>'+contId);
        for(ContactWrapper wrp : conList){
            if(wrp.contactId == contId){
                con = wrp;
            }
        }
    }
    
    public class ContactWrapper {
        public Id contactId {get;set;}
        public String contactName {get;set;}
    }
}