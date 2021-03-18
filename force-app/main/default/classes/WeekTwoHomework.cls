
public class WeekTwoHomework{
    //Method intended to query contacts in Org where the domain name of the email 
    //is @uog.com. This method will then proceed to print out the Account Name and Industry 
    //related to each Contact that is part of the query 
    //instantiate method queryContacts
    public static void queryContacts(){
        //instantiate new List of Contacts and query Account Name, Industry, First Name, Last Name From Contacts where email is similar to @uog.com
        List<Contact> contactList = [SELECT Account.Name, Account.Industry, FirstName, LastName FROM Contact WHERE Email like '%@uog.com'];

        //begin For Loop - loop through the results of above query 
        for(Contact contactRecord : contactList){
            //print out the Account Name for each contact 
           system.debug('Contacts Account Is: ' + contactRecord.Account.Name);
        }

    }
    //Method intended to query accounts in Org, and any associated CLOSED WON opportunities 
    //Instantiate method queryAccountsWithClosedWon
    public static void queryAccountsWithClosedWon(){
        //instantiate a new list of Accounts and query Name, and then perform a sub query for Closed Won Opportunities, limit at 10 accounts
        List<Account> accountList = [SELECT Name, (SELECT Name FROM Opportunities WHERE StageName = 'Closed Won') FROM Account LIMIT 10];

        //begin a for loop of each account that was returned and stored in accountList
        for(Account accountRecord : accountList){
            //check if the account has any closed won opportunities associated - if yes, proceed to next for loop
            if(accountRecord.Opportunities.size() > 0 ){
            //begin a second for loop to handle the opportunities associated with each individual account
            for(Opportunity oppRecord : accountRecord.Opportunities){
                //print out Name of the opportunity that is closed won under the account 
                system.debug(oppRecord.Name);
            }
        }
        }
    }
    //Method intended to query Opportunities that are currently in the stage of Qualification and store them in a Map, where their ID is the key
    //and the actual sObject record is the value 
    //Instantiate method queryOppMap
    public static void queryOppMap(){
        //instantiate a new Map of Id, Opp and perform a query to assign ID to the key and the Opportunity record to the value
        Map<Id, Opportunity> oppMap = new Map<ID, Opportunity>([SELECT ID, Name FROM Opportunity WHERE StageName = 'Qualification']);
        //print out the Map
        system.debug('Map contains: ' + oppMap);
    }

    //Method intended to provide a count of the number of open opportunities in the org that are not currently in any type of CLOSED stage
    //Instantiate method queryOpenOppCount
    public static void queryOpenOppCount(){
        //Instantiate an Integer variable to store the results of the aggregate query 
        //Query the count of opportunities where the stage is not set to be recorded as IsClosed
        Integer countOpenOpp = [SELECT COUNT() FROM Opportunity WHERE IsClosed = FALSE];
        //print out the total number of Opportuntiies that are considered Open 
        system.debug('Number of open Opps is ' + countOpenOpp);
    }

}