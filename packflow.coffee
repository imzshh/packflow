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
        'step-processor'
        'util'
        'processors/sequence'
        'processors/waterfall'
        'processors/combine'
        'processors/combine-file'
        'processors/compile-coffee'
        'processors/uglify-js'
        'processors/compile-less'
        'processors/copy-file'
        'processors/wrap-text'
      ]

    'compress-js' :
      type : 'uglify-js'
      writeFile : true
      outputPath : './lib'
      outputFileNameFormat : '${fileName}.min.js'

    'copy-readme' :
      type : 'copy-file'
      inputPath : ''
      outputPath : './lib'
      files : [
        'README.md'
      ]
      
