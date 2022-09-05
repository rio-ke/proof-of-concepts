#!/usr/bin/env python3
import os
import aws_cdk as cdk
from stacks.glueStackCreation import glueStackCreation

app = cdk.App()
glueStackCreation(app, "glueStackCreation-dev")
glueStackCreation(app, "glueStackCreation-qa")
glueStackCreation(app, "glueStackCreation-prod")
app.synth()
