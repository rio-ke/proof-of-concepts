#!/usr/bin/env python3
import os

import aws_cdk as cdk

from stacks.stacks_stack import StacksStack


app = cdk.App()
StacksStack(app, "StacksStack")
app.synth()
