module.exports = (grunt) ->

  # Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    coffeelint: {
      app: ['src/*.coffee']
    },
    sass: {
      dist: {
        options: {
          style: 'expanded'
        },
        files: {
          'build/style.css': 'src/css/style.scss'
        }
      }
    },
    coffee: {
      compileJoined: {
        options: {
          join: true
        },
        files: {
          'build/sched.js': ['src/js/*.coffee']
        }
      }
    },
    watch: {
      scripts: {
        files: ['src/js/*.coffee'],
        tasks: ['coffeelint', 'coffee', 'shell:codo']
      },
      styles: {
        files: ['src/css/*.scss'],
        tasks: ['sass']
      }
    },
    shell: {
      codo: {
        command: 'codo -n "sched" --title "sched documentation" --cautious src/js/'
      }
    }
  })

  # Load tasks
  grunt.loadNpmTasks('grunt-coffeelint')
  grunt.loadNpmTasks('grunt-contrib-sass')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-shell')

  # Default task(s).
  grunt.registerTask('default', ['coffeelint', 'coffee', 'sass', 'watch', 'shell:codo'])