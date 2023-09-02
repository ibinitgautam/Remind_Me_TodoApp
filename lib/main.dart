import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NotePad(),
      child: const MaterialApp(
        title: "Remind Me",
        home: MainApp(),
      ),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currenMode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Remind Me",
          theme: ThemeData(primarySwatch: Colors.blue),
          darkTheme: ThemeData.dark(),
          themeMode: currenMode,
          home: const HomeApp(),
        );
      },
    );
  }
}

class HomeApp extends StatelessWidget {
  const HomeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Remind Me",
          style: GoogleFonts.notoSans(),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              MainApp.themeNotifier.value == ThemeMode.light
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
            ),
            onPressed: () {
              MainApp.themeNotifier.value =
                  (MainApp.themeNotifier.value == ThemeMode.light
                      ? ThemeMode.dark
                      : ThemeMode.light);
            },
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: const AppBody(),
    );
  }
}

class AppBody extends StatefulWidget {
  const AppBody({super.key});

  @override
  State<AppBody> createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<NotePad>();
    return LayoutBuilder(builder: (context, constraints) {
      return const Layout();
    });
  }
}

class Layout extends StatelessWidget {
  const Layout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<NotePad>();
    TextEditingController textInput = TextEditingController();
    // ignore: prefer_typing_uninitialized_variables
    var input;

    return SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(5),
            child: SizedBox(
                child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      constraints: const BoxConstraints(
                        maxHeight: double.infinity,
                        maxWidth: double.infinity,
                      ),
                      child: Wrap(
                          direction: Axis.horizontal,
                          spacing: 4.0,
                          runSpacing: 2.0,
                          children: [
                            Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: 
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  width: 200,
                                  child: TextFormField(
                                    controller: textInput,
                                    keyboardType: TextInputType.streetAddress,
                                    decoration: const InputDecoration(
                                        hintText: "Do Assignment",
                                        icon: Icon(Icons.task),
                                        errorStyle: TextStyle(height: 0),
                                        labelText: "Task"),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                ElevatedButton.icon(
                                    onPressed: () {
                                      input = textInput.text;
                                      appState.taskAdded(input);
                                      //print(input);
                                    },
                                    icon: const Icon(Icons.add),
                                    label: const Text("Add")),
                              ],
                            )),
                            const BodyContent(),
                          ]),
                    )))));
  }
}

class BodyContent extends StatelessWidget {
  const BodyContent({super.key});

  @override
  Widget build(BuildContext context) {
    var inherit = context.watch<NotePad>();

    if (inherit.addedTask.isEmpty) {
      return const Column(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 700,
              child: Center(child: Text("Hello There! Welcome to RemindMe app.\nNote all important tasks here!"))
              ),
            ),
          ]
      );
    } else {
      return Expanded(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
        child: Column(
          children: [
            for (var task in inherit.addedTask)
              ListTile(
                leading: IconButton(
                  icon: const Icon(Icons.done_all_outlined),
                  onPressed: () {
                    inherit.taskDone(task);
                  },
                ),
                title: Text(task),
              )
          ],
        ),
      ));
    }
  }
}

class NotePad extends ChangeNotifier {
  var addedTask = [];

  void taskAdded(input) {
    if (input.isNotEmpty) {
      addedTask.add(input);
      // ignore: avoid_print
      print("Added");
    } else {}

    notifyListeners();
  }

  void taskDone(task) {
    if (addedTask.isNotEmpty) {
      addedTask.remove(task);
    } else {}

    notifyListeners();
  }
}
