#include <flutter/runtime_effect.glsl>

uniform vec4 uColor;

out vec4 fragColor;

void main() {
    float kSmooth = 50 /
            (1.5 *
                (50 / (12 * 0.5 * 1 * 2)));
    fragColor = uColor * clamp(((1 - abs(50 - FlutterFragCoord().y) / 50) * kSmooth), 0, 1);;
}
