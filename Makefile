.PHONY : chmod put

chmod :
	find . -name '*.lua' | xargs chmod 644
	chmod 644 *.txt *.xml

put:
	#git commit -am auto
	cp -f ./Libs/LibLazyCrafting/* /Volumes/Elder\ Scrolls\ Online/live/AddOns/DolgubonsLazyWritCreator/Libs/LibLazyCrafting/


