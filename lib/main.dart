import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class TestShaderHolder {
  static TestShaderHolder shared = TestShaderHolder();
  ui.FragmentProgram? _program;

  ui.FragmentProgram get program {
    assert(_program != null, 'TestShaderHolder was not initialized');
    return _program!;
  }

  Future<bool> init() async {
    _program = await ui.FragmentProgram.fromAsset('lib/test_shader.frag');
    return true;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool showGradient = false;
  bool showCaps = false;
  bool showCustomShader = false;
  bool showCircles = false;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: TestShaderHolder.shared.init(),
        builder: (context, data) {
          if (!data.hasData) {
            return Container();
          }
          return MaterialApp(
              title: 'Demo',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              home: Scaffold(
                appBar: AppBar(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  title: const Text('Demo'),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showCaps = !showCaps;
                          });
                        },
                        child: Text('${showCaps ? 'Hide' : 'Show'} Caps')),
                    const SizedBox(width: 8),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showGradient = !showGradient;
                          });
                        },
                        child:
                            Text('${showGradient ? 'Hide' : 'Show'} Gradient')),
                    const SizedBox(width: 8),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showCustomShader = !showCustomShader;
                          });
                        },
                        child: Text(
                            '${showCustomShader ? 'Hide' : 'Show'} Custom Shader')),
                    const SizedBox(width: 8),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showCircles = !showCircles;
                          });
                        },
                        child:
                            Text('${showCircles ? 'Hide' : 'Show'} Circles')),
                    const SizedBox(width: 8),
                  ],
                ),
                body: CustomPaint(
                  painter: DemoCustomPainter(
                    showGradient: showGradient,
                    showShader: showCustomShader,
                    showCaps: showCaps,
                    showCircles: showCircles,
                  ),
                ),
              ));
        });
  }
}

class DemoCustomPainter extends CustomPainter {
  final bool showGradient;
  final bool showShader;
  final bool showCaps;
  final bool showCircles;

