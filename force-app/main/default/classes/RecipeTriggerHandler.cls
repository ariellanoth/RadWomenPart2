public class RecipeTriggerHandler{
    //create method intended to determine if the recipe has any crucial data points missing
    //if true, mark the recipe as DRAFT
    //if false, set DRAFT to FALSE 
    public static void isRecipeDraft(List<Recipe__c> recipeList){
        system.debug('Begin Recipe Draft Status Evaluation');
        //loop through each recipe 
        for(Recipe__c recipe : recipeList ){
            //evaluate the field values of Name, Active Time, Description, Active Time Units and Servings
            //if any of these fields are empty or null, set the field DRAFT to TRUE 
            //if all fields are populated, set the field DRAFT to FALSE 
            if(recipe.Name == '' || recipe.Active_Time__c == NULL || recipe.Description__c == '' 
            || recipe.Active_Time_Units__c == '' || recipe.Servings__c == NULL){
                recipe.Draft__c = TRUE; 
            }
            else{
                recipe.Draft__c = FALSE; 
            }
        }

    }
    //create method intended to rate the complexity of the recipe 
    //method will call method established in HelperFunctions class to evaluate
    public static void determineComplexity(List<Recipe__c> recipeList){
        system.debug('Begin Complexity Evaluation');
        //loop through each recipe
        for(Recipe__c recipe : recipeList){
            system.debug(recipe.Servings__c);
            system.debug(recipe.Active_Time_Units__c);
            system.debug(recipe.Active_Time__c);
            //establish an Integer variable, and assign the return value of the
            //rateRecipeComplexity method to it 
            //evaluate the value assigned to Rating
            //if 3 set Complexity as Difficult
            //if 2 set complexity as Moderate
            //if 1 set Complexity as Simple 
            Integer rating = HelperFunctions.rateRecipeComplexity(recipe);
            system.debug(rating);
            if(rating == 3){
                recipe.Complexity__c = 'Difficult';
            }
            else if(rating == 2){
                recipe.Complexity__c = 'Moderate';
            }
            else if(rating == 1){
                recipe.Complexity__c = 'Simple';
            }
            system.debug(recipe.Complexity__c);
        }
        
    }
    //create method intended to create a task to review the cookbook for a recipe that is not a draft
    public static void createReviewTask(List<Recipe__c> recipeList, Map<Id, Recipe__c> oldRecipeMap){
        Set<ID> draftRecipes = new Set<ID>();
        for(Recipe__c recipe : recipeList){
            //loop through every recipe
            //determine if recipe is a draft - if not add it to the Set to store the Recipe IDS
            if(!recipe.Draft__c && (oldRecipeMap.get(recipe.Id).Draft__c != recipe.Draft__c)){
                draftRecipes.add(recipe.Id);
            }
        }
        //Use recipe ID set to perform a query and sub-query of recipes and any associated recipe usage records
        List<Recipe__c> recipeUsage = [SELECT ID, (SELECT ID, Recipe__c, Cookbook__r.Id, Cookbook__r.OwnerId FROM Recipe_Usages__r) FROM Recipe__c WHERE ID in : draftRecipes];
        Set<Cookbook__c> cookBooks = new Set<Cookbook__c>();
        for(Recipe__c recipe : recipeUsage){
            //loop through each recipe and then the values of its sub query
            for(Recipe_Usage__c usage : recipe.Recipe_Usages__r){
                //if suby query returns a value, add it to the Cookbook set 
                cookBooks.add(usage.Cookbook__r);
            }
        }
        List<Task> insertTasks = new List<Task>();
        //loop through Cookbook set to create each new task 
        for(Cookbook__c cookbook : cookBooks){
            Task newtask = new Task();
            newTask.WhatId = cookbook.Id; 
            newTask.OwnerId = cookbook.OwnerId; 
            newTask.ActivityDate = system.today() + 7;
            newTask.Subject = 'Cookbook Review Needed';
            insertTasks.add(newTask);

        }
        insert insertTasks; 
    }
}