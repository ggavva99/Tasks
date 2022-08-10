MSK Cluster:
      To create the Mskcluster through cft, we need To fallow these steps:
          1. we need to create vpc with subnets(routetables,internet gateway,natgateway) through cft in multiple  available zones
          2. By using vpc cft stack export values, we are creating the mskcluster

Requirements:
    1. Cloudformation script  need for vpc with subnet creation.
    2. Roles,capacity,plugins,Encryption Type,Authentication Type need for mskcluster creation
    3. cloudformation script need for mskcluster creation.
    4. shell script need for Run the vpc&mskcluster cloudformation template

Where to get:
 
     Via Github:
               Download the cloudformation code and shell script from this url "https://github.com/cjpcloud/mskrepo.git"
                  
Usage:
  1. we need to clone the mskrepo by using below command
      git clone https://github.com/cjpcloud/mskrepo.git
  2. Once clone the repo then we need the run the script.sh file
      sh script.sh

Note:     Whenever run the Shell script intially create the vpc with subnets(routable,internetgateway,natgateway with assosiation,stack outputs). 
    By using vpc cft stack export values, we are Impliment the mskcluster cft.

Outputs:
  VPC:
    Description: A reference to the created VPC
    Value: !Ref VPC
    Export:
      Name:
        Fn::Sub: "${AWS::StackName}-VPCID"  
Parameters:
   NetworkStackName:
    Description: Name of the base stack with all infra resources
    Type: String
    Default: vpc
  SecurityGroups:
          - 'Fn::ImportValue':
              'Fn::Sub': '${NetworkStackName}-SecurityGroupID'
   