  DemoCustomPainter({
    required this.showGradient,
    required this.showShader,
    required this.showCaps,
    required this.showCircles,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var lastX = 0.0;
    const stepX = 70.0;
    // Color:
    paintFigures(canvas, lastX, 'color', Paint()..color = Colors.blue);
    lastX += stepX;

    // Texture Image
    final image = _makePatternImage();
    final imageShader = ImageShader(
      image,
      TileMode.clamp,
      TileMode.clamp,
      Matrix4.identity().storage,
    );

    paintFigures(canvas, lastX, 'texture', Paint()..shader = imageShader);

    imageShader.dispose();
    image.dispose();
    lastX += stepX;

    // Gradient as shader - this will make a crash in Impeller, but works in Skia
    if (showGradient) {
      final gradient = _makeGradient();
      final gradientShader =
          gradient.createShader(const Rect.fromLTWH(0, 0, 5, 100));

      paintFigures(canvas, lastX, 'gradient', Paint()..shader = gradientShader);

      gradientShader.dispose();
      lastX += stepX;
    }
    if (showShader) {
      final testShader = TestShaderHolder.shared.program.fragmentShader();
      paintFigures(canvas, lastX, 'shader', Paint()..shader = testShader);
      testShader.dispose();
      lastX += stepX;
    }
  }

  void paintFigures(Canvas canvas, double x, String title, Paint paint) {
    _drawText(canvas, title, Offset(x + 10, 5));
    // Line
    final lineVertices = makeLineVertices(offset: Offset(x, 20));
    canvas.drawVertices(lineVertices, BlendMode.color, paint);
    lineVertices.dispose();

    // Dot circle
    if (showCircles) {
      final circleVertices = makeCircleVertices(offset: Offset(x + 20, 450));
      canvas.drawVertices(circleVertices, BlendMode.color, paint);
      circleVertices.dispose();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  ui.Vertices makeCircleVertices({required Offset offset}) {
    final positions = <double>[];
    final textureCoordinates = <double>[];
// 0:
    positions.add(125.35922766749373);
    textureCoordinates.add(0.0);
    positions.add(309.03884300208097);
    textureCoordinates.add(0.0);
// 1:
    positions.add(123.98689516129025);
    textureCoordinates.add(0.0);
    positions.add(309.03884300208097);
    textureCoordinates.add(25.0);
// 2:
    positions.add(125.24058328870773);
    textureCoordinates.add(0.0);
    positions.add(309.597020918838);
    textureCoordinates.add(0.0);
// 3:
    positions.add(123.98689516129025);
    textureCoordinates.add(0.0);
    positions.add(309.03884300208097);
    textureCoordinates.add(25.0);
// 4:
    positions.add(124.90516484329216);
    textureCoordinates.add(0.0);
    positions.add(310.05868480290053);
    textureCoordinates.add(0.0);
// 5:
    positions.add(123.98689516129025);
    textureCoordinates.add(0.0);
    positions.add(309.03884300208097);
    textureCoordinates.add(25.0);
// 6:
    positions.add(124.41096922764028);
    textureCoordinates.add(0.0);
    positions.add(310.34400877462946);
    textureCoordinates.add(0.0);
// 7:
    positions.add(123.98689516129025);
    textureCoordinates.add(0.0);
    positions.add(309.03884300208097);
    textureCoordinates.add(25.0);
// 8:
    positions.add(123.84344735332455);
    textureCoordinates.add(0.0);
    positions.add(310.40365772722595);
    textureCoordinates.add(0.0);
// 9:
    positions.add(123.98689516129025);
    textureCoordinates.add(0.0);
    positions.add(309.03884300208097);
    textureCoordinates.add(25.0);
// 10:
    positions.add(123.30072890818852);
    textureCoordinates.add(0.0);
    positions.add(310.22731781489233);
    textureCoordinates.add(0.0);
// 11:
    positions.add(123.98689516129025);
    textureCoordinates.add(0.0);
    positions.add(309.03884300208097);
    textureCoordinates.add(25.0);
// 12:
    positions.add(122.87665484183847);
    textureCoordinates.add(0.0);
    positions.add(309.84547981046893);
    textureCoordinates.add(0.0);
// 13:
    positions.add(123.98689516129025);
    textureCoordinates.add(0.0);
    positions.add(309.03884300208097);
    textureCoordinates.add(25.0);
// 14:
    positions.add(122.64455141293831);
    textureCoordinates.add(0.0);
    positions.add(309.3241669738099);
    textureCoordinates.add(0.0);
// 15:
    positions.add(123.98689516129025);
    textureCoordinates.add(0.0);
    positions.add(309.03884300208097);
    textureCoordinates.add(25.0);
// 16:
    positions.add(122.64455141293831);
    textureCoordinates.add(0.0);
    positions.add(308.75351903035204);
    textureCoordinates.add(0.0);
// 17:
    positions.add(123.98689516129025);
    textureCoordinates.add(0.0);
    positions.add(309.03884300208097);
    textureCoordinates.add(25.0);
// 18:
    positions.add(122.87665484183847);
    textureCoordinates.add(0.0);
    positions.add(308.232206193693);
    textureCoordinates.add(0.0);
// 19:
    positions.add(123.98689516129025);
    textureCoordinates.add(0.0);
    positions.add(309.03884300208097);
    textureCoordinates.add(25.0);
// 20:
    positions.add(123.30072890818852);
    textureCoordinates.add(0.0);
    positions.add(307.8503681892696);
    textureCoordinates.add(0.0);
// 21:
    positions.add(123.98689516129025);
    textureCoordinates.add(0.0);
    positions.add(309.03884300208097);
    textureCoordinates.add(25.0);
// 22:
    positions.add(123.84344735332455);
    textureCoordinates.add(0.0);
    positions.add(307.674028276936);
    textureCoordinates.add(0.0);
// 23:
    positions.add(123.98689516129025);
    textureCoordinates.add(0.0);
    positions.add(309.03884300208097);
    textureCoordinates.add(25.0);
// 24:
    positions.add(124.41096922764028);
    textureCoordinates.add(0.0);
    positions.add(307.7336772295325);
    textureCoordinates.add(0.0);
// 25:
    positions.add(123.98689516129025);
    textureCoordinates.add(0.0);
    positions.add(309.03884300208097);
    textureCoordinates.add(25.0);
// 26:
    positions.add(124.90516484329216);
    textureCoordinates.add(0.0);
    positions.add(308.0190012012614);
    textureCoordinates.add(0.0);
// 27:
    positions.add(123.98689516129025);
    textureCoordinates.add(0.0);
    positions.add(309.03884300208097);
    textureCoordinates.add(25.0);
// 28:
    positions.add(125.24058328870773);
    textureCoordinates.add(0.0);
    positions.add(308.48066508532395);
    textureCoordinates.add(0.0);
// 29:
    positions.add(123.98689516129025);
    textureCoordinates.add(0.0);
    positions.add(309.03884300208097);
    textureCoordinates.add(25.0);
// 30:
    positions.add(125.35922766749373);
    textureCoordinates.add(0.0);
    positions.add(309.03884300208097);
    textureCoordinates.add(0.0);
// 31:
    positions.add(123.98689516129025);
    textureCoordinates.add(0.0);
    positions.add(309.03884300208097);
    textureCoordinates.add(25.0);

    offset = Offset(-123.98689516129025, -309.03884300208097) + offset;

    return _makeVerticesFromPositions(positions, textureCoordinates, offset);
  }

  ui.Vertices makeLineVertices({Offset? offset}) {
    var positions = <double>[];
    final textureCoordinates = <double>[];
    if (showCaps) {
      // 0:
      positions.add(25.148307869183807);
      textureCoordinates.add(0.0);
      positions.add(400.13200789408165);
      textureCoordinates.add(100.0);
      // 1:
      positions.add(20.0);
      textureCoordinates.add(0.0);
      positions.add(400.0);
      textureCoordinates.add(49.999999999999794);
      // 2:
      positions.add(23.547059728860642);
      textureCoordinates.add(0.0);
      positions.add(403.7337470830112);
      textureCoordinates.add(100.0);
      // 3:
      positions.add(20.0);
      textureCoordinates.add(0.0);
      positions.add(400.0);
      textureCoordinates.add(49.999999999999794);
      // 4:
      positions.add(19.867992105918347);
      textureCoordinates.add(0.0);
      positions.add(405.1483078691838);
      textureCoordinates.add(100.0);
      // 5:
      positions.add(20.0);
      textureCoordinates.add(0.0);
      positions.add(400.0);
      textureCoordinates.add(49.999999999999794);
      // 6:
      positions.add(16.266252916988773);
      textureCoordinates.add(0.0);
      positions.add(403.54705972886063);
      textureCoordinates.add(100.0);
      // 7:
      positions.add(20.0);
      textureCoordinates.add(0.0);
      positions.add(400.0);
      textureCoordinates.add(49.999999999999794);
      // 8:
      positions.add(14.851692130816193);
      textureCoordinates.add(0.0);
      positions.add(399.86799210591835);
      textureCoordinates.add(100.0);
      // 9:
      positions.add(20.0);
      textureCoordinates.add(0.0);
      positions.add(400.0);
      textureCoordinates.add(49.999999999999794);
    }
    // 10:
    positions.add(25.148307869183807);
    textureCoordinates.add(0.0);
    positions.add(400.13200789408165);
    textureCoordinates.add(100.0);
    // 11:
    positions.add(14.851692130816193);
    textureCoordinates.add(0.0);
    positions.add(399.86799210591835);
    textureCoordinates.add(0.0);
    // 12:
    positions.add(35.14830786918383);
    textureCoordinates.add(390.1281840626232);
    positions.add(10.132007894081637);
    textureCoordinates.add(100.0);
    // 13:
    positions.add(24.85169213081617);
    textureCoordinates.add(390.1281840626232);
    positions.add(9.867992105918363);
    textureCoordinates.add(0.0);
    if (showCaps) {
      // 14:
      positions.add(35.14830786918383);
      textureCoordinates.add(0.0);
      positions.add(10.132007894081637);
      textureCoordinates.add(100.0);
      // 15:
      positions.add(30.0);
      textureCoordinates.add(0.0);
      positions.add(10.0);
      textureCoordinates.add(50.00000000000002);
      // 16:
      positions.add(33.73374708301123);
      textureCoordinates.add(0.0);
      positions.add(6.4529402711393296);
      textureCoordinates.add(100.0);
      // 17:
      positions.add(30.0);
      textureCoordinates.add(0.0);
      positions.add(10.0);
      textureCoordinates.add(50.00000000000002);
      // 18:
      positions.add(30.13200789408164);
      textureCoordinates.add(0.0);
      positions.add(4.8516921308161685);
      textureCoordinates.add(100.0);
      // 19:
      positions.add(30.0);
      textureCoordinates.add(0.0);
      positions.add(10.0);
      textureCoordinates.add(50.00000000000002);
      // 20:
      positions.add(26.45294027113933);
      textureCoordinates.add(0.0);
      positions.add(6.266252916988766);
      textureCoordinates.add(100.0);
      // 21:
      positions.add(30.0);
      textureCoordinates.add(0.0);
      positions.add(10.0);
      textureCoordinates.add(50.00000000000002);
      // 22:
      positions.add(24.85169213081617);
      textureCoordinates.add(0.0);
      positions.add(9.867992105918363);
      textureCoordinates.add(100.0);
      // 23:
      positions.add(30.0);
      textureCoordinates.add(0.0);
      positions.add(10.0);
      textureCoordinates.add(50.00000000000002);
    }

    return _makeVerticesFromPositions(positions, textureCoordinates, offset);
  }

  ui.Vertices _makeVerticesFromPositions(
    List<double> positions,
    List<double> textureCoordinates,
    Offset? offset,
  ) {
    if (offset != null) {
      var index = 0;
      positions = positions.map((e) {
        e += index.isEven ? offset.dx : offset.dy;
        index += 1;
        return e;
      }).toList();
    }

    return ui.Vertices.raw(
      VertexMode.triangleStrip,
      Float32List.fromList(positions),
      textureCoordinates: Float32List.fromList(textureCoordinates),
    );
  }

  ui.Image _makePatternImage() {
    final recorder = ui.PictureRecorder();
    const rect = Rect.fromLTWH(0, 0, 5, 100);
    final canvas = Canvas(recorder, rect);

    final shader = _makeGradient().createShader(rect);

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = shader;

    canvas.drawRect(rect, paint);

    shader.dispose();

    final picture = recorder.endRecording();
    return picture.toImageSync(rect.width.ceil(), rect.height.ceil());
  }

  LinearGradient _makeGradient() {
    final colors = <Color>[
      Colors.blue.withAlpha(0),
      Colors.blue,
      Colors.blue,
      Colors.blue.withAlpha(0)
    ];
    final stops = <double>[0, 0.15, 0.85, 1];
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: colors,
      stops: stops,
    );
  }

  void _drawText(Canvas canvas, String text, Offset offset) {
    final textSpan = TextSpan(
      text: text,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 12,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: 100,
    );
    textPainter.paint(canvas, offset);
  }
}
