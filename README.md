# MSc Dissertation - University of Sunderland

## Project Title
The Impact of Cyber Attacks on Cloud Security and Data Privacy (A Practical Analysis)

## Overview
This dissertation aims to conduct a comprehensive analysis of major privacy and data security threats faced by organizations, understand the motivations and impact of these attacks, and evaluate defensive strategies to mitigate risks.

### Objectives
- **Literature Review**: Review existing literature on privacy and data security breaches.
- **Attack Classification**: Classify and analyze different types of attacks.
- **Motivation Analysis**: Examine the diverse motivations driving threat actors.
- **Impact Assessment**: Assess the impacts of data breaches on organizations.
- **Defense Evaluation**: Evaluate technological solutions and policy-based defenses.
- **Risk Assessment Framework**: Develop a framework to assess and mitigate risks.
- **Recommendations**: Provide actionable recommendations for organizations.

### Schedule and Deliverables
- **D1.1 Annotated Bibliography**
- **D1.2 Literature Review Draft**
- **D2.1 Methodology Section Draft**
- **D3.1 Attack Taxonomy**
- **D3.2 Threat Actor Profiles**
- **D3.3 Impact Analysis**
- **D3.4 Defense Evaluation**
- **D4.1 Complete Draft**
- **D4.2 Final Thesis**

## AWS Attack Demonstration

### Objective
To demonstrate a practical attack on AWS infrastructure, highlighting vulnerabilities and showing how such attacks can be mitigated.

### Setup
1. **AWS Account**: Ensure you have access to an AWS account with sufficient permissions.
2. **EC2 Instance**: Launch an EC2 instance that will act as the target for the attack.
3. **Security Groups**: Configure security groups to allow necessary traffic (e.g., SSH, HTTP).

### Steps
1. **Reconnaissance**
   - Gather information about the target EC2 instance.
   - Identify open ports and services.

2. **Exploitation**
   - Use a known vulnerability to gain unauthorized access.
   - Example: Exploit a misconfigured S3 bucket to obtain sensitive data.

3. **Post-Exploitation**
   - Escalate privileges within the compromised instance.
   - Maintain access by creating a backdoor.

4. **Mitigation**
   - Implement IAM policies to restrict access.
   - Enable logging and monitoring to detect suspicious activities.
   - Regularly update and patch instances to fix vulnerabilities.


### Tools Used
- **Nmap**: For network scanning and reconnaissance.
- **Metasploit**: For exploitation of vulnerabilities.
- **AWS CLI**: For interacting with AWS services.

### Results
- Demonstrated the potential impact of exploiting AWS infrastructure.
- Highlighted the importance of proper configuration and continuous monitoring.

### Recommendations
- **Access Control**: Implement strict IAM policies and multi-factor authentication.
- **Monitoring**: Use AWS CloudTrail and CloudWatch for monitoring and logging activities.
- **Regular Audits**: Conduct regular security audits and vulnerability assessments.

## Conclusion
The practical AWS attack demonstration provided insights into the vulnerabilities within cloud environments and emphasized the need for robust security measures. The overall project aims to offer comprehensive recommendations for enhancing cloud security and protecting data privacy.
