import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'dart:math' as math;

// global values
Color whiteColor = const Color.fromRGBO(186, 186, 186, 1);

class FlipClockScreen extends StatefulWidget {
  @override
  _FlipClockScreenState createState() => _FlipClockScreenState();
}

class _FlipClockScreenState extends State<FlipClockScreen> {
  late Timer _timer;
  late DateTime _currentTime;
  late int _hour12;
  late String _meridian;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _currentTime = now;
      _meridian = DateFormat("a").format(now);
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        alignment: Alignment.center,
        height: double.infinity,
        width: double.infinity,
        child: OrientationBuilder(
          builder: (context, _layout) {
            if (_layout == Orientation.portrait || width < 800) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClockAnimation(
                    timerDuration: Duration(minutes: 60 - _currentTime.minute),
                    limit: 12,
                    start: 1,
                    onTime: (_currentTime.hour % 12),
                    showhour: true,
                    ampm: _meridian,
                  ),
                  ClockAnimation(
                    timerDuration: Duration(seconds: 60 - _currentTime.second),
                    limit: 59,
                    start: 0,
                    onTime: _currentTime.minute,
                    showhour: false,
                    ampm: '',
                  ),
                  if (height > 700)
                    ClockAnimation(
                      timerDuration: const Duration(seconds: 1),
                      limit: 59,
                      start: 0,
                      onTime: _currentTime.second,
                      showhour: false,
                      ampm: _meridian,
                    ),
                ],
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClockAnimation(
                        timerDuration:
                            Duration(minutes: 60 - _currentTime.minute),
                        limit: 12,
                        start: 1,
                        onTime: _hour12,
                        showhour: true,
                        ampm: _meridian,
                      ),
                      ClockAnimation(
                        timerDuration:
                            Duration(seconds: 60 - _currentTime.second),
                        limit: 59,
                        start: 0,
                        onTime: _currentTime.minute,
                        showhour: false,
                        ampm: '',
                      ),
                      ClockAnimation(
                        timerDuration: const Duration(seconds: 1),
                        limit: 59,
                        start: 0,
                        onTime: _currentTime.second,
                        showhour: false,
                        ampm: '',
                      ),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

class ClockAnimation extends StatefulWidget {
  final Duration timerDuration;
  final int limit;
  final int start;
  final int onTime;
  final bool showhour;
  final String ampm;
  ClockAnimation(
      {required this.timerDuration,
      required this.limit,
      required this.start,
      required this.onTime,
      required this.showhour,
      required this.ampm});

  @override
  _ClockAnimationState createState() => _ClockAnimationState();
}

class _ClockAnimationState extends State<ClockAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Timer _timer;
  late int _current; // current displayed value
  late int _next; // next value to display

  int _calcNext(int val) {
    return (val == widget.limit) ? widget.start : val + 1;
  }

  @override
  void didUpdateWidget(covariant ClockAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.onTime != _current) {
      // شغل الفليب بدل ما تغير الرقم فورًا
      _next = widget.onTime;
      _controller.forward(from: 0.0);
    }
  }

  @override
  void initState() {
    super.initState();
    _current = widget.onTime;
    _next = _calcNext(_current);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: math.pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _current = _next;
        });
        _controller.reset();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ارتفاع كل نصف
    const double halfHeight = 99.0;
    const double width = 200.0;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // الجزء العلوي (ثابت خلفي) - يعرض الرقم الحالي
              Container(
                height: halfHeight,
                width: width,
                decoration: _boxDecoration(true),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (widget.showhour)
                      Positioned(
                        top: 10.0,
                        left: 10.0,
                        child: Text(
                          widget.ampm,
                          style: GoogleFonts.cabin(
                            fontSize: 18.0,
                            color: whiteColor,
                          ),
                        ),
                      ),
                    Positioned(
                      top: Platform.isAndroid ? 15 : 4.0,
                      child: _timeText(_next),
                    ),
                  ],
                ),
              ),

              // الجزء السفلي (ثابت) - يعرض الرقم الحالي أو الرقم الجديد بعد منتصف الفليب
              Container(
                height: halfHeight,
                width: width,
                decoration: _boxDecoration(false),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      bottom: Platform.isAndroid ? 23 : 14.0,
                      child: (_animation.value < (math.pi / 2))
                          ? _timeText(_current)
                          : _timeText(_next),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // الـ overlay الذي يقوم بالفليب (يجب أن يغطي الجزء العلوي)
          // نستخدم AnimatedBuilder-like behavior عبر _animation listener (setState)
          Positioned(
            // يضعه فوق الجزء العلوي
            child: Transform(
              alignment: Alignment
                  .bottomCenter, // محور الدوران عند الحافة السفلية للجزء العلوي
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.003) // perspective
                ..rotateX(_animation.value),
              child: Container(
                height: halfHeight,
                width: width,
                decoration: _boxDecoration(true),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // أثناء النصف الأول من الفليب: نعرض الواجهة الأمامية (current)
                    // أثناء النصف الثاني: نعرض الواجهة الخلفية (next) مقلوبة لكي تصبح صحيحة بعد الدوران الكامل
                    _animation.value <= (math.pi / 2)
                        ? Positioned(
                      top: Platform.isAndroid ? 15 : 4.0,
                      child: _timeText(_current),
                    )
                        : Positioned(
                      top: Platform.isAndroid ? 15 : 14.0,
                      child: Transform(
                        transform: Matrix4.rotationX(math.pi),
                        alignment: Alignment.center,
                        child: _timeText(_next),
                      ),
                    ),

                    if (widget.showhour && (_animation.value < (math.pi / 2)))
                      Positioned(
                        top: 10.0,
                        left: 10.0,
                        child: Text(
                          widget.ampm,
                          style: GoogleFonts.cabin(
                            fontSize: 18.0,
                            color: whiteColor,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // خط فاصل مرئي بين النصفين (يظهر فوقهم)
          Padding(
            padding: const EdgeInsets.only(top: halfHeight),
            child: Container(
              color: Colors.black,
              height: 2.0,
              width: width,
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _boxDecoration(bool top) => BoxDecoration(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(top ? 10 : 0),
      topRight: Radius.circular(top ? 10 : 0),
      bottomLeft: Radius.circular(top ? 0 : 10),
      bottomRight: Radius.circular(top ? 0 : 10),
    ),
    color: const Color.fromRGBO(20, 20, 20, 1),
  );

  Text _timeText(int value) {
    return Text(
      value.toString().padLeft(2, '0'),
      style: GoogleFonts.cabin(
        fontSize: 126.0,
        color: whiteColor,
      ),
    );
  }

  void startTimer() {
    // ملاحظة: Timer.periodic سيبدأ بعد مدة widget.timerDuration الأولى
    _timer = Timer.periodic(widget.timerDuration, (Timer timer) {
      // حساب التالي وتشغيل الأنيميشن
      _next = _calcNext(_current);
      // شغّل الفليب من البداية
      _controller.forward(from: 0.0);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }
}
