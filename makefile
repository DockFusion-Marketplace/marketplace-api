.PHONY: add-submodule

ifeq ($(OS),Windows_NT)
	ifneq ($(strip $(filter %sh,$(basename $(realpath $(SHELL))))),)
		POSIXSHELL := 1
	else
		POSIXSHELL :=
	endif
else
	# not on windows:
	POSIXSHELL := 1
endif

ifneq ($(POSIXSHELL),)
	CMDSEP := ;
	PSEP := /
	CPF := cp -f
	CLR := clear
	# more variables for commands you need
else
	CMDSEP := &
	PSEP := \\
	CPF := copy /y
	CLR := cls
	# more variables for commands you need
endif

GOALS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
ARGUMENTS := $(if $(args),$(args)$(if $(GOALS), ,),)$(GOALS)

add-submodule:
	@git submodule add https://github.com/DockFusion-Marketplace/$(ARGUMENTS).git marketplace/$(ARGUMENTS)

remove-submodule:
	-@git add .gitmodules
	-@git config -f .gitmodules --remove-section submodule.marketplace/$(ARGUMENTS)
	-@git add .gitmodules
	-@git rm --cached marketplace/$(ARGUMENTS)
	-@sed -i.bak "/\[submodule \"marketplace\/$(ARGUMENTS)\"\]/,/^\[.*\]/ {/^\[.*\]/!d}" .git/config
	-@rm -rf ./marketplace/$(ARGUMENTS)
	-@rm -rf ./.git/modules/marketplace/$(ARGUMENTS)