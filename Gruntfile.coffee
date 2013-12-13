module.exports = (grunt) ->

  grunt.initConfig {
    pkg: grunt.file.readJSON('package.json'),
    # monitoring
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
      production: {
        options: {
          file: 'server.coffee',
          ignoredFiles: ['README.md', 'node_modules/**'],
          delayTime: 1,
          legacyWatch: true,
          env: {
            PORT: '3001'
          },
          cwd: __dirname
        }
      }
    },
    watch: {
      scripts: {
        files: 'src/js/*.coffee',
        tasks: ['coffeelint', 'coffee', 'shell:codo']
      },
      routes: {
        files: 'routes/*.coffee',
        tasks: ['coffeelint:routes', 'coffee:routes']
      }
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
      app: ['src/*.coffee'],
      routes: ['routes/*.coffee']
    },
    autoprefixer: {
      styles: {
        src: 'app/build/style.css',
        dest: 'app/build/style.css'
      }
    },
    csso: {
      compress: {
        options: {
          report: 'gzip'
        },
        files: {
          'app/build/style.css': ['app/build/style.css']
        }
      }
    }
    shell: {
      # There does not as yet exist a good grunt-codo plugin
      codo: {
        command: 'codo -n "sched" --title "sched documentation" --cautious src/js/'
      },
      # For some reason, JS files are generated in the source folder despite them
      # supposedly being removed at some point, so we remove them manually
      removeJS: {
        command: 'rm src/js/*.js'
      }
    },
    ngmin: {
      script: {
        src: ['app/build/sched.js'],
        dest: 'app/build/sched.js'
      }
    },
    uglify: {
      script: {
        files: {
          'app/build/sched.js': ['app/build/sched.js']
        },
        sourceMapIn: 'app/build/sched.js.map',
        options: {
          mangle: false
        }
      }
    }
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
      },
      routes: {
        expand: true,
        flatten: true,
        cwd: 'routes/',
        src: ['*.coffee'],
        dest: 'routes/',
        ext: '.js'
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
  grunt.loadNpmTasks('grunt-ngmin')
  grunt.loadNpmTasks('grunt-contrib-uglify')
  grunt.loadNpmTasks('grunt-bg-shell')
  grunt.loadNpmTasks('grunt-autoprefixer')
  grunt.loadNpmTasks('grunt-csso')

  grunt.registerTask('compile', (args...) ->
    tasks = []
    prod = 'production' in args
    msg = "BUILDING FOR #{if prod then 'PRODUCTION' else 'DEVELOPMENT'}"
    spaces = (" " for i in [0..7]).join('')
    equals = ("=" for i in [1..(msg.length + 2 * spaces.length)]).join('')
    console.log "#{equals}\n#{spaces}#{msg}#{spaces}\n#{equals}"
    # additional ones remove from compilation
    if 'coffee' not in args
      tasks = tasks.concat ['coffeelint', 'coffee', 'shell:removeJS']
      if prod then tasks = tasks.concat ['ngmin', 'uglify']
    if 'sass' not in args
      tasks = tasks.concat ['sass', 'autoprefixer']
      if prod then tasks.push 'csso'
    if 'jade' not in args
      tasks.push 'jade'
    if 'doc' not in args
      tasks.push 'shell:codo'
    grunt.task.run tasks
  )

  grunt.registerTask('default', ['compile', 'nodemon:dev'])
  grunt.registerTask('production', ['compile:production', 'nodemon:production'])