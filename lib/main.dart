import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_texture_issue/paint_provider.dart';

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
  double progress = 0;
  final colorPainter = ColorPaintProvider();
  final texturePainter = TexturePaintProvider();
  final shaderPainter = ShaderPaintProvider();
  final gradientPainter = GradientPaintProvider();

  late PaintProvider currentPaintProvider = colorPainter;

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
                  title: Slider(
                      value: progress,
                      onChanged: (v) {
                        setState(() {
                          progress = v;
                        });
                      }),
                  actions: [
                    SegmentedButton<PaintProvider>(
                      segments: [
                        ButtonSegment(
                          value: colorPainter,
                          label: const Text('Color'),
                        ),
                        ButtonSegment(
                          value: texturePainter,
                          label: const Text('Texture'),
                        ),
                        ButtonSegment(
                          value: gradientPainter,
                          label: const Text('Gradient'),
                        ),
                        ButtonSegment(
                          value: shaderPainter,
                          label: const Text('Shader'),
                        )
                      ],
                      selected: {currentPaintProvider},
                      onSelectionChanged: (value) {
                        setState(() {
                          currentPaintProvider = value.first;
                        });
                      },
                      multiSelectionEnabled: false,
                    ),
                  ],
                ),
                body: CustomPaint(
                  painter: DemoCustomPainter(
                    progress: progress,
                    paintProvider: currentPaintProvider,
                  ),
                ),
              ));
        });
  }
}

class DemoCustomPainter extends CustomPainter {
  final double progress;
  final PaintProvider paintProvider;

  DemoCustomPainter({
    required this.progress,
    required this.paintProvider,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final before = DateTime.now();
    final colors = [Colors.blue, Colors.blueGrey, Colors.lightGreen];
    for (var i = 0; i < 50; i += 1) {
      final color = colors[i % colors.length];
      final y = (i % colors.length) * 20.0 * progress;
      paintFigures(canvas, Offset(i * 20, y), color);
    }
  }

  void paintFigures(Canvas canvas, Offset offset, Color color) {
    // Line
    final lineVertices = makeLineVertices(offset: offset);
    canvas.drawVertices(
        lineVertices, BlendMode.color, paintProvider.getPaint(color));
    lineVertices.dispose();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  ui.Vertices makeLineVertices({Offset? offset}) {
    var positions = <double>[];
    final textureCoordinates = <double>[];

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
