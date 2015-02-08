public class DescribeCall_Examples{

    public static void outerMethod(){
        //try{
        	innerMethod();            	
        /*}
        catch(Exception exp){
        	return exp.getMessage();    
        }*/
    }
    
    private static void innerMethod(){
        try{
            List<String> stringList ;
            System.debug(stringList.size());            
        }
        catch(Exception exp){
        	
        }
    }
}