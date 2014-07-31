# csc notes

Notes on CSC hardware and software projects.

### generating html

If you want to make a pretty version of the notes, run the following commands.
You will need to have npm and grunt installed on your system.

   ```sh
   npm install
   grunt build
   ```

This will create a `build/` directory with the generated html files and
required assets. You can then start a local web server with the following
command `python -m SimpleHTTPServer`. You can view the site by opening
[localhost:8000/notes](http://localhost:8000/notes) in your browser.
