import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:weather/constants/api_const.dart';
import 'package:weather/constants/app_colors.dart';
import 'package:weather/constants/app_text.dart';
import 'package:weather/constants/app_text_style.dart';
import 'package:weather/models/weather.dart';

import 'components/top_icon.dart';

const List cities = <String>[
  'bishkek',
  'osh',
  'jalal-abad',
  'naryn',
  'batken',
  'talas',
  'tokmok',
  'karakol'
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Weather? weather;

  Future<void> weatherName([String? name]) async {
    final dio = Dio();
    // await Future.delayed(Duration(seconds: 7));
    final res = await dio.get(ApiConst.address(name));
    if (res.statusCode == 200) {
      weather = Weather(
          id: res.data['weather'][0]['id'],
          main: res.data['weather'][0]['main'],
          description: res.data['weather'][0]['description'],
          icon: res.data['weather'][0]['icon'],
          city: res.data['name'],
          temp: res.data['main']['temp'],
          country: res.data['sys']['country']);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    weatherName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            AppText.appBarTitle,
            style: AppTextStyle.appBar,
          ),
          centerTitle: true,
          backgroundColor: AppColors.white,
        ),
        body: weather == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/bg.jpg'), fit: BoxFit.cover)),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TopIcons(
                        icon: Icons.near_me,
                        press: () {},
                      ),
                      TopIcons(
                          icon: Icons.location_city,
                          press: () {
                            showButton(context);
                          })
                    ],
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          '${(weather!.temp - 273.15).floorToDouble()}',
                          style: AppTextStyle.body1,
                        ),
                        Image.network(
                          ApiConst.getIcon('${weather?.icon}', 4),
                          height: 160,
                          fit: BoxFit.fitHeight,
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FittedBox(
                          child: Text(
                            // 'You will need to wear and '.replaceAll(' ', '\n'),

                            '${weather?.description}'.replaceAll(' ', '\n'),
                            style: AppTextStyle.body2,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: FittedBox(
                      child: Text(
                        '${weather?.city}',
                        style: AppTextStyle.body1,
                      ),
                    ),
                  )
                ]),
              )
        // FutureBuilder<Weather?>(
        //     future: fetchData(),
        //     builder: (context, sn) {
        //       if (sn.connectionState == ConnectionState.waiting) {
        //         return const Center(child: CircularProgressIndicator());
        //       } else if (sn.connectionState == ConnectionState.none) {
        //         return const Center(
        //           child: Text('Please, chek your internet!'),
        //         );
        //       } else if (sn.connectionState == ConnectionState.done) {
        //         if (sn.hasError) {
        //           return Text('${sn.error}');
        //         } else if (sn.hasData) {
        //           final weather = sn.data;

        //         }
        //       }
        //       return const Text('We can\'t to load this app');
        //     }),
        );
  }

  void showButton(context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.white),
                color: Colors.black,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(20))),
            child: ListView.builder(
                itemCount: cities.length,
                itemBuilder: (BuildContext context, int index) {
                  final city = cities[index];
                  return Card(
                    child: ListTile(
                      title: Text(city),
                      onTap: () async {
                        setState(() {
                          weather = null;
                        });
                        Navigator.pop(context);
                        weatherName(city);
                      },
                    ),
                  );
                }),
          );
        });
  }
}
