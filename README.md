一个基于步骤定义的命令行打包工具
====================
packflow是一个用coffeescript开发的打包工具。你可以定义一个包含若干个打包步骤的打包过程定文件（`packflow.coffee`是一个打包过程定义文件的范例），然后交给packflow去处理。

## 安装

```
npm install -g packflow
```

## 使用

1. 在步骤定义文件中定义打包步骤
2. 在包含步骤定义文件的目录下执行`packflow`命令

```
packflow [-m main-step-name] [-w]
```

在执行packflow命令时，会在当前目录中查找步骤定义文件，然后根据读取到的步骤定义，一步步地执行，最终完成打包过程。

## packflow打包过程定义

因为我们通过利用nodejs的require函数在当前目录中查找`./packflow`模块的方式来读取步骤定义，所以步骤定义文件可以是packflow.json、packflow.js或者packflow.coffee，看你喜欢哪个了。但是在后面的示例中，都会使用coffeescript语法来定义步骤。

packflow定义对象包括以下几个属性：

1. `name`: string, 打包项目的名称
2. `main`: string, 最先执行的步骤名称，默认为`"main"`
3. `steps`: object, 打包步骤

下面是一个简单的packflow.coffee文件示例：将`./src`目录中的`foo.js`和`bar.js`经过[UglifyJS](https://github.com/mishoo/UglifyJS)压缩后保存到`./release`目录中。

```
module.exports =
  name : "sample"
  main : "build"
  steps : [
    build :
      type : "uglify-js"
      inputPath : "./src"
      outputPath : "./release"
      files : [
      	"foo.js"
        "bar.js"
      ]
  ]
```

## steps

packflow支持以下几种类型的步骤：

- [uglify-js](#uglify-js)
- [compile-coffee](compile-coffee)
- [compile-less](compile-less)
- [wrap-text](warp-text)
- [copy-file](copy-file)
- [combine-file](combine-file)
- [sequence](sequence)
- [waterfall](waterfall)

<a name="uglify-js"></a>
### uglify-js

使用[UglifyJS](https://github.com/mishoo/UglifyJS)模块来压缩js文件。

<a name="compile-coffee"></a>
### compile-coffee

将coffeescript文件编译成javascript文件。

<a name="compile-less"></a>
### compile-less

将less文件编译成css文件。

<a name="wrap-text"></a>
### wrap-text

在文本文件的头部和尾部加上指定的内容。可用于在文件头部增加版权、版本等信息，或者导出AMD、CMD模块。

<a name="copy-file"></a>
### copy-file

复制文件

<a name="combine-file"></a>
### combine-file

将多个文本文件合并成一个文本文件。可用于将多个js或者多个css文件合并成一个文件，以减少请求数。

<a name="sequence"></a>
### sequence

这是一个流程控制类步骤，可以用于依次执行几个步骤。

<a name="waterfall"></a>
### waterfall

和`sequence`类似，也是用户依次执行几个步骤，不同的是，上一个步骤的输出内容会变成下一个步骤的输入内容。

例如，利用`waterfall`步骤依次执行`combine-file`，`compile-coffee`和`uglify-js`，就可以将多个.coffee文件合并，然后编译成js并且压缩。

## 扩展

以上这些类型的步骤都是由`src/processors`中对应的处理器来处理的，你可以自己写一个步骤处理器来处理你自定义的步骤类型。

或者也可以[告诉我](https://github.com/8hoursdo/packflow/issues)你需要什么类型的步骤处理器。

## License

MIT
