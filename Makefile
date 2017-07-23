# Program: PROCERATO - Program Provenance Analysis
# Author: Duy KHUONG <khuong@eurecom.fr>

include setting.mk

.PHONY:clean clean-all

all: $(GITHUB_TOKEN) $(REPORT)

$(GITHUB_TOKEN):
	@echo "[$@] Please enter your GitHub token key:"
	@read token_key; echo $${token_key} > $@

$(APT_PKGNAMES):
	@echo "[$@] List up all packages managed by APT"
	@./apt_pkglist.sh $@ 2>$(ERR_LOG) 3>$(DEBUG_LOG)
	@echo -ne "					"; echo -n "  Count: "
	@wc -l $@ | awk '{print $$1}'

$(PIP_PKGNAMES):
	@echo "[$@] List up all packages managed by PIP"
	@-pip list --format=legacy 2>>/dev/null | awk '{print $$1}' > $@ 2>>$(ERR_LOG)
	@echo -ne "					"; echo -n "  Count: "
	@wc -l $@ | awk '{print $$1}'

$(APT_LST): $(APT_PKGNAMES)
	@echo "[$@] List up all files managed by APT"
	@./apt_files_list.sh $< $@ 2>>$(ERR_LOG)
	@echo -ne "					"; echo -n "  Count: "
	@wc -l $@ | awk '{print $$1}'

$(PIP_LST): $(PIP_PKGNAMES)
	@echo "[$@] List up all files managed by PIP"
	@-./pip_files_list.sh $< $@ 2>>$(ERR_LOG)
	@echo -ne "					"; echo -n "  Count: "
	@wc -l $@ | awk '{print $$1}'

$(ALL_FILES_LST):
	@echo "[$@] List up all files inside $(SCAN_DIRS) directories"
	@./all_files_list.sh $(SCAN_DIRS) "$(SCAN_TYPES)" > $@ 2>>$(ERR_LOG)
	@echo -ne "					"; echo -n "  Count: "
	@wc -l $@ | awk '{print $$1}'

$(APT_SO_LST): $(APT_LST)
	@echo "[$@] Filter only specific file types, $(SCAN_TYPES), which were installed by APT"
	@cat $< | grep -E "\.($(SCAN_TYPES))" > $@ 2>>$(ERR_LOG)
	@echo -ne "					"; echo -n "  Count: "
	@wc -l $@ | awk '{print $$1}'

$(PIP_SO_LST): $(PIP_LST)
	@echo "[$@] Filter only specific file types, $(SCAN_TYPES), which were installed by PIP"
	@-cat $< | grep -E "\.($(SCAN_TYPES))" > $@ 2>>$(ERR_LOG)
	@echo -ne "					"; echo -n "  Count: "
	@wc -l $@ | awk '{print $$1}'

$(INTERESTING_LST): $(APT_SO_LST) $(PIP_SO_LST) $(ALL_FILES_LST)
	@echo "[$@] List up only files that are not managed by APT or PIP"
	@sed -n 's/.py$$/.pyc/p' $(APT_SO_LST) > tmp
	@sed -n 's/.py$$/.pyc/p' $(PIP_SO_LST) > tmp2
	@sort $< $^ $(word 2,$^) tmp tmp tmp2 tmp2 | uniq -u > $@ 2>>$(ERR_LOG)
	@echo -ne "					"; echo -n "  Count: "
	@wc -l $@ | awk '{print $$1}'

$(INTERESTING_DIRS_LST): $(INTERESTING_LST)
	@echo "[$@] Extract programs list that not managed by APT"
	@./extract_package_dirs.sh $< tmp 2>>$(ERR_LOG)
	@cat tmp | while read line; do cnt=$$(grep "$$line" $(APT_SO_LST) | wc -l); if [ $$cnt -gt 0 ]; then echo $$line; fi; done > tmp2
	@sort tmp tmp2 | uniq -u > $@ 2>>$(ERR_LOG)
	@echo -ne "					"; echo -n "  Count: "
	@wc -l $@ | awk '{print $$1}'

$(PROGRAMS_INFO): $(INTERESTING_DIRS_LST)
	@echo "[$@] Extract information of each program"
	@echo "path,modified_date" > $@
	@./program_info_batch.sh $< $@ 2>>$(ERR_LOG)
	@echo -ne "					"; echo -n "  Count: "
	@wc -l $@ | awk '{print $$1}'

$(INTERNET_INFO): $(INTERESTING_DIRS_LST) $(INTERESTING_LST) $(GITHUB_TOKEN)
	@echo "[$@] Get the latest information of each program from Internet"
	@echo "path,github_user,github_repo,latest_release,release_date,latest_commit,committed_date" > $@
	@./internet_info_batch.sh $< $(INTERESTING_LST) $@ 2>>$(ERR_LOG) 3>>$(DEBUG_LOG)
	@echo -ne "					"; echo -n "  Count: "
	@wc -l $@ | awk '{print $$1}'

$(FILES_INFO): $(INTERESTING_LST)
	@echo "[$@] Extract information of each interesting file"
	@echo "file_path,MD5sum,Build-ID,Size(bytes),ModifiedTime,ModifiedTime(HumanReadable)" > $@
	@cat $< | while read line; do ./extract_info.sh $$line; done >> $@ 2>>$(ERR_LOG)
	@echo -ne "					"; echo -n "  Count: "
	@wc -l $@ | awk '{print $$1}'

$(REPORT): $(INTERNET_INFO) $(PROGRAMS_INFO)
	@echo "[$@] Generate final report"
	@./report.py $^ > $@ 2>>$(ERR_LOG)
	@grep -E --color '^|N ' $@ 
clean:
	rm -f *.dat

clean-all: clean
	rm -f *.list *.log
