import 'dart:math';
import 'package:flutter/material.dart';

// class FadeInAnimattion extends StatefulWidget {
//   const FadeInAnimattion({super.key});

//   @override
//   State<FadeInAnimattion> createState() => _FadeInAnimattionState();
// }

// class _FadeInAnimattionState extends State<FadeInAnimattion> {
//   double opacity = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Implicit Animations Demo'),
//       ),
//       body: Column(
//         children: [
//           SizedBox(
//             child: Image.asset("assets/images/cumeo.jpg"),
//           ),
//           TextButton(
//             onPressed: () {
//               setState(() {
//                 opacity = 1;
//               });
//             },
//             child: const Text(
//               'Show Details',
//               style: TextStyle(color: Colors.blueAccent),
//             ),
//           ),
//           AnimatedOpacity(
//             opacity: opacity,
//             duration: const Duration(seconds: 4),
//             child: Column(
//               children: const [
//                 Text('Type: Bird'),
//                 Text('Name: Owl'),
//               ],
//             ),
//           ),  
//         ],
//       ),
//     );
//   }
// }

///////////////////////////////////////////////////////////

class MyAnimatedContainer extends StatefulWidget {
  //const MyAnimatedContainer({super.key});
  const MyAnimatedContainer({Key? key}) : super(key: key);
  @override
  State<MyAnimatedContainer> createState() => _MyAnimatedContainerState();
}

class _MyAnimatedContainerState extends State<MyAnimatedContainer> {
  late double margin;
  late double borderRadius;
  late Alignment alignment;
  late TextStyle textStyle;
  late bool isPositioned;
  
  

  @override
  void initState(){
    super.initState();
    margin = _randomMargin();
    borderRadius = _randomBorderRadius();
    alignment = Alignment.center;
    textStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black);
    isPositioned = false;
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Implicit Animations Demo'),
      ),
      body: Center(
        child: Column( //Stack AnimatedPositioned
          children: [
            // AnimatedContainer(
            //   width: 128,
            //   height: 128,
            //   margin: EdgeInsets.all(margin),
            //   decoration: BoxDecoration(
            //     color: Colors.amber,
            //     borderRadius: BorderRadius.circular(borderRadius),
            //     ),
            //   duration: const Duration(milliseconds: 400),
            // ),

            // AnimatedAlign(
            //   alignment: alignment,
            //   duration: const Duration(milliseconds: 400),
            //   child: Container(
            //     width: 128,
            //     height: 128,
            //     margin: EdgeInsets.all(margin),
            //     decoration: BoxDecoration(
            //       color: Colors.amber,
            //       borderRadius: BorderRadius.circular(borderRadius),
            //     ),
            //   ),
            // ),
          
            // AnimatedDefaultTextStyle(
            // style: textStyle,
            // duration: const Duration(milliseconds: 400),
            // child: const Text('Hello'),
            // ),

            // AnimatedPadding(
            //   padding: EdgeInsets.all(margin),
            //   duration: const Duration(milliseconds: 400),
            //   curve: Curves.easeInOut,
            //   child: DefaultTextStyle(
            //     style: textStyle,
            //     child: const Text('Hello'),
            //   ),
            // ),
            
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              top: isPositioned ? 50 : 0,
              child: Container(
                width: 200,
                height: 200,
                color: Colors.blue,
              ),
            ),

            ElevatedButton(
              onPressed:() {
                setState(() {
                  // margin = _randomMargin(); //AnimatedContainer //AnimatedPadding
                  // borderRadius = _randomBorderRadius(); //AnimatedContainer
                  // alignment = _randomAlignment(); //AnimatedAlign
                  // textStyle = _randomTextStyle(); //AnimatedDefaultTextStyle
                  // isPositioned = !isPositioned; //AnimatedPositioned
                });
              }, 
              child: const Text('Change')  
            )
          ],
        ),
      ),
    );
  }
  double _randomMargin(){
    return Random().nextDouble() *64;
  }
  double _randomBorderRadius(){
    return Random().nextDouble() *64;
  }
  Alignment _randomAlignment() {
    final List<Alignment> alignments = [
      Alignment.topLeft,
      Alignment.topCenter,
      Alignment.topRight,
      Alignment.centerLeft,
      Alignment.center,
      Alignment.centerRight,
      Alignment.bottomLeft,
      Alignment.bottomCenter,
      Alignment.bottomRight,
    ];
    return alignments[Random().nextInt(alignments.length)];
  }
  TextStyle _randomTextStyle() {
    final List<double> fontSizes = [16, 20, 24, 28];
    final List<FontWeight> fontWeights = [
      FontWeight.normal,
      FontWeight.bold,
      FontWeight.w500,
    ];
    final List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
    ];

    return TextStyle(
      fontSize: fontSizes[Random().nextInt(fontSizes.length)],
      fontWeight: fontWeights[Random().nextInt(fontWeights.length)],
      color: colors[Random().nextInt(colors.length)],
    );
  }
}
