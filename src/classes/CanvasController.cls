public with sharing class CanvasController implements Canvas.CanvasLifecycleHandler{
    
    private string QUERY_PARAM;
        
    public Set<Canvas.ContextTypeEnum> excludeContextTypes(){
        Set<Canvas.ContextTypeEnum> excluded = new Set<Canvas.ContextTypeEnum>();
        excluded.add(Canvas.ContextTypeEnum.ORGANIZATION);
        return excluded;
    }
    
    public void onRender(Canvas.RenderContext renderContext){
        System.debug('** Canvas lifecycle called. **');
        Canvas.ApplicationContext app = renderContext.getApplicationContext();
        Canvas.EnvironmentContext env = renderContext.getEnvironmentContext();                
        URL url = new URL(app.getCanvasUrl());
        System.debug('** url ==>' + url);
        
        Map<String, Object> currentParams = (Map<String, Object>) JSON.deserializeUntyped(env.getParametersAsJSON());
        
        QUERY_PARAM = '/?OMID=' + currentParams.get('OMID');
        
        System.debug('** QUERY_PARAM ==>' + QUERY_PARAM);
        
        app.setCanvasUrlPath(QUERY_PARAM);
        System.debug('** url ==>' + app.getCanvasUrl());
    }
}