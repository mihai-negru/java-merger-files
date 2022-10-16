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

### **Inputs**

**java_merger** script takes one java filename (without .java ext) for example:
* FirstClass (there has to exist FirstClass.java file)
* SecondClass (not SecondClass.java)

>**NOTE:** A bad example would be to send as input a class named Main
because all files will be merged into a **Main.java** file which will break some
functionality. However you can have a Main.java file in the package and it will be overwritten
with the merged java files, so my advidse is not to create a Main.java file

The input file has to contain a **main function** with the following signature:

```JAVA
    public static void main(["I do not care what is here"]) {
        // Your code here
    }
```

>**NOTE:** If the input file does not contain a main method then the script will exit with **EXITCODE: 2**

If the input file passed the checks that every **.java** file from the pakage (except of Input file and Main.java file)
will be inserted into the **Main.java** (if Main.java exists it will be overwritten and no warning will be shown).

If another java file contains a **main** method the following message will be prompted and the script
will continue its execution **WITHOUT** adding the java file into the **Main.java**:

```BASH
    java_merger FirstClass
    File SecondClass has a main method
    File AnotherClass has a main method
```

As a result the SecondClass and AnotherClass will be not added, and the rest java files from
the package will be concatenated to the **Main.java**.

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
    java_merger.sh AClassWithMainMeth
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

* You should provide one java file containing a **main** method

* The java files WILL BE NOT modified in any way, they will be merged
in the Mian.java and every edit will occur in Main file

## **Example**

Go in the `test/matrix22` folder and try to run the script:

```BASH
    cd test/matrix22/

    java_merge JobMarket
```

After running you should have one **Main.java** containing all the java files
concatenated and ready for **lambda checker**
