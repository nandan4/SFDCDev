public class ExportToExcel{
    
    public list<Account> accList {get;set;}
    public ExportToExcel(ApexPages.StandardSetController controller) {
        accList = new List<Account>();
        controller.addFields(new List<String> {'Name','Phone','OwnerId'});
        accList = controller.getSelected();
    }



}