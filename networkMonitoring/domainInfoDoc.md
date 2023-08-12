# Network Monitoring
This documentation provides an overview of a Bash script designed to monitor network connectivity for specific domains. The script reads domain names from a file or accepts domain names as input parameters, and then performs a ping operation to gather network information. This information is then inserted into a PostgreSQL database.
Prerequisites

## Usage

To run the script, execute the following command:

./network_monitoring.sh [options]

The script accepts the following options:

    -c <ping_count>: Specifies the number of ping packets to send. The default value is 5.
    -d <domain>: Specifies a single domain to monitor.
    -f <file>: Specifies a file containing a list of domains to monitor.

### Note: You can use either the -d or -f option, but not both simultaneously.

### Network Information

The following network information is captured and inserted into the database:

    domain_name: The domain name being monitored.
    ip_address: The IP address obtained from the ping operation.
    jitter: The difference between the maximum and minimum ping times.
    packet_loss: The percentage of packet loss during the ping operation.
    avg_ping_time: The average ping time for the given domain.

## Examples

### Monitor a single domain:

    ./network_monitoring.sh -d example.com

This command will execute a ping operation for the example.com domain and insert the gathered information into the PostgreSQL database.

### Monitor multiple domains from a file:

Create a file named domains.txt with the following contents:

    example.com
    google.com
    yahoo.com
<br>

    ./network_monitoring.sh -f domains.txt

This command will read the domain names from the domains.txt file and execute a ping operation for each domain. The gathered information will be inserted into the PostgreSQL database.

### Specify the number of ping packets to send:

    ./network_monitoring.sh -c 3 -d example.com

This command will send 3 ping packets to the example.com domain instead of the default 5 packets.
Cleanup

The script creates a temporary file called domain_info to store ping output temporarily. This file is automatically deleted at the end of script execution.
Conclusion

## Code Explanation

The while loop is used to loop through the command line options and arguments. Inside the loop, the case statement is used to check the value of $opt and take appropriate actions based on the option.

- If the option is "-c", the value of $OPTARG is assigned to the variable "ping_count".

- If the option is "-d", the value of $OPTARG is assigned to the variable "domain" and the function "getPing" is called with the "domain" variable as an argument.

- If the option is "-f", the value of $OPTARG is assigned to the variable "file" and the script reads each line from the file, assigns it to the variable "line", and then calls the function "getPing" with the "line" variable as an argument.

- If the option is not one of the specified options, an error message is displayed and the script exits.

### getPing function

it runs a ping command with the given parameters (-c $ping_count $1) and redirects the output to a file called domain_info.

- packet_loss: extracted from the 6th column (field) of the line number count + 4 in the domain_info file. The % character is then removed using the sed command.

- avg_ping: extracted from the 4th column of the line number count + 5 in the domain_info file. The value is further manipulated using the cut command to extract the second field based on the delimiter /.

-  min_ping, max_ping: extracted using the same method as avg_ping.

- jitter: calculated by subtracting min_ping from max_ping using the bc command.

- ip: extracted from the 3rd column of the first line in the domain_info file. Any parentheses are removed using the sed command.

Finally, the function executes a database query to insert the extracted information (domain_name, ip_address, jitter, packet_loss, avg_ping_time) into a table called domain_info.

## POSTGRESQL

before running the code you should create a network database in psql and domain_info table with this structure:
    
    CREATE TABLE domain_info (
        id SERIAL PRIMARY KEY,
        ping_time timestamp without time zone DEFAULT current_timestamp,
        domain_name VARCHAR(255) NOT NULL,
        ip_address VARCHAR(45) NOT NULL,
        jitter FLOAT NOT NULL,
        packet_loss FLOAT NOT NULL,
        avg_ping_time FLOAT NOT NULL
    );

then you can access the datas with this query:

    select * from domain_info;