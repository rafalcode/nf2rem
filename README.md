![alt text](https://raw.githubusercontent.com/rafalcode/nf2rem/master/sche.png)

# nf2rem

Standing for "New File TO REMote", this is a shell script task, whereby a remote linux computer contacts a local Windows computer about a certain folder and a possible new file in that folder. THe remote shell script identifies files that are new in that folder, copies them to a (its) local folder and calculate the number of lines int he new files and sends an email to a certain email address with the subject line giving the number of lines in the new files.

# Problem description

1. Automatically check (daily) a specified folder on a local Windows machine to see if a new file has been added
2. If new file has been added automatically copy the new file from the local Windows machine to a folder on the remote Linux server
3. If new file has been added automatically send an Email to a specified address with the number of lines in the new file in the subject line
4. Add notes on downloading software/sharing folders if necessary.

# Problem orientation
The are three increasing grades of difficulty in the problem:
1. local test environment to simulate task problem
2. local-to-local new file checks
3. remote-local new file check (allowing for network permissions, FTP is most portable solution)

## Windows-Linux heterogeneity
The approach adopted is to solve the easier problems first and build up from there. The main challenge is step 3 as it's a heterogeneous network, i.e. Linux and WIndows. If Linux-to-linux, the rsync program could be used without any scripts at all. WinSCP is also a piece of software strikes a good balance between ease of use and security, allowing both remote Linux and local WIndows communicate and copy files using the SSH protocol.

## FTP and Windows
The FTP service capability of the local Windows machine is noted, though as this only refers to modern Windows machines, Failing this there is the option of filezilla server, which is a mature and widely used client and server and hich most versions of Windows can install. The proviso with FTP is that the network and firewall settings must allow it, often in the security enhanced TLS protocol and this is not often aviable by default. It certainly isn't in home LAN settings and in institutions is only available on request.

## Security concerns
Heightened security always introduces more operting complications which these script would have to be hardened for. For example, anonymous FTP, would have made thigns easier, but this was avoided here due to lack of security.

# File descriptions
* nf2cp.sh is the main script, if local computer is generating its own files and crontab is set up, only this script is required.
* nf2ssh.sh is a secondary solution for SSH-only networks characteristic of high security networks. SFTP is the transfer protocol used.
* cron.lines: the lines required in the user's crontab. This git repository must be cloned in ~/rafgh/nf2rem for these to work.
* chkct.sh this script will check the current crontab for the appropriate lines.
* nf2gen.sh this is a test envirnment file: generates new files in a certain directory

# Requirements and assumptions for remote server
* Xargs version with -I option available.
* cron logs for the operating user held in ~/crologs
* remote account password held in user-read-only file called p66.txt in ~/crologs
* the git repository of scripts is held in folder "nf2rem" found in ~/rafgh folder (clone with git clone https://github.com/rafalcode/nf2rem)

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
* Modern Windows machines (i.e. Windows 10) are able to run ftp services. These can be set up with:
Winkey+X | Programs | PRograms and features
and iby enabling TFTP and IIS FTP services.
* The test local Windows compute is a home Windows 10 computer. 
* smbtree is a useful Linux command for seeing windows shares on a local network
