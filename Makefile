# Program: PROCERATO - Program Provenance Analysis
# Author: Duy KHUONG <khuong@eurecom.fr>

APT_PKGNAMES=apt-pkgnames.list
APT_LST=apt.list
APT_SO_LST=apt_sorted.list
ALL_FILES_LST=all_files.list
INTERESTING_LST=interesting.list
FILES_INFO=files_info.dat

SCAN_TYPES=(so|sh|py|pyc|rb|jar|apk)
SCAN_DIRS="/usr/lib /usr/share"

.PHONY:clean clean-all

all: $(FILES_INFO)

$(APT_PKGNAMES): 
	@echo "[-] List up all packages are currently installed and managed by APT"
	@./apt_pkglist.sh > $@ 

$(APT_LST): $(APT_PKGNAMES)
	@echo "[-] List up all files that are installed by the packages that managed by APT"
	@./apt_files_list.sh $< > $@

$(ALL_FILES_LST):
	@echo "[-] List up all libraries (binaries) inside $(SCAN_DIRS) directories"
	@./all_files_list.sh $(SCAN_DIRS) > $@

$(APT_SO_LST): $(APT_LST) 
	@echo "[-] Filter only specific file types, $(SCAN_TYPES), which were installed by APT directory"
	@cat $< | egrep "\.$(SCAN_TYPES)" > $@

$(INTERESTING_LST): $(APT_SO_LST) $(ALL_FILES_LST)
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
