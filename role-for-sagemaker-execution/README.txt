Instructions below are needed to use this infrastructure-as-code.

[1] Ensure that the file terraform.tfvars contains the correct image_name 
    value. Make it short but meaningful.

    (e.g. "tf25", is short for tensorflow 2.5)

[2] Make sure that the codecommit files:
    ** filename: app-image-config-input.json
        - has "AppImageConfigName" set to "config-[image_name]" (from #1 above)
    ** filename: update-domain-input.json
        - has "AppImageConfigName" matching the same key in file app-image-config-input.json
        - has "ImageName" maching the string "smstudio-[image_name]" (from #1 above)

[2.A] Additional note: CodeCommit repository name will be the same name used in ECR repository.
    Taken from #1 above, it will be the prefix "smstudio-" followed by the defined image_name.

    (e.g. "tf25" => smstudio-tf25)

[3] If there is already an existing SageMaker Studio domain, make sure that the file:
    ** etc/environment-vars.yml with key "DOMAIN_ID" contains the correct 
        domain value of its "definition" key
    ** etc/environment-vars.yml with key "ACCOUNT_ID" contains the correct 
        AWS Account ID of its "definition" key

[4] If you need to add more AWS Managed Policies, add them to the file 
    etc/aws-managed-policies.yml file under the correct key (yaml file syntax).

[5] If applicable, change the value of "region" in the file variables.tf.