import 'dart:async';
import 'package:flutter/material.dart';
import 'calculation.dart';
void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextField(),
                Keyboard(),
              ],
            )
        )
    );
  }
}
//==============================================================================
// 表示
class TextField extends StatefulWidget {
  _TextFiledState createState() => _TextFiledState();
}
class _TextFiledState extends State<TextField> {
  String _expression = '';
  void _UpdateText(String letter){
    setState(() {
      if (int.tryParse(letter) != null) {
        // 数字のとき
        if (_expression == '0'){
          _expression = letter;
        }else{
          _expression += letter;
        }
      } else {
        // 数字以外のとき
        switch(letter){
          case '+/-': //整数の時と小数とで処理を分ける
            if (_expression.contains('.') == true){
              _expression = (-1 * double.parse(_expression)).toString();
            }else{
              _expression = (-1 * int.parse(_expression)).toString();
            }
            break;
          case '.':
            if (_expression.contains('.') == true){
              if( _expression.contains('+') == true ||
                  _expression.contains('-') == true ||
                  _expression.contains('×') == true ||
                  _expression.contains('÷') == true ){
                _expression += letter;
              }
            }else{
              if(_expression == ''){
                _expression = _expression;
              }else{
                _expression += letter;
              }
            }
            break;
          case 'AC':
            _expression = '';
            break;
          case 'C':
            int Clear = _expression.length - 1;
            _expression = _expression.substring(0, Clear);
            break;
          case '=':
            if(_expression.contains('+') == true){
              int len = _expression.indexOf('+'); //何文字目に演算子が来るか
              double? num1 = double.tryParse(_expression.substring(0,len));
              double? num2 = double.tryParse(_expression.substring(len + 1));
              String answer = (num1! + num2!).toString();
              _expression = answer;
              if (_expression.endsWith('0') == true){
                int Clear = _expression.length - 2;
                _expression = _expression.substring(0, Clear);
              }
            }else if(_expression.contains('-') == true){
              int len = _expression.indexOf('-'); //何文字目に演算子が来るか
              double? num1 = double.tryParse(_expression.substring(0,len));
              double? num2 = double.tryParse(_expression.substring(len + 1));
              String answer = (num1! - num2!).toString();
              _expression = answer;
              if (_expression.endsWith('0') == true){
                int Clear = _expression.length - 2;
                _expression = _expression.substring(0, Clear);
              }
            }else if(_expression.contains('×') == true){
              int len = _expression.indexOf('×'); //何文字目に演算子が来るか
              double? num1 = double.tryParse(_expression.substring(0,len));
              double? num2 = double.tryParse(_expression.substring(len + 1));
              String answer = (num1! * num2!).toString();
              _expression = answer;
              if (_expression.endsWith('0') == true){
                int Clear = _expression.length - 2;
                _expression = _expression.substring(0, Clear);
              }
            }else if(_expression.contains('÷') == true){
              int len = _expression.indexOf('÷'); //何文字目に演算子が来るか
              double? num1 = double.tryParse(_expression.substring(0,len));
              double? num2 = double.tryParse(_expression.substring(len + 1));
              String answer = (num1! / num2!).toString();
              _expression = answer;
              if (_expression.endsWith('0') == true){
                int Clear = _expression.length - 2;
                _expression = _expression.substring(0, Clear);
              }
            }
            break;
          default:
            if( _expression.contains('+') == true ||
                _expression.contains('-') == true ||
                _expression.contains('×') == true ||
                _expression.contains('÷') == true ||
                _expression == ''){
              _expression = _expression;
            }else{
              _expression += letter;
            }
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 1,
        child: Container(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              Formula,
              style: TextStyle(
                fontSize: 64.0,
              ),
            ),
          ),
        )
    );
  }
  static final controller = StreamController<String>.broadcast();
}
//==============================================================================
// キーボード
class Keyboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 2,
        child: Center(
            child: Container(
              color: const Color(0xff87cefa),
              child: GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 3.0,
                crossAxisSpacing: 3.0,
                children: [
                  'AC', 'C', 'For', '=',
                  '7', '8', '9', '+',
                  '4', '5', '6', '-',
                  '1', '2', '3', '×',
                  '+/-', '0', '.', '÷',
                ].map((key) {
                  return GridTile(
                    child: Button(key),
                  );
                }).toList(),
              ),
            )
        )
    );
  }
}
// キーボタン
class Button extends StatelessWidget {
  final _key;
  Button(this._key);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: FlatButton(
          child: Center(
            child: Text(
              _key,
              style: TextStyle(
                fontSize: 40.0,
                color: Colors.black54,
              ),
            ),
          ),
          onPressed: (){
            _TextFiledState.controller.sink.add(_key);
          },
        )
    );
  }
}