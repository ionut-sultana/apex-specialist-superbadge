public with sharing class MaintenanceRequestHelper {
    
    public static  Database.UpsertResult[] updateWorkOrders(Map<String, Case> updatedCases ) {
        SObject[] maintenanceCases = new Sobject[]{};
        SObject[] equipMaintReq = new Sobject[]{};
        SObject[] sobjList = new Sobject[]{};

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
            
            SObject caseSObj = new Case();
            caseSObj = newCs;
                
            if (cs.isSet('Description') && cs.Description.contains('Forbidden text phrase')){
                system.debug('caseSobj'+caseSobj);
                caseSObj.addError('Too many forbidden phrases here');
            }

            maintenanceCases.add(caseSObj);

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
            system.debug('results' + results);
            return results;
        
        } catch (Exception e) {
            System.debug(e.getTypeName() + ' - ' + e.getCause() + ': ' + e.getMessage());
            return null;
        }
    }        
}