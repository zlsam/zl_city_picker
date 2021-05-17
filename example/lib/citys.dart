import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zl_city_picker/zl_city_picker.dart';


class Citys extends StatefulWidget {
  Citys({Key? key}) : super(key: key);

  @override
  _CitysState createState() => _CitysState();
}

class _CitysState extends State<Citys> {

  String? cityData;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("cityDemo"),
      ),
      body: cityData!=null ? CityPicker(cityData):Container(child: Text("城市数据不能为空"),),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getLocalCityData().then((value) => {
              setState(() {
                cityData = value;
              })
        });
  }

  // Get city data ... async
  Future<String> getLocalCityData() async {
    return await rootBundle.loadString('assets/json/city.json');
  }
}