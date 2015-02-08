public class VFC_OppButton{

    public list<Opportunity> recs {get;set;}
    
    public VFC_OppButton(ApexPages.standardcontroller controller)
    {
        recs = new list<Opportunity>{(Opportunity)controller.getrecord()};
    }
    
    public VFC_OppButton(ApexPages.standardsetcontroller setcontroller)
    {
        recs = setcontroller.getselected();
    }
    
    public void methodCall()
    {
        System.debug('** Records ==>'+recs);
    }
}