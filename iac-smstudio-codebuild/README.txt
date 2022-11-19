Instructions below are needed to use this infrastructure-as-code.

To implement, execute: terraform plan | terraform apply

[1] Renamed to terraform.tfvars-ask-instead to ask for the value of image_name variable.
    Change the extension back to .tfvars to revert.

    Ensure that the file terraform.tfvars contains the correct image_name 
    value. Make it short but meaningful. Lowercase only.

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
    ** etc/environment-vars.yml with key "IMAGE_NAME" contains the correct 
        image_name of its "definition" key (this is the full image name with prefix)

    (e.g. for "tf25", the IMAGE_NAME should be "smstudio-tf25")


[4] If you need to add more AWS Managed Policies, add them to the file 
    etc/aws-managed-policies.yml file under the correct key (yaml file syntax).


[5] If applicable, change the value of "region" in the file variables.tf.
