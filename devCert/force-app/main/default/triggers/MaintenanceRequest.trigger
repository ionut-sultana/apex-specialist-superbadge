trigger MaintenanceRequest on Case (before update, after update) {
    
    if (Trigger.isAfter){
        Map<String, Case> caseList = new map<String, Case>(
            [SELECT Id, Vehicle__r.id, Status,(SELECT Quantity__c, Equipment__c, Equipment__r.Maintenance_Cycle__c FROM Equipment_Maintenance_Items__r) 
            FROM Case where ID in :Trigger.New AND (Type='Routine Maintenance' OR Type='Repair') AND Status='Closed' ]);
        Map<String, Case> updatedClosedCases = new Map<string, case>();

        if(caseList.size()>0){
            for (Case cs : Trigger.New){
                if ( Trigger.oldMap.get(cs.Id).Status != caseList.get(cs.Id).Status ){
                    updatedClosedCases.put(cs.Id, caseList.get(cs.Id));
                }
            }
            if (updatedClosedCases.size() > 0 ){
                MaintenanceRequestHelper.updateWorkOrders(updatedClosedCases);
                system.debug('all');
            }
        }
    }
}