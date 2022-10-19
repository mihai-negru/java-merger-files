#!/bin/bash

####################################################################
# Copyright (c) 2022 Mihai Negru <determinant289@gmail.com>        #
#                                                                  #
# This file is provided in the hope that it will                   #
# be of use.  There is absolutely NO WARRANTY.                     #
# Permission to copy, redistribute or otherwise                    #
# use this file is hereby granted provided that                    #
# the above copyright notice and this notice are                   #
# left intact.                                                     #
####################################################################

# Function to check if a java file has
# a "public static void main" method
#
# Input:
#   $1 - filename + java extenssion to check (.java)
#
# Return:
#   0 - file has a main function
#   1 - file has not a main function
check_main_func() {

    # Java File to check for main method
    local check_file="$1"

    # Check if input file has a main method
    if cat $check_file | grep -q "public static void main"; then

        # Return true
        return 0
    fi
    
    # Return false
    return 1
}

# Function to append all java files from current working
# directory (pwd) into the specified input file ($1)
# If function takes the second input then it will not
# be added in the resulting file ($1).
# If a Java File has a main method than the file will
# be ignored and will not be added in the specified
# file ($1) and the process will continue to next file
#
# Input:
#   $1 - Java File (with .java ext) where all the files will
#        be appended to
#   $2 - Java File (with .java ext) that the function will ignore
#        by default (needed when $1 == $2 as Java Files)
#
# Return:
#   VOID
append_java_files_to_one() {

    # Java Files from current working directory (pwd)
    local java_files

    # Java File to append to
    local append_file="$1"

    # Java File to ignore and not to add the code
    local ignore_file="$2"

    # Find all Java Files from current working directory
    if [[ "$#" == 1 ]]; then
        java_files=$(ls *.java | grep -v -E "$append_file")
    elif [[ "$#" == 2 ]]; then
        java_files=$(ls *.java | grep -v -E "$append_file|$ignore_file")
    else
        printf "<Error>: append_java_files: expected 1/2 classes, got $#\n"
        printf "<Error>: Java Merger finished execution unsuccessfully\n"
        exit 2
    fi

    # Append all Java Files to specified file
    for java_file in $java_files; do
        if check_main_func $java_file; then
            printf "<Warning>: $java_file will not be added, has a main method\n"
        else
            cat $java_file >> $append_file
            printf "\n" >> $append_file
        fi
    done
}

# Function to get all imports from a Java File,
# to sort and remove dublicates and to append to
# the beginning of the specified java file.
# Function will remove any trace of package from
# the Java File, because is not needed by lambdaChecker
#
# Input:
#   $1 - Java File (with .java ext) to recalibrate the imports
#        and to remove the package.
#
# Return:
#   VOID
recalibrate_java_imports() {

    # Java File to modify the imports
    local modify_file="$1"

    # Temporary Java File to append imports to the top of the file
    local temporar_file="temp.java"

    # Get all imports, sort and remove dublicates
    local uniq_imports=$(cat $modify_file | grep -E '^import [a-zA-Z.]+;' | sort -k 2 -u)

    # Delete all packages and imports from the Java File
    sed -i '/\(package\|import\)/d' $modify_file

    # Append the imports to the beginning of the Java File  
    printf "$uniq_imports\n" | cat - $modify_file > $temporar_file && mv $temporar_file $modify_file
}

# Function to delete "public" keyword from every java classes
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

    # Java File to remove uneccessary public keywords
    local modify_file="$1"

    # Simple Public Class
    sed -i 's/^\(public\) \(class\)/\2/g' $modify_file

    # Public + Final Class
    sed -i 's/^\(final\) \(public\) \(class\)/\1 \3/g' $modify_file
    sed -i 's/^\(public\) \(final\) \(class\)/\2 \3/g' $modify_file

    # Public + Abstract Class
    sed -i 's/^\(abstract\) \(public\) \(class\)/\1 \3/g' $modify_file
    sed -i 's/^\(public\) \(abstract\) \(class\)/\2 \3/g' $modify_file

    # Simple Public Interface
    sed -i 's/^\(public\) \(interface\)/\2/g' $modify_file
}

