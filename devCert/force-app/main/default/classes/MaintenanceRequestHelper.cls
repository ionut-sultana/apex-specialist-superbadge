public with sharing class MaintenanceRequestHelper {
    
    public static void updateWorkOrders(Map<String, Case> updatedCases ) {
        Sobject[] maintenanceCases = new Sobject[]{};
        Sobject[] equipMaintReq = new Sobject[]{};
        SObject[] sobjList = new List<SObject>();

        for (Case cs : updatedCases.values()){

            Date dt = date.today(); 
            Integer[] maintenanceCycles = new integer[]{};

            if (cs.Equipment_Maintenance_Items__r.size() > 0){
                for (equipment_maintenance_item__c equipM : cs.Equipment_Maintenance_Items__r){
                    maintenanceCycles.add((integer)equipM.Equipment__r.Maintenance_Cycle__c);
                    case caseReference = new case(External_Id__c= cs.Id + '123'); 
                    
                    equipment_maintenance_item__c eq = new equipment_maintenance_item__c();
                    eq.Maintenance_Request__r = caseReference;
                    eq.Quantity__c= equipM.Quantity__c;  
                    eq.Equipment__c= equipM.Equipment__c;  
 
                    equipMaintReq.add(eq);   
                    system.debug('maintenanceCases-->' + maintenanceCases);              
                }
                maintenanceCycles.sort();
            }

            dt = dt.addDays(maintenanceCycles[0]);

            Case newCs = new Case(
                Type='Routine Maintenance',
                External_Id__c= cs.Id + '123',
                Subject='Routine maintenance ' + cs.Id,
                Date_Due__c = dt,
                Date_Reported__c = date.today(),
                vehicle__c = cs.Vehicle__r.id
            );

            maintenanceCases.add(newCs);

        } 
        
        sobjList.addAll(maintenanceCases);
        sobjList.addAll(equipMaintReq);

        try {
            Database.UpsertResult[] results = Database.upsert(sobjList,false);
            if (results != null){
                for (Database.UpsertResult result : results) {
                    if (!result.isSuccess()) {
                        Database.Error[] errs = result.getErrors();
                        for(Database.Error err : errs)
                            System.debug(err.getStatusCode() + ' - ' + err.getMessage());
        
                    }
                }
            }
        
        } catch (Exception e) {
            System.debug(e.getTypeName() + ' - ' + e.getCause() + ': ' + e.getMessage());
        }
    }        
}