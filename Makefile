.PHONY : chmod

chmod :
	find . -name '*.lua' | xargs chmod 644
	chmod 644 *.txt *.xml

