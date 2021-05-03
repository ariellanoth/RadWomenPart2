public inherited sharing class RecipeController {
    @AuraEnabled(Cacheable=true)
    public static Recipe__c[] getAllRecipes() {
        return [
            SELECT
                Id,
                Name,
                Draft__c,
                Active_Time__c,
                Active_Time_Units__c,
                Complexity__c,
                Needs_Review__c,
                Possible_Duplicate__c,
                Season__c
            FROM Recipe__c
            ORDER BY Name
            LIMIT 50
        ];
    }

    @AuraEnabled(Cacheable=true)
    public static Recipe__c[] searchRecipes(String searchTerm) {
        // Return all recipes when no search term
        searchTerm = searchTerm.trim();
        if (searchTerm == '') {
            System.debug('returning: '+getAllRecipes());
            return getAllRecipes();
        }
        // Prepare query paramters
        searchTerm = '%' + searchTerm + '%';
        // Execute search query
        return [
            SELECT
                Id,
                Name,
                Draft__c,
                Active_Time__c,
                Active_Time_Units__c,
                Complexity__c,
                Needs_Review__c,
                Possible_Duplicate__c,
                Season__c
            FROM Recipe__c
            WHERE Name LIKE :searchTerm
            ORDER BY Name
            LIMIT 50
        ];
    }
    @AuraEnabled
    public static void addIngredient(string ingredientName, Integer measurementAmount, string measurementType, Id recipeId){
        Ingredient__c newIngredient = new Ingredient__c();
        newIngredient.Name = ingredientName;
        newIngredient.Measurement__c = measurementAmount;
        newIngredient.Measurement_Type__c = measurementType;
        newIngredient.Recipe__c = recipeId; 

        insert newIngredient; 

    }
    @AuraEnabled
    public static List<Ingredient__c> generateGroceryList(Id recipeId){
        List<Ingredient__c> getIngredients = [SELECT ID, Name, Measurement__c, Measurement_Type__c, Notes__c, Recipe__r.Servings__c FROM Ingredient__c WHERE Recipe__c = : recipeId ];
        return getIngredients; 
    }
    @AuraEnabled 
    public static List<Ingredient__c> scaleRecipeForServings(ID recipeId, Decimal desiredServings){
        List<Ingredient__c> ingredientsNeeded = generateGroceryList(recipeId);
        for(Ingredient__c currentIngredient : ingredientsNeeded){
            Decimal newMeasurement = currentIngredient.Measurement__c / currentIngredient.Recipe__r.Servings__c; 
            if(desiredServings > 1){
                currentIngredient.Measurement__c = newMeasurement * desiredServings; 

            }
            else{
                currentIngredient.Measurement__c = newMeasurement;
            }
           
        }
        return ingredientsNeeded; 
    }
}