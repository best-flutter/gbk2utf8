import 'dart:convert';

import 'gbk.dart';
import 'unicode.dart';

GbkCodec gbk = new GbkCodec();

class GbkEncoder extends Converter<String, List<int>> {
  const GbkEncoder();

  @override
  List<int> convert(String input) {
    return unicode2gbk(utf82unicode(utf8.encode(input)));
  }
}

class GbkDecoder extends Converter<List<int>, String> {
  const GbkDecoder();

  @override
  String convert(List<int> input) {
    return decodeGbk(input);
  }
}

String decodeGbk(List<int> codeUnits) {
  return utf8.decode(gbk2utf8(codeUnits));
}

class GbkCodec extends Encoding {
  @override
  Converter<List<int>, String> get decoder => const GbkDecoder();

  @override
  Converter<String, List<int>> get encoder => const GbkEncoder();

  @override
  String get name => "gbk";
}

int unicode2gbkOne(int unicode) {

  int offset;

  if (unicode <= 0x9FA5)
    offset = unicode - 0x4E00;
  else if (unicode > 0x9FA5) //是标点符号
  {
    if (unicode < 0xFF01 || unicode > 0xFF61) return 0; //没有对应编码
    offset = unicode - 0XFF01 + 0X9FA6 - 0X4E00;
  }
  return gbkTables[offset]; //读取UNICODE转GBK编码表
}

List<int> unicode2gbk(List<int> res) {
  List<int> resp = [];
  for (int i = 0, l = res.length; i < l; ++i) {
    //注意这里必须是bytes array而不是word array，所以需要拆除高低位
    int unicode = res[i];
    if(unicode <= 0x80){
      resp.add(unicode);
    }else{
      int value = unicode2gbkOne(unicode);
      if(value == 0){
        continue;
      }
      resp.add((value >> 8 )& 0xff );
      resp.add( value & 0xff  );
    }
   // resp[i] = unicode2gbkOne(unicode);
  }
  return resp;
}

List<int> gbk2utf8(List<int> gbk_buf) {
  return unicode2utf8(gbk2unicode(gbk_buf));
}

/// gbk => unicode word array
/// @param gbk_buf byte array
/// @return   word array
List<int> gbk2unicode(List<int> gbk_buf) {
  int uni_ind = 0, gbk_ind = 0, uni_num = 0;
  int ch;
  int word; //unsigned short
  int word_pos;
  List<int> uni_ptr = new List()..length = gbk_buf.length;

  for (; gbk_ind < gbk_buf.length;) {
    ch = gbk_buf[gbk_ind];
    if (ch > 0x80) {
      word = gbk_buf[gbk_ind];
      word <<= 8;
      word += gbk_buf[gbk_ind + 1];
      gbk_ind += 2;
      word_pos = word - gbk_first_code;
      if (word >= gbk_first_code &&
          word <= gbk_last_code &&
          (word_pos < unicode_buf_size)) {
        uni_ptr[uni_ind] = unicodeTables[word_pos];
        uni_ind++;
        uni_num++;
      }
    } else {
      gbk_ind++;
      uni_ptr[uni_ind] = ch;
      uni_ind++;
      uni_num++;
    }
  }

  uni_ptr.length = uni_num;

  return uni_ptr;
}

int z_pos(int x) {
  for (int i = 0; i < 5; i++, x <<= 1) {
    if ((x & 0x80) == 0) return i;
  }

  return 4;
}

List<int> mask = [0x7f, 0x3f, 0x1f, 0x0f, 0x7];

List<int> utf82unicode(List<int> bytes) {
  List<int> loc = [];

  for (int i = 0; i < bytes.length;) {
    int byte_cnt = z_pos(bytes[i]);
    int sum = bytes[i] & mask[byte_cnt];

    for (int j = 1; j < byte_cnt; j++) {
      sum <<= 6;
      sum |= bytes[i + j] & mask[1];
    }

    i += byte_cnt > 0 ? byte_cnt : 1;
    loc.add(sum);
  }

  return loc;
}

///Word array to utf-8
List<int> unicode2utf8(List<int> wordArray) {
  // a utf-8 character is 3 bytes
  List<int> list = new List()..length = wordArray.length * 3;
  int pos = 0;

  for (int i = 0, c = wordArray.length; i < c; ++i) {
    int word = wordArray[i];
    if (word <= 0x7f) {
      list[pos++] = word;
    } else if (word >= 0x80 && word <= 0x7ff) {
      list[pos++] = 0xc0 | ((word >> 6) & 0x1f);
      list[pos++] = 0x80 | (word & 0x3f);
    } else if (word >= 0x800 && word < 0xffff) {
      list[pos++] = 0xe0 | ((word >> 12) & 0x0f);
      list[pos++] = 0x80 | ((word >> 6) & 0x3f);
      list[pos++] = 0x80 | (word & 0x3f);
    } else {
      //-1
      list[pos++] = -1;
    }
  }

  list.length = pos;
  return list;
}
