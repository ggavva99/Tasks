aws cloudformation create-stack --stack-name vpc --template-body file://vpc.yaml
sleep 600
aws cloudformation create-stack --stack-name mskcluster --template-body file://mskcluster.yaml
