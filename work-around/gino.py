class demo():
    def __init__(self):
        self.print = self.print()

    def print(self):
        return "demo"

_demo = demo()

print(_demo.print)