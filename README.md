# gbk2utf8
A flutter package to convert gbk to utf-8

# 目的

现在这个版本官方的http还不能支持中文gbk的解析，这个项目就是为了解决这个问题

目前这个库已经成熟，严格来说，这个库的作用不是gbk和utf8的相互转换，而是服务器的gbk二进制数据流和dart的String之间相互转换，类似flutter原有的utf8编码调用，即为gbk.encode和gbk.decode这两个方法进行转化。
如果还有不懂的地方，可以入群854192563讨论.

# 使用方法

增加依赖

```

gbk2utf8: ^1.0.1

```

#### String转gbk流用以上传服务器


```
gbk.encode("需要转gbk的中文");
```

注意转化后的结果是List<int>，中文编码的二进制流，在上传表单的时候需要注意编码格式。

#### gbk流转String

```
gbk.decode(gbk二进制流，一般是http的response);
```



#### 例子：解析中文html

编写代码

```
 void download() async {
    try {
      http.Response response =
          await http.get("http://www.ysts8.com/index_hot.html");
      String data = gbk.decode(response.bodyBytes);
      setState(() {
        _text = data;
      });
    } catch (e) {
      setState(() {
        _text = "网络异常，请检查";
      });
    }
  }

```

完整代码在

>[这里](https://github.com/jzoom/gbk2utf8/blob/master/example/lib/main.dart)


效果:

![](https://github.com/jzoom/images/raw/master/gbk2utf8.png)
