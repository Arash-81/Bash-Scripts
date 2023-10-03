# Bash-Scripts

Developed a set of bash scripts to automate daily tasks, including creating a to-do list, User and Group Management
and organizing files.

## Network Monitoring
a Bash script designed to monitor network connectivity for specific domains. The script reads domain names from a file or accepts domain names as input parameters, and then performs a ping operation to gather network information. This information is then inserted into a PostgreSQL database.


## DNS Changer
The script is a simple and easy-to-use way to change the DNS servers that your system uses. It can be useful for improving your browsing experience.

### How to use

1. Make the script executable by running the following command: 
   
        chmod +x dnsChanger.sh

2. Run the script with one of the following options:

    `g`: Changes the DNS to Google's DNS servers (8.8.8.8 and 8.8.4.4).

    `sh`: Changes the DNS to Shecan's DNS servers (178.22.122.100 and 185.51.200.2).

    `cf`: Changes the DNS to Cloudflare's DNS servers (1.1.1.1 and 1.0.0.1).

    `cfg`: Changes the DNS to Cloudflare's primary DNS server (1.1.1.1) and Google's primary DNS server (8.8.8.8).

    `def`: Changes the DNS to the default DNS server (127.0.0.53).

3. To run the script with an option, type `./dnsChanger.sh <option>` in the terminal, where \<option> is one of the options listed above.

    For example, to change the DNS to Google's DNS servers, you would run the following command:

        ./dnsChanger.sh g

> [!NOTE]
> To use the dnsChanger.sh script as a command, you can create a symbolic link to it in one of your $PATH directories. This will allow you to run the script from anywhere in your terminal without having to specify its full path.
>   sudo ln -s ~/path/to/dnsChanger.sh /usr/local/bin/chdns

> [!IMPORTANT]
> This script changes the DNS servers temporarily.