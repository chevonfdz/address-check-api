import ballerina/http;
import ballerinax/mysql.driver as _;
import ballerinax/mysql;

type Person record {
    string firstName;
    string lastName;
    string dob;
    string address;
    string telno;
    string nic;
};


type isValid record {
    boolean valid;
};

// MySQL configuration parameters

configurable string host = ?;
configurable string user = ?;
configurable string password = ?;
configurable string database = ?;

final mysql:Client mysqlClient = check new (host = host, user = user, password = password,
                                            database = database);

service / on new http:Listener(9090) {

    isolated resource function get checkAddress(string nic, string address) returns json|error? {
        Person | error queryRowResponse1 =  mysqlClient->queryRow(`select * from addresses where address=${address.trim()}`);
        Person | error queryRowResponse2 =  mysqlClient->queryRow(`select * from addresses where nic=${nic.trim()}`);
        if queryRowResponse1 is error || queryRowResponse2 is error{
         isValid result = {
                valid: false
            };
            return result.toJson();
        }else{
            isValid result = {
                valid: true
            };
            return result.toJson();
        }

    }
}
