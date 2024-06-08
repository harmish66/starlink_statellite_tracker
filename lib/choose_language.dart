import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starlink_statellite/onboarding_screen.dart';

class ChooseLanguage extends StatefulWidget {
  const ChooseLanguage({Key? key}) : super(key: key);

  @override
  State<ChooseLanguage> createState() => _ChooseLanguageState();
}

class _ChooseLanguageState extends State<ChooseLanguage> {
  int currentLanguageIndex = 0; // Store the index of the selected language

  final List<Map<String, String>> languages = [
    {
      'assets': 'assets/choose_lan/english.png',
      'name': 'English (Default)',
      'code': 'EN'
    },
    {
      'assets': 'assets/choose_lan/hindi.png',
      'name': 'Hindi (हिन्दी)',
      'code': 'HI'
    },
    {
      'assets': 'assets/choose_lan/spanish.png',
      'name': 'Spanish (Española)',
      'code': 'ES'
    },
    {
      'assets': 'assets/choose_lan/french.png',
      'name': 'French (Français)',
      'code': 'FR'
    },
    {
      'assets': 'assets/choose_lan/arabic.png',
      'name': 'Arabic (العربية)',
      'code': 'AR'
    },
    {
      'assets': 'assets/choose_lan/dutch.png',
      'name': 'Dutch (Nederlands)',
      'code': 'NL'
    },
    {
      'assets': 'assets/choose_lan/german.png',
      'name': 'German (Deutsch)',
      'code': 'DE'
    },
    {
      'assets': 'assets/choose_lan/indonesian.png',
      'name': 'Indonesian (Bahasa Indonesia)',
      'code': 'ID'
    },
    {
      'assets': 'assets/choose_lan/italian.png',
      'name': 'Italian (Italiana)',
      'code': 'IT'
    },
    {
      'assets': 'assets/choose_lan/japanese.png',
      'name': 'Japanese (日本語)',
      'code': 'JA'
    },
    {
      'assets': 'assets/choose_lan/korean.png',
      'name': 'Korean (한국인)',
      'code': 'KO'
    },
    {
      'assets': 'assets/choose_lan/malaysian.png',
      'name': 'Malaysian (Malaysian)',
      'code': 'MS'
    },
    {
      'assets': 'assets/choose_lan/portuguese.png',
      'name': 'Portuguese (Português)',
      'code': 'PT'
    },
    {
      'assets': 'assets/choose_lan/punjabi.png',
      'name': 'Punjabi (ਪੰਜਾਬੀ)',
      'code': 'PA'
    },
    {
      'assets': 'assets/choose_lan/russian.png',
      'name': 'Russian (Pусский)',
      'code': 'RU'
    },
    {
      'assets': 'assets/choose_lan/thai.png',
      'name': 'Thai (แบบไทย)',
      'code': 'TH'
    },
    {
      'assets': 'assets/choose_lan/turkish.png',
      'name': 'Turkish (Türkçe)',
      'code': 'TR'
    },
    {
      'assets': 'assets/choose_lan/vietnamese.png',
      'name': 'Vietnamese (Tiếng Việt)',
      'code': 'VI'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("Choose Language",
              style: TextStyle(fontSize: 70.sp, color: Colors.white)),
          actions: [
             Padding(
              padding: EdgeInsets.only(right: 10),
              child: InkWell(
                child: Icon(Icons.check, color: Colors.white),
                onTap: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setBool("isLanguageChosen", true);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => OnboardingScreen()),
                  );
                },
              ),
            ),
          ]),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(color: Colors.black),
        child: Column(
          children: [
            ListTile(
              title: Text('Current Language',
                  style: TextStyle(fontSize: 60.sp, color: Colors.white)),
              subtitle: Card(
                margin: const EdgeInsets.all(10),
                borderOnForeground: true,
                elevation: 10,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Stack(children: [
                  Image.asset("assets/choose_lan/pressed_bg.png"),
                  Row(
                    children: [
                      Image.asset(languages[currentLanguageIndex]['assets']!,
                          height: 150.h),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            languages[currentLanguageIndex]['name']!,
                            style:
                                TextStyle(fontSize: 50.sp, color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
                color: const Color(0xFF0E0E0E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(200.0),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Default Language",
                  style: TextStyle(fontSize: 60.sp, color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: languages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Image.asset("assets/choose_lan/unpressed_bg.png"),
                        ListTile(
                          titleAlignment: ListTileTitleAlignment.center,
                          leading: Image.asset(
                            languages[index]['assets']!,
                          ),
                          title: Text(languages[index]['name']!,
                              style: TextStyle(
                                  fontSize: 60.sp, color: Colors.white)),
                          trailing: currentLanguageIndex == index
                              ? const Icon(Icons.check, color: Colors.blue)
                              : null,
                          onTap: () {
                            setState(() {
                              currentLanguageIndex = index;
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
