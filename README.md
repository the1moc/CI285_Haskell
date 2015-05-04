# CI285_Haskell
Simple web server
Malcolm Campbell
********************************
The following websites were used when creating this project (specific URLs used when possible)

For the database - https://hackage.haskell.org/package/sqlite-simple-0.4.8.0/docs/Database-SQLite-Simple.html
                 - https://www.fpcomplete.com/school/starting-with-haskell/libraries-and-frameworks/persistent-db
                 
                 
For the server: - http://www.happstack.com/docs/crashcourse/index.html
                - https://hackage.haskell.org/package/happstack-server 
                - https://hackage.haskell.org/package/blaze-html

********************************
BUILDING THE APPLICATION

PRE-REQUISITES
Ensure all modules are installed that are required for the project. These should/may include, but are not limited to:
happstack
aeson
HTTP-4000
sqlite-simple
blaze-html
direct-sqlite

Any packages not named that are required will also need to be installed. One method of doing this is to use cabal with the commands 'cabal install (insert-package-here). Also ensure the .db file that is present with the haskell source files is in the same directory. 

1. In the terminal, cd to the directory containing the project .hs files. e.g. cd /files/are/here
2. Compile file 'Main.hs' using the command 'ghc --make Main.hs'.
3. To run the file, simply type ./Main and the server should run

*********************************
NOTES
When a duplicate date is added to the database, there will be a unique constraint error and the page simply shall not load. This error will be shown in the terminal where the server is running. Simply going back to the previous page will allow you to try re-entering data. 

I have added a delete functionality to the webserver to demonstrate adding external JSON data to the database. Therefore, if when adding JSON data from a website a second time, use the delete form to remove those dates and re-add them if required.

The show all function of the form sometimes does not update once a new temperature has been added, though all other functions do. To have this correctly show recently added data, the server must be restarted. 

*************************************
ISSUES
When new data is inserted, the functions to display (all, the max, the mix) temperatures sometimes do now show the uddated information. However when querying the database for the new data, the results appear confirming that the data has been added.

Once the server is restarted, these functions show previously inserted data.
