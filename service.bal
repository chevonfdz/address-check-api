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

// MySQL configuration parameters

configurable string host = ?;
configurable string user = ?;
configurable string password = ?;
configurable string database = ?;

final mysql:Client mysqlClient = check new (host = host, user = user, password = password,
                                            database = database);

service / on new http:Listener(9090) {

    isolated resource function get checkAddress(string nic, string address) returns json|error? {
        Person queryRowResponse1 = check mysqlClient->queryRow(`select * from addresses where address=${address}`);
        Person queryRowResponse2 = check mysqlClient->queryRow(`select * from addresses where nic=${nic}`);

        if (queryRowResponse1.address == queryRowResponse2.address) {
            return queryRowResponse1.toJson();
        }

    }
}