# Function to merge all Java Files into one
# and to make it syntactically correct so you could
# execute it. If the input is NULL("") then all the
# files that have a main function will not be merged.
# Generated Java File will not have a Main class or
# main method (casses when lambdaChecker provides a Main
# Class), if "main_file" exists it will be deleted.
# If the input is equal to "main_class" then all the
# files that have a main method will not be added
# and will be appended to "main_file" Java File.
# If the input is a name of a Java Class (MUST EXISTS
# in the current working directory) it will become the
# "main_class" and a "main_file" Java File will be generated
# (The initial input class will not be modified in any way)
# The rest of Java Files that do not contain a main method
# will be appended in the "main_file" Java File.
# 
#
# Input:
#   $1 - (1) Java Class (WITHOUT .java ext) or
#        (2) "main_class" or
#        (3) ""(NULL)
# Return:
#   Generates a Java File with or without a Main class
main_merge_java_files() {

    # Input class name (upper choices)
    local input_class="$1"
    local input_file="$1.java"

    # Generated File with all merged Java Files 
    local main_class="Main"
    local main_file="Main.java"

    # Main Execution Code
    if [[ $input_class == "" ]]; then
        printf "<Warning>: No file provided, $main_file will not contain a main method\n"
        printf "<Run>: Empty the $main_file\n"

        # Clear Main Java File
        cat /dev/null > $main_file

        printf "<Run>: Generate $main_file\n"

        # Append all classes to Main Java File
        append_java_files_to_one $main_file
    elif [[ -f $input_file ]]; then
        if [[ $input_class == $main_class ]]; then
            printf "<Warning>: $main_file provided as input, do not run \"java_merger Main\" twice\n"

            # Check if Main Java Class has a main method
            if ! check_main_func $main_file; then
                printf "<Error>: $input_file file has no main method\n"
                printf "<Error>: Java Merger finished execution unsuccessfully\n"
                exit 2
            fi

            printf "<Run>: Generate $main_file\n"

            # Append all classes to Main Java File
            append_java_files_to_one $main_file
        elif [[ $input_class != *"."* ]]; then

            # Check if Input Java Class has a main method
            if ! check_main_func $input_file; then
                printf "<Error>: $input_file file has no main method\n"
                printf "<Error>: Java Merger finished execution unsuccessfully\n"
                exit 2
            fi

            printf "<Run>: Create/Empty $main_file\n"

            # Overwrite Input Java Class to Main Java File
            # and change the Input Java Class name into the
            # Main Java Class
            cat $input_file > $main_file
            printf "\n" >> $main_file
            sed -i "s/$input_class/$main_class/g" $main_file

            printf "<Run>: Generate $main_file\n"

            # Append all classes to Main Java File
            append_java_files_to_one $main_file $input_file
        else
            printf "<Error>: Wrong class name $input_class\n"
            printf "<Error>: Java Merger finished execution unsuccessfully\n"
            exit 1
        fi
    else
        printf "<Error>: $input_file file does not exist\n"
        printf "<Error>: Java Merger finished execution unsuccessfully\n"
        exit 1
    fi

    # Move all imports to the top of the Main Java File,
    # remove dublicates from imports and remove package name
    printf "<Run>: Recalibrate $main_file package and imports\n"
    recalibrate_java_imports $main_file

    # Remove uneccessary public keywords from classes
    # or interfaces from Main Java File
    printf "<Run>: Remove public key from java classes\n"
    remove_class_public_key $main_file
    sed -i "/^class $main_class/ s/^/public /" $main_file

    # Make the code look beautiful by removing newlines
    # between the Java Classes.
    # Last newlines will not be removed
    printf "<Run>: Remove unnecessary newlines\n"
    sed -i '/^$/{:a;N;s/\n$//;ta}' $main_file

    # java_merger executed successfully
    printf "<Finish>: Java Merger finished execution successfully\n"
}

# Call function to merge all Java Files from
# current working directory (pwd)
# into specified Java File
main_merge_java_files $1