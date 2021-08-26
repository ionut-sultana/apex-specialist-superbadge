@IsTest
private class WarehouseCalloutServiceTest {
    
    
    @isTest private static void testFailUpsertingProducts(){

        WarehouseCalloutServiceMock.insertBadContent = true;
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        HttpResponse res = new HttpResponse();
        try{
            WarehouseCalloutService.getCalloutResponseContents();
        } catch (Exception e) {
            string exceptionType =(String) e.getTypeName();
            system.assertEquals('System.DmlException', exceptionType);
            Product2[] productList = new Product2[]{[Select Name from Product2]};
            system.assert(productList.isEmpty(), 'Product List is not Empty');
        }

    }
    
    @isTest private static void testExecute(){
        WarehouseCalloutServiceMock.insertBadContent = false;
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());

        Test.startTest();        
            System.enqueueJob(new WarehouseCalloutService());
        Test.stopTest();
       
    }

    @isTest private static void testSuccedUpsertingProducts(){
        WarehouseCalloutServiceMock.insertBadContent = false;
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        WarehouseCalloutService.getCalloutResponseContents();
       
        Product2[] productList = [Select Name from Product2];
        system.assert(!productList.isEmpty(), 'Product List is Empty');
        system.assertEquals(7,productList.size(), 'Product List size not expected');
    }
}