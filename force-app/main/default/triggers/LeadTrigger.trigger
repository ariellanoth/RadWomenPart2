Trigger LeadTrigger on Lead(after insert, after update){

    if(trigger.isAfter){
        if(trigger.isInsert){
            leadTriggerHandler.createLeadTask(trigger.New, trigger.OldMap);
        }
        if(trigger.isUpdate){
            leadTriggerHandler.createLeadTask(trigger.New, trigger.OldMap);
        }
    }
}