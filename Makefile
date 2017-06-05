# Program: PROCERATO - Program Provenance Analysis
# Author: Duy KHUONG <khuong@eurecom.fr>

include setting.mk

.PHONY:clean clean-all

#all: $(FILES_INFO)
all: $(PROGRAMS_INFO) $(INTERNET_INFO)

$(APT_PKGNAMES): 
	@echo "[-] List up all packages are currently installed and managed by APT"
	@./apt_pkglist.sh > $@ 

$(APT_LST): $(APT_PKGNAMES)
	@echo "[-] List up all files that are installed by the packages that managed by APT"
	@./apt_files_list.sh $< > $@

$(ALL_FILES_LST):
	@echo "[-] List up all files inside $(SCAN_DIRS) directories"
	@./all_files_list.sh $(SCAN_DIRS) "$(SCAN_TYPES)" > $@

$(APT_SO_LST): $(APT_LST) 
	@echo "[-] Filter only specific file types, $(SCAN_TYPES), which were installed by APT"
	@cat $< | egrep "\.($(SCAN_TYPES))" > $@

$(INTERESTING_LST): $(APT_SO_LST) $(ALL_FILES_LST)
	@echo "[-] List up only files that were not installed by APT"
	@sort $< $^ | uniq -u > $@

$(INTERESTING_DIRS_LST): $(INTERESTING_LST)
	@echo "[-] Extract programs list that not managed by APT"
	@./extract_package_dirs.sh $< > $@

$(PROGRAMS_INFO): $(INTERESTING_DIRS_LST) $(INTERESTING_LST) 
	@echo "[-] Extract information of each program"
	@echo "path,modified_datetime,modified_datetime_human_readable" > $@
	@cat $< | while read line; do ./extract_info2.sh $$line $(INTERESTING_LST); done >> $@

$(INTERNET_INFO): $(INTERESTING_DIRS_LST) $(INTERESTING_LST)
	@echo "[-] Get the latest information of each program from Internet"
	@echo "path,github_user,github_repo,latest_release,latest_commit,comitted_date" > $@
	@cat $< | while read line; do ./internet_info.sh $$line $(INTERESTING_LST); done >> $@

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
