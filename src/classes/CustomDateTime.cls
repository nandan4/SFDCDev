public class CustomDateTime{
    public string startDate {get;set;}
    public string endDate {get;set;}
    public integer count {get;set;}
    
    public DateTime stDate {get;set;}
    public Time stTime {get;set;}
    
    public CustomDateTime(){
        System.debug('** startDate ==>'+ startDate );       
    }
    
    public void search(){
        System.debug('** startDate ==>'+ startDate );
        System.debug('** endDate ==>'+ endDate );
        List<String> startdatSplit = startDate.split(' ');
        System.debug('** startdatSplit ==>'+ startdatSplit );
        List<String> enddatSplit = startDate.split(' ');
        System.debug('** enddatSplit ==>'+ enddatSplit );
        
        List<String> startdat = startdatSplit [0].split('/');
        List<String> starttim = startdatSplit [1].split(':');
        System.debug('** startdat ==>'+ startdat );
        System.debug('** starttim ==>'+ starttim );
        
        List<String> enddat = enddatSplit [0].split('/');
        List<String> endtim = enddatSplit [1].split(':');
        System.debug('** enddat ==>'+ enddat );
        System.debug('** endtim ==>'+ endtim );
        
        Integer startYear = Integer.valueOf(startdat [0]);
        Integer startMonth = Integer.valueOf(startdat [1]);
        Integer startDay = Integer.valueOf(startdat [2]);
        Integer startHour = Integer.valueOf(starttim [0]);                        
        Integer startMin = Integer.valueOf(starttim [1]);   
        
        Integer endYear = Integer.valueOf(enddat [0]);
        Integer endMonth = Integer.valueOf(enddat [1]);
        Integer endDay = Integer.valueOf(enddat [2]);
        Integer endHour = Integer.valueOf(endtim [0]);                        
        Integer endMin = Integer.valueOf(endtim [1]);      

        Datetime startDateTime =  datetime.newInstanceGmt(startYear , startMonth ,startDay ,startHour , startMin , 0);
        Datetime endDateTime =  datetime.newInstanceGmt(endYear , endMonth ,endDay ,endHour , endMin , 0);
        System.debug('** startDateTime ==>'+ startDateTime );
        System.debug('** endDateTime ==>'+ endDateTime );
        count = [SELECT Count() FROM Account WHERE CreatedDate >=: startDateTime AND CreatedDate <: endDateTime  ];
        System.debug('** count ==>'+ count );
    }
}