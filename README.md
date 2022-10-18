# **java-merger-files**
Bash Script to merge all java files into one **Main.java** file

## **Getting Started**

The script is written for Linux Systems, however you can
run the script under the **WSL** on Windows Systems or
under **Git Bash** terminal in the Windows OS

## **Giving execution rights for script**

In order to execute the script you must give execution rights

```BASH
    # Clone the repository
    git clone https://github.com/Matrix22/java-merger-files.git

    # Change dir into project
    cd java-merger-files

    # Give execution rights
    chmod u+x java_merger.sh
```

## **Installing the script**

If you want to make the script globally and to execute it anywhere
you should copy the script to `/usr/bin` folder (Just for Linux or WSL users)

**Make sure that you gave execution rights for script**

```BASH
    sudo cp java_merger.sh /usr/bin/java_merger
```

Now you can call the script from anywhere just as you would call **ls**, **cd** ... etc

```BASH
    java_merger <Input>
```

## **Using the script**

If you didn't install the script under `/usr/bin` folder, then you must
copy the script in the **java package** where you want to merge the files

If you installed the script then you just have to make sure that you are in
the package where you want to merge the files

### **Inputs and Options**

**java_merger** accepts **3** types of inputs and concatenates the files differently
based on the options. Based on your needs you can merge files differently

**Options:**

* (1) - No input needed for the java_merger. This option will generate an empty **Main.java** file with **NO MAIN CLASS** and other classes appended **WILL NOT** be public. If you have a Main.java file in your directory then it will be wiped out and the processing will occur. This option is good then you want to add all classes and **lambdaChecker** already has provided you a **Main Class**. Just classes with no main method will be added
the rest will be ignored.

* (2) (Main) - Input should be a **Main** class and there MUST exists a **Main.java** file containing a functional Main class. All the files will be appended after the Main Class. If **Main.java** File does not exist the execution will be canceled. This is good when you provide a Main Class and want other Java Classes to be appended on this file so you can post it on **lambdaChecker**. This option works just with **Main** Class. For this option you **MUST** not run the script for the second time will the Main method, because all the classes will be appended twice. If you want to call again this method, refactor your Main class at its initial state.

* (3) (OtherClassName) - Input should be a name of an existing java class which will became the new **MAIN** Class, if the class has no **main** method the process will be canceled and an exiting code will be returned. The Input class will be appended first and its name will be changed into the **Main** name (Policy of lambdaChecker) other classes will be appended and the code will be refactored so it can work

**Examples of running java_merger:**

(Option number one):

```BASH
    java_merger
    # Here will be printed a list of messages and warnings
```

After this command a Main.java file will be generated with all java files merged and without a Main Class

(Option number two):
```BASH
    # Be sure that you know what you are doing and
    # have provided a Main Java File
    java_merger Main
    # Here will be printed a list of messages and warnings
```

After this command the Main.java file will be populated with all java files merged and refactored.

(option number three):
```BASH
    # Must exist a class with a main method provided to java_merger
    java_merger AClassWithMainMeth
    # Here will be printed a list of messages and warnings
```

After this command a Main.java file will be created and **AClassWithMainMeth** will be translated into a **Main** Class (The class itself is not modifed, it is copied to Main.java and all the modifications take place in the Main.java). After changing class name all the java files will be appended and refactored.

>**NOTE:** Be aware of the warnings and error messages because they relate every action that is wrong and can break your Main.java. However **JAVA CLASSES** are not modified at all, first are copied to Main.java and then refractored. If you call the second option then just the Main.java file will be modified from its initial state.


A valid **main** method should look like this (respecting the Java Coding style standard):
```JAVA
    public static void main(["I do not care what is here"]) {
        // Your code here
    }
```



>**NOTE:** **java_merger** script is based on the fact that **YOUR** java code is written **CORRECT**
and follows a rigid **indentation** (nested blocks should not be on the same level as the parent block)

**Bad indentation example**:

```JAVA
    public class SomeClass {
    
    // Bad but java_merger accepts it
    private String field1;

    // Bad and will break the script
    public static class NestedClass {
        // ...Something
    }
    }
```

For the things not to break be sure you indent your code just the right way:

```JAVA
    public class SomeClass {
    
        // Perfect
        private String field1;

        // Perfect
        public static class NestedClass {
            // ...Something
        }
    }
```

## **Not installed the script**

If you havent installed the script then copy the **java_merger.sh** from the project folder
into the package folder of your java project and run as follows:

```BASH
    java_merger.sh AClassWithMainMeth # or any other options
```

Also you can rename the script name as you want (maybe to get rid of the .sh ext):

```BASH
    mv java_merger.sh java_merger
```

## **Good to know**

* The script will remove every **package** codeline because is irrelevant for the **lambda checker**
(In Intellij Idea you will get a error to add the package name).

* Every import will be inserted **ONCE**, so do not be scared about multiple imports.

* Between java classes is left just one **newline** character and the Main.java files
starts with the **Main** class

* The script works even for classes that contain **generics** or are extending a class or implementing another interfaces.

* The script will remove the public keyword also from the interfaces.

* The indentation of the blocks is inherited from parent files.

* Read the documentation and explore the options of the java_merger

* The java files WILL BE NOT modified in any way, they will be merged
in the Main.java and every edit will occur in Main file

## **Example**

Go in the `src/matrix22` folder and try to run the script:

```BASH
    cd src/matrix22/

    java_merger
    <Warning>: No file provided, Main.java will not contain a main method
    <Run>: Empty the Main.java
    <Warning>: JobMarket.java has a main method, ignoring
    <Run>: Recalibrate Main.java package and imports
    <Run>: Remove public key from java classes
    <Run>: Remove unnecessary newlines
    <Finish>: Java Merger finished execution successfully
```

After running **java_merger** without any input you will get a **Main.java** file which
will contain every Java Class from current working directory and **WILL NOT HAVE A MAIN CLASS**

```BASH
    cd src/matrix22/

    java_merger JobMarket
    <Run>: Creating/Empty Main.java
    <Run>: Generating Main.java
    <Run>: Recalibrate Main.java package and imports
    <Run>: Remove public key from java classes
    <Run>: Remove unnecessary newlines
    <Finish>: Java Merger finished execution successfully
```

After running **java_merger JobMarket** you will get a **Main.java** where **JobMarket** Class will be translated into Main Class and the rest of Java Files that do not contain a main class will be appended and refactored.

For this option you have to provide a **Main.java** File with a working Main class

```JAVA
    package matrix22;

    public class Main {
        public static void main(String[] args) {
            // Your code goes here
        }
    }
```

Then run the following command (**Works just for Main Java File**)

```BASH
    cd src/matrix22/

    java_merger Main
    <Warning>: Main.java provided as input, do not run "java_merger Main twice"
    <Run>: Generating Main.java
    <Warning>: JobMarket.java has a main method, ignoring
    <Run>: Recalibrate Main.java package and imports
    <Run>: Remove public key from java classes
    <Run>: Remove unnecessary newlines
    <Finish>: Java Merger finished execution successfully
```

After running **java_merger Main** all Java Files that do not contain a main method will be appended and refactored in the Main.java class so you could run it on lambdaChecker
