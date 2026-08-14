import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import '../core/utils/three_d_manager.dart';

class SafeModelViewer extends StatefulWidget {
  final String src;
  final String alt;
  final String? cameraOrbit;
  final String? cameraTarget;
  final String? fieldOfView;

  /// GLB ichidagi ANIMATION CLIP nomi.
  ///
  /// Siz yuborgan GLB faylda:
  /// Armature|mixamo.com|Layer0
  final String? animationName;

  /// Animatsiyani avtomatik ishga tushirish.
  final bool autoPlay;

  const SafeModelViewer({
    super.key,
    required this.src,
    this.alt = '3D Model',
    this.cameraOrbit,
    this.cameraTarget,
    this.fieldOfView,
    this.animationName,
    this.autoPlay = false,
  });

  @override
  State<SafeModelViewer> createState() => _SafeModelViewerState();
}

class _SafeModelViewerState extends State<SafeModelViewer> {
  bool _shouldRender = false;

  late final String _instanceId;

  final ThreeDManager _manager = ThreeDManager();

  @override
  void initState() {
    super.initState();

    _instanceId = DateTime.now().microsecondsSinceEpoch.toString();

    _manager.register(_instanceId);

    final delay = kIsWeb ? 1800 : 800;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(
        Duration(milliseconds: delay),
            () {
          if (!mounted) return;

          if (_manager.isAllowed(_instanceId)) {
            setState(() {
              _shouldRender = true;
            });
          }
        },
      );
    });
  }

  @override
  void dispose() {
    _manager.unregister(_instanceId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: _manager.activeViewerId,
      builder: (context, activeId, _) {
        final allowed = activeId == _instanceId;

        if (!allowed || !_shouldRender) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white30,
            ),
          );
        }

        /*
        IMPORTANT:

        Bu yerda cache ishlatmayapmiz.

        Oldingi kodda ModelViewer bir marta yaratilganidan keyin
        animationName o'zgarsa ham eski viewer qaytarilardi.

        Endi animationName o'zgarganda yangi ModelViewer yaratiladi.
        */

        return ModelViewer(
          key: ValueKey(
            '3d_viewer_${_instanceId}_${widget.animationName ?? 'none'}_${widget.autoPlay}',
          ),

          src: widget.src,

          alt: widget.alt,

          autoRotate: false,

          cameraControls: true,

          backgroundColor: Colors.transparent,

          disableZoom: false,

          // These values are supplied by screen callers. Forward them so the
          // avatar is framed instead of relying on the model's default camera.
          cameraOrbit: widget.cameraOrbit,
          cameraTarget: widget.cameraTarget,
          fieldOfView: widget.fieldOfView,

          animationName: widget.animationName,

          autoPlay: widget.autoPlay,
        );
      },
    );
  }
}
