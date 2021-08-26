public with sharing class MaintenanceRequestHelper {
    
    public static SObject[] updateWorkOrders(Map<String, Case> updatedCases ) {
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
            caseSObj = (Case)newCs;
            maintenanceCases.add(caseSObj);

        } 
        
        sobjList.addAll(maintenanceCases);
        sobjList.addAll(equipMaintReq);

        upsert sobjList;
        return sobjList;
    }        
}