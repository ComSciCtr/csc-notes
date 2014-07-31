module.exports = (grunt) ->
   grunt.initConfig
      copy:
         css:
            files:
               'build/css/bootstrap.min.css': 'assets/css/bootstrap.min.css'

         fonts:
            files: [
               expand: true
               src: ['assets/fonts/*']
               dest: 'build/fonts/'
               flatten: true
            ]

      markdown:
         compile:
            files: [
               expand: true
               src:  ['notes/**/*.md']
               dest: 'build/'
               ext:  '.html'
            ]

         options:
            template: 'views/layout.jst'
            markdownOptions:
               gfm: true
               highlight: 'manual'

      watch:
         markdown:
            files: ['notes/**/*.md', 'views/layout.jst']
            tasks: ['markdown']

   grunt.loadNpmTasks 'grunt-contrib-copy'
   grunt.loadNpmTasks 'grunt-markdown'
   grunt.loadNpmTasks 'grunt-contrib-watch'

   grunt.registerTask 'build', ['copy', 'markdown']
   grunt.registerTask 'default', 'build'
