# Program: PROCERATO - Program Provenance Analysis
# Author: Duy KHUONG <khuong@eurecom.fr>

APT_PKGNAMES=apt-pkgnames.list
APT_LST=apt.list
APT_SO_LST=apt_so.list
USR_LIB_LST=usr_lib.list
INTERESTING_LST=interesting.list
FILES_INFO=files_info.dat

.PHONY:clean clean-all

all: $(FILES_INFO)

$(APT_PKGNAMES): 
	@echo "[-] List up all packages are currently installed and managed by APT"
	@./apt_list.sh > $@ 

$(APT_LST): $(APT_PKGNAMES)
	@echo "[-] List up all files that are installed by packages managed by APT"
	@./files_list.sh $< > $@

$(USR_LIB_LST):
	@echo "[-] List up all libraries (binaries) inside /usr/lib directory"
	@./usr_lib_list.sh > $@

$(APT_SO_LST): $(APT_LST) 
	@echo "[-] Filter only files .so which were installed by APT in usr/lib directory"
	@cat $< | grep "\.so" > $@

$(INTERESTING_LST): $(APT_SO_LST) $(USR_LIB_LST)
	@echo "[-] List up only files that were not installed by APT"
	@sort $< $^ | uniq -u > $@

$(FILES_INFO): $(INTERESTING_LST)
	@echo "[-] Extract information of each interesting file"
	@echo "file_path,MD5sum,Build-ID,Size(bytes),ModifiedTime,ModifiedTime(HumanReadable)" > $@
	@cat $< | while read line; do ./extract_info.sh $$line; done >> $@

clean: 
	@echo "Clean"
	@rm -f $(FILES_INFO)

clean-all: clean
	@echo "Clean all."
	@rm -f *.list *.dat
