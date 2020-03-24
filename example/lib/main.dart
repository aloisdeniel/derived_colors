import 'package:derived_colors/derived_colors.dart';
import 'package:example/swatches.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auto Colors Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ExamplePage(),
    );
  }
}

class ExamplePage extends StatefulWidget {
  @override
  _ExamplePageState createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  Swatch swatch = bulma;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Palette(swatch.primary),
                    Palette(swatch.link),
                    Palette(swatch.info),
                    Palette(swatch.danger),
                    Palette(swatch.warning),
                    Palette(swatch.grey),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: <Widget>[
                    Button.regular(color: swatch.primary, text: 'Example'),
                    Button.regular(color: swatch.link, text: 'Example'),
                    Button.regular(color: swatch.info, text: 'Example'),
                    Button.regular(color: swatch.danger, text: 'Example'),
                    Button.regular(color: swatch.warning, text: 'Example'),
                    Button.regular(color: swatch.success, text: 'Example'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: <Widget>[
                    Button.light(color: swatch.primary, text: 'Example'),
                    Button.light(color: swatch.link, text: 'Example'),
                    Button.light(color: swatch.info, text: 'Example'),
                    Button.light(color: swatch.danger, text: 'Example'),
                    Button.light(color: swatch.warning, text: 'Example'),
                    Button.light(color: swatch.success, text: 'Example'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Palette extends StatelessWidget {
  final Color color;

  Palette(this.color);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 24,
          height: 24,
          color: color.variants.dark,
        ),
        Container(
          width: 24,
          height: 24,
          color: color.variants.regular.darken(0.05),
        ),
        Container(
          width: 24,
          height: 24,
          color: color.variants.regular,
        ),
        Container(
          width: 24,
          height: 24,
          color: color.variants.regular.lighten(0.05),
        ),
        Container(
          width: 24,
          height: 24,
          color: color.variants.light,
        ),
        Container(
          width: 24,
          height: 24,
          color: color.variants.regular,
          child: Center(
            child: Container(
              width: 8,
              height: 8,
              color: color.variants.invert,
            ),
          ),
        ),
      ],
    );
  }
}

class Button extends StatefulWidget {
  final Color backgroundColor;
  final Color foregroundColor;
  final String text;

  const Button({
    @required this.backgroundColor,
    @required this.foregroundColor,
    @required this.text,
  });

  factory Button.light({
    @required String text,
    @required Color color,
  }) =>
      Button(
        backgroundColor: color.variants.light,
        foregroundColor: color.variants.dark,
        text: text,
      );

  factory Button.regular({
    @required String text,
    @required Color color,
  }) =>
      Button(
        backgroundColor: color.variants.regular,
        foregroundColor: color.variants.invert,
        text: text,
      );

  @override
  _LightButtonState createState() => _LightButtonState();
}

class _LightButtonState extends State<Button> {
  bool isActive = false;
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => this.setState(() => this.isHover = true),
      onExit: (_) => this.setState(() => this.isHover = false),
      child: Listener(
        onPointerDown: (_) => this.setState(() => this.isActive = true),
        onPointerUp: (_) => this.setState(() => this.isActive = false),
        onPointerCancel: (_) => this.setState(() => this.isActive = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: widget.backgroundColor.decline(
              isActive ? 0.06 : (isHover ? 0.03 : 0.0),
            ),
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.text,
            style: TextStyle(
              color: widget.foregroundColor,
            ),
          ),
        ),
      ),
    );
  }
}
