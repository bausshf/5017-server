:: Sets the project name
SET projectNameAuth=conquer-online-5017-auth
SET projectNameWorld=conquer-online-5017-world

:: Removes cached dub application
if EXIST ".dub" (
	cd .dub
	rmdir build /q /s
	mkdir build
	cd ..
	erase %projectNameAuth%.exe
	erase %projectNameWorld%.exe
)

::	Compiles the executable
call dub build --config=auth
call dub build --config=world
