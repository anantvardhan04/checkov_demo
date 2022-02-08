from checkov.common.models.enums import CheckResult, CheckCategories
from checkov.terraform.checks.resource.base_resource_check import BaseResourceCheck


class TagIsPresent(BaseResourceCheck):
    def __init__(self):
        name = "Ensure 'TechOwnerEmail' tag is present in Terraform ALB configuration"
        id = "CUSTOM_AWS_1"
        supported_resources = ['aws_alb']
        categories = [CheckCategories.GENERAL_SECURITY]
        super().__init__(name=name, id=id, categories=categories, supported_resources=supported_resources)

    def scan_resource_conf(self, conf):
        if 'TechOwnerEmail' in  conf["tags"][0]:
                return CheckResult.PASSED
        return CheckResult.FAILED

check = TagIsPresent()
