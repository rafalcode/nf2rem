# nf2rem
Standing for "New File TO REMote". THis is a shell script task, whereby a remote linux computer contacts a local Windows computer abotu a a certain folder and a possible new file in that folder.

# Problem description

1. Automatically check (daily) a specified folder on a local Windows machine to see if a new file has been added
2. If new file has been added automatically copy the new file from the local Windows machine to a folder on the remote Linux server
3. If new file has been added automatically send an Email to a specified address with the number of lines in the new file in the subject line
4. Add notes on downloading software/sharing folders if necessary.

# Problem orientation
The are four increasing grades of difficulty in the problem:
1) local folder check
2) remote linux check using ftp
3) Local Network Windows check using smbclient (very sinilar to ftp).
4) remote Windows check using smbclient

The approach adopted is to sole the easier problems first and build up from there.

The service capability of the local windows machine

# Cron-nature of script
As the script is run on a regular basis, it must be in the current user's crontab file. The shuld be a script to check whether these are in place.
The script for this is chkct.sh.

# new files
There are various ways of identifying new files in a folder. Normally we need a comparison: between an old file listing and a new one.
If we assume the file names are unique and we are not talking about an old file which has been newly modified, we can simply compare the old and new
file listing for any new filenames.

The script for this is is nf2chk.sh

So the remote server needs to keep a Past File Listing in a certain place. We will choose ~/crologs/nf2.lst for this.

# Rough work notes

* Some small configuration work on Windows machine may be necessary as they are not usually enabled by default for this sort of operation. In particular, a sharing folder must be designated. Its settings configuration must be revised so that security and network parameters do not shut out attempts by (even) an authorised remote server to access a certain folder.
* Smbclient from the samba suite of software is able to communicate with a windows machine, if all the above have been configured correctly. It is very similar in style to the old ftp clinet that most inux distributions have.
* Modern Windows machines (i.e. Windows 10) are able to run ftp services. These can be set up with Winkey+X and enable certain program features. Trivial FTP is avaiable, which means that the ftp script will work correctly.
* The test local Windows compute is a home Windows 10 computer. 
* smbtree is a useful Linux command for seeing windows shares on a local network
