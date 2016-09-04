:: Sets the project name
SET projectName=conquer-online-5017

:: Removes cached dub application
if EXIST ".dub" (
	cd .dub
	rmdir build /q /s
	mkdir build
	cd ..
	erase %projectName%.exe
)

::	Compiles the executable
dub build