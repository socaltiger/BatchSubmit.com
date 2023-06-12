class Animal():

    def __init__(self, name):
        self.name = name

    def saySomething(self):
        print ("I am " + self.name)

class Dog(Animal):
    
    def saySomething(self):
       print ("I am " + self.name + ", and I can bark")

dog = Dog("Chiwawa")

dog.saySomething()  