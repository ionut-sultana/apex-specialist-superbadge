@isTest
private with sharing class MaintenanceRequestHelperTest {

    @testSetup static void setup() {
        // Create common test data
        createDefaultData.CreateDefaultData();
    }

    @isTest static void testInsertingMaintenanceRequests() {
        Case[] caseList10 = [Select Id, Type, Status from Case limit 10];
        
        for (Case cs : caseList10){
            cs.Status = 'Closed';
            cs.Type = 'Repair';
        }
        
        Test.startTest();
        Database.SaveResult[] result = Database.update(caseList10, false);
        Test.stopTest();
        
        for ( Database.SaveResult db: result){
            system.assert(db.isSuccess());
        }

        Case[] allCases = [select id from case];
        system.assertEquals(310, allCases.size(), 'Not all the cases have been inserted');
    }

    @isTest static void testExceptionInsertingMaintRequests(){
        Case[] caseList10 = [Select Id, Type, Vehicle__r.id, Status, (SELECT Quantity__c, Equipment__c, Equipment__r.Maintenance_Cycle__c FROM Equipment_Maintenance_Items__r)  from Case limit 10];
        
        for (Case cs : caseList10){
            cs.Status = 'Closed';
            cs.Type = 'Repair';
            cs.Description = 'Forbidden text phrase';
        }

        Test.startTest();
            try{
                for (equipment_maintenance_item__c cs : caseList10[0].equipment_maintenance_items__r){
                        system.debug('ultimateCs' + cs);
                }
                Database.SaveResult[] result = Database.update(caseList10, false);

            } catch (Exception e){
                Boolean expectedExceptionThrown =  e.getMessage().contains('Too many forbidden phrases here, help') ? true : false;
                System.AssertEquals(expectedExceptionThrown, true); 
            }

        Test.stopTest();



    }

    @isTest static void testFailCreatingMaintRequest() {
        Case[] caseList10 = [Select Id, Type, Status from Case limit 10];
        for (Case cs : caseList10){
            cs.Status = 'Closed';
            cs.Type = 'Electrical';
        }

        Test.startTest();
        Database.SaveResult[] result = Database.update(caseList10, false);
        Test.stopTest();

        Case[] allCases = [select id from case];
        system.assertEquals(300, allCases.size());

    }

    @isTest
    static void testMaintenanceRequestCreation (){
        Map<String, Case>  caseList300 =  new Map<String, Case> ([Select Id, Type, Status, Vehicle__r.id, (SELECT Quantity__c, Equipment__c, Equipment__r.Maintenance_Cycle__c FROM Equipment_Maintenance_Items__r) from Case limit 300]);
       
        for (Case cs : caseList300.values()){
            cs.Status = 'Closed';
            cs.Type = 'Repair';
        }

        SObject[] soCaseList300 = (List<Case>) caseList300.values();

        Test.startTest();
            Database.SaveResult[] result = Database.update(soCaseList300,false);
        Test.stopTest();

        // set<id> closedCasesIds = new set<id>();
        // for (Database.UpsertResult res : insertResult) {
        //     if (res.isSuccess()) {
        //         closedCasesIds.add(res.getId());
        //     }
        // }

        Map<String, Case> totalCreatedCases = new Map<String, Case>([Select Id, Status, Vehicle__c, (SELECT Equipment__c FROM Equipment_Maintenance_Items__r) from Case where Status != 'Closed'  ]);
        for (Case cs: totalCreatedCases.values()){
            
            system.assertEquals(true, cs.Equipment_Maintenance_Items__r.size() > 0);
            system.assertEquals(true, cs.isSet('Vehicle__c'));
            
            for (Equipment_Maintenance_Item__c eq : Cs.Equipment_Maintenance_Items__r){
                system.assertEquals(true, eq.isSet('Equipment__c'));
            }
        }

        system.assertEquals(300, totalCreatedCases.size());
    }
}