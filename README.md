# gbk2utf8
A flutter package to convert gbk to utf-8

# 目的

现在这个版本官方的http还不能支持中文gbk的解析，这个项目就是为了解决这个问题

# 使用方法

增加依赖

```

gbk2utf8: ^0.0.1

```

编写代码

```

  Future fetch(String url) async {
    http.Response response = await http.get(url);
    String str = decodeGbk ( response.bodyBytes );
    return str;
  }
  
  @override
    void initState() {
  
      fetch("http://www.ysts8.com/index_hot.html").then( (data){
        setState(() {
          _text = data;
        });
      }).catchError((e){
        _text = "网络异常，请检查";
      });
  
      super.initState();
    }



```

完整代码在

>[这里](https://github.com/jzoom/gbk2utf8/blob/master/example/lib/main.dart)


效果:

![](https://github.com/jzoom/images/raw/master/gbk2utf8.png)
