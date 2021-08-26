@isTest
private with sharing class WarehouseSyncScheduleTest {

    @isTest static void testSchedulable(){
        WarehouseCalloutServiceMock.insertBadContent = false;
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());

        Test.startTest();
            // String jobId  =  System.enqueueJob(new WarehouseCalloutService());
            String jobId2 = System.schedule('testBasicScheduledApex',
            '0 0 0 ? * * *', 
               new WarehouseSyncSchedule());

                // Get the information from the CronTrigger API object
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
      NextFireTime
      FROM CronTrigger WHERE id = :jobId2];

   // Verify the expressions are the same
   System.assertEquals('0 0 0 ? * * *', 
      ct.CronExpression);


        Test.stopTest(); 

        Product2[] prdList = [Select Id from Product2];
        system.debug(prdList);

    }
}