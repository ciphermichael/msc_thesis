#!/usr/bin/env python3

import argparse
import sys
import os
import urllib.request
import datetime

# Function to obtain an IMDSv2 session token
# This function retrieves a session token required for making secure requests to the EC2 instance metadata service (IMDSv2).
# The token is valid for 6 hours as specified by the "X-aws-ec2-metadata-token-ttl-seconds" header.
def get_token():
    token_url = "http://169.254.169.254/latest/api/token"
    req = urllib.request.Request(token_url, method="PUT")
    req.add_header("X-aws-ec2-metadata-token-ttl-seconds", "21600")  # Token valid for 6 hours
    try:
        with urllib.request.urlopen(req) as response:
            return response.read().decode('utf-8')
    except urllib.error.URLError as e:
        print("Failed to retrieve IMDSv2 token.")
        return None

# Function to access metadata service using the session token
# This function makes an authenticated request to the EC2 metadata service using the IMDSv2 token.
# It fetches metadata based on the provided path and returns the data in string format.
def get_instance_metadata(path, token):
    metadata_url = f"http://169.254.169.254/latest/{path}"
    req = urllib.request.Request(metadata_url)
    req.add_header("X-aws-ec2-metadata-token", token)
    try:
        with urllib.request.urlopen(req) as response:
            return response.read().decode('utf-8')
    except urllib.error.HTTPError as e:
        if e.code == 404:
            return None  # Return None if the requested metadata path does not exist
        else:
            print("HTTP error:", e)
            return None
    except urllib.error.URLError as e:
        print("Failed to access metadata service.")
        return None

# Function to scan for stored AWS credentials on the system
# This function searches through the home directories of all users on the system to detect any stored AWS credentials.
# The presence of such credentials poses a potential security risk, especially if they are exposed or improperly managed.
def credential_scan():
    passwd_file = "/etc/passwd"  # System file containing user account information
    found_creds = False
    with open(passwd_file, 'r') as file:
        for line in file:
            fields = line.strip().split(":")
            cred_location = os.path.join(fields[-2], ".aws", "credentials")  # Path to AWS credentials
            if os.path.isfile(cred_location):
                print(f"\033[1;31m[-]\033[0m AWS credentials discovered at: {cred_location} \033[1;31m(Not OK)\033[0m")
                found_creds = True
    if not found_creds:
        print("\033[1;32m[+]\033[0m No AWS credentials found \033[1;32m(OK)\033[0m")

# Function to detect if an IAM role is associated with the EC2 instance
# This function checks if the EC2 instance is linked to an IAM role, which could be leveraged for accessing AWS resources.
# The function retrieves the IAM role name if it exists, indicating that the instance may have elevated privileges.
def role_detect(token):
    role = get_instance_metadata("meta-data/iam/security-credentials/", token)
    if role:
        print(f"\033[1;33m[I]\033[0m Detected IAM Role: {role} \033[1;33m(Informational)\033[0m")
    else:
        print("\033[1;33m[I]\033[0m No IAM Role linked to this instance \033[1;33m(Informational)\033[0m")

# Function to retrieve user data associated with the EC2 instance
# This function accesses any user data configured for the EC2 instance, which may contain scripts or configuration information.
# Analyzing user data is important for understanding the initial setup and configuration of the instance.
def user_detect(token):
    user_data = get_instance_metadata("user-data", token)
    if user_data:
        print(f"\033[1;33m[I]\033[0m Retrieved user data: {user_data} \033[1;33m(Informational)\033[0m")
    else:
        print("\033[1;32m[+]\033[0m No user data available \033[1;32m(OK)\033[0m")

