import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_texture_issue/main.dart';

abstract class PaintProvider {
  Paint getPaint(Color color);
}

class ColorPaintProvider extends PaintProvider {
  @override
  Paint getPaint(Color color) {
    return Paint()..color = color;
  }
}

class GradientPaintProvider extends PaintProvider {
  @override
  Paint getPaint(Color color) {
    final gradient = _makeGradient(color);
    const rect = Rect.fromLTWH(0, 0, 5, 100);
    return Paint()..shader = gradient.createShader(rect);
  }
}

class ShaderPaintProvider extends PaintProvider {
  ui.FragmentShader? shader;

  @override
  Paint getPaint(Color color) {
    shader ??= TestShaderHolder.shared.program.fragmentShader();

    shader!.setFloat(0, color.r);
    shader!.setFloat(1, color.g);
    shader!.setFloat(2, color.b);
    shader!.setFloat(3, color.a);
    return Paint()..shader = shader!;
  }
}

class TexturePaintProvider extends PaintProvider {
  final imagePerColor = <Color, ui.Image>{};

  @override
  Paint getPaint(Color color) {
    final image = imagePerColor[color] ?? makeImage(color);
    imagePerColor[color] = image;

    final imageShader = ImageShader(
      image,
      TileMode.clamp,
      TileMode.clamp,
      Matrix4.identity().storage,
    );

    return Paint()..shader = imageShader;
  }

  ui.Image makeImage(Color color) {
    final recorder = ui.PictureRecorder();
    const rect = Rect.fromLTWH(0, 0, 5, 100);
    final canvas = Canvas(recorder, rect);

    final shader = _makeGradient(color).createShader(rect);

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = shader;

    canvas.drawRect(rect, paint);

    shader.dispose();

    final picture = recorder.endRecording();
    return picture.toImageSync(rect.width.ceil(), rect.height.ceil());
  }
}

LinearGradient _makeGradient(Color color) {
  final colors = <Color>[color.withAlpha(0), color, color, color.withAlpha(0)];
  final stops = <double>[0, 0.05, 0.95, 1];
  return LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: colors,
    stops: stops,
  );
}
