public class LeadTriggerHandler{
    public static void createLeadTask(List<Lead> leadRecords, Map<Id, Lead> oldLeadRecords){
        List<Task> insertTasks = new List<Task>();
        if(leadRecords.size() > 0){
            for(Lead leadRecord : LeadRecords){
                if(trigger.isInsert && leadRecord.ProductInterest__c == 'Cookbook Printing'){
                    insertTasks.add(leadTriggerHandler.taskMethod('New Cookbook Printing Inquiry', leadRecord.Id, 'New Printing Inquiry'));
                   
                }
                if(trigger.isUpdate && leadRecord.ProductInterest__c == 'Cookbook Printing' 
                && leadRecord.ProductInterest__c != oldLeadRecords.get(leadRecord.Id).ProductInterest__c){
                    
                    insertTasks.add(leadTriggerHandler.taskMethod('New Cookbook Printing Inquiry', leadRecord.Id, 'New Printing Inquiry'));
                }
            }
        }
        if(insertTasks.size() > 0){
            insert insertTasks; 
        }

    }
    public static Task taskMethod(String subjectLine, Id leadId, String typeTask){
        Task newTask = new Task();
        newTask.Subject = subjectLine;
        newTask.WhoId = leadId; 
        newTask.Status = 'New';
        newTask.Type = typeTask; 
        newTask.ActivityDate = system.today() + 3;
        return newTask;  

    }

}