# Function to collect network interface and VPC peering information
# This function gathers information about the instance's network interfaces, including associated VPCs and the AWS account ID.
# It is useful for identifying the network environment and potential peering relationships that the instance may be part of.
def peering_data(token):
    nic_dict = {}  # Dictionary to store MAC addresses and corresponding VPC IDs
    nic_list = get_instance_metadata("meta-data/network/interfaces/macs/", token)
    if nic_list:
        for mac in nic_list.splitlines():
            mac = mac.rstrip('/')
            vpc_id = get_instance_metadata(f"meta-data/network/interfaces/macs/{mac}/vpc-id/", token)
            nic_dict[mac] = vpc_id if vpc_id else "Not within a VPC"

    identity_document = get_instance_metadata("dynamic/instance-identity/document", token)
    account_id = "Unknown"
    if identity_document:
        for line in identity_document.splitlines():
            if "accountId" in line:
                account_id = line.split(":")[1].strip().strip('",')  # Extract the AWS account ID
                break

    print("Collected Peering Data:")
    for i, (mac, vpc_id) in enumerate(nic_dict.items()):
        print(f"\033[1;34m[*]\033[0m Interface #{i} MAC: {mac}, VPC ID: {vpc_id}, Account ID: {account_id}")

# Function to display subnet information associated with the instance's network interfaces
# This function retrieves and displays subnet CIDR blocks associated with each network interface.
# The information helps to understand the network segmentation and IP range allocated to the instance.
def vpc_subnets(token):
    nic_dict = {}  # Dictionary to store MAC addresses and corresponding VPC Subnets
    nic_list = get_instance_metadata("meta-data/network/interfaces/macs/", token)
    if nic_list:
        for mac in nic_list.splitlines():
            mac = mac.rstrip('/')
            vpc_subnet = get_instance_metadata(f"meta-data/network/interfaces/macs/{mac}/vpc-ipv4-cidr-blocks/", token)
            nic_dict[mac] = vpc_subnet if vpc_subnet else "Not within a VPC"

    print("Subnet Information Summary:")
    for i, (mac, vpc_subnet) in enumerate(nic_dict.items()):
        print(f"\033[1;34m[*]\033[0m Interface #{i} MAC: {mac}, VPC Subnet: {vpc_subnet}")

if __name__ == '__main__':
    # Argument parser configuration for command-line options
    # This section handles the input arguments provided by the user and maps them to the corresponding functions.
    parser = argparse.ArgumentParser(description="""
    EC2 Scanner for simple security findings
    by Michael Lawrence
    Scan an EC2 Instance for potential Security Findings
    """, formatter_class=argparse.RawTextHelpFormatter)

    parser.add_argument('-c', '--credentialscan', help='Scan to for AWS credentials', action='store_true')
    parser.add_argument('-i', '--iamrole', help='Identify if there are IAM roles on the instance', action='store_true')
    parser.add_argument('-u', '--userdata', help='Display Userdata', action='store_true')
    parser.add_argument('-p', '--peering', help='check for VPC peering connection', action='store_true')
    parser.add_argument('-v', '--vpcsubnets', help='List VPC subnets', action='store_true')

    args = parser.parse_args()

    print("EC2 Security Scanner")

    # Obtain the session token for IMDSv2
    # The token is essential for accessing instance metadata securely.
    token = get_token()
    if token:
        if not any(vars(args).values()):
            # If no specific command-line arguments are passed, perform all security checks by default
            credential_scan()
            role_detect(token)
            user_detect(token)
            peering_data(token)
            vpc_subnets(token)
        else:
            # Execute specific functions based on the user's command-line arguments
            if args.credentialscan:
                print("Initiating scan for AWS credentials in user directories...")
                credential_scan()
            if args.iamrole:
                print("Checking for IAM roles linked to this instance...")
                role_detect(token)
            if args.userdata:
                print("Extracting user data from this instance...")
                user_detect(token)
            if args.peering:
                peering_data(token)
            if args.vpcsubnets:
                vpc_subnets(token)

        # Log the completion time of the process for audit purposes
        print(f'Process completed at: {datetime.datetime.now():%H:%M:%S on %m-%d-%Y}')
    else:
        print("Unable to proceed without a valid IMDSv2 token.")
    
    sys.exit(0)
