module.exports =
  name : 'packflow'
  main : 'build-js'
  steps :
    'build-js' :
      type : 'sequence'
      steps : [
        'compile-js'
        'copy-readme'
      ]

    'compile-js' :
      type : 'waterfall'
      steps : [
        'compile-coffee'
        'compress-js'
      ]

    'compile-coffee' :
      type : 'compile-coffee'
      inputPath : './src'
      writeFile : true
      outputPath : './lib'
      files : [
        'packflow'
        'packer'
        'processors/sequence'
        'processors/compile-coffee'
        'processors/uglify-js'
        'processors/compile-less'
      ]

    'compress-js' :
      type : 'uglify-js'
      outputPath : './lib'
      outputFileName : '${fileName}.min.js'

    'copy-readme' :
      type : 'copy-file'
      inputPath : ''
      outputPath : './lib'
      files : [
        'README.md'
      ]
      
