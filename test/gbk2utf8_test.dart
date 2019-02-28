import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:gbk2utf8/gbk2utf8.dart';

void main() {
  test('utf8 and unicode', () {

    List<int> utf8Array = utf8.encode("测试ABCD1234一下");
    List<int> unicodeArray = utf82unicode(utf8Array);
    List<int> utf8ArrayResp  = unicode2utf8(unicodeArray);
    expect(utf8Array, utf8ArrayResp);
    expect(utf8.decode(utf8ArrayResp), "测试ABCD1234一下");
  });

  test("convert utf8 to unicode", (){
    expect(utf82unicode(utf8.encode("春")),[0x6625]);
    expect(unicode2utf8([0x6625]),utf8.encode("春"));
  });

  test("convert unicode to gbk", (){
    expect(unicode2gbk([0x6625]),[0xB4,0xBA]);
    expect(gbk2unicode([0xB4,0XBA]),[0x6625]);
  });

  test("convert utf8 and gbk", (){
    expect(gbk.encode("春"),[0xB4,0xBA] );
    expect(gbk.decode([0xB4,0xBA]),"春" );
  });
}
