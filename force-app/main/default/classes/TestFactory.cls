//Test Factory example from Trailhead: https://trailhead.salesforce.com/en/content/learn/modules/unit-testing-on-the-lightning-platform/generate-data-for-tests

@isTest
public class TestFactory {

    public static Account getAccount(String name, Boolean doInsert){
        Account a = new Account(name = name);
        if(doInsert){
            insert a;
        }
        return a;
    }

    public static Contact getContact(Id accountId, String fname, String lname, Boolean doInsert){
        Contact c = new Contact(firstName = fname, lastName = lname, accountId = accountId);
        if(doInsert){
            insert c;
        }
        return c;
    }

    public static void generateAccountWithContacts(Integer numContacts){
        Account a = getAccount('default account ltd', true);
        List<Contact> contacts = new List<Contact>();
        for(Integer i = 0; i < numContacts; i++){
            String contactName = 'contact' + i;
            contacts.add(getContact(a.id, contactName, contactName, false));
        }
        insert contacts;
    }

    public static Opportunity[] generateOppsForAccount(id accountId, Decimal amount, Integer numOpps){
        List<Opportunity> opps = new List<Opportunity>();
        for(Integer i = 0; i < numOpps; i++){
            Opportunity o = new Opportunity();
            o.name = 'Account ' + i;
            o.accountId = accountid;
            o.amount = amount;
            o.closeDate = Date.today().addDays(5);
            o.stageName = 'Prospecting';
            opps.add(o);
        }
        return opps;
    }
    
    public static User generateUser(String profileName){
        UserRole userRole = new UserRole(DeveloperName = 'TestingTeam', Name = 'Testing Team');
        insert userRole;
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = :profileName].Id,
            LastName = 'last',
            Email = 'Cpt.Awesome@awesomesauce.com',
            Username = 'Cpt.Awesome@awesomesauce.com',
            CompanyName = 'Testing Co',
            Title = 'Captian',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = userRole.Id
        );
        insert u;
        return u;
    }
    public static List<Ingredient__c> generateIngredients(Integer numOfIngredients){
        List<Ingredient__c> testIngredients = new List<Ingredient__c>();
        for(Integer count; count < nuMofIngredients; count++){
            Ingredient__c newRec = new Ingredient__c();
            newRec.Name = 'Test Ingredient' + count; 
            testIngredients.add(newRec);

        }
        return testIngredients; 

    }
    public static List<Ingredient__c> insertIngredients(Integer numOfIngredients, List<Recipe__c> testRecipes){
        List<Ingredient__c> testIngredients = generateIngredients(numOfIngredients);
        for(Recipe__c testRecipeRecord : testRecipes){
            for(Ingredient__c testIngredientRecord : testIngredients){
                testIngredientRecord.Recipe__c = testRecipeRecord.Id;
            }
        }
        insert testIngredients; 
        return testIngredients; 
    }
    public static List<Recipe__c> insertRecipes(Integer numOfRecipes){
        List<Recipe__c> testRecipes = new List<Recipe__c>();
        for(Integer count; count < numOfRecipes; count++){
            Recipe__c newRec = new Recipe__c();
            newRec.Name = 'Test Recipe ' + count; 
            newRec.Servings__c = count; 
            testRecipes.add(newRec);

        }
        insert testRecipes;  
        return testRecipes; 
    }
    
}
