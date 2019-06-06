.PHONY: install


install: ${HOME}/.zshrc 


${HOME}/.zshrc:
	ln -s ${CURDIR}/zshrc ${HOME}/.zshrc
