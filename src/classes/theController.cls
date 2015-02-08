public class theController{
    public string out{
        get{
            System.debug('** Getter **');
            if(out == null) out = 'getter';
            return out;
        }
        set;        
    }
    
    public theController(){
        System.debug('** Constructor **');
        out = 'constructor';
    }
    
    public void setOut(){
        System.debug('** Setter **');
        out = 'action';
    }
}