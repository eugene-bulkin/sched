module.exports = (grunt) ->

  grunt.initConfig {
    pkg: grunt.file.readJSON('package.json'),
    # monitoring
    concurrent: {
      dev: {
        tasks: ['nodemon', 'watch'],
        options: {
          logConcurrentOutput: true
        }
      }
    },
    nodemon: {
      dev: {
        options: {
          file: 'server.coffee',
          ignoredFiles: ['README.md', 'node_modules/**'],
          delayTime: 1,
          legacyWatch: true,
          env: {
            PORT: '3000'
          },
          cwd: __dirname
        }
      },
    },
    watch: {
      scripts: {
        files: 'src/js/*.coffee',
        tasks: ['coffeelint', 'coffee', 'shell:codo']
      },
      styles: {
        files: ['src/css/*.scss'],
        tasks: ['sass']
      },
      templates: {
        files: ['src/html/*.jade'],
        tasks: ['jade']
      }
    },
    # processing
    coffeelint: {
      app: ['src/*.coffee']
    },
    shell: {
      codo: {
        command: 'codo -n "sched" --title "sched documentation" --cautious src/js/'
      }
    },
    # compilation
    sass: {
      dist: {
        options: {
          style: 'expanded',
          sourcemap: true
        },
        files: {
          'app/build/style.css': 'src/css/style.scss'
        }
      }
    },
    coffee: {
      compileJoined: {
        options: {
          join: true,
          sourceMap: true
        },
        files: {
          'app/build/sched.js': 'src/js/*.coffee'
        }
      }
    },
    jade: {
      dist: {
        options: {
          pretty: true,
          doctype: '5'
        },
        files: [{
            expand: true,
            cwd: 'src/html/'
            src: ['*.jade', '!index.jade'],
            dest: 'app/build/partials',
            ext: '.html'
        },{
            expand: true,
            cwd: 'src/html/',
            src: 'index.jade',
            dest: 'app/',
            ext: '.html'
        }]
      }
    }
  }

  grunt.loadNpmTasks('grunt-nodemon')
  grunt.loadNpmTasks('grunt-concurrent')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-coffeelint')
  grunt.loadNpmTasks('grunt-contrib-sass')
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-jade')
  grunt.loadNpmTasks('grunt-shell')

  grunt.registerTask('compile', ['coffeelint', 'coffee','sass','jade', 'shell:codo'])
  grunt.registerTask('default', ['compile', 'concurrent'])