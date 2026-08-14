import 'dart:async';

import 'package:flutter/material.dart';

import '../../models/animation_sequence.dart';
import '../../widgets/safe_model_viewer.dart';

class AnimationPlayerScreen extends StatefulWidget {
  final AnimationSequence sequence;

  const AnimationPlayerScreen({
    super.key,
    required this.sequence,
  });

  @override
  State<AnimationPlayerScreen> createState() =>
      _AnimationPlayerScreenState();
}

class _AnimationPlayerScreenState
    extends State<AnimationPlayerScreen> {
  bool isPlaying = false;

  double speed = 1.0;

  int currentGestureIndex = 0;

  Timer? _playbackTimer;

  /*
  ============================================================
  GLB ANIMATION NOMI
  ============================================================

  Siz yuborgan GLB ichida animation:

  Armature|mixamo.com|Layer0

  Shuning uchun Gemini'dan keladigan:

  GREETING_SALOM
  GREETING_RAHMAT
  GOOD_YAXSHI
  YOU_SIZ

  kabi nomlarni to'g'ridan-to'g'ri ModelViewer'ga bermaymiz.

  Bu modelda hozircha bitta animation clip bor.

  ============================================================
  */

  static const String _glbAnimationName =
      'Armature|mixamo.com|Layer0';

  /*
  Model faylining project ichidagi yo'li.
  */

  static const String _modelPath =
      'assets/models/model.glb';

  @override
  void initState() {
    super.initState();

    currentGestureIndex = 0;

    /*
    Sahifa ochilishi bilan animatsiya avtomatik boshlansin.
    Xohlamasangiz true o'rniga false qiling.
    */

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      setState(() {
        isPlaying = true;
      });

      _startPlayback();
    });
  }

  @override
  void dispose() {
    _playbackTimer?.cancel();
    super.dispose();
  }

  /*
  ============================================================
  PLAYBACK
  ============================================================
  */

  void _startPlayback() {
    _playbackTimer?.cancel();

    if (!isPlaying) return;

    if (widget.sequence.animationSequence.isEmpty) {
      return;
    }

    final currentGesture =
    widget.sequence.animationSequence[currentGestureIndex];

    final baseDuration =
    currentGesture.durationMs > 0
        ? currentGesture.durationMs
        : 1500;

    final durationMs =
    (baseDuration / speed).round();

    final safeDuration =
    durationMs < 300 ? 300 : durationMs;

    _playbackTimer = Timer(
      Duration(milliseconds: safeDuration),
          () {
        if (!mounted) return;

        if (!isPlaying) return;

        setState(() {
          if (currentGestureIndex <
              widget.sequence.animationSequence.length - 1) {
            currentGestureIndex++;
          } else {
            /*
            Oxirgi gesture tugaganda boshidan qaytamiz.
            */

            currentGestureIndex = 0;
          }
        });

        /*
        Keyingi gesture uchun timer.
        */

        _startPlayback();
      },
    );
  }

  /*
  ============================================================
  PLAY / PAUSE
  ============================================================
  */

  void _togglePlayback() {
    if (widget.sequence.animationSequence.isEmpty) {
      return;
    }

    setState(() {
      isPlaying = !isPlaying;
    });

    if (isPlaying) {
      if (currentGestureIndex >=
          widget.sequence.animationSequence.length) {
        setState(() {
          currentGestureIndex = 0;
        });
      }

      _startPlayback();
    } else {
      _playbackTimer?.cancel();
    }
  }

  /*
  ============================================================
  PREVIOUS
  ============================================================
  */

  void _previousGesture() {
    if (widget.sequence.animationSequence.isEmpty) {
      return;
    }

    setState(() {
      if (currentGestureIndex > 0) {
        currentGestureIndex--;
      } else {
        currentGestureIndex =
            widget.sequence.animationSequence.length - 1;
      }
    });

    if (isPlaying) {
      _startPlayback();
    }
  }

  /*
  ============================================================
  NEXT
  ============================================================
  */

  void _nextGesture() {
    if (widget.sequence.animationSequence.isEmpty) {
      return;
    }

    setState(() {
      if (currentGestureIndex <
          widget.sequence.animationSequence.length - 1) {
        currentGestureIndex++;
      } else {
        currentGestureIndex = 0;
      }
    });

    if (isPlaying) {
      _startPlayback();
    }
  }

  /*
  ============================================================
  RESTART
  ============================================================
  */

  void _restart() {
    if (widget.sequence.animationSequence.isEmpty) {
      return;
    }

    setState(() {
      currentGestureIndex = 0;
      isPlaying = true;
    });

    _startPlayback();
  }

  /*
  ============================================================
  SPEED
  ============================================================
  */

  void _changeSpeed() {
    setState(() {
      if (speed == 1.0) {
        speed = 1.5;
      } else if (speed == 1.5) {
        speed = 2.0;
      } else if (speed == 2.0) {
        speed = 0.5;
      } else {
        speed = 1.0;
      }
    });

    if (isPlaying) {
      _startPlayback();
    }
  }

  @override
  Widget build(BuildContext context) {
    /*
    Agar sequence bo'sh bo'lsa xatolik bermasligi uchun.
    */

    if (widget.sequence.animationSequence.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: const Center(
          child: Text(
            'Animatsiya topilmadi',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      );
    }

    final currentGesture =
    widget.sequence.animationSequence[currentGestureIndex];

    final total =
        widget.sequence.animationSequence.length;

    final progress =
        (currentGestureIndex + 1) / total;

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.transparent,

        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text(
          widget.sequence.inputText,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white70,
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            /*
            ====================================================
            3D MODEL
            ====================================================
            */

            Expanded(
              child: Container(
                width: double.infinity,

                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.white10,
                    ],
                  ),
                ),

                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          width: double.infinity,

                          child: SafeModelViewer(
                            src: _modelPath,
                            alt: '3D Sign Language Avatar',

                            animationName: _glbAnimationName,

                            autoPlay: isPlaying,
                          )
                        ),
                      ),
                    ),

                    /*
                    ====================================================
                    STATUS
                    ====================================================
                    */

                    const Padding(
                      padding: EdgeInsets.only(
                        bottom: 10,
                      ),
                      child: Text(
                        'AI 3D ENGINE ACTIVE',
                        style: TextStyle(
                          color: Colors.white24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                          fontSize: 10,
                        ),
                      ),
                    ),

                    /*
                    ====================================================
                    CURRENT GESTURE
                    ====================================================
                    */

                    Container(
                      margin: const EdgeInsets.only(
                        bottom: 20,
                      ),

                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),

                      decoration: BoxDecoration(
                        color:
                        Colors.white.withOpacity(0.05),

                        borderRadius:
                        BorderRadius.circular(20),

                        border: Border.all(
                          color: Colors.white10,
                        ),
                      ),

                      child: Text(
                        currentGesture.gesture,

                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /*
            ============================================================
            BOTTOM CONTROL PANEL
            ============================================================
            */

            Container(
              padding: const EdgeInsets.fromLTRB(
                24,
                24,
                24,
                20,
              ),

              decoration: const BoxDecoration(
                color: Color(0xFF0A0A0A),

                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /*
                  PROGRESS
                  */

                  LinearProgressIndicator(
                    value: progress,

                    backgroundColor:
                    Colors.white10,

                    color:
                    Colors.white,

                    minHeight: 2,
                  ),

                  const SizedBox(height: 24),

                  /*
                  ======================================================
                  GESTURE LIST
                  ======================================================
                  */

                  ConstrainedBox(
                    constraints:
                    const BoxConstraints(
                      maxHeight: 100,
                    ),

                    child:
                    SingleChildScrollView(
                      child: Wrap(
                        alignment:
                        WrapAlignment.center,

                        spacing: 8,

                        runSpacing: 8,

                        children:
                        List.generate(
                          total,
                              (index) {
                            final isCurrent =
                                index ==
                                    currentGestureIndex;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentGestureIndex =
                                      index;
                                });

                                if (isPlaying) {
                                  _startPlayback();
                                }
                              },

                              child:
                              AnimatedContainer(
                                duration:
                                const Duration(
                                  milliseconds: 250,
                                ),

                                padding:
                                const EdgeInsets
                                    .symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),

                                decoration:
                                BoxDecoration(
                                  color: isCurrent
                                      ? Colors.white
                                      : Colors
                                      .transparent,

                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                    8,
                                  ),

                                  border:
                                  Border.all(
                                    color: isCurrent
                                        ? Colors
                                        .white
                                        : Colors
                                        .white10,
                                  ),
                                ),

                                child: Text(
                                  widget
                                      .sequence
                                      .animationSequence[
                                  index]
                                      .gesture,

                                  style: TextStyle(
                                    color: isCurrent
                                        ? Colors.black
                                        : Colors
                                        .white54,

                                    fontWeight: isCurrent
                                        ? FontWeight
                                        .bold
                                        : FontWeight
                                        .normal,

                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /*
                  ======================================================
                  CONTROLS
                  ======================================================
                  */

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly,
                    children: [
                      /*
                      RESTART
                      */

                      IconButton(
                        icon: const Icon(
                          Icons.replay_rounded,
                          color: Colors.white54,
                        ),
                        onPressed: _restart,
                      ),

                      /*
                      PREVIOUS
                      */

                      IconButton(
                        icon: const Icon(
                          Icons.skip_previous_rounded,
                          size: 36,
                          color: Colors.white,
                        ),
                        onPressed:
                        _previousGesture,
                      ),

                      /*
                      PLAY / PAUSE
                      */

                      Container(
                        decoration:
                        const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),

                        child: IconButton(
                          icon: Icon(
                            isPlaying
                                ? Icons.pause_rounded
                                : Icons
                                .play_arrow_rounded,

                            color: Colors.black,

                            size: 32,
                          ),

                          onPressed:
                          _togglePlayback,
                        ),
                      ),

                      /*
                      NEXT
                      */

                      IconButton(
                        icon: const Icon(
                          Icons.skip_next_rounded,
                          size: 36,
                          color: Colors.white,
                        ),
                        onPressed: _nextGesture,
                      ),

                      /*
                      SPEED
                      */

                      GestureDetector(
                        onTap:
                        _changeSpeed,

                        child: Container(
                          padding:
                          const EdgeInsets
                              .symmetric(
                            horizontal: 9,
                            vertical: 6,
                          ),

                          decoration:
                          BoxDecoration(
                            border: Border.all(
                              color: Colors
                                  .white24,
                            ),

                            borderRadius:
                            BorderRadius
                                .circular(
                              6,
                            ),
                          ),

                          child: Text(
                            '${speed}x',

                            style:
                            const TextStyle(
                              color:
                              Colors.white,

                              fontSize: 12,

                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  /*
                  POSITION
                  */

                  Text(
                    'Gesture ${currentGestureIndex + 1} of $total',

                    style:
                    const TextStyle(
                      color: Colors.white38,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
