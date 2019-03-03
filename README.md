# ACDC Toolkit

For any remark and/or if you noticed a mistake please contact me.

# For the ACDC-Team:
To correct a submission one should use the scripts public.sh through run.sh in
order. Or use correct.sh. Another solution is to use nunit_correct.sh.

## crun.sh
(__C__orrection __RUN__.sh)

Requires 3 argument: Path to the submissions folder, Solution name and path to
the NUnit ".cs" test file.

This script will automatically install NUnit(v. 3.11.0) nuget and mono via apt
and extract nunit.framework.dll needed to compile the tests. Then for every
student in the submission folder. the script will compile the project and run
the tests.

#### BEFORE RUNING THE TESTS
You should install all the packet dependencies listed in requirements.txt.

Also, if your practical needs a specific dll (for example System.Drawing.dll to
manipulate images) then specify the dll in the REFERENCES variable of the
script (At the beginning of the script)

#### RUNNING THE TESTS
To run the test you should put call the script with these arguments in the
following order:
- Submission folder (Folder containing the students submission
(if you cloned the repository using pull.sh, then the folder should be named
csharp-tp__X__ ))
- Solution Name ("Conquer", "TinyMarkovChain", ...)
- NUnit Unit test file (The test file provided by the subject maintainer)

Example: ./crun.sh csharp-tp8/ Conquer ConquerTest.cs

Note: Apparently many students don't know how to make a correct submission
(bad solution name, bad architecture...) unfortunately you'll have to fix that
by hand :-[ .

One may change the CSC (C Sharp Compiler), EDITOR (default: vim), and RUNNER
variables of the script as they please.

### WHILE RUNNING THE SCRIPT
If a solution doesn't compile (which will happen more often than not) you can
edit the *.cs file by hand or use __e__ to edit the files in the current window
then compile the files again using __c__ and launch the runner with __r__ (try
__h__ to have a list of all commands and play with it).
If the architecture is not correct (use __tree__ to check) then you'll have
to fix it in another terminal. Once done you need to update the variables
(__next__ then __previous__ or __jump__ to the current student index
(use __info__ or __list__))

Remarks:
- \t is not yet supported for multiple argument commands.
- You can put i3's focus_on_window_activation to urgent instead of smart to
disable the autofocus when TestCentric's window opens.

## public.sh
Requires 1 argument: Path to the submissions folder.
Replaces every "private" or "protected" string by "public". This change is not
applied in bin, obj or Properties directories.

## comment_remover.sh
Requires 1 argument: Path to the submissions folder.
As the name implies, This scripts removes all the comments in the comments
(// and /* */ comment styles) in .cs files of the submissions folder excluding
bin, obj, and Properties directories

## fun_exist.sh
Requires 1 argument: Path to the submissions folder.
Checks for every student if the function in the file fun_list.txt (Can be
changed in the script) have been implemented.

## replace_main.sh
Requires 1 argument: Path to the submissions folder.
This script renames the original Main function by Old_Main and adds a custom
Main function (Default name is main_swap.cs, this can be changed by opening the
scritp). If the Main has already been replaced, nothing is done.

## compile.sh
Requires 1 argument: Path to the submissions folder.
Compiles every projects in the submissions folder with mcs. The files to be
compiled are in the  SRC_FILES variable (by default it only contains
Program.cs) and the output file name is in the EXEC_NAME variable (out.exe by
default).

## run.sh
Requires 1 argument: Path to the submissions folder.
Run every executable created by compile.sh. The EXEC_NAME variable should be
the same as the one in compile.sh. After each run the script waits for the user
to press Enter.

## correct.sh
Requires 1 argument: Path to the submissions folder.
Run (in this order) the public.sh, replace_main.sh, compile.sh & run.sh scripts

## add_nunit.sh
Not done yet
Adds nunit to every submission.

## nunit_install.sh
Not done yet
Installs NUnit

## one_for_all.sh
Not done yet

## pull.sh
Pull/Clone every submission from a given file.

## unzip.sh
Unzips every zip in the current directory.

## zipit.sh
Requires 1 argument: Path to the submissions folder.
Takes a directory, deletes all the bin/ and obj/ folder then zips the directory.
(Change the default name of the zip in the get_zip_name() function).

# Contact
william.lin@epita.fr


