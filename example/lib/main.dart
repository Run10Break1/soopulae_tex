import "package:flutter/material.dart";
import 'package:soopulae_tex/soopulae_tex.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 300,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
          ),
          child: SoopulaeTexView(
            tex: r"""그림과 같이 `$$\overline{\mathrm{AC}}=12\mathrm{~cm}$$`, `$$\angle \mathrm{ACB}=15^{\circ}$$`인 직각삼각형 `$$\mathrm{ABC}$$`를 직선 `$$l$$` 위에서 점 `$$\mathrm{C}$$`를 중심으로 회전시켰다. 이때 점 `$$\mathrm{A}$$`가 움직인 거리는 `$$a\pi\mathrm{~cm}$$`이다. `$$a$$`를 구하시오.""",
          ),
        ),
      ),
    );
  }
}
