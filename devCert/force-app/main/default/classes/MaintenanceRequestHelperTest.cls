@isTest
private with sharing class MaintenanceRequestHelperTest {
    @isTest static void testUpdatingMaintenanceRequests() {
        createDefaultData.CreateDefaultData();
        Case[] caseList = [Select Id, Type, Status from Case limit 10];

        for (Case cs : caseList){
            cs.Status = 'Closed';
            cs.Type = 'Repair';
        }

        Test.startTest();
            Database.SaveResult  result = Database.update(caseList[0], false);
        Test.stopTest();

    }
}