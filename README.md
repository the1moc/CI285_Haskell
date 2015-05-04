# CI285_Haskell Simple web server

Malcolm Campbell

********************************
The following websites were used when creating this project (specific URLs used when possible)

For the database - https://hackage.haskell.org/package/sqlite-simple-0.4.8.0/docs/Database-SQLite-Simple.html
                 - https://www.fpcomplete.com/school/starting-with-haskell/libraries-and-frameworks/persistent-db
                 
                 
For the server: - http://www.happstack.com/docs/crashcourse/index.html
                - https://hackage.haskell.org/package/happstack-server 
                - https://hackage.haskell.org/package/blaze-html

*******************************
I created the web app in this manner by interpreting the basic points of what the assignment required. Therefore I felt using forms to make POST and GET requests was the most straightforward and clean way. It is possible to input local data from the user end, input data in JSON format from an external website, and also perform several queries from the default page of the server. There are also options to delete specific rows, or to delete all data from the database at once, though these are more for testing purposes.

Similarly, matching each request with 'dir "/..."' was a clear and straightforward way of giving back different responses depending on which form the user had used.

If more was to be added, I think adding options for users to input specific requests on the database would be useful. For example, having a default form that gave them options for their statement (e.g. SELECT, INSERT, DELETE) and then their data/conditions. This would require having different levels of control to prevent misuse. 
********************************
BUILDING THE APPLICATION

PRE-REQUISITES
Ensure all modules are installed that are required for the project. These should/may include, but are not limited to:
happstack,
aeson,
HTTP-4000,
sqlite-simple,
blaze-html,
direct-sqlite

Any packages not named that are required will also need to be installed. One method of doing this is to use cabal with the commands 'cabal install (insert-package-here). Also ensure the .db file that is present with the haskell source files is in the same directory. 

1. In the terminal, cd to the directory containing the project .hs files. e.g. cd /files/are/here
2. Compile file 'Main.hs' using the command 'ghc --make Main.hs'.
3. To run the file, simply type ./Main and the server should run

Current data in the database is shown below:

12-03-1996 -- 3°C
12-03-1997 -- 13°C
12-03-1998 -- 19°C

*********************************
NOTES

I have added a delete functionality to the webserver to demonstrate adding external JSON data to the database. Therefore, if when adding JSON data from a website a second time, use the delete form to remove those dates and re-add them if required. If data is inputted that is already in the database, the page shall not load due to a non-unique constraint. If wanting to insert the information still, either remove the specific data OR delete all the data using the two forms at the bottom.

The functions that display all the temperatures, the max temperate and the minimum temperature all have an input text box that they do not require. Removing this input textbox causes the database to show historic data, and will only show new information upon restarting. Therefore I have left them in, even if they look out of place. 

The PDF submitted is old, but I am not able to change it. The issues highlighted about errors within certain functions that query the database have been resolved.
