import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:test001/reply/model/email_model.dart';
import 'package:test001/test_page.dart';
import 'package:test001/tetris/generated/l10n.dart';




void main() {
  Paint.enableDithering = true;
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  _disableDebugPrint();

  runApp(const MyApp());
}

void _disableDebugPrint() {
  bool debug = false;
  assert(() {
    debug = true;
    return true;
  }());
  if (!debug) {
    debugPrint = (message, {wrapWidth}) {
      //disable log print when not in debug mode
    };
  }
}

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<EmailModel>.value(value: EmailModel()),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        navigatorObservers: [routeObserver],
        supportedLocales: S.delegate.supportedLocales,
        themeMode: ThemeMode.light,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          //colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          //useMaterial3: true,
        ),
        home: TestPage(context),
      ),

      // child: NeumorphicApp(
      //   debugShowCheckedModeBanner: false,
      //   title: 'Flutter Demo',
      //   localizationsDelegates: const [
      //     S.delegate,
      //     GlobalMaterialLocalizations.delegate,
      //     GlobalWidgetsLocalizations.delegate
      //   ],
      //   navigatorObservers: [routeObserver],
      //   supportedLocales: S.delegate.supportedLocales,
      //   themeMode: ThemeMode.light,
      //   theme: const NeumorphicThemeData(
      //     baseColor: Color(0xFFFFFFFF),
      //     lightSource: LightSource.topLeft,
      //     depth: 10,
      //   ),
      //   darkTheme: const NeumorphicThemeData(
      //     baseColor: Color(0xFF3E3E3E),
      //     lightSource: LightSource.topLeft,
      //     depth: 6,
      //   ),
      //   home: TestPage(context),
      // ),
    );
  }
}
