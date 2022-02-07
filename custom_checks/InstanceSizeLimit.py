import re
from checkov.common.models.enums import CheckResult, CheckCategories
from checkov.terraform.checks.resource.base_resource_check import BaseResourceCheck


class InstanceSizeLimit(BaseResourceCheck):
    def __init__(self):
        name = "Selected Instance size not allowed."
        id = "CUSTOM_AWS_2"
        supported_resources = ['aws_instance']
        categories = [CheckCategories.GENERAL_SECURITY]
        super().__init__(name=name, id=id, categories=categories, supported_resources=supported_resources)

    def scan_resource_conf(self, conf):
        instance = conf["instance_type"][0]
        if re.match('^r6', instance):
                return CheckResult.FAILED
        return CheckResult.PASSED
        
check = InstanceSizeLimit()
