import 'package:fintech_vault_app/auth.dart';
import 'package:flutter/material.dart';

class Socials extends StatefulWidget {
  const Socials({Key? key}) : super(key: key);

  @override
  State<Socials> createState() => _SocialsState();
}

class _SocialsState extends State<Socials> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _controllera;
  late final Animation animation;
  late final Animation aanimation;
  late final AnimationController _heightController;
  late final Animation<double> _heightAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 2400),
      vsync: this,
    )..repeat(reverse: true);
    _controllera = AnimationController(
      duration: Duration(milliseconds: 2900),
      vsync: this,
    )..repeat(reverse: true);

    animation = Tween<double>(begin: 0, end: 13).animate(CurvedAnimation(parent: _controllera, curve: Curves.easeInOut));
    aanimation = Tween<double>(begin: 25, end: 5).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _heightController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _heightAnimation = Tween<double>(begin: 0, end: 50).animate(_heightController);
    _heightController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllera.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: MySocials(animation, aanimation, _heightAnimation),
    );
  }
}

class MySocials extends AnimatedWidget {
  final Animation animation;
  final Animation aanimation;
  final Animation<double> heightAnimation;

  MySocials(this.animation, this.aanimation, this.heightAnimation)
      : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffD5D5D5),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 200,
                  child: Image.asset('asstes/vault.png')),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedContainer(
                  height: heightAnimation.value,
                  duration: Duration(milliseconds: 200),
                  child: heightAnimation.isCompleted
                      ? TypewriterText(text: "Welcome to Vault",textStyle: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold),)
                      : Container(),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: animation.value + 14,
                  left: aanimation.value,
                ),
                child: InkWell(
                  onTap: () {},
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 100),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,  PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => const /*VaultHome()*/ HomePage(),transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          final tween = Tween(begin: begin, end: end);
                          final offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },));
                      },
                      child: Icon(Icons.arrow_forward),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TypewriterText extends StatefulWidget {
  final String text;
  final Duration duration;
  final TextStyle textStyle;

  TypewriterText({
    required this.text,
    this.duration = const Duration(milliseconds: 1200),
    this.textStyle = const TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    ),
  });

  @override
  _TypewriterTextState createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<int> _typingAnimation;
  String get _currentText => widget.text.substring(0, _typingAnimation.value);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _typingAnimation = StepTween(
      begin: 0,
      end: widget.text.length,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Text(
          _currentText,
          style: widget.textStyle,
        );
      },
    );
  }
}
