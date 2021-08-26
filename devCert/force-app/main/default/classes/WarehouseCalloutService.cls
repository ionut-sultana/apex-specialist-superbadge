public with sharing class WarehouseCalloutService  implements Queueable  {
    
    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    
    @future(callout=true)
    public static void getCalloutResponseContents() {
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(WAREHOUSE_URL);
        req.setMethod('GET');
        HttpResponse res = h.send(req);
        WarehouseCalloutService.processWarehouseResponse(res);
 
    }

    public static void processWarehouseResponse (httpResponse response){
        List<Object> results =  (List<Object>) JSON.deserializeUntyped(response.getBody());
        Product2[] productList = new Product2[]{};
        for (object o : results){
            Map<String, Object> objectMap = (Map<String, Object>) o;

            Product2 prod = new Product2();
            prod.Replacement_Part__c = true;
            prod.Cost__c = (Integer) objectMap.get('cost');
            prod.Name = (String) objectMap.get('name');
            prod.Current_Inventory__c = (Integer) objectMap.get('quantity');
            prod.Lifespan_Months__c = (Integer) objectMap.get('lifespan');
            prod.Maintenance_Cycle__c = (Integer) objectMap.get('maintenanceperiod');
            prod.Warehouse_SKU__c = (String) objectMap.get('sku');
            prod.ProductCode = (string) objectMap.get('_id');
            productList.add(prod);

        }

        try {
            Database.UpsertResult[] upsResults = Database.upsert(productList,true);
        } catch (Exception e) {
            System.debug(e.getTypeName() + ' - ' + e.getCause() + ': ' + e.getMessage());
        }

    }

      public void execute (QueueableContext context){
        getCalloutResponseContents();
      }
}