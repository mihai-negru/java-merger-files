#!/bin/bash

# Copyright (c) 2022 Mihai Negru <determinant289@gmail.com>
#
# This file is provided in the hope that it will
# be of use.  There is absolutely NO WARRANTY.
# Permission to copy, redistribute or otherwise
# use this file is hereby granted provided that
# the above copyright notice and this notice are
# left intact.

# Function to check if a java file has
# a "public static void main" method
#
# Input:
#   $1 - filename + java extenssion to check
#
# Return:
#   0 - file has a main function
#   1 - file has not a main function
check_main_func() {

    # Check if input file has a main method
    if cat $1 | grep -q "public static void main"; then
        return 0
    fi
    
    # Return false
    return 1
}

# Function to concatenate al the java files
# from a package to one file named "Main.java"
# if a java file contain a main method then
# the java file WILL NOT be added to the resulting
# Main.java file
#
# Input:
#   $1 - filename (without java extenssion) which will represent
#        the main class containing a "main" method
#        this fale has to contain a main method
#   $2 - filename (without java extenssion) which will represent
#        the resulting java file with all concatenated classes.
#        The program will create by default the "Main.java" file
#        with the "public class Main" within.
#
# Return:
#   VOID
concate_java_files_to_one() {

    # Find all java files except of $1 and $2 File
    JAVA_FILES=$(ls *.java | grep -v -E "$1.java|$2.java")

    # Copy content from $1 file to $2 file
    # and add a new line after the $2(Main) class
    cat $1.java > $2.java
    printf "\n" >> $2.java

    # Append all java classes/interfaces to $2.java
    for java_file in $JAVA_FILES; do
        if check_main_func $java_file; then
            printf "File $java_file has a main method\n"
        else
            cat $java_file >> $2.java
        fi
    done
   
    # Change the class name to $2(Main) class name
    sed -i "s/$1/$2/g" $2.java
}

# Function to get all imports from a java file,
# to sort and remove dublicates and to append to
# the beginning of the specified java file
#
# Input:
#   $1 - java file (with .java ext) to recalibrate the imports
#
# Return:
#   VOID
recalibrate_java_imports() {

    # Get all imports, sort and remove dublicates
    uniq_imports=$(cat $1 | grep -E '^import [a-zA-Z.]+;' | sort -k 2 -u)

    # Delete all packages and imports from the $1 file
    sed -i '/\(package\|import\)/d' $1

    # Append the imports to the beginning of the $1 file  
    echo "$uniq_imports" | cat - $1 > temp && mv temp $1
}

# Function to delete public keyword for every java classes
# or interfaces, however nested classes/interfaces WILL NOT
# be touched by the function, also the public fields/variables
# WILL NOT be modified
#
# Input:
#   $1 - java file (with .java ext) to delete the public keyword
#
# Return:
#   VOID
remove_class_public_key() {

    # A class can not be static by itself (should be nested)
    # A class cannot be final and abstract
    # An interface cannot contain abstract or final or static keyword
    # (should be nested)
    # So we DO NOT check those cases

    # Simple public class
    sed -i 's/^\(public\) \(class\)/\2/g' $1

    # Public + Final class
    sed -i 's/^\(final\) \(public\) \(class\)/\1 \3/g' $1
    sed -i 's/^\(public\) \(final\) \(class\)/\2 \3/g' $1

    # Public + Abstract class
    sed -i 's/^\(abstract\) \(public\) \(class\)/\1 \3/g' $1
    sed -i 's/^\(public\) \(abstract\) \(class\)/\2 \3/g' $1

    # Simple public interface
    sed -i 's/^\(public\) \(interface\)/\2/g' $1
}

# Function to concatenate all java files into one
# and to make it syntactically correct so you could
# execute it. You MUST provide a java file that has a
# main method (this class will be converted into the Main class)
# JUST the java files from the same package as the first java
# file will be concatenated to the Main.java file. If another
# file has a main function the class will be not appended to the
# Main.java file. The package keyword will be REMOVED
#
# Input:
#   $1 - filename (WITHOUT .java ext) representing the Main class
# Return:
#   VOID
merge_java_files() {

    # Check if input file exists in the package and
    # has no file extenssions at all
    if [[ $1 != "" ]] && [[ $1 != *"."* ]]; then

        # Check if input file has a main function
        if ! check_main_func $1.java; then
            printf "$1.java: file has no main method\n"
            exit 2
        fi
     
        # Main file to concatenate all the java files
        MAIN_FILE=Main
        MAIN_JAVA=Main.java

        # Append all files to the Main.java file
        concate_java_files_to_one $1 $MAIN_FILE

        # Remove all unecessary packages and imports
        # from Main.java file
        recalibrate_java_imports $MAIN_JAVA

        # Remove ALL public key from classes (also Main class)
        remove_class_public_key $MAIN_JAVA

        # Add public keyword to the Main class
        sed -i '/^class Main/ s/^/public /' $MAIN_JAVA

        # Remove trailing newline characters
        sed -i '/^$/{:a;N;s/\n$//;ta}' $MAIN_JAVA
    else
        printf "No input or wrong input given\n"
        exit 1
    fi
}

# Call function to merge all java files from
# current package (pwd) into Main.java files
merge_java_files $1
