import 'dart:convert';

import 'package:flutter/material.dart';
import '../models/code_model.dart';
import '../views/list_views.dart';

class CityPicker extends StatefulWidget {
  CityPicker(this.data,
      {Key? key,
      this.labelColor = Colors.black,
      this.labelWidth,
      this.unselectedLabelColor = Colors.black,
      this.physics,
      this.selectColor = Colors.pinkAccent})
      : super(key: key);

  /// city data
  final String? data;

  /// label color, default black
  final Color? labelColor;

  /// label width
  final double? labelWidth;

  /// text color
  final Color? unselectedLabelColor;

  /// scroll page
  final ScrollPhysics? physics;

  /// select color
  final Color? selectColor;

  @override
  _CityPickerState createState() => _CityPickerState();
}

class _CityPickerState extends State<CityPicker> with TickerProviderStateMixin {
  TabController? _tabController;
  // tabbar index
  int _currentIndex = 0;

  List<String> _tabList = ['请选择省份'];
  // change data
  List<CodeModel> _listData = [];
  // provinces
  List<CodeModel> _provincesData = [];
  // city
  List<CodeModel> _cityData = [];
  // area
  List<CodeModel> _areaData = [];
  // select model
  List<CodeModel> _selectData = [];

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          TabBar(
              controller: _tabController,
              labelColor: widget.labelColor,
              indicatorSize: TabBarIndicatorSize.label,
              unselectedLabelColor: widget.unselectedLabelColor,
              tabs: _tabList
                  .map((e) => Container(
                        width: widget.labelWidth ??
                            MediaQuery.of(context).size.width / _tabList.length,
                        child: Tab(
                          text: e,
                        ),
                      ))
                  .toList()),
          Expanded(
              child: TabBarView(
                  controller: _tabController,
                  physics: widget.physics ?? NeverScrollableScrollPhysics(),
                  children: _tabList
                      .asMap()
                      .keys
                      .map((e) => ListViews(_listData,
                              onTap: (CodeModel items) {
                            _selectItems(items);

                            if (items.children != null &&
                                ((_currentIndex == 0 && _tabList.length == 1) ||
                                    (_currentIndex == 1 &&
                                        _tabList.length == 2))) {
                              _currentIndex += 1;
                              _addTabBar();
                            } else {
                              if (_currentIndex < 2 && items.children != null) {
                                _tabController?.animateTo(_currentIndex + 1);
                              }
                            }

                            if (items.children != null) {
                              if (_currentIndex == 1) {
                                _cityData = items.children as List<CodeModel>;
                                _listData = _cityData;
                              }
                              if (_currentIndex == 2) {
                                _areaData = items.children as List<CodeModel>;
                                _listData = _areaData;
                              }
                            } else {
                              if (_currentIndex == 0) {
                                _cityData.clear();
                              }
                              if (_currentIndex == 1) {
                                _areaData.clear();
                              }
                              Navigator.of(context).pop(_selectData);
                            }
                            if (mounted) {
                              setState(() {});
                            }
                          },
                              selectColor: widget.selectColor,
                              selectData: _selectData,
                              tabIndex: _currentIndex))
                      .toList()))
        ],
      );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabList.length, vsync: this);
    List<dynamic> list = JsonDecoder().convert(widget.data!);
    _provincesData = CodeModelList.fromJson(list).list;
    _listData = _provincesData;
  }

  @override
  void didUpdateWidget(covariant CityPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  // add tabbar
  void _addTabBar() {
    if (_currentIndex > 2) return;
    String title = _currentIndex == 1 ? "请选择城市" : "请选择区";
    _tabList.add(title);
    _tabController = TabController(length: _tabList.length, vsync: this)
      ..addListener(() {
        switch (_tabController?.index) {
          case 0:
            {
              _listData = _provincesData;
            }
            break;
          case 1:
            {
              _listData = _cityData;
            }
            break;
          case 2:
            {
              _listData = _areaData;
            }
            break;
        }
        setState(() {
          _currentIndex = _tabController!.index;
        });
      });
    _tabController?.animateTo(_currentIndex);
  }

  // select item
  void _selectItems(CodeModel items) {
    if (_currentIndex == 0) {
      _selectData.clear();
      _tabList = ['请选择省份'];
      _tabController = TabController(length: _tabList.length, vsync: this)
        ..addListener(() {
          switch (_tabController?.index) {
            case 0:
              {
                _listData = _provincesData;
              }
              break;
            case 1:
              {
                _listData = _cityData;
              }
              break;
            case 2:
              {
                _listData = _areaData;
              }
              break;
          }
          setState(() {
            _currentIndex = _tabController!.index;
          });
        });
    }
    if (_currentIndex == 1 && _selectData.length > 1) {
      _selectData.removeAt(1);
    }
    if (_currentIndex == 2 && _selectData.length > 2) {
      _selectData.removeAt(2);
    }
    _selectData.insert(_currentIndex, items);

    _tabList[_currentIndex] = items.name;
  }
}
