public class VectorMapController{
    public static String pretty {get;set;}
    
    public VectorMapController(){        
        pretty = generateJSON();
    }
    
     public static String generateJSON(){
        String jsonString;
        Map<String,String> coordinatesMap = new Map<String,String>();
        
        coordinatesMap.put('al','mstr');
        coordinatesMap.put('af','lcl');
        System.debug('** coordinatesMap ==> '+coordinatesMap);
        JSONGenerator generator = JSON.createGenerator(true);
        generator.writeStartObject();
        for(String key : coordinatesMap.keyset()){
            generator.writeStringField(key,coordinatesMap.get(key));
        }
        generator.writeEndObject();
        System.debug('** JSON Generator ==> '+generator);
        jsonString = generator.getAsString();
        System.debug('** JSON String ==> '+jsonString);
        return jsonString;
    }
}