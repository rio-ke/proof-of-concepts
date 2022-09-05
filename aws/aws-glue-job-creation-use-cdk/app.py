#!/usr/bin/env python3
import os
import aws_cdk as cdk
from stacks.glueStackCreation import glueStackCreation

app = cdk.App()
glueStackCreation(app, "glueStackCreation")
app.synth()